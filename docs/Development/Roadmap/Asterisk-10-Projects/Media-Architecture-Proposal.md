---
title: Media Architecture Proposal
pageid: 9568381
---



# Introduction
Asterisk was written from the ground up with a set of assumptions about how media is represented and negotiated. These assumptions have worked to get Asterisk where it is today, but unfortunately they have also put in place a set of limitations that must be overcome before Asterisk can meet the demands of the future. While these limitations are built into the foundation of Asterisk's design, the necessary changes required to lift these constraints can be made. This document outlines the required changes and breaks them up into a layered approach. Each section addresses a specific problem with Asterisk's current media architecture and proposes a solution. As the sections progress each new section uses the foundation outlined in the previous sections to address an increasingly complex set of problems. By attacking this issue from the foundation up it is possible to generate a complete solution that exceeds the current development constraints opening Asterisk up to an entire new set of possibilities.

# Table of Contents

{toc:style=disc|indent=20px}

# Project Requirements

* Lift the limit placed on the number of media formats Asterisk can support.
* Add the ability for Asterisk to represent media formats with attributes.
    * Support for SILK with attributes
    * Support for H.264 with attributes
* Add the ability for Asterisk to negotiate media formats with attributes.
* Allow translation paths to be built between all media types, not just audio.
* Allow translation paths to be built in a way that takes into account both media quality and translation cost for all media formats.
* Allow a channel to process multiple media streams, even of the same media type, with translation.
* Support the ability to renegotiate media formats after call setup is complete.
* Support the ability to pass-through media Asterisk does not yet understand.
* Support the ability to for users to specify media formats with attributes in .conf files.

# Representation of Media Formats
## Problem Overview
One of the key problems the new media architecture must address is how to represent a media format that does not have statically defined parameters. In the past, simply defining a media format type as uLaw or g722 posed no problem as these formats have a very specific set of parameters associated with them. For example uLaw is always 8khz, each sample is always the exact same size, and there is really nothing more required to describe a uLaw payload other than now large it is. Everything else can be calculated because parameters for uLaw payloads never change. Unfortunately the assumption that media formats do not need to be defined beyond their format type has proven to be a limitation in the ability to adopt modern media formats. The problems prohibiting integration of feature complete SILK codec support into Asterisk offers a prime example of how this limitation is hindering development. SILK is an audio codec that may adjust the sample rate used in a stream based upon the capabilities of the network. Right now Asterisk assumes every media format will always contain the same sample rate. Without the ability to define a format's sample rate outside of the hard coded rate defined at compile time, implementing SILK into Asterisk without limiting the codec's functionality is not currently possible.

In order to address this limitation, media formats will have the ability to be further defined using format specific attribute structures. These structures along with usage examples are outlined in below.

## Introducing ast_format, The New and Improved format_t
The ast_format structure completely replaces format_t everywhere in the code. This new structure allows for a format to be represented not only by a unique ID, but with an attribute structure as well. This means if a channel's read format is SILK and it understands 8khz->16khz without the need of translation, this can be now represented using only a single format identifier. In this case the ast_format's uid would be AST_FORMAT_SILK, and the attribute structure would be configured to further define this format as having a possible dynamic sample rate between 8khz and 16khz.

The ast_format structure on an ast_frame has a slightly different behavior than representing a read and write format though. When on a frame the attributes structure must be used only to further define the frame's payload. In the SILK read format example discussed above, the attribute structure is used to represent a sample rate range the channel's read format is capable of understanding without translation, but when the attribute structure is used on a frame it must represent a very precise set of parameters directly related to the media payload being transported. In the case of SILK, the attribute structure on a frame would represent precisely what sample rate the payload contains.

## The Ast Format API

```


/*! \brief This structure contains the buffer used for format attribute */
struct ast_format_attr {
 uint8_t format_attr[AST_FORMATNEW_ATTR_SIZE];
};

/*! \brief Represents a media format within Asterisk */
struct ast_format {
 /*! The unique id representing this format from all the other formats */
 enum ast_format_id id;
 /*! Attribute structure used to associate attributes with a format */
 struct ast_format_attr fattr;
};

enum ast_format_cmp_res {
 /*! structure 1 is identical to structure 2 */
 AST_FORMAT_CMP_EQUAL = 0,
 /*! structure 1 contains elements not in structure 2 */
 AST_FORMAT_CMP_NOT_EQUAL,
 /*! structure 1 is a proper subset of the elements in structure 2. */
 AST_FORMAT_CMP_SUBSET,
};

/*!
 * \brief This function is used to set an ast_format object to represent a media format
 * with optional format attributes represented by format specific key value pairs.
 *
 * \param format to set
 * \param id, format id to set on format
 * \param set_attributes, are there attributes to set on this format. 0 == false, 1 == True.
 * \param var list of attribute key value pairs, must end with AST_FORMATNEW_ATTR_END;
 *
 * \details Example usage.
 * ast_format_set(format, AST_FORMATNEW_ULAW, 0); // no capability attributes are needed for ULAW
 *
 * ast_format_set(format, AST_FORMATNEW_SILK, 1, // SILK has capability attributes.
 * AST_FORMATNEW_SILK_ATTR_RATE, 24000,
 * AST_FORMATNEW_SILK_ATTR_RATE, 16000,
 * AST_FORMATNEW_SILK_ATTR_RATE, 12000,
 * AST_FORMATNEW_SILK_ATTR_RATE, 8000,
 * AST_FORMATNEW_ATTR_END);
 *
 * \return Pointer to ast_format object, same pointer that is passed in
 * by the first argument.
 */
struct ast_format \*ast_format_set(struct ast_format \*format, enum ast_format_id id, int set_attributes, ... );

/*!
 * \brief This function is used to set an ast_format object to represent a media format
 * with optional capability attributes represented by format specific key value pairs.
 *
 * \details Example usage. Is this SILK format capable of 8khz
 * is_8khz = ast_format_isset(format, AST_FORMATNEW_SILK_CAP_RATE, 8000);
 *
 * \return 0, The format key value pairs are within the capabilities defined in this structure.
 * \return -1, The format key value pairs are _NOT_ within the capabilities of this structure.
 */
int ast_format_isset(struct ast_format \*format, ... );

/*!
 * \brief Compare ast_formats structures
 *
 * \retval ast_format_cmp_res representing the result of comparing format1 and format2.
 */
enum ast_format_cmp_res ast_format_cmp(struct ast_format \*format1, struct ast_format \*format2);

/*!
 * \brief Find joint format attributes of two ast_format
 * structures containing the same uid and return the intersection in the
 * result structure.
 *
 * retval 0, joint attribute capabilities exist.
 * retval -1, no joint attribute capabilities exist.
 */
int ast_format_joint(struct ast_format \*format1, struct ast_format \*format2, struct ast_format \*result);

/*!
 * \brief copy format src into format dst.
 */
void ast_format_copy(struct ast_format \*src, struct ast_format \*dst);

/*!
 * \brief ast_format to iax2 bitfield format represenatation
 *
 * \note This is only to be used for IAX2 compatibility 
 *
 * \retval iax2 representation of ast_format
 * \retval 0, if no representation existis for iax2
 */
uint64_t ast_format_to_iax2(struct ast_format \*format);

/*!
 * \brief convert iax2 bitfield format to ast_format represenatation
 * \note This is only to be used for IAX2 compatibility 
 *
 * \retval on success, pointer to the dst format in the input parameters
 * \retval on failure, NULL
 */
struct ast_format \*ast_format_from_iax2(uint64_t src, struct ast_format \*dst);



```


## Introducing the Format Attribute Structure

