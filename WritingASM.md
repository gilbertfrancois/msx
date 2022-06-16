# Writing assembly for MSX with Champ

*Gilbert François Duivesteijn*



On this page, I try to explain how to use Champ for MSX(1) to write, store and deploy programs written in assembly or hybrid basic-assembly. Back in the days, around 1986 and beyond, I liked Champ a lot. It was easy to use, because it was an all-in-one editor, assembler, disassembler, monitor/debugger. On top of it, one could easily escape to basic to test the compiled program, which is still in memory and go back to Champ to do further programming. But the most killer feature was that you can step through code line by line, inspecting registers and memory values.

The aim of this page is not to be another ASM tutorial, but to show how you can develop and debug on a real MSX with only a cassette player/recorder as storage device, like it was done in the 80's with an MSX1 computer.

|                                   |                                     |
| :-------------------------------: | :---------------------------------: |
| ![](./assets/images/champ000.jpg) | ![](./assets/images/champtitle.png) |
|         Box and cassette          |            Title screen             |

## Modes

Champ has 4 modes, Insert, Edit, Assemble and Debug. You can switch between the modes with the keys as described in the schema below.


---

 `< EDIT >`   &larr; `[ret]` &rarr;   `< INSERT >`

​          &uarr;

​     `[esc]`

​          &darr;

`< ASSEMBLE >`

                &uarr;

   `[m]`   `[a]`
 ​     &darr; 
   `< DEBUG >`

---
## Example 1: Assembler -> Basic -> Assembler roundtrip

 In this example, I loosly follow *Keith ChibiAkumas'* tutorial [Learn Z80 Assembly Lesson 3](https://www.youtube.com/watch?v=zPXmvoZz9Nk&list=PLp_QNRIYljFq-9nFiAUiAkRzAXfcZTBR_&index=3). We will make a small program in assembly that performs an add or subtract operation on single byte integers. We will make:

- Basic program that asks for the user input and shows the result.
- ASM program that computes and stores the result in memory.

 Please follow the steps below:

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](./assets/images/champ001.png)                            | ![](./assets/images/champ002.png)                            |
| 1) Use **insert** and **edit** to type in the example program. | 2) In **assemble** mode, type `a` `2` to compile. Save the listing as text to cassette with `s` -> `filename`. |
| ![](./assets/images/champ004.png)                            | ![](./assets/images/champ005.png)                            |
| 3) Go to **debug** mode by pressing `m`, view memory and disassembled code with `Q saddr`. If you want, you can store your finished binary to cassette with: `W saddr faddr filename`. | 4) Go back to assemble mode by pressing `a`. Now go to **MSX Basic** with `q` `y` and type in the listing above. |
| ![](./assets/images/champ006.png)                            | ![](./assets/images/champ007.png)                            |
| 5) If all is well, type `run` and see if your program works. | 6) You can go back to the Assembler by the commands above and edit/update your asm program. |

## Example 2: Assembler -> Run, Debug and Monitor

What makes Champ really powerful is that you are able to step through code and monitor the memory, stack, registers and program count. Let's go through a very simple example and step though the code line by line:







## Commands and keybindings

### `<DEBUG>` mode commands

<table>
<tr>
	<th style="width: 50%;">Command</th>
	<th style="width: 50%;">Screenshot</th>
</tr>
<tr>
	<td>5) If all is well, type `run` and see if your program works. | 6) You can go back to the Assembler by the commands above and edit/update your asm program.</td>
	<td><img src="./assets/images/champ007.png"></td>
</tr>
</table>


<table>
<tr>
	<th style="width: 30%;">Command</th>
	<th style="width: 70%;">Description</th>
</tr>
<tr>
	<td> @addr </td>
	<td> Memory from the given *addr* onwards displayed, one byte at the time, in hex and ascii equivalent. Hit (RET) to advance to next byte, hit (ESC) to return to command level, or type a hex constant to replace the existing content of the byte. </td>
</tr>
<tr>
	<td> A </td>
  <td> Return to Assemble mode. </td>
</tr>
<tr>
	<td> D addr faddr </td>
	<td> Memory from the given address onwards is displayed in screen pages: hit any key to continue, or (ESC) to return to command level. </td>
</tr>
<tr>
	<td> F saddr faddr hx </td>
	<td> Every byte between saddr and faddr is filled with hx. </td>
</tr>
<tr>
	<td> K </td>
	<td> Print source and symbol table usage. </td>
</tr>
<tr>
	<td> M daddr saddr faddr </td>
	<td> The block of memory between saddr and faddr is copied to the block starting at daddr. </td>
</tr>
<tr>
  <td> Q addr </td>
  <td> Memory from addr onwards is disassembled. Hit (RET) to continue and (ESC) to return to command level. </td>
</tr>
<tr>
	<td> G addr </td>
	<td> The code starting at addr is executed (returnable). </td>
</tr>
<tr>
	<td>C addr </td>
	<td> Execute from addr (non-returnable) </td>
</tr>
<tr>
	<td> Bn=addr </td>
	<td> A breakpoint number n (between 1 and 8) is set at addr, to cause a break in execution of any program which accesses the contents of addr as an instruction. Press (C)(RET) to continue from breakpoint. </td>
</tr>
<tr>
	<td> En </td>
	<td> Eliminates breakpoint n. </td>
</tr>
<tr>
	<td> T </td>
	<td> Display the addresses of all breakpoints. </td>
</tr>
<tr>
	<td> R regname </td>
	<td> Displays the contents of a CPU register and accepts a new value (similar to the function of @ above). </td>
</tr>
<tr>
	<td> J addr </td>
	<td> Executes the code from addr onwards, one instruction at the time, giving a full register display. Hit (J) to continue, (ESC) to return to the command level. </td>
</tr>
<tr>
	<td> H expr </td>
	<td> Displays the decimal, hex and binary value of expr. </td>
</tr>
<tr>
	<td> S bytestr </td>
	<td> Searches the memory from $0000 onwards for every occurance of bytestr. </td>
</tr>
<tr>
	<td> N chstr </td>
	<td> As `S` above. </td>
</tr>
<tr>
	<td> W </td>
	<td> Load, save and verify machine code to tape. </td>
</tr>
</table>





Some notes:

- Champ has 3 columns: label, command, arguments.
- Press space if the line does not start with a label, to go to the next column.
- In edit mode, delete a line with `ctrl` `z`.
- Labels start with a letter, are max 6 characters long and have no `:` at the end.
- Hexadecimal addresses start with a `$`.
- Best ORG address $C000 (according to Champ).





## References

[Champ Users Manual](./assets/doc/champ.pdf)

[YouTube: Learn Multi platform Z80 Assembly Programming... ](https://www.youtube.com/watch?v=LpQCEwk2U9w&list=PLp_QNRIYljFq-9nFiAUiAkRzAXfcZTBR_)

[MSX Assembly Page, Grauw](http://map.grauw.nl)

[MSX Made Simple, Margaret Norman](https://www.elsevier.com/books/msx-made-simple/norman/978-0-434-98406-0)

[Practical MSX machine code programming, Steve Webb](https://archive.org/details/practical_msx_machine_code_programming_steve_webb)

