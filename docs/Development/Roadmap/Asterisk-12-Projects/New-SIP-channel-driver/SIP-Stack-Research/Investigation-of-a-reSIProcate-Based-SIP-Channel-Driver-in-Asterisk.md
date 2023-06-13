---
title: Investigation of a reSIProcate Based SIP Channel Driver in Asterisk
pageid: 22085776
---

Introduction
============


Digium has identified the need for a new SIP channel driver and ancillary modules based on a third party SIP library. Currently there are two candidates being explored: the Teluu pjproject libraries and reSIProcate. As reSIProcate is a C++ based implementation, special consideration must be given beyond the SIP-related technical merits and quality of implementation. The focus here is primarily on the implications of incorporating a third party library or any kind that has an API defined in C++. Evaluation of the technical merits of reSIProcate and it's suitability for a new channel driver with respect to compliance, feature set, support, etc. are outside of the scope of this document.


*Note: research for this page was done by Brent Eagles.*


General Considerations of Mixing C and C++ Code
===============================================


Mixing C and C++ is common-place, particularly using C libraries with C++ code. The most common and straightforward example is the use of system libraries on a UNIX like system, all of which are exposed as functions and data types with C linkage and memory layouts. The reverse, using C++ from C libraries, is not as common. In this case, the C++ API is typically "wrapped" in a C-callable layer as C code does not "understand" C++ specific constructs. Besides the necessity of the a C accessible wrapper, the following must also be considered:


* C++ exceptions
* C++ specific memory management
* passing objects back and forth across the API boundary
* build time requirements for inclusion of C++ code


Exceptions
----------


C++ exception support results in the generation of additional code to support stack unwinding and exception propagation "up" the stack. To be certain that an exception does not produce undefined behavior, C++ exceptions should not be allowed to cross a C boundary. It is possible that this may work in some situations but the ultimate behavior may be platform-dependent.


### Exception thrown from C++ propagating to C


The most basic form of this scenario is an uncaught exception propagating to a C call frame. This may easily be avoided in practice but exceptions may be useful if the same function is also called from C++. In this case, two versions of the function are required.


reSIProcate\_C\_calling\_CPlusPlusL
### Exception passing through C code to be caught in C++


This is a far more severe example: a function implemented in C++ invokes a utility function implemented in C that in turn invokes a C++ function that throws an exception. With a gcc/g++ built executable, the thrown exception actually safely makes its way up the stack due to the way the GNU compiler framework implements C++ exceptions. Weird stack problems or disappearing exceptions do not occur. However, the exception causes immediate stack unwinding and the `free()` and `unlock_mutex()` calls in the example C function is skipped. There is no remedy for that particular issue and the results are potentially disastrous.


reSIProcate\_Cpp\_to\_C\_to\_CppL
While it may be difficult to create an example that demonstrates all of the issues around exceptions, it **is** clear that C code cannot handle C++ exceptions. Exceptions allowed to propagate out of C++ calls into C code will either cause crashes and aborts, undefined behavior or skipped "cleanup" code or essential "matching" operations. To avoid these issues, all C++ exceptions must be caught within the C++ code and either entirely handled there or converted to error codes and data and returned to the caller. The resultant code tends to be neither C++ or C like and unpleasant to maintain. C++ exceptions are difficult to simply avoid altogether as they are necessary for using certain C++ features properly (e.g. exceptions thrown from constructors allow proper automatic cleanup of partially created objects).


Memory Management
-----------------


Memory management in C++ typically employes `new()` and `delete()`. These operators, besides managing memory allocations on the heap, invoke the appropriate constructor and destructor for the object being allocated. Use of `malloc()` or `free()` may allocate or release memory but will fail to invoke the appropriate constructor or destructor, resulting in partially initialized objects or resource leaks. Complications may also occur if memory management functions use specialized heaps and/or diagnostic code. While it is possible with a reasonable amount of care to successfully manage multiple parallel memory management schemes, variable or unanticipated call paths can make maintaining these systems difficult and time consuming.


Passing Objects Back And Forth Across the API Boundary
------------------------------------------------------


Pointers to C++ objects may be assigned to void\* and cast back to the original type via static\_cast<T>() without issue. However, there are potential complications with virtual and multiple inheritance and pointer values. Pointers to the "same" object may not agree if they are obtained by different means.


Build Time Requirements
-----------------------


C++ requires the inclusion and initialization of the C++ run-time library. On many systems this means that the compilable unit containing the entry point for the process must be compiled with a C++ compiler and linked to the C++ run-time library. Alternatively, and only if supported, the run-time must be loaded and initialized through some other means.


 Manually managing the loading and loading of a run-time library may raise issues such as race conditions during startup and shutdown.


Asterisk Specific Considerations
================================