The attribute structure is present on every ast_format object. This attribute structure is an opaque buffer that can be used in anyway necessary by the format it represents. Since it will be necessary for Asterisk to perform a few generic operations on these attribute structures, every format requiring the use of the attribute structure must implement and register a format attribute interface with Asterisk. These registered interfaces are used by the Ast Format API allowing for attributes on an ast_format structure to be set, removed, and compared using a single set of API functions for all format types. The Ast Format API does all the work of finding the correct interface to use and calling the correct interface functions.

The size of the buffer in the attribute structure was determined by researching the media format with the largest number of attributes expected to be present in Asterisk 10. In this case the H.264 SVC draft was used, which is an expanded form of RFC 3984 allowing for some additional functionality. The attributes required by H.264 SVC are determined based upon the SDP parameters defined in the draft. The SDP parameters used by the draft do not all have fixed sizes, but it was determined that an attribute buffer of ~70 bytes will easily suffice for representing the most common use cases. In order to account for undefined future development, this buffer is initially set at 128 bytes which satisfies the current estimated attribute size requirements.

## The Ast Format Attribute API

```

#define AST_FORMAT_ATTR_SIZE 128

struct ast_format_attr {
 uint8_t format_attr[AST_FORMAT_FORMAT_ATTR_SIZE];
}

/*! \brief A format must register an attribute interface if it requires the use of the format attributes void pointe */
struct ast_format_attr_interface {
 /*! format typ */
 enum ast_format_id id;

 /*! \brief Determine if format_attr 1 is a subset of format_attr 2.
 *
 * \retval ast_format_cmp_res representing the result of comparing fattr1 and fattr2.
 */
 enum ast_format_cmp_res (\* const format_attr_cmp)(struct ast_format_attr \*fattr1, struct ast_format_attr \*fattr2);

 /*! \brief Get joint attributes of same format type if they exist.
 *
 * \retval 0 if joint attributes exist
 * \retval -1 if no joint attributes are present
 */
 int (\* const format_attr_get_joint)(struct ast_format_attr \*fattr1, struct ast_format_attr \*fattr2, struct ast_format_attr \*result);

 /*! \brief Set format capabilities from a list of key value pairs ending with AST_FORMAT_ATTR_END.
 * \note This function is expected to call va_end(ap) after processing the va_list */
 void (\* const format_attr_set)(struct ast_format_attr \*format_attr, va_list ap);
};

/*! \brief register ast_format_attr_interface with core.
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_format_attr_reg_interface(struct ast_format_attr_interface \*interface);

/*!
 * \brief unregister format_attr interface with core.
 *
 * \retval 0 success
 * \retval -1 failure
 */
int ast_format_attr_unreg_interface(struct ast_format_attr_interface \*interface);

```


## The New Format Unique Identifier

Media formats in Asterisk are currently defined using a bit field, format_t, where every format is uniquely identified by a single bit. While this makes comparing media format capabilities extremely simple using bitwise operations, this representation limits the number of media formats that can be represented due to the limited size of the bit field in use. Even if a bit field could represent an infinite number of bits, this representation has no concept of how to compare format capability attributes.

In order to remove the limitation of the number of unique formats that can be represented the identifier will change from a single bit representation to a numeric representation. This means that #define AST_FORMAT_ULAW (1 << 0) now becomes #define AST_FORMAT_ULAW 1. By changing the way media formats are identified from a bit in a bit field to a numeric value, the limit on the number of formats that can be represented goes from 64 to 4,294,967,296. Altering this representation completely removes the ability to use bitwise operations on a bit field containing multiple media format capabilities, but since these bitwise operations lack the ability to process format attributes, they must be replaced by a more robust system anyway. The new system for computing joint media capabilities between peers hinted at here is discussed in detail in the Representation of Format Capabilities section.

## Format Unique Identifier Organization

The old system of using a single bit in a bit field to represent a single format also allows for bitmasks to be used to determine what type of media a format is categorized as. For example, there is a bitmask for determining if a format is an audio format, video format, or text format. By changing the unique id to a number the ability to use bitmasks to determine the category is no longer possible. Instead, a new convention of organizing these formats into media categories must be set in place.

Since the number of formats that can be represented will likely never be exhausted using the new system, formats can be uniquely identified and categorized using a system that sections off each category into a range of numbers. Since it is unlikely any category will ever have even close to 100,000 unique formats associated with it, each category will be sectioned off by increments of 100,000. For example, all audio formats will be uniquely identified in a category between 100,000-199,999, all video formats will be uniquely identified in a category between 200,000-299,999, and so on for every category. This new system allows for each format's unique id to be overloaded with a category as well just like the previous system did. Instead of using a bitmask to determine if a format is video or audio, a function or macro can be used to do the comparison consistently across the code base.


## New Format Unique Id Changes to frame.h


```

/*OLD */
#define AST_FORMAT_AUDIO_MASK 0xFFFF0000FFFFULL
#define AST_FORMAT_G723_1 (1ULL << 0)
#define AST_FORMAT_GSM (1ULL << 1)
#define AST_FORMAT_ULAW (1ULL << 2)
#define AST_FORMAT_ALAW (1ULL << 3)

#define AST_FORMAT_VIDEO_MASK ((((1ULL << 25)-1) & ~(AST_FORMAT_AUDIO_MASK)) | 0x7FFF000000000000ULL)
#define AST_FORMAT_H263_PLUS (1ULL << 20)
#define AST_FORMAT_MP4_VIDEO (1ULL << 22)

```


```

/*NEW */
#define AST_FORMAT_INC 100000

/* ALL FORMAT CATEGORIE */
enum ast_format_type {
 AST_FORMAT_TYPE_AUDIO = 1 \* FORMAT_INC,
 AST_FORMAT_TYPE_VIDEO = 2 \* FORMAT_INC,
 AST_FORMAT_TYPE_IMAGE = 3 \* FORMAT_INC,
};

enum ast_format_id {
 /* ALL AUDIO FORMAT */
 AST_FORMAT_G723_1 = 1 + AST_FORMAT_TYPE_AUDIO,
 AST_FORMAT_GSM = 2 + AST_FORMAT_TYPE_AUDIO,
 AST_FORMAT_ULAW = 3 + AST_FORMAT_TYPE_AUDIO,
 AST_FORMAT_ALAW = 4 + AST_FORMAT_TYPE_AUDIO,

 /* ALL VIDEO FORMAT */
 AST_FORMAT_H263_PLUS = 1 + AST_FORMAT_TYPE_VIDEO,
 AST_FORMAT_MP4_VIDEO = 2 + AST_FORMAT_TYPE_VIDEO,
};

/* Determine what category a format type is i */
#define AST_FORMAT_GET_TYPE(format) (((unsigned int) (format->uid / AST_FORMAT_INC)) \* AST_FORMAT_INC)

```

## New Format Representation Code Examples and Use cases.

This section shows example usage of the ast_format structure and how it replaces existing functionality in Asterisk. It also outlines other highlevel use cases that can not easilly be represented by a code example.

Example 1: One to one mapping of old format_t usage with ast_format structure and its API.

```

 /* OLD: Media formats are represented by a bit in the format_t bit field */
 format_t read_format;
 read_format = AST_FORMAT_ULAW;

```


```

 /* NEW: Media formats are represented using the ast_format struct and are stored in an ast_cap object */
 struct ast_format read_format;
 ast_format_set(&read, AST_FORMAT_ULAW);

```


Example 2: Set an optional format attribute structure for a SILK ast_format structure capable of a dynamic sample rate.

```

struct ast_format read_format;
ast_format_set(&read, AST_FORMAT_SILK,
 AST_FORMAT_SILK_RATE, 24000,
 AST_FORMAT_SILK_RATE, 16000,
 AST_FORMAT_SILK_RATE, 12000,
 AST_FORMAT_SILK_RATE, 8000,
 AST_FORMAT_END);

```


Example 3: Set the sample rate of SILK ast_frame representing the sample rate of the frame's payload. Then compare the format of the ast_frame with a read format determine if translation is required.

