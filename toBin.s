.globl toBin

toBin:
    MOV     R1, R0
    MOV     R2, #0
    MOV     R3, #1
    MOV     R4, #1
    MOV     R0, #0
    MOV     R6, #10
FOR:
    CMP     R1, R2
    BEQ     EXIT
    AND     R5, R1, R3
    MUL     R5, R5, R4
    ADD     R0, R0, R5
    LSR     R1, R1, #1
    MUL     R4, R4, R6
    B       FOR
EXIT:
    BX      LR
