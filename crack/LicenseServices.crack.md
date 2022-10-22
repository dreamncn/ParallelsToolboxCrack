# Crack For Parallels Toolbox

crack for 6.0.0-4536

## 1. LicenseServices

Location: `Contents/Frameworks/LicenseServices.framework/Versions/A/LicenseServices`

patch function `-[LICLicenseInfo rawStatus]` to `return 0`

### x86_64

```
__text:0000000000009AB4                         ; int __cdecl -[LICLicenseInfo rawStatus](LICLicenseInfo *self, SEL)
__text:0000000000009AB4                         __LICLicenseInfo_rawStatus_ proc near   ; DATA XREF: __objc_const:00000000001570C0↓o
__text:0000000000009AB4
__text:0000000000009AB4                         var_30          = qword ptr -30h
__text:0000000000009AB4
__text:0000000000009AB4 55                                      push    rbp
__text:0000000000009AB5 48 89 E5                                mov     rbp, rsp
__text:0000000000009AB8 41 57                                   push    r15
__text:0000000000009ABA 41 56                                   push    r14
__text:0000000000009ABC 41 55                                   push    r13
__text:0000000000009ABE 41 54                                   push    r12
__text:0000000000009AC0 53                                      push    rbx
__text:0000000000009AC1 50                                      push    rax
__text:0000000000009AC2 49 89 FC                                mov     r12, rdi
__text:0000000000009AC5 48 8B 7F 18                             mov     rdi, [rdi+18h]  ; id
__text:0000000000009AC9 FF 15 01 27 13 00                       call    cs:_objc_retain_ptr
__text:0000000000009ACF 49 89 C7                                mov     r15, rax
__text:0000000000009AD2 48 89 C7                                mov     rdi, rax        ; obj
__text:0000000000009AD5 E8 06 9D 0E 00                          call    _objc_sync_enter
__text:0000000000009ADA 49 8B 7C 24 18                          mov     rdi, [r12+18h]  ; id
__text:0000000000009ADF 48 8B 35 9A 21 15 00                    mov     rsi, cs:selRef_count ; SEL
__text:0000000000009AE6 FF 15 D4 26 13 00                       call    cs:_objc_msgSend_ptr
__text:0000000000009AEC 48 85 C0                                test    rax, rax
__text:0000000000009AEF 0F 84 60 01 00 00                       jz      loc_9C55
__text:0000000000009AF5 48 8B 3D 44 2B 15 00                    mov     rdi, cs:classRef_LICLicenseInfo ; id
__text:0000000000009AFC 49 8B 54 24 18                          mov     rdx, [r12+18h]
```

opcode

```
55 48 89 E5 41 57 41 56 41 55 41 54 53 50 49 89
FC 48 8B 7F 18 FF 15 01 27 13 00 49 89 C7 48 89
C7 E8 06 9D 0E 00 49 8B 7C 24 18 48 8B 35 9A 21
15 00 FF 15 D4 26 13 00 48 85 C0 0F 84 60 01 00
```

patch

```
48 31 C0 C3
```

after

```
__text:0000000000009AB4                         ; int __cdecl -[LICLicenseInfo rawStatus](LICLicenseInfo *self, SEL)
__text:0000000000009AB4                         __LICLicenseInfo_rawStatus_ proc near   ; DATA XREF: __objc_const:00000000001570C0↓o
__text:0000000000009AB4 48 31 C0                                xor     rax, rax
__text:0000000000009AB7 C3                                      retn
__text:0000000000009AB7                         __LICLicenseInfo_rawStatus_ endp
```

### arm64

```
__text:00000000000096F4                         ; int __cdecl -[LICLicenseInfo rawStatus](LICLicenseInfo *self, SEL)
__text:00000000000096F4                         __LICLicenseInfo_rawStatus_             ; DATA XREF: __objc_methlist:00000000000CD6BC↓o
__text:00000000000096F4
__text:00000000000096F4                         var_30          = -0x30
__text:00000000000096F4                         var_20          = -0x20
__text:00000000000096F4                         var_10          = -0x10
__text:00000000000096F4                         var_s0          =  0
__text:00000000000096F4
__text:00000000000096F4 F8 5F BC A9                             STP             X24, X23, [SP,#-0x10+var_30]!
__text:00000000000096F8 F6 57 01 A9                             STP             X22, X21, [SP,#0x30+var_20]
__text:00000000000096FC F4 4F 02 A9                             STP             X20, X19, [SP,#0x30+var_10]
__text:0000000000009700 FD 7B 03 A9                             STP             X29, X30, [SP,#0x30+var_s0]
__text:0000000000009704 FD C3 00 91                             ADD             X29, SP, #0x30
__text:0000000000009708 F5 03 00 AA                             MOV             X21, X0
__text:000000000000970C 00 0C 40 F9                             LDR             X0, [X0,#0x18] ; id
__text:0000000000009710 8E 0C 03 94                             BL              _objc_retain
__text:0000000000009714 F3 03 00 AA                             MOV             X19, X0
__text:0000000000009718 9E 0C 03 94                             BL              _objc_sync_enter
__text:000000000000971C A0 0E 40 F9                             LDR             X0, [X21,#0x18] ; id
__text:0000000000009720 48 08 00 D0                             ADRP            X8, #selRef_count@PAGE
__text:0000000000009724 01 75 44 F9                             LDR             X1, [X8,#selRef_count@PAGEOFF] ; SEL
__text:0000000000009728 7F 0C 03 94                             BL              _objc_msgSend
__text:000000000000972C 80 09 00 B4                             CBZ             X0, loc_985C
__text:0000000000009730 48 08 00 F0                             ADRP            X8, #classRef_LICLicenseInfo@PAGE
__text:0000000000009734 00 55 41 F9                             LDR             X0, [X8,#classRef_LICLicenseInfo@PAGEOFF] ; id
__text:0000000000009738 A2 0E 40 F9                             LDR             X2, [X21,#0x18]
```

opcode

```
F8 5F BC A9 F6 57 01 A9 F4 4F 02 A9 FD 7B 03 A9
FD C3 00 91 F5 03 00 AA 00 0C 40 F9 8E 0C 03 94
F3 03 00 AA 9E 0C 03 94 A0 0E 40 F9 48 08 00 D0
01 75 44 F9 7F 0C 03 94 80 09 00 B4 48 08 00 F0
```

patch

```
00 00 80 D2 C0 03 5F D6
```

after

```
__text:00000000000096F4                         ; int __cdecl -[LICLicenseInfo rawStatus](LICLicenseInfo *self, SEL)
__text:00000000000096F4                         __LICLicenseInfo_rawStatus_             ; DATA XREF: __objc_methlist:00000000000CD6BC↓o
__text:00000000000096F4 00 00 80 D2                             MOV             X0, #0
__text:00000000000096F8 C0 03 5F D6                             RET
__text:00000000000096F8                         ; End of function -[LICLicenseInfo rawStatus]
```