```

struct ast_format read_format;
/* The read format is of format type SILK and can be of sample rates 8khz and 12kh */
ast_format_set(&read, AST_FORMAT_SILK,
 AST_FORMAT_SILK_RATE, 12000,
 AST_FORMAT_SILK_RATE, 8000,
 AST_FORMAT_END);

/* The frame's format type is SILK and the payload is 24khz audio */
ast_format_set(frame->subclass.format, AST_FORMAT_SILK,
 AST_FORMAT_SILK_RATE, 24000,
 AST_FORMAT_END);

/* Comparing the frame with the read format shows that while the formats are identical
 * their attributes make them incompatible requiring a translation path to be built */
if ((ast_format_cmp(&read_format, frame->subclass.format) < 0)) {
 /* Build Translation Path.
 * This will be the outcome of this example */
} else {
 /* Frame's format is either identical or a subset of the read_format
 * requiring no translation path */
}

```


Example 4. Determine if a format is of type audio.

```

/*OLD */
format_t format = AST_FORMAT_ULAW;
if (format & AST_FORMAT_AUDO_MASK) {
 /* this is of type audi */
}

```


```

/*NEW */
struct ast_format format;
ast_format_set(&format, AST_FORMAT_ULAW);
if (AST_FORMAT_GET_TYPE(&format) == AST_FORMAT_TYPE_AUDIO) {
 /* this is of type audi */
}

```


Example 5: Media format seamlessly changes parameters midstream.

1. A channel is defined to have a write format of SILK with the capabilities of understanding 8khz and 16khz without translation.
2. A stream of SILK audio ast_frames containing 16khz frame attributes begin to be written to the channel.
3. During the call the audio stream's SILK frame attributes change to 8khz.
4. ast_write() determines this change is still within the channel's write format capabilities and continues without translation.

Example 6: Media format changes parameters requiring translation midstream.

1. A channel is defined to have a write format of SILK with the capabilities of understanding 8khz and 16khz without translation.
2. A stream of SILK audio ast_frames containing 16khz frame attributes begin to be written to the channel.
3. During the call the audio stream's SILK frame attributes change to 24khz.
4. ast_write() determines this change is not within the bounds of the channel's write format capabilities and builds a translation path from 24khz SILK to 16khz SILK.

# Representation of Format Capabilities
## Problem Overview
The new way of handling format capabilities must address two issues. First, formats are no longer represented by the format_t bit field and are replaced by the ast_format structure. This means that the old system of representing format capability sets with a bit field must be replaced as well. Second, even if we could use a bit field to represent format capability sets, the bitwise operators used to compare capabilities and calculate joint capabilities are incapable of processing the new format attribute structures. In order to handle both of these changes, an opaque capabilities container must be created to manipulate sets of ast_format structures. This container must also be coupled with an API that abstracts all the work required to compare sets of ast_formats and their internal format attributes.

## Introducing ast_cap, The Format Capability Container.

The Format Capability API introduces a new container type, struct ast_cap, which acts as the opaque capabilities container discussed in the overview. Like an ao2_container holds astobj2 objects, the ast_cap container holds ast_format objects. The thing that sets the ast_cap container apart from other generic containers in Asterisk is that it is designed specifically for the purpose of comparing and manipulating sets of ast_format structures. API functions for adding/removing ast_formats, computing joint capabilities, and retrieving all capabilities for a specific media type are present. The best way to communicate the big picture for how this new container and API replaces the current architecture is by providing some examples. These examples will walk through the sections discussed so far and provide a better understanding for how the ast_format and ast_cap containers interact with each other using the new API. All the examples below take code from the existing media architecture in Asterisk and show how the new architecture replaces it.

Example 1: Add format capabilities to a peer.

```

/* ---OLD: Media formats are represented by a bit in a bit field */
format_t capabilities = 0;
capabilities |= AST_FORMAT_ULAW;
capabilities |= AST_FORMAT_GSM;
/* XXX SILK can not be set using a bit since it requires a capability
 * attribute to be associated with it.
 * capabilities |= AST_FORMAT_SILK;
 */

```



```

/* ---NEW: Media formats are represented using the ast_format struct and are stored in an ast_cap object. */
struct ast_format tmp = { 0, };

ast_cap_add(capabilties, ast_format_set(&tmp, AST_FORMAT_ULAW));
ast_cap_add(capabilties, ast_format_set(&tmp, AST_FORMAT_GSM));

/* SILK media format requires the format capability attribute to be set. */
ast_format_set(&tmp, AST_FORMAT_SILK,
 AST_FORMAT_SILK_CAP_RATE, 24000,
 AST_FORMAT_SILK_CAP_RATE, 16000,
 AST_FORMAT_SILK_CAP_RATE, 12000,
 AST_FORMAT_SILK_CAP_RATE, 8000,
 AST_FORMAT_ATTR_END);
ast_cap_add(capabilties, &tmp);

```


Example 2: Find joint capabilities between a peer and remote endpoint.

```

/*---OLD: Peer and remote capabilities are bit fields, no capability attributes can be used. */
format_t jointcapabilties = 0;

peer->capability |= (AST_FORMAT_ULAW | AST_FORMAT_GSM);

/*
 * peer->capability = ULAW and GSM
 *
 * remote_capabilities structure is already built to contain uLaw
 * remote_capability = ULAW
 *
 * jointcapabilities will be ULAW
 */
jointcapabilties = peer->capability & remote_capability

```



```

/*---NEW: Peer and remote capabilities are ast_cap objects. */
struct ast_cap \*jointcapabilities;

ast_cap_add(peer->capability, ast_format_set(&tmp, AST_FORMAT_ULAW));
ast_cap_add(peer->capability, ast_format_set(&tmp, AST_FORMAT_GSM));

ast_format_set(&tmp, AST_FORMAT_SILK,
 AST_FORMAT_SILK_CAP_RATE, 24000,
 AST_FORMAT_SILK_CAP_RATE, 16000,
 AST_FORMAT_SILK_CAP_RATE, 12000,
 AST_FORMAT_SILK_CAP_RATE, 8000,
 AST_FORMAT_ATTR_END);
ast_cap_add(peer->capabilties, &tmp);

ast_format_set(&tmp, AST_FORMAT_H264,
 AST_FORMAT_H264_CAP_PACKETIZATION, 0,
 AST_FORMAT_H264_CAP_PACKETIZATION, 1,
 AST_FORMAT_H264_CAP_RES, "CIF",
 AST_FORMAT_H264_CAP_RES, "VGA",
 AST_FORMAT_ATTR_END);
ast_cap_add(peer->capabilties, &tmp);

/*
 * peer->capabilities structure was just built to contain.
 * silk (rate = 24000, rate = 16000, rate = 12000, rate = 8000)
 * h.264 (packetization = 0, packetization = 1, res = vga, res = cif)
 *
 * remote_capabilities structure is already built to contain
 * silk (rate = 16000)
 * h.264 (packetization = 0, res = vga, res = svga)
 *
 * The resulting jointcapabilities object contains
 * SILK (Rate = 16000khz)
 * H.264 (packetization = 0, Res = VGA)
 *
 * Computing of joint capabilities of formats with capability attributes is
 * possible because of the format attribute interface each format requiring
 * attributes must implement and register with the core.
 */
jointcapabilities = ast_cap_joint(peer->capability, remote_capability);

```


Example 3: Separate audio, video, and text capabilities.

```

/*---OLD: Separate media types are separated by a bit mask. */
format_t video_capabilities = capabilities & AST_FORMAT_VIDEO_MASK;
format_t audio_capabilities = capabilities & AST_FORMAT_AUDIO_MASK;
format_t text_capabilities = capabilities & AST_FORMAT_TEXT_MASK;

```


