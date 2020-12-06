.model small
.stack 100h
.data

numberOfElements dw 0;
invite1 db "Enter size  $"
invite2 db "Введите элементы массива: $"
minus db ' -$'
error1 db 'Invalid input. Be attentive , please! $'
flag_initial_zerro dw 0
overflow db 'Overflow ,sorry friend :) $'
a dw 0

tmp dw 0

shift db 0
new_symbol db 0
space db " $"
amount_elem db 26
index db 0



.code


overflowp proc

push ax
;push bx
push cx
push dx
push si
push di

error2:
;preparation
	mov dl,10 ; 10 ascii new line
	mov ah, 2h ;код функции 21 прерывания вывод из регистра al
	int 21h
	mov dl,13 ; перевод курсора на новую строчку на начало строки
	int 21h

;output message
	mov ah, 9 ; 9 я функция 21 прерывания: выводит строку пока не встретит доллар
	mov dx, offset overflow ;
	int 21h

mov bx,9

pop di
pop si 
pop dx
pop cx
;pop bx
pop ax	

mov ah,4Ch
     mov al,00h
    int 21h
ret
overflowp endp



firsttask proc
push cx
push si
push dx
push bx

 ;mov ax,-156
 mov cx, ax

;preparation
 ;mov dl,10 ; 10 ascii new line
 ;mov ah, 2h ;код функции 21 прерывания вывод из регистра al
 ;int 21h
 ;mov dl,13 ; перевод курсора на новую строчку на начало строки
 ;int 21h

;output message
 ;mov ah, 9 ; 9 я функция 21 прерывания: выводит строку пока не встретит доллар
 ;mov dx, offset message ; заносим адрес этой переменной в регистр
 ;int 21h

;clean ax
 xor si,si ;counter
 ;mov ax, a

write :
 ; проверяем число на знак.
   test   cx, cx
   jns    positive_number     ; sf=0 (нет знака)
 
 ;negative
 mov ah, 9 ; 9 я функция 21 прерывания: выводит строку пока не встретит доллар
 mov dx, offset minus ; заносим адрес этой переменной в регистр
 int 21h
 neg cx 

positive_number:
 
 mov bx,10
 label_while:

 
 xor dx,dx
 mov ax,cx
 div bx ; r = dx, d = ax ;ok
 xor cx,cx
 mov cx, ax
 ;xor ah, ah
 push dx
 inc si
  cmp cx,0
 je label_all ;Jump if equal
 jmp label_while

label_all:
 ;push cx
 mov cx, si;ok
 xor ax, ax

 ;ret
 ;write endp


getfromstack:
 ;pop di
 
 mov cx,si
 cycle:
 ;xor dx,dx
 pop dx
 add dx, '0'
 mov ah,02h
        int 21h
 loop cycle
 ;push di
;ret
;getfromstack endp
 


pop bx
pop dx
pop si
pop cx

ret
firsttask endp


backspace proc
push ax
push bx
push cx
push dx
push si
push di

mov bx,10

mov dl, 32
mov ah, 2h; вывод из регистра dl 
int 21

mov ah,02h; in al the symbol
int 21h
mov dl, 08h ;return back
mov ah,02h; in al the symbol
int 21h

xor dx,dx
mov ax,a
div bx
mov a,ax

pop di
pop si 
pop dx
pop cx
pop bx
pop ax ;not COMMENT

ret
backspace endp

secondtask proc
;read
push bx
push si
mov flag_initial_zerro,0
mov bx,10

xor si,si
mov a,0

read_while:
xor ax,ax
xor dx,dx

mov ah,01h; in al the symbol

int 21h
xor ah,ah
cmp al, 13 ;cmp with enter
je endinput
cmp al, 32 ;cmp with bacspace
je endinput
cmp al, 08
jne further3

call backspace
jmp read_while

further3:
cmp al, 27
jne further5


mov dl, 08h ;return back
mov ah,02h; in al the symbol
int 21h
mov dl, 32
mov ah,02h; in al the symbol
int 21h
mov dl, 08h ;return back
mov ah,02h; in al the symbol
int 21h



;call backspace
label_while2:
mov dl, 08h ;return back
mov ah,02h; in al the symbol
int 21h
call backspace
cmp a,0 ;previous
jne label_while2

jmp read_while

further5:
cmp al, '9'
ja invalidinput
cmp al, '0'
jb invalidinput

cmp al, '0'
jne further6

cmp a, 0
jne further7

cmp flag_initial_zerro,0

je further6

call invalidinput 


further6:
mov flag_initial_zerro,1
jmp further7

further7:
sub ax,'0'
mov tmp,ax ;current number
mov ax, a  ;previous
mov bx, 10
mul bx
jnc further

;jc overflowp
call overflowp

further:
add ax, tmp
jnc further1

;jc overflowp
call overflowp

further1:
mov a,ax
;push ax
inc si
jmp read_while


endinput:
mov ax,a

pop si
pop bx
ret
secondtask endp


invalidinput proc
invalidinput:
;preparation
	mov dl,10 ; 10 ascii new line
	mov ah, 2h ;код функции 21 прерывания вывод из регистра al
	int 21h
	mov dl,13 ; перевод курсора на новую строчку на начало строки
	int 21h

;output message
	mov ah, 9 ; 9 я функция 21 прерывания: выводит строку пока не встретит доллар
	mov dx, offset error1 ;
	int 21h
	

mov ah,4Ch
    	mov al,00h
   	int 21h
invalidinput endp


main:
	mov	ax,@data
	mov	ds,ax

;start:
	xor ax,ax
	xor dx,dx


	call secondtask
	mov shift, al
	;call firsttask

	xor ax,ax
	xor bx,bx
    read_while_enter:
    xor ax,ax
 	xor dx,dx

;ALGORITHM
 mov ah,07h; in al the symbol
 int 21h

xor ah,ah
 cmp al, 13
  jz label_all_read_while_enter
  cmp al, 10
  jz label_all_read_while_enter
  cmp al,27
  ;je esc_case



cmp al, 48
jb not_letter_or_number
cmp al,57
ja capital
mov amount_elem,10
mov index,48 
jmp algo


capital:
cmp al,65
jb not_letter_or_number
cmp al, 90
ja @small
mov index,65
mov amount_elem,26
jmp algo


@small:
cmp al,97
jb not_letter_or_number
cmp al,122
ja not_letter_or_number

mov index,97 
mov amount_elem,26
jmp algo



not_letter_or_number:
mov dl,al
mov ah,02
int 21h

;jmp algo
;distant:
;jmp start


algo:
add al, shift
JC problem

sub al, index
div amount_elem
add ah, index
JC problem

mov dl,ah
mov ah,02
int 21h

;  mov data4[si],al
  ;inc si
  ;inc bx
  jmp read_while_enter

 

problem:
;xor bx,bx
call overflowp
;cmp bx, 9
;je distant

label_all_read_while_enter:
mov ah,4Ch
     mov al,00h
    int 21h

end main