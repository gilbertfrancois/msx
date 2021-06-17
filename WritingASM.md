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

   `[m]`    &uarr;

​      &darr;    `[a]`

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
| 3) Go to **debug** mode by pressing `m`, view memory and disassembled code with `Q saddr`. If you want, you can store your finished binary to cassette with: `W saddr faddr filename`. | 4) Go back to assemble mode by pressing `a`. Go back to basic with `q` `y` and type in the listing above. |
| ![](./assets/images/champ006.png)                            | ![](./assets/images/champ007.png)                            |
| 5) If all is well, type `run` and see if your program works. | 6) You can go back to the Assembler by the commands above and edit/update your asm program. |

Some notes:

- Champ has 3 columns: label, command, arguments.
- Press space if the line does not start with a label, to go to the next column.
- In edit mode, delete a line with `ctrl` `z`.
- Labels start with a letter, are max 6 characters long and have no `:` at the end.
- Hexadecimal addresses start with a `$`.
- Best ORG address $C000 (according to Champ).

## Example 2

*Todo...*





## References

[YouTube: Learn Multi platform Z80 Assembly Programming... ](https://www.youtube.com/watch?v=LpQCEwk2U9w&list=PLp_QNRIYljFq-9nFiAUiAkRzAXfcZTBR_)

[Champ Users Manual](./assets/doc/champ.pdf)