```

/*---NEW: Separate media types are returned on a new capabilities structure using ast_cap_get_type() */
struct ast_cap \*video = ast_cap_get_type(capabilities, AST_FORMAT_TYPE_AUDIO);
struct ast_cap \*voice = ast_cap_get_type(capabilities, AST_FORMAT_TYPE_VIDEO);
struct ast_cap \*text = ast_cap_get_type(capabilities, AST_FORMAT_TYPE_TEXT);

```

## Ast Format Capability API Defined

```

/*! Capabilities are represented by an opaque structure statically defined in format_capability. */
struct ast_cap;

/*! \brief Allocate a new ast_cap structure.
 *
 * \retval ast_cap object on success.
 * \retval NULL on failure.
 */
struct ast_cap \*ast_cap_alloc(void);

/*! \brief Destroy an ast_cap structure.
 *
 * \return NULL
 */
void \*ast_cap_destroy(struct ast_cap \*cap);

/*! \brief Add format capability to capabilities structure.
 *
 * \note A copy of the input format is made and that copy is
 * what is placed in the ast_cap structure. The actual
 * input format ptr is not stored.
 */
void ast_cap_add(struct ast_cap \*cap, struct ast_format \*format);

/*! \brief Remove format capability from capability structure.
 *
 * \Note format must match Exactly to format in ast_cap object in order
 * to be removed.
 *
 * \retval 0, remove was successful
 * \retval -1, remove failed. Could not find format to remove
 */
int ast_cap_remove(struct ast_cap \*cap, struct ast_format \*format);

/*! \brief Remove all format capabilities from capability
 * structure for a specific format id.
 *
 * \Note This will remove _ALL_ formats matching the format id from the
 * capabilities structure.
 *
 * \retval 0, remove was successful
 * \retval -1, remove failed. Could not find formats to remove
 */
int ast_cap_remove_byid(struct ast_cap \*cap, enum ast_format_id id);

/*! \brief Find if ast_format is within the capabilities of the ast_cap object.
 *
 * retval 1 format is compatible with formats held in ast_cap object.
 * retval 0 format is not compatible with any formats in ast_cap object.
 */
int ast_cap_iscompatible(struct ast_cap \*cap, struct ast_format \*format);

/*! \brief Get joint capability structure.
 *
 * \retval !NULL success
 * \retval NULL failure
 */
struct ast_cap \*ast_cap_joint(struct ast_cap \*cap1, struct ast_cap \*cap2);

/*! \brief Get all capabilities for a specific media type
 *
 * \retval !NULL success
 * \retval NULL failure
 */
struct ast_cap \*ast_cap_get_type(struct ast_cap \*cap, enum ast_format_type ftype);


/*! \brief Start iterating format */
void ast_cap_iter_start(struct ast_cap \*cap);

/*! \brief Next format in interation
 *
 * \details
 * Here is how to use the ast_cap iterator.
 *
 * 1. call ast_cap_iter_start
 * 2. call ast_cap_iter_next in a loop until it returns -1
 * 3. call ast_cap_iter_end to terminate the iterator.
 *
 * example:
 *
 * ast_cap_iter_start(cap);
 * while (!ast_cap_iter_next(cap, &format)) {
 *
 * }
 * ast_cap_iter_end(Cap);
 *
 * \retval 0 on success, new format is copied into input format struct
 * \retval -1, no more formats are present.
 */
int ast_cap_iter_next(struct ast_cap \*cap, struct ast_format \*format);

/*! \brief Ends ast_cap iteration.
 * \note this must be call after every ast_cap_iter_start
 */
void ast_cap_iter_end(struct ast_cap \*cap);

/*!
 * \brief ast_cap to iax2 bitfield format represenatation
 *
 * \note This is only to be used for IAX2 compatibility 
 *
 * \retval iax2 representation of ast_cap
 * \retval 0, if no iax2 capabilities are present in ast_cap
 */
uint64_t ast_cap_to_iax2(struct ast_cap \*cap);

/*!
 * \brief convert iax2 bitfield format to ast_cap represenatation
 * \note This is only to be used for IAX2 compatibility 
 */
void ast_cap_from_iax2(uint64_t src, struct ast_cap \*dst);

```


# IAX2 Ast Format API Compatibility

IAX2 represents media formats the same way Asterisk currently does using a bit field. This allows Asterisk to communicate format capabilities over IAX2 using the exact same representation Asterisk uses internally. This relationship between Asterisk and IAX2 breaks with the introduction of the ast_format and ast_cap structures though. In order for Asterisk to maintain compatiblity with IAX2 a conversion layer must exist between the previous format representation and the new format representation. This conversion layer will be limited to the formats defined at the moment the media format representation in Asterisk changes to use the ast_format structure. As new media formats are introduced, they must be added to this conversion layer in order to be transported over IAX2. Any media formats requiring the use of media attributes may have to be excluded from this conversion depending on their complexity. Eventually the number of media formats that can be represented in IAX2 will be exhasted. At that point it must be decided to either accept that limitation or alter the protocol in a way that will expand it to take advantage of Asterisk's new format capabilities. This proposal is not defining a change any changes to the IAX2 protocol.

# Revised Format Translation
## Problem Overview
There are two sets of problems that must be addressed in regards to media translation in Asterisk. The first set of problems is a ripple effect caused by the changes surrounding the new representation of media formats with attributes. Translators must gain the ability to process these attributes and build translation paths between formats requiring the use of them. The other set of problems involves the ability to translate between media types other than just audio. The current translation architecture is very audio specific. It assumes that all translators are audio format translators of some kind, and that no other media type will ever be translated. This assumption is not only within the translation code, it is also deeply rooted throughout the code base. The ability to translate between media other than audio is a concept Asterisk completely lacks at the moment.

This section builds upon the foundation established by the new ast_format media format representation and uses it to redefine what translators look like and how translation paths are built. After these changes are made Asterisk will still not be able to translate video or other types of media even if translation paths actually exist between them. This problem is a result of limitations set in place by the Ast Channel API. The changes required to lift that limitation are discussed in the "Handling Multiple Media Streams" section.

## Building Translation Paths

The current method of calculating translation cost by using the computational time required to translate between formats is no longer effective. When all the formats in Asterisk were 8khz audio, picking the best translation path based upon computational cost made sense. The problem with this system now is that it does not take into account the quality of the translation. It may be computationally quicker to translated from one 16khz audio format to another 16khz audio format using 8khz signed linear audio even when 16khz signed linear is an option. Regardless of the computational costs, down sampling an audio stream unless it is absolutely necessary is a bad idea from a quality perspective. Provisions were made in the current code base to account for the down sampling issue just described, but the introduction of that fix was merely a hack to sustain the current system until a more robust architecture could be set in place. The new system must be aware of quality changes between all forms of media, not just sample rate.

Instead of building a translation cost table out based on computational complexity, the table should be built based on what kind of translation is taking place. For example categorizing a translator as a "lossless to lossy translation with a down sampling of quality" gives quite a bit more information about what kind of translation is actually taking place than simply knowing the translation is between two formats and it takes x amount of time to compute 1 second of sample data. As new formats are introduced, knowing how all the different translators affect media during translation allows the path builder algorithm to consistently produce the best quality available.

### Computing Translation Costs
The new translation cost table is built on a scale between 400 and 9999. Notice that the lowest cost is 400 and the next cost after that is 600. These two numbers add up to 1000, which guarantees that a direct translation path will always take precedence over any path containing multiple translation steps. The only exception to this rule is a multiple step translation path between lossless formats of the same quality, which does not exist in Asterisk yet but may in the future.

