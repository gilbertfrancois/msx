# Writing assembly for MSX with Champ

*Gilbert François Duivesteijn*



On this page, I try to explain how to use Champ for MSX(1) to write, store and deploy programs written in assembly or hybrid basic-asm. Back in the days, around 1986-1988 I liked Champ a lot. It was easy to use, because it was an all-in-one editor, assembler, disassembler, monitor/debugger. On top of it, one could easily escape to basic to test the compiled program, which is still in memory and go back to Champ to do further programming.

The aim of this page is not to be another ASM tutorial, but to show how you can develop and debug on a real MSX with only a cassette player/recorder as storage device, like it was done in the 80's with an MSX1 computer.

Champ is only available on cassette. You can start it with `bload"cas:",r` 

## Example 1

 In this example, I loosly follow Keith tutorial [Learn Z80 Assembly Lesson 3](https://www.youtube.com/watch?v=zPXmvoZz9Nk&list=PLp_QNRIYljFq-9nFiAUiAkRzAXfcZTBR_&index=3). We will make a small program in ASM that performs an add or subtract operation. We will make:

- Basic program that asks for the user input and shows the result.
- ASM program that computes and stores the result in memory.

Start Champ with `bload"cas:",r`. Champ has 4 modes: Insert, edit, assemble and debug. The schema below shows how to switch between modes:

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

|                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](/Users/gilbert/Development/git/msx/assets/images/champ001.png) | ![](/Users/gilbert/Development/git/msx/assets/images/champ002.png) |
| 1) Sample code with condition and 2 math ops.                | 2) Compiling successful. Save the listing as text with `s` -> `filename`. |
| ![](/Users/gilbert/Development/git/msx/assets/images/champ004.png) | ![](/Users/gilbert/Development/git/msx/assets/images/champ005.png) |
| 3) Go to `<debug>` mode with `m`, view memory and disassembled code with `Q [saddr]` and write your binary to cassette with: `w saddr faddr filename`. | 4) In `<assemble>` mode, go to basic with `q` `y` and type in the listing above. |
| ![](/Users/gilbert/Development/git/msx/assets/images/champ006.png) | ![](/Users/gilbert/Development/git/msx/assets/images/champ007.png) |
| 5) If all is well, your basic-asm program works :)           | 6) Go back to Champ                                          |

Some notes:

- Champ has 3 columns: label, command, arguments.
- Press space if the line does not start with a label, to go to the next column.
- In edit mode, delete a line with `ctrl` `z`.
- Labels start with a letter, are max 6 characters long.
- Hexadecimal addresses start with a $
- Best ORG address $C000 (according to Champ)

## Example 2

*Todo...*





## References

[YouTube: Learn Multi platform Z80 Assembly Programming... ](https://www.youtube.com/watch?v=LpQCEwk2U9w&list=PLp_QNRIYljFq-9nFiAUiAkRzAXfcZTBR_)

[Champ Users Manual](./assets/doc/champ.pdf)