There are issues specific to Asterisk and the future plans for the product that need to be addressed when considering a third party library with a C++ API:


* Constraints on Modular Implementations
* Integration with Asterisk Specific Utility Libraries
* Support


Constraints on Modular Implementations
--------------------------------------


Asterisk modules are traditionally monolithic with little code sharing and reuse across modules and module specific functionality is entirely encapsulated in one compilable unit and not exposed through external linkage. There is an initiative to move away from the *status quo* and have a more modular architecture, exposing some of the functional subunits that have historically been hidden away. For example:


* SIP and the registry
* Voicemail and IMAP access  

The motivations behind this initiative are outside of the scope of this document. However, it is generally viewed as a necessary step in maintaining and evolving Asterisk in a reasonable fashion into the foreseeable future.


Using a C++ based implementation as basis for a related functionality implies one of the following approaches:


* All modules that "use" the third party library are implemented in C+. The modules internally use C+ and may share common C++ code, but they are ultimately accessible from Asterisk via a C compatible API.
* A C wrapper, or "facade", is created to encapsulate the C++ library. Asterisk modules then use the facade instead of the C++ API.


### Pervading C++


Allowing or requiring C++ to pervade or "creep" into several modules implies that each module be written with care to address the C++ related challenges described above. This is a development, maintenance and support risk, particularly for a community that may not be experienced with C+. The "natural boundary" at which C+ may be hidden behind may prove to be ambiguous or flexible in time, resulting in inconsistencies in interface definitions and modules of inconsistent utility.


reSIProcate\_Cpp\_Natural\_BoundaryL
It is worthwhile noting that C++ code libraries developed to aide in the implementation of the C++ Asterisk modules are, in the same way as the third party C++ library, not available to C Asterisk modules unless wrapped in a facade.


### A "C" Facade


Implementing and maintaining a facade or "wrapper" around any third party library is a development, maintenance and support burden of some significance. The stability is directly dependent on the third-party library's stability and requires a special, and perhaps uncommon, amalgam (e.g problem domain, product, library, C and C++) of knowledge to implement correctly. In the case of a feature rich third party API, the effort required to wrap a useful expanse of the API may prove to be roughly equivalent to the implementation of the library itself.


One consequence of this approach is that the more of a library you use, the more of a facade you need to build. If the third-party library API changes in some significant way in a major release, Asterisk must either remain on the old version, possibly maintaining it past it's EOL horizon or alter the facade to match the third-party library's changes. Either situation is against one of the principle reasons for using a third party library in the first place.


reSIProcate\_C\_Cpp\_FacadeL
Integration with Asterisk Specific Utility Libraries
----------------------------------------------------


The Asterisk code base represents an investment in time and expertise in C development. Crucial, common code elements have been identified and moved into re-usable units of utility functions. Elements such as reference counted data elements, collections (including the incipient red-black tree collection), and memory management are thoroughly tested both by the test framework and frequent and pervasive use. This collateral is primarily C based and may not integrate well with C++ modules. In addition to the issue of usability, APIs for Asterisk and/or the third party library expect data to be defined in terms of collections common to their respective languages or even proprietary to them. This can result in pervasive allocation, copying and deallocation steps as data moves back and forth across API boundaries.


Just as the growing library of C code may not be of utility to a C++ module, neither will C++ specific constructs invented and implemented in the C++ module be available to the C based Asterisk modules.


Support
-------


The term "support" is used here in the most general and universal sense. To support a C++ based module, whether it be an actual module or a facade, requires community involvement including the commitment for the continuation of C++ expertise both inside and outside of Digium. Independent of a subjective debate regarding the ease or difficulty of C+, the relevance of C as an application language, etc., supporting a critical, first-class module implemented in C+ requires the continuous availability of the relevant skill sets. In addition to code, there are module specific build system requirements that must be addressed and guidelines on acceptable coding practices must be conceived, documented and maintained. Acceptance in the Asterisk community is perhaps the most important "support" required.


Conclusion
==========


The consequences of employing a third party library that is accessed through a C++ API are diverse and significant. Technical excellence in the library notwithstanding, an effort to incorporate a library of this type in Asterisk requires careful consideration, a detailed communication and agreement of the challenges both current and future, and the full commitment of the Asterisk community and Digium. Considering the existing challenges that the aforementioned face in the continuation and evolution of Asterisk, it is imprudent to add obstacles that do not directly, and in all reasonable fashion, aide in overcoming these challenges. Also, given that the library in question would be used in implementing one of the most critical and fundamental parts of the system and that the initiative to eventually replace the existing SIP implementation is largely motivated on the difficulties of managing and maintaining the current implementation, adopting an approach that adds complexities not related to the challenges of implementing robust SIP functions adds significant complexity and risk to the Asterisk project.