Every one of these cost categories can be thought of as a range starting at the number listed and ranging all the way up to the next category. If a format is capable of multiple translators for any single category listed below, the cost associated with those translators should not fall onto the same cost number as each other. Instead each translator for a single format calling into the same cost table category should be given a weighted cost within the category's range. For example, siren17 is a 32khz audio codec with translators capable of down sampling to both 16khz signed linear and 8khz signed linear. Both of these translators fall under the \[~dvossel@digium.com:lossy -> lossless\] downsample" category which starts at cost 960. In order to make this work the 16khz conversion would be 960 and the 8khz conversion would be 961. This gives the translator that loses the least amount of information priority over the the one that loses more if a tie occurs.

This cost table is weighted in a way that assigns lower cost to translators with the most ideal outcome. For example, translating between a lossless format to a lossy format is aways more ideal that converting a lossy format to a lossless format, translating between two lossy formats of the same quality is always more ideal than translating to a lossy format of lesser quality, and translating to a format of equivalent in quality to the original format is more ideal than any translation that requires some sort of re-sampling. The costs are computed based on these principles and more.

### Translation Cost Table

Table Terms
\*Up Sample:\* The original format is translated to a format capable of representing more detailed information than the original one. Examples of this term would be audio codec being translated to a higher sample rate, a video codec being translated to a higher resolution/frame rate, or an image being translated to a higher resolution.

\*Down Sample:\* The original format is translated to a format of lesser quality. Examples of this term would be audio codec being translated to a lower sample rate, a video codec being translated to a lower resolution/frame rate, or an image being translated to a lower resolution.

\*Original Sampling:\* The original format is translated to a format of similar quality with little to no loss of information. Examples of this term would be an audio codec being translated to a format equivalent in quality of the original one, a video codec being translated to a format which preserves all the original information present, and an image being translated to another format preserving the same resolution and color depth.


```

--- Lossless Source Translation Costs
400 [lossless -> lossless] original sampling
600 [lossless -> lossy] original sampling
800 [lossless -> lossless] up sample
825 [lossless -> lossy] up sample
850 [lossless -> lossless] down sample
875 [lossless -> lossy] down sample
885 [lossless -> Unknown] Unknown sample

--- Lossy Source Translation Costs
900 [lossy -> lossless] original sampling
915 [lossy -> lossy] original sampling
930 [lossy -> lossless] up sample
945 [lossy -> lossy] up sample
960 [lossy -> lossless] down sample
975 [lossy -> lossy] down sample
985 [lossy -> Unknown] Unknown sample

```


### Translation Path Examples
\*Example 1:\* Downsampling g722 to ulaw using signed linear as an intermediary step. Notice that using two lossless conversions is more expensive than downsampling g722 directly to 8khz slin.

```

[g722->slin16->slin->ulaw] 900+850+600 = 2350
[g722->slin->ulaw] 960+600 = 1560 wins

```


\*Example 2:\* Direct lossy to loss translation using ulaw to alaw. Notice how the direct path between uLaw and aLaw beats using the intermediary slin step.

```

[ulaw->slin->alaw] 900+600 = 1500
[ulaw->alaw] 945 = 945 wins

```


\*Example 3:\* Complex resampling of siren14 to siren7 using g722 as an intermediary step. Notice how downsamping all the way to 8khz signed linear loses to the path that only requires downsampling to 16khz signed linear.

```

[siren14->slin->g722->slin16->siren7] 960+825+900+600 = 3285
[siren14->slin16->g722->slin16->siren7] 960+600+900+600 = 3060 wins

```


\*Example 4:\* Complex resampling using siren14 to a fake 32khz lossy codec. Notice how siren14->slin16 has a 830 cost while siren14-slin8 has 831. This allows translations within the same category to be weighted against each other to produce the best quality.

```

[siren14->slin->Fake 32khz lossy Codec] 961+825 = 1786
[siren14->slin16->Fake 32khz lossy Codec] 960+825 = 1785 wins

```


### Translator Costs Defined. 

Note that the table costs actually defined in the code are larger than the ones discussed so far by a factor of 1000.

```

/*!
 * \brief Translator Cost Table definition.
 *
 * \note The defined values in this table must be used to set
 * the translator's table_cost value.
 *
 * \note The cost value of the first two values must always add
 * up to be greater than the largest value defined in this table.
 * This is done to guarantee a direct translation will always
 * have precedence over a multi step translation.
 *
 * \details This table is built in a way that allows translation
 * paths to be built that guarantee the best possible balance
 * between performance and quality. With this table direct
 * translation paths between two formats always takes precedence
 * over multi step paths, lossless intermediate steps are always
 * chosen over lossy intermediate steps, and preservation of
 * sample rate across the translation will always have precedence
 * over a path that involves any re-sampling.
 */
enum ast_trans_cost_table {

 /* Lossless Source Translation Cost */

 /*! [lossless -> lossless] original samplin */
 AST_TRANS_COST_LL_LL_ORIGSAMP = 400000,
 /*! [lossless -> lossy] original samplin */
 AST_TRANS_COST_LL_LY_ORIGSAMP = 600000,

 /*! [lossless -> lossless] up sampl */
 AST_TRANS_COST_LL_LL_UPSAMP = 800000,
 /*! [lossless -> lossy] up sampl */
 AST_TRANS_COST_LL_LY_UPSAMP = 825000,

 /*! [lossless -> lossless] down sampl */
 AST_TRANS_COST_LL_LL_DOWNSAMP = 850000,
 /*! [lossless -> lossy] down sampl */
 AST_TRANS_COST_LL_LY_DOWNSAMP = 875000,

 /*! [lossless -> unknown] unknown.
 * This value is for a lossless source translation
 * with an unknown destination and or sample rate conversion */
 AST_TRANS_COST_LL_UNKNOWN = 885000,

 /* Lossy Source Translation Cost */

 /*! [lossy -> lossless] original samplin */
 AST_TRANS_COST_LY_LL_ORIGSAMP = 900000,
 /*! [lossy -> lossy] original samplin */
 AST_TRANS_COST_LY_LY_ORIGSAMP = 915000,

 /*! [lossy -> lossless] up sampl */
 AST_TRANS_COST_LY_LL_UPSAMP = 930000,
 /*! [lossy -> lossy] up sampl */
 AST_TRANS_COST_LY_LY_UPSAMP = 945000,

 /*! [lossy -> lossless] down sampl */
 AST_TRANS_COST_LY_LL_DOWNSAMP = 960000,
 /*! [lossy -> lossy] down sampl */
 AST_TRANS_COST_LY_LY_DOWNSAMP = 975000,

 /*! [lossy -> unknown] unknown.
 * This value is for a lossy source translation
 * with an unknown destination and or sample rate conversion */
 AST_TRANS_COST_LY_UNKNOWN = 985000,

};

```


### Creation of Translation Path Matrix

Most least cost algorithms take a matrix as input. The current code's translation path matrix is represented by a 2 dimensional array of translation path structures. The current matrix will not change structurally, but there are some complications involved. The current code accesses translation paths from the matrix using index values which represent individual formats. The index values are computed by converting the format's bit representation to a numeric value. Since the numeric representation of a format bit has to be between 1 and 64, the maximum size of the bit field in use, the numeric representation works as an index for the current two dimensional matrix. With the introduction of the ast_format structure, this conversion between a format's unique id and the a matrix index value is not clean. To account for this complication a hash table mapping every format id to a matrix index value will be used.

### Computing Least Cost Translation Paths

The Floyd-Warshall algorithm will be the least cost algorithm in use. At its core, the current translation path building code uses this algorithm but has a few layers of complexity added on top of the base algorithm to deal with translation paths between audio codecs of differing sample rates. With the introduction of the new translation cost table, this additional complexity is completely stripped away from the algorithm. Now the translation costs are computed with translation quality and efficiency in mind, which abstracts these concepts away from least cost algorithm in use.


```

FloydWarshall ()
 for k := 1 to n
 for i := 1 to n
 for j := 1 to n
 path[i][j] = min (path[i][j], path[i][k]+path[k][j]);

```


