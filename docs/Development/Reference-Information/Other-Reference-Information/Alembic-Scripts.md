---
title: Alembic Scripts
pageid: 28315092
---

Boolean Values
==============

Originally, boolean values were represented as simple "yes/no" strings but this was inconsistent with the valid boolean values for config files which include '0', '1', 'off', 'on', etc.  The correct representation in Alembic scripts was therefore changed to the following:




---

  
Alembic Script Boolean Values  


```

pyAST\_BOOL\_NAME = 'ast\_bool\_values'
AST\_BOOL\_VALUES = [ '0', '1',
 'off', 'on',
 'false', 'true',
 'no', 'yes' ]
def upgrade():
 ast\_bool\_values = ENUM(\*AST\_BOOL\_VALUES, name=AST\_BOOL\_NAME, create\_type=False)
 op.add\_column('ps\_aors', sa.Column('remove\_unavailable', ast\_bool\_values))



```


 

Merging Alembic Scripts
=======================

There are a few extra steps necessary when merging alembic scripts into the code repository.

1) Be sure to update the branch before you commit your new alembic version scripts.

2) Run "alembic branches" to see if you have a merge conflict in the version chain. 

3) If you have multiple heads to the version chain as a result of a merge conflict, you need to update the down\_revision of your new version script to point to the head of the chain already checked into the repository. For completeness, you should also update the comment indicating which revision your new version script revises. You can run "alembic heads" to see the head information.




---

  
  


```

"""Create queue tables

Revision ID: 28887f25a46f
Revises: 21e526ad3040 <---- change this version to the previous head
Create Date: 2014-03-03 12:26:25.261640

"""

# revision identifiers, used by Alembic.
revision = '28887f25a46f'
down\_revision = '21e526ad3040' <---- change this version to the previous head


```


4) If the above fails consult the alembic tutorial here for more information about resolving the conflict in the working with branches section: <http://alembic.zzzcomputing.com/en/latest/branches.html>

