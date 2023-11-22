# RISCV-CLLD
Uni exercise - Circular Doubly-Linked List implementation in RISCV 64 Assembly

### Program workflow:
- Create head node with ASCII value 'R'
- Add node with ASCII value 'V' to the tail
- Add node with ASCII value 'I' to the tail
- Add node with ASCII value 'S' to the tail
- Add node with ASCII value 'C' to the tail
- Traverse the list nodes and print their values
- Remove the node with 'V' value from the list
- Exit with exit code 0

### Task specifications:
- No pseudoinstructions or libraries are allowed to be used.
- Registers only called by their ABI names
- Function and syscall return values must always be checked for error. if syscall returns error value, the program must terminate with exit code 125
- The program must exit only under _start label

### Node structure:
- val (8 Bytes): node value
- next (8 Bytes): address of the next node
- prev (8 Bytes): address of the previous node

### Functions that must be implemented:

- alloc_node()
  
  args:
  a0: val

  description:
  Allocates memory for an empty node structure, sets val MSByte to 0xA
  and other bytes to value specified in (a0)

  disclaimer:
  next and prev values must be not NULL and set to itself

  return:
  starting address of the allocated node

- add_tail()
  
  args:
  a0: address of head node
  a1: address of the new node

  description:
  adds the new node (a1) to the tail of a list that
  starts from head node (a0)

- del_node()
  
  args:
  a0: address of head node
  a1: address of node to be deleted

  description:
  deletes node with address (a1) from list
  starting from head node (a0)

  return:
  (-1) if the tobe-deleted node isn't found or
  list head node address, otherwise.

- print_list()
  
  args:
  a0: address of head node

  description:
  traverses every node of a list starting from head (a0)
  and prints node->val to the terminal

  return:
  (-1) at first print fail or the number of bytes written at last
  