## Translator Redundancy and Failover

It is possible that multiple redundant translators may exist for a single translation path. A common example of this would be a hardware translator with limited capacity coupled with a software translator. Both of these translators perform the exact same task, but the hardware translator is much faster. In this case the hardware translator would be used until it reached capacity and then it would failover to the software translator. There is however a complication involved with this. Only one of these translators can exist in the translation path matrix at a time. This means that when multiple translators with the same source and destination formats are present, some sort of priority must be used to pick which one is used. If the translator in use reaches capacity it then must deactivate itself allowing the matrix to be rebuilt in order to take advantage of the redundant translator.

In order to prioritize redundant translators, computational cost will be used. Formats requiring the use of redundant translators must supply a set of sample data to translate. This data is already present for most audio formats because it is required by the current architecture to compute translation cost. Translation cost in the new architecture is replaced by the translation cost table, but computational cost is still important when choosing between redundant translators.

## Redefining The Translator Interface

Translators are currently defined by a simple set of functions (constructor, destructor, framein, frameout) coupled with a source and destination media format to translate between. There is not much that needs to be changed about this interface except that the source and destination formats must be converted to be ast_format structures in all the existing code, and each translator must provide a cost value. There will be a table available to guide exactly what cost value to use. In order to make any future changes to the cost table effortless, defined values will be used when assigning cost to a translator. Otherwise this interface is in great shape for the changes ahead.


```

/* each format must be declared statically no */
static struct ast_format slin16;
static struct ast_format g722;

/* each interface holds a pointer to the static formats */
static struct ast_translator lin16tog722 = {
 .name = "lin16tog722",
 .cost = AST_TRANS_COST_LL_LY_ORIGSAMP,
 .srcfmt = &slin16,
 .dstfmt = &g722,
 .newpvt = lin16tog722_new, /* same for both direction */
 .framein = lintog722_framein,
 .sample = slin16_sample,
 .desc_size = sizeof(struct g722_encoder_pvt),
 .buffer_samples = BUFFER_SAMPLES \* 2,
 .buf_size = BUFFER_SAMPLES,
};

/* Notice the static formats are initialized before registering the translato */
static int load_module(void)
{
 int res = 0;

 ast_format_set(&slin16, AST_FORMAT_SLIN16);
 ast_format_set(&g722, AST_FORMAT_G722);

 res |= ast_register_translator(&lin16tog722);

 if (res) {
 unload_module();
 return AST_MODULE_LOAD_FAILURE;
 } 

 return AST_MODULE_LOAD_SUCCESS;
}

```


# Handling Multiple Media Streams
## Problem Overview
Asterisk was designed from the ground up with the idea of only one audio media path being passed between channels. The code that handles this media path is done in such a way that makes expanding it to multiple media paths very difficult, especially media that is not audio. Asterisk has gotten away with being able to support very limited video functionality by not treating it as a media path at all. Instead of putting all media in the same media path as audio, video and other forms of media are just passed through similar to the way signalling is done. In order to bring all media into the same code path as audio, several fundamental design changes must be made to the way channels represent media streams. This section discusses those changes and how they affect channel drivers and other applications requiring access to media streams.

## Defining a Media Stream in Asterisk
The first step in improving Asterisk's ability to represent multiple media streams is to actually define what a media stream is. At the moment, a stream in Asterisk is a very abstract idea. There is no tangible representation of a stream, no stream object or structure. The best representation of a stream Asterisk has now is the ast_channel structure which is capable of representing a single set of audio tx/rx streams through the use of a bunch disjoint elements. Lets start this discussion by breaking out the elements of the ast_channel structure that allow it to represent these streams.

In order for the ast_channel structure to represent a single set of audio tx/rx streams it needs the following things.

# \*Read translator\* - Translates stream on the read path going into the Asterisk Core.
# \*Write translator\* - Translates stream on the write path going out to the channel driver.
# \*Native Format Capabilities\* - Native capabilities the channel driver is capable of understanding without translation for this stream.
# \*Read Format\* - Requested Read format after translation on the read path.
# \*Raw Read Format\* - Expected read format before translation.
# \*Write Format\* - Requested write format after translation on the write path.
# \*Raw Read Format\* - Expected write format before translation.

The combination of all these items represent everything Asterisk needs to make channels compatible with one another and build translation paths between one another for a single set of corresponding tx/rx streams. The problem with this architecture is that all these disjoint elements make it impossible to replicate this functionality allowing for multiple tx/rx streams to exist on a single channel. In order for channels in Asterisk to gain the ability to process multiple tx/rx stream sets on a single channel all of theses stream elements must be organized into an isolated structure that can be easily replicated and manipulated. This new structure is called the \*ast_channel_stream\* structure and is discussed in detail in the next section.

## Introducing ast_channel_stream, Making Sense out of Madness
The ast_channel_stream structure is made up of all the individual elements required to represent single set of tx/rx streams on an ast_channel structure. This allows all the disjoint translators and formats on the ast_channel structure associated with the audio streams go away and be replaced by a single ast_channel_stream structure. Everyplace in the current code base that directly accesses any of the stream elements on a channel such as nativeformats, readformat, and writeformat will be replaced by a set of API functions provided by the new Ast Channel Stream API. This API contains all the common operations channel drivers and applications need to perform on a stream, such as setting the native format capabilities, initializing the read/write formats, retrieving the current read/write formats, and setting the read/write formats. By using this API, channels also gain the ability to contain more than one media stream set. This is done through the concept of stream identifiers which is further discussed in the next section.

## Stream Identifiers
The ast_channel_stream structure isolates the concept of tx/rx streams to a single entity allowing channels to represent multiple streams through the use of multiple ast_channel_stream structures. Since it is prohibited for any part of Asterisk except channel.c to directly access the ast_channel_stream structures on a channel, the rest of Asterisk needs a way access these individual streams through the use of the Ast Channel Stream API. This introduces the concept of \*stream identifiers\*. Stream identifiers completely abstract away the concept of the ast_channel_stream structure from the rest of Asterisk. Every ast_channel_stream structure on a channel will have a unique stream id assigned to it. This stream id is required by every function in the Ast Channel Stream API to access and manipulate the individual streams on a channel.

In order to separate ast_frames belonging to separate streams, a stream id will also be present on each frame. This will involve placing a new value on the ast_frame structure to represent what stream the frame belongs to. By default the current code will not use the stream id on the ast_frame even though it will be present. This concept is discussed in more detail in the "Default Streams" section.

Steam identifiers are organized into three categories. For the sake of organization and ABI compatibility each of these categories are given a range of unique stream identifiers available to them. Separating the default streams from the auxiliary and dynamic streams also makes it much easier to filter out auxiliary and dynamic streams for applications and modules that do not support them. Once a new stream identifier is defined, its unique id must remain consistent. 

# \*default streams\*: Unique id defined between 1 - 99999
# \*auxiliary streams\*: Unique id defined between 100000 - 199999
# \*dynamic streams\*: Unique id defined between 200000 - 299999

### Default Streams
Since Asterisk was designed with the concept of a single audio tx/rx stream set existing on a channel, some provisions must be made to allow for a smooth transition into the concept of multiple stream sets. This is where default streams come into play. Every ast_channel structure will contain a set of default streams associated with it, each with a predefined consistent stream id.

\*Default Audio Streams\* - The first default tx/rx stream set present on every channel is the default audio streams. This is the stream set all of Asterisk already knows about. It is the one that used to be made of individual elements in the ast_channel structure but was stripped out after defining the ast_channel_stream structure. Every channel driver built so far already knows how to manipulate these streams and many applications require access to them as well. All ast_frames of type AST_FRAME_VOICE with a stream id of 0 will automatically match this default stream set on a channel. Since 0 is the default initialization value for the stream id on a frame, all the channel drivers and applications already making use of these streams do not have to be modified.

