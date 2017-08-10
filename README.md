# Integer Calculator

### Assignment, class and language
This is the solution to the assignment **Integer Calculator** of class **computer architecture,** written in ARM Assembly with my team member [Ehsan Moslehi](https://github.com/eca852).

### Requirements
The assignment required to write an ARM assembly calculator that implements integer addition, subtraction and multiplication. This assignment was our first one and we just had to get to know ARM assembly. For multiplication we had to use a shift-and-add algorithm that we just learned in class. We were not allowed to use any of the ARM arithmetic instructions for the calculating parts (e.g. add, sub, mul, div, or any variants).

Most of my work was the writing of the calculator menue main.s. My team members most work was writing the mathematical files intadd.s, intmul.s and intsub.s. Once the calculator is startet it asks to enter two numbers (the operands of a calculation). Afterwards it asks for an operation where the user has to chose between addition (+), subtraction (-) or a multiplication (*). The calculator then prints the correct result to the screen and asks, if the user wants to do another calculation. If the user types `y` it all starts with entering two new numbers. If the user types `n` the calculator ends. Any input by the user is checked and false ones are rejected.
