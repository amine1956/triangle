org 100h 
jmp start
;Question 1 :
rect db "Triangle Rectangle $"
isocele db "Triangle Isocele $"
isorect db "Triangle Isocele rectangle $"
equilateral db "Triangle  equilateral $"
simple db "Triangle simple $"
hypomsg db "Entre la valeur de l'hypotenuse $"
arc1msg db "Entre la valeur du premier Arc $"
arc2msg db "Entre la valeur du deuxieme Arc $"
x dw 0 ; la variable de hypotenuse
y dw 0 ; la variable acr1
z dw 0 ; la variable acr2
;Question 2
start:
boucleverif:
lea bx,hypomsg
call AfficheMsg
call RecupVar
mov b.x,al
call AfficheVar
call AfficheRetour
sub x,30h

lea bx,arc1msg
call AfficheMsg
call RecupVar
mov b.y,al
call AfficheVar
call AfficheRetour
sub y,30h

lea bx,arc2msg
call AfficheMsg
call RecupVar
mov b.z,al
call AfficheVar
call AfficheRetour
sub z,30h

call VerifParamProc
cmp dl,0
je boucleverif
call MainProc 
jmp end

;Question 3 :
AfficheVar proc
    mov dl,al
    mov ah,6h
    int 21h
    ret
AfficheVar endp

;Question 4 :
AfficheMsg proc
    mov dx,bx
    mov ah,9h
    int 21h
    ret
AfficheMsg endp

;Question 5 :
AfficheRetour proc
    mov dl,0Dh
    mov ah,06h
    int 21h
    mov dl,0Ah
    int 21h
    ret
AfficheRetour endp

;Question 6 :
RecupVar proc   
bcl:mov ah,00h
    int 16h
    cmp al,30h               ; bonus hhh
    jb bcl
    cmp al,39h
    ja bcl
    ret               
RecupVar endp

;Question 7 :
VerifParamProc proc
    mov dl,0
    mov ax,x
    cmp ax,y
    jb no1
    cmp ax,z
    jb no1
    mov dl,1
no1:ret    
VerifParamProc endp

;Question 8 :
IsEquilateral proc
    push bp
    mov bp,sp
    mov dl,0
    mov ax,[bp+4]     ; z
    cmp ax,[bp+6]     ; y
    jne no2
    cmp ax,[bp+8]     ; x
    jne no2
    mov dl,1
no2:pop bp
    ret
IsEquilateral endp

;Question 9 :
IsIsoRecto proc
    mov si,2
    call IsIsocele
    cmp dl,1
    jne no3
    mov si,2
    call IsRecto
no3:ret
IsIsoRecto endp

;Question 10 :
IsIsocele proc
    push bp
    mov bp,sp
    mov dl,1
    add si,4
    mov ax,[bp+si+2]  ; y
    mov cx,[bp+si+4]  ; x
    cmp ax,cx
    je oui
    cmp cx,[bp+si]    ; z
    je oui
    cmp ax,[bp+si]    ; z
    je oui
    mov dl,0
oui:pop bp
    ret    
IsIsocele endp

;Question 11 :
IsRecto proc
    push bp
    mov bp,sp
    mov dl,0
    add si,4
    mov ax,[bp+si]    ; z
    mul ax
    mov bx,ax
    mov ax,[bp+si+2]  ; y
    mul ax
    add bx,ax
    mov ax,[bp+si+4]  ; x
    mul ax
    cmp ax,bx
    jne no5
    mov dl,1
no5:pop bp
    ret    
IsRecto endp

;Question 12 :
MainProc proc
    push x
    push y
    push z
    
    call IsEquilateral
    cmp dl,1
    jne sv1
    lea bx,equilateral
    jmp fin

sv1:call IsIsoRecto
    cmp dl,1
    jne sv2
    lea bx,isorect
    jmp fin

sv2:mov si,0
    call IsIsocele
    cmp dl,1
    jne sv3
    lea bx,isocele
    jmp fin

sv3:mov si,0
    call IsRecto
    cmp dl,1
    jne sv4
    lea bx,rect
    jmp fin

sv4:lea bx,simple
fin:call AfficheMsg
    add sp,6
    ret
MainProc endp

end:ret    