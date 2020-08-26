; multi-segment executable file template.

data segment
    ; add your data here!        
debut   db 10,13, "  ***********************************************************   "
        db 10,13, " *                                                           *  "
        db 10,13, "*               _                                             * "
        db 10,13, "*              |_|                                            * "
        db 10,13, "*     ___  ___  _   ECOLE NATIONALE SUPERIEURE D'INFORMATIQUE * "
        db 10,13, "*    / _ \/ __|| |                                            * "
        db 10,13, "*   |  __/\__ \| |      Cycle Preparatoire integre (CPI)      * "
        db 10,13, "*    \___||___/|_|                                            * "
        db 10,13, "*                                 -2017/2018-                 * "
        db 10,13, "*-------------------------------------------------------------* " 
        db 10,13, "*-------------------------------------------------------------* "
        db 10,13, "*                                                             * "
        db 10,13, "* Raliser par: - Bousdira Imane - Mecharbat Lotfi -           * " 
        db 10,13, "*                                                             * "
        db 10,13, "*                    Section: C - Groupe: 8                   * " 
        db 10,13, "*                                                             * "
        db 10,13, "* Encadre par: Mr.KHELOUAT                                    * "
        db 10,13, "*                                                             * "  
        db 10,13, " *                        - TP2 ASSEMBLEUR -                 *  "
        db 10,13, "  ***********************************************************   ",10,13,10,13,
        db 13,10,"Veuillez entrer le nombre: $"
                                                                      
msg2  db 13,10,"l'affichage du nombre: $"
msg3  db 13,10,"ERREUR $"
msg4  db 13,10,"DEBORDEMENT $"
zone db 15 dup(20h) 
de dw 10    
zm dw  ?                                                     

    pkey db 13,10,"press any key...$"
ends

stack segment
    dw   128  dup(0)                                        
ends                                                  

code segment
start:
; set segment registers:
    mov ax, data           
    mov ds, ax
    mov es, ax

    ; add your code here 
    
;////////////////////////////// PROGRAMME PRINCIPAL ////////////////////////////////////////
    
    
    lea dx,debut  
    mov ah,9
    int 21H         
                     

    call lecture
       mov si,0
     mov ax,zm[si]
     add si,2
     mov cx,zm[si]
     cmp cx,43
     je  somme
     
     
     
     
somme: add si,2 
       mov bx,zm[si]
       add si,2
       cmp bx,43
       je  somme
       add ax,bx
       sub si,2
       mov zm[si],ax
       call ecriture
   
                 
    

    

    
    ;call ecriture
  
   

;///////////////////////////////////////////////////////////////////////////////////////////     
    
    
;////////////////////////////////////////////////////////////////////////////////////////////

              ; la procedure qui lit un entier signe represente sur 16 bits
              ;          et le ranger dans la zone memoroir "zm" 
                    

lecture     proc        
    
            mov     si,0
            mov     bx,0 
            mov     cx,0          
 lire:      mov     ah,1                  
            int     21h        
            cmp     al,20h         
            je      lire
            cmp     al,'+'
            je      boucle
            cmp     al,'-'
            jne     suit 
            mov     dh,1
 boucle:    mov     ah,1
            int     21h 
 suit:      cmp     al,0Dh
            je      fbl
            
            cmp     al,2Ah
            mov     cl,al
            je      fbl 
            cmp     al,2Bh
            je      fbl
            cmp     al,2Dh
            je      fbl
            cmp     al,2Fh
            je      fbl 
            
            cmp     al,30h
            jb      err1
            cmp     al,39h
            ja      err1              
            mov     di,bx
            shl     di,1 
            jo      err2
            mov     bx,di  
            shl     di,2
            jo      err2 
            add     bx,di
            jo      err2 
            sub     al,48
            cbw     
            add     bx,ax
            jo      err2
            jmp     boucle            
err1:       lea     dx,msg3
            mov     ah,9
            int     21H
            jmp     ff     
err2:       lea     dx,msg4   
            mov     ah,9
            int     21H
            jmp     ff   
fbl:       
            cmp     bx,0
            je      suiv 
            cmp     dh,1
            jne     fin
            mov     ax,-1
            cwd
            sub     ax,bx
            add     ax,1
            mov     bx,ax
            
fin:        mov     zm[si],bx 
            add     si,2 
suiv:       
            cmp     cl,2Ah
            je      op
            cmp     cl,2Bh
            je      op
            cmp     cl,2Dh
            je      op
            cmp     cl,2Fh
            je      op 
            jmp     fin2
            
op:         mov     al,cl
            cbw       
            mov     zm[si],ax
            add     si,2
            mov     bx,0 
            mov     cx,0
            mov     di,0 
            jmp     boucle          
fin2:                        
            cmp     zm[si-2],2Ah
            je      err1
            cmp     zm[si-2],2Bh
            je      err1
            cmp     zm[si-2],2Dh
            je      err1
            cmp     zm[si-2],2Fh
            je      err1
            
            cmp     zm[0],2Ah
            je      err1 
            cmp     zm[0],2Fh
            je      err1   
            mov   zm[si],61       
            ret    
lecture     endp                                                                           

;////////////////////////////////////////////////////////////////////////////////////////// 


;//////////////////////////////////////////////////////////////////////////////////////////


      ;la procedure qui ecrit un entier signe represente sur 16 bits 
                       
ecriture   proc
                 
    ddd:    mov ax,zm[si]
            cmp ax,61
            je fh 
            
           cmp ax,43
            jne ecr
            
            lea dx,msg2
    mov ah,9
    int 21h 
             
            mov dx,zm[si]
            mov ah,2
            int 21h
          
                 
   ecr:    mov     dx,0
           mov     [zone],10 
           mov     si,8
           mov     zone[si+1],"$" 
           mov     ax,zm
           mov     cx,ax
           cmp     ax,0
           jge     calcul
           mov     bl,"-"
           neg     ax
calcul:    idiv    de
           cmp     ax,0
           jz      suite 
           add     dl,48
           mov     zone[si],dl
           dec     si
           mov     dl,0
           jmp     calcul
suite:     add     dl,48
           mov     zone[si],dl
           cmp     cx,0
           jge     lort
           mov     zone[si-1],bl
lort:      mov     ah,9
           lea     dx,zone
           int     33  
 
            
           add si,2 
               

           jmp ddd
               
    
           
fh: ret         
ecriture   endp


;ecrire proc 
    
    ;deb:    mov ax,zm[si]
     ;       cmp ax,61
       ;     je fh
       ;     cmp ax,43
       ;     je ecr
       ;;     call ecriture
        ;    jp g 
       ;ecr: mov dx,zm[si]
        ;    mov ah,2
        ;;    int 21h
        ;g:  add si,2
         ;   jp deb
             
    
;ecrire    endp
                      
         

;//////////////////////////////////////////////////////////////////////////////////////////

ff:    lea dx, pkey
       mov ah, 9
       int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