It should be noted that while additional audio streams will be possible in the future, it is likely the default audio stream will be the only one that any kind of tone detection is performed on for DTMF, FAX, etc. This document does not attempt to alter this limitation in any way.

\*Default Video Streams\* - It is currently impossible to do translation between two channels transmitting different video formats because the channel has no way of representing video translators. This changes with the introduction of the default video rx/tx stream set. Similar to the default audio streams, any video frames containing a stream Id of 0 is automatically matched to the default video stream set on a channel.

As more media types are introduced, it may be beneficial to define additional default stream sets. Initially only audio and video will present.

### Auxiliary Streams
If a channel driver is capable of negotiating more streams than can be represented by the default rx/tx stream sets on a channel, the auxiliary media stream sets can be used. These stream sets work the exact same way as the default stream sets except they require the use of the media stream id on frames. With auxiliary streams the stream id must be present on every ast_frame created for the stream. This allows channels and applications not capable of processing auxiliary streams to filter out the frames they don't understand.

Since Asterisk supports multiple protocols with various capabilities, all the auxiliary streams that can be used anywhere in Asterisk must be defined at compile time. This means when a channel driver is extended to make use of a new type of auxiliary stream, that stream must be defined with a stream id that uniquely represents it across the entire code base. This is the only way to keep the different types of auxiliary streams and what they are used for consistent across all modules.


```
 

Example 1: Chan_sip is extended to make use of up to four video and audio streams per call. This sort of functionality has never been done before so six new auxiliary streams must be defined for the three new video and three new audio streams.

enum ast_channel_stream_id {
 /*! Define Default Streams belo */
 AST_STREAM_DEFAULT_AUDIO = 1,
 AST_STREAM_DEFAULT_VIDEO = 2,

 /*! Define Auxiliary Streams Belo */
 AST_STREAM_VIDEO_AUX1 = 100000,
 AST_STREAM_VIDEO_AUX2, = 100001,
 AST_STREAM_VIDEO_AUX3, = 100002,
 AST_STREAM_AUDIO_AUX1, = 100003,
 AST_STREAM_AUDIO_AUX2, = 100004,
 AST_STREAM_AUDIO_AUX3, = 100005,
}

As chan_sip receives individual stream payloads and creates ast_frames to pass into the core, each frame's stream id is marked with the ast_channel_stream_id it belongs to. Any channel driver or applications that gets passed an audio or video frame belonging to one of these newly defined auxiliary streams that does not support it will ignore it.


```


### Dynamic Streams

It is possible that Asterisk will need the ability to pass through streams containing media it does not understand. This can only be accomplished if both the channel negotiating the unknown media type and whatever that channel is bridged too can agree that they both understand the unknown media type and are assigning it a dynamic stream id that they both agree upon. This document does not define the negotiation of dynamic streams in Asterisk.


## Ast Channel Stream API Defined


```

/*! \brief Definition of opaque channel stream structur */
struct ast_channel_stream {
 /*! represents the stream typ */
 enum ast_channel_stream_id id;

 struct ast_trans_pvt \*writetrans;
 struct ast_trans_pvt \*readtrans;

 struct ast_cap nativeformats;

 struct ast_format readformat;
 struct ast_format writeformat;
 struct ast_format rawreadformat;
 struct ast_format rawwriteformat;
};

```



```


/*! \brief stream identifier structure. Present on both ast_frame
 * and ast_channel_stream structure.
 */
enum ast_channel_stream_id {
 /*! Define all Default Streams below */
 AST_STREAM_DEFAULT_AUDIO = 1,
 AST_STREAM_DEFAULT_VIDEO = 2,

 /*! Define Auxiliary Streams Below starting at 100000
 * Example:
 * AST_STREAM_VIDEO_AUX1 = 100000,
 */
}

void ast_channel_init_write_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*format)

void ast_channel_init_read_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*format)

void ast_channel_set_native_cap(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_cap \*cap)

int ast_channel_copy_readwrite_format(struct ast_channel \*chan1, struct ast_channel \*chan2, enum ast_channel_stream_id id)

void ast_channel_set_read_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*format)

void ast_channel_set_write_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*format)

int ast_channel_get_native_cap(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_cap \*result)

int ast_channel_get_write_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*result)

int ast_channel_get_read_format(struct ast_channel \*chan, enum ast_channel_stream_id id, struct ast_format \*result)


```


## Code Change Examples

This sections shows how the Ast Channel Stream API replaces existing usage in Asterisk.

Example 1: A channel driver creating a new channel and initializing the default audio stream's formats and capabilities.

```

chan->nativeformats = capabilty;
chan->readformat = best_format;
chan->rawreadformat = best_format;
chan->writeformat = best_format;
chan->rawwriteformat = best_format;

```



```

ast_channel_set_native_cap(chan, AST_STREAM_DEFAULT_AUDIO, capability);
ast_channel_init_write_format(chan, AST_STREAM_DEFAULT_AUDIO, best_format);
ast_channel_init_read_format(chan, AST_STREAM_DEFAULT_AUDIO, best_format);

```


Example 2: Setting the read format on a channel.

```

ast_set_read_format(chan, format);

```



```

ast_set_read_format(chan, AST_STREAM_DEFAULT_AUDIO, format);

```


# Media Format with Attributes User Configuration

With the addtion of media formats with attributes, users will need a way to represent these new formats and their attributes in their config files. This will be accomplished by the ability to define custom media types that can be used in the format allow/disallow fields. These custom media type definitions will live in codecs.conf. For people familiar with Asterisk's config structure, the best way to present this concept is with some examples.

\*Example 1\*. SILK is capable of several different sample rates. If a peer wants to negotiate only using SILK in a narrow band format, a custom format must be created to represent this.


```

/* Limit negotiation of SILK to only 8khz and 12khz */
[silk_nb]
type=silk
samplerates=8000,12000

/* Limit negotiation of SILK to only 16khz and 24kh */
[silk_wb]
type=silk
samplerates=16000,24000

/* Allow any SILK sample rate a device is capable of to be negotiate */
[silk_all]
type=silk
samplerates=8000,12000,16000,24000


```



```


/* Define a peer using only the narrow band custom SILK format definitio */
[sip_peer]
type=friend
host=dynamic
disallow=all
allow=silk_nb

```


\*Example 2\*. H.264 is capable of negotiating a wide range of attributes. If specific attributes are to be negotiated, a custom format must be created to represent this.


```

/* H.264 at vga or svga resolutions, 30 frames per second */
[h264_custom1]
type=h264
res=vga,svga
framerate=30


```


```


/* Define a peer using the new h264_custom1 custom format type */
[sip_peer]
type=friend
host=dynamic
disallow=all
allow_ulaw
allow=h264_custom1

```


Notice from these examples that both the SILK and H264 custom formats are defined using fields specific to their format. Each format will define what fields are applicable to them. If there are common fields used for several different media formats, those fields should be named in a consistent way across all the media formats that use them. Every format allowing custom media formats to be defined must be documented in codecs.conf along with all the available fields.


# Enhancing Format Negotiation During Call Setup
{warning}
This is an area of focus for our initial media overhaul efforts, but research into this area is still incomplete. Because of this, the design surrounding the ability to better negotiate media formats during call setup has not yet been defined. This will be addressed at a later date.
{warning}

# Format Renegotiation After Call Setup

{warning}
Please note that this section is incomplete. A very high level approach to format renegotiation has been outlined below, but many details pertaining to exactly how this will work are not yet defined. Format renegotiation has been marked as one of the later implementation phases and the design will be completely re-evaluated and proven before implementation.
{warning}

## Problem Overview
When it is at all possible, it is always better to have two bridged channels share the same media formats for their audio streams than to have to perform translation. Translation for audio is expensive, but translation for video is exponentially more expensive that audio. Because of the computational complexity involved with translating video, the concept of being able to renegotiate media after a call is estabilshed in an attempt to get the device to do the translation for us is very important. Right now Asterisk lacks this ability.

## Making ast_channel_make_compatible() Smarter

Every time a channel is bridged with another channel a call to ast_channel_make_compatible() is made. This function takes the two channels to be bridged as input and figures out all the translation paths and intermediate media formats that need to be set in order for the two channels to talk to each other. With protocols like SIP, it is possible to renegotiate the call parameters after call setup has taken place. By placing a feature in ast_channel_make_compatible() that can make the two channels aware of each other's native media format before translation takes place, it is possible for one side to re-negotiate its session to switch to the same media format used by the other side. When this is possible, Asterisk is able to avoid translation completely.

### How Renegotiation Works

At the heart of renegotiation is the introduction of a channel option called \*AST_OPTION_FORMAT_RENEGOTIATE\* and a structure called \*ast_option_renegotiate_param\*. The ast_format_renegotiate_param structure is passed as the data for the AST_OPTION_FORMAT_RENEGOTIATE's query and set actions. This structure contains both a format to renegotiate for each stream renegotation must take place on, a function pointer containing the place a channel tech must report the result of its renegotiation attempt, and an internal structure used to determine what action to take next after a channel tech reports the renegotiation attempt.

On query, the ast_option_renegotiate_param structure is passed down to the channel tech pvt containing information about all the formats and streams to renegotiate. The result of a query request indicates whether or not the channel tech is capable of attempting renegotiation with the formats provided or not. Queries are performed synchronously, meaning the result of a query request must never block for a network transaction to take place.

On set, the ast_option_renegotiate_param structure is passed down to the channel tech pvt containing both the formats and streams to renegotiate along with a place to report the result of the renegotiation. Renegotiation is event driven, meaning that the channel tech pvt is given the renegotation parameters and it must report back at a later time the result of the renegotiation attempt. This allows the set operation to avoid blocking the bridge code by performing the renegotation asynchronously.

During ast_channel_make_compatible(), if it is determined that translation is required to make two channels compatible both channels are queried using the AST_OPTION_FORMAT_RENEGOTIATE option and ast_option_renegotiate_param structures. After the queries, if either of the two channels are capable of renegotiating the set action is used on best candidate to attempt the renegotiation. If the channel used for the first renegotiation attempt reports a failure, a second attempt at renegotiation may take place for the bridged channel if neither channel has hung up.

### Renegotiation with Intermediary Translation

* Make Compatible Flow of Events
    * ast_channel_make_compatible() is invoked
    * read and write formats are different between channels for at least one stream
    * translation paths are built for streams requiring translation
    * query to AST_OPTION_FORMAT_RENEGOTIATE is made on both channels
    * if candidate for renegotation exists, renegotiation parameters are set to the channel using AST_OPTION_FORMAT_RENEGOTIATE
    * channels are bridged
* Asynchronous Renegotation Flow of Events
    * channel tech is set with renegotation paramters using AST_OPTION_FORMAT_RENEGOTIATE
    * channel tech attempts renegotiation and reports result to renegotiation parameter result function
\*\*\* on SUCCESS: new format is set for renegotated stream and translation path goes away
\*\*\* on FAILURE: result function attempts renegotation with bridged channel if possible, else translation must remain

### Renegotiation with no Intermediary Translation

* Make Compatible Flow of Events
    * ast_channel_make_compatible() is invoked
    * channel's read and write formats are different for at least one stream
    * \*NO\* translation path is possible to make channels compatible
    * query to AST_OPTION_FORMAT_RENEGOTIATE is made to both channels
    * if best candidate for renegotiation is found, renegotiation parameters are set to the channel using AST_OPTION_FORMAT_RENEGOTIATE
    * channel is bridged
    * media for incompatible streams are blocked for a period of time while renegotiation takes place
* Asynchronous Renegotiation Flow of Events
    * channel tech is set with renegotiation parameters using AST_OPTION_FORMAT_RENEGOTIATE.
    * channel tech attempts renegotiation and reports result to renegotiation parameter result function
\*\*\* on SUCCESS: new format is set for renegotiated stream and translation path goes away
\*\*\* on FAILURE: result function attempts renegotiation with bridged channel if possible
    * if renegotiation fails on both channels, depending on the stream in question media is either indefinitely blocked or both channels are hung up

# Implementation Phases

With a project of this size, it is important to break down the implementation into manageable phases. Each phase of development contains a set of steps which act as milestones. These steps must be small enough to be attainable within a week to two week period but complete enough to not break any Asterisk functionality once they are introduced. Once a step is complete, it should be reviewed and committed into trunk. This allows progress to be made in a maintainable way.

## Phase 1: Re-architect how media is represented and how translation paths are built

From the user perspective, no functionality changes will be present during this phase.

* Step 1
    * Define new format unique ID system using numbers rather than bits. Allow this definition to remain unused during this step except by the new APIs.
    * Create Ast Format API + unit tests.
    * Create Ast Capibility API + unit tests.
    * Create IAX2 Conversion layer for ast_format and ast_cap objects. Create unit tests and leave this layer inactive until conversion to new APIs takes place.

* Step 2
    * Define translation cost table.
    * Replace current matrix algorithm with new matrix algorithm using predefined costs from table.
    * Continue to use computational costs for tie breaking translators with identical src and dst formats.
    * Create table for mapping format ids to matrix index values. This is required once the conversion from the format bit field representation to a numeric value takes place and will allow for a smoother transition.

* Step 3
    * Replace old format unique ID system with the new system. This will temporarily break all asterisk media functionality.
    * Add media functionality back into Asterisk by replacing all instances of format_t with ast_format and ast_cap.
    * Completely remove format_t type def.

## Phase 2: Exercise the functionality introduced by formats with attributes

This is done by introducing the SILK codec and allowing H.264 to be negotiated with format attributes.

* Step 1
    * Define SILK format in Asterisk.
    * Create SILK format attribute interface.
    * Make SILK translators to and from signed linear.
    * Add the ability to define custom media formats with attributes in user configuration.
    * Extend the rtp mapping code to allow chan_sip to advertise SILK appropriately in SDPs.

* Step 2
    * Create H.264 format attribute interface.
    * Extend codecs.conf to allow custom H.264 format definitions.
    * Extend chan_sip to be able to correctly advertise and negotiate H.264 with attributes in SDPs.

## Phase 3: Extend Asterisk to handle multiple media streams

* Step 1
    * Create Ast Channel Stream API
    * Define default audio stream by replacing current audio stream formats and translators on a channel with an ast_channel_stream structure.
    * Define default video stream by introducing a new ast_channel_stream structure used solely for negotiating the primary video stream.

* Step 2
    * Add the stream id field to the ast_frame structure.
    * Block the ability to read anything other than the default streams with all current channel drivers and applications.
    * Introduce new ast_read functionality for reading auxiliary streams when it is explicitly requested.

* Step 3
    * Exercise the new ability to build video translation paths using an FFMPEG addon translation module.

## Phase 4: Format Renegotiation after call setup

Allowing calls to renegotiate their media formats after call setup is perhaps the most practical functionality introduced by this project. Due to the way multiple media streams will be represented in Asterisk, this ability to represent multiple streams is prerequisite for format renegotiation be implemented correctly. That is the primary reasoning for pushing back the introduction of this functionality to a later phase.

* Step 1
    * Re-evaluate design. Define use cases and prove concept with a set of sequence diagrams.
    * Test interoperability of renegotiation use cases using sipp scenarios against common SIP devices.

* Step 2
    * Implement core functionality changes required to detect and attempt format renegotiation with channel techs.
    * Implement chan_sip configuration options and functionality required to allow format renegotiation triggered by the Asterisk core to occur after call setup.

