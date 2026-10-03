/* ==== 401000  sub_401000  ()  size=26 ==== */
int __thiscall sub_401000(_DWORD **this, int a2, int a3)
{
  return (*(int (__thiscall **)(_DWORD *, _DWORD **, int, int))(*this[1] + 4))(this[1], this, a2, a3);
}


/* ==== 401020  unknown_libname_3  ()  size=10 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_3(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  this[1] = a2;
  return result;
}


/* ==== 401030  ?Release@CStringData@ATL@@QAEXXZ  (ATL::CStringData::Release(void))  size=26 ==== */
void __thiscall ATL::CStringData::Release(ATL::CStringData *this)
{
  if ( _InterlockedDecrement((volatile signed __int32 *)this + 3) <= 0 )
    (*(void (__thiscall **)(_DWORD, ATL::CStringData *))(**(_DWORD **)this + 4))(*(_DWORD *)this, this);
}


/* ==== 401050  sub_401050  ()  size=24 ==== */
_DWORD *__thiscall sub_401050(_DWORD *this)
{
  int v2; // eax

  v2 = sub_417937();
  *this = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  return this;
}


/* ==== 401090  sub_401090  ()  size=38 ==== */
_DWORD *__thiscall sub_401090(_DWORD *this)
{
  int v2; // eax

  *this = &off_4234CC;
  v2 = sub_417937();
  this[2] = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  this[1] = 0;
  return this;
}


/* ==== 4010C0  sub_4010C0  ()  size=36 ==== */
volatile signed __int32 *__thiscall sub_4010C0(_DWORD *this)
{
  volatile signed __int32 *result; // eax

  result = (volatile signed __int32 *)(this[2] - 16);
  *this = &off_4234CC;
  if ( _InterlockedDecrement(result + 3) <= 0 )
    return (volatile signed __int32 *)(*(int (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)result + 4))(result);
  return result;
}


/* ==== 4010F0  sub_4010F0  ()  size=22 ==== */
void __cdecl __noreturn sub_4010F0(int pExceptionObject)
{
  if ( pExceptionObject == -2147024882 )
    unknown_libname_11();
  AfxThrowOleException(pExceptionObject);
}


/* ==== 401110  sub_401110  ()  size=465 ==== */
int sub_401110()
{
  int result; // eax

  if ( dword_42D9A0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9A0)(dword_42D9A0, 1);
  if ( dword_42D9A4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9A4)(dword_42D9A4, 1);
  if ( dword_42D9A8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9A8)(dword_42D9A8, 1);
  if ( dword_42D9AC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9AC)(dword_42D9AC, 1);
  if ( dword_42D9B0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9B0)(dword_42D9B0, 1);
  if ( dword_42D9B4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9B4)(dword_42D9B4, 1);
  if ( dword_42D9B8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9B8)(dword_42D9B8, 1);
  if ( dword_42D9BC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9BC)(dword_42D9BC, 1);
  if ( dword_42D9C0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9C0)(dword_42D9C0, 1);
  if ( dword_42D9C4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9C4)(dword_42D9C4, 1);
  if ( dword_42D9C8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9C8)(dword_42D9C8, 1);
  if ( dword_42D9CC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9CC)(dword_42D9CC, 1);
  if ( dword_42D9D0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9D0)(dword_42D9D0, 1);
  if ( dword_42D9D4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9D4)(dword_42D9D4, 1);
  if ( dword_42D9D8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9D8)(dword_42D9D8, 1);
  if ( dword_42D9DC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9DC)(dword_42D9DC, 1);
  if ( dword_42D9E0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9E0)(dword_42D9E0, 1);
  if ( dword_42D9E4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9E4)(dword_42D9E4, 1);
  if ( dword_42D9E8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9E8)(dword_42D9E8, 1);
  if ( dword_42D9EC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9EC)(dword_42D9EC, 1);
  if ( dword_42D9F0 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9F0)(dword_42D9F0, 1);
  if ( dword_42D9F4 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9F4)(dword_42D9F4, 1);
  if ( dword_42D9F8 )
    result = (**(int (__thiscall ***)(int, int))dword_42D9F8)(dword_42D9F8, 1);
  if ( dword_42D9FC )
    result = (**(int (__thiscall ***)(int, int))dword_42D9FC)(dword_42D9FC, 1);
  if ( dword_42DA00 )
    result = (**(int (__thiscall ***)(int, int))dword_42DA00)(dword_42DA00, 1);
  if ( dword_42DA04 )
    result = (**(int (__thiscall ***)(int, int))dword_42DA04)(dword_42DA04, 1);
  if ( dword_42DA08 )
    result = (**(int (__thiscall ***)(int, int))dword_42DA08)(dword_42DA08, 1);
  if ( dword_42DA0C )
    result = (**(int (__thiscall ***)(int, int))dword_42DA0C)(dword_42DA0C, 1);
  if ( dword_42DA10 )
    return (**(int (__thiscall ***)(int, int))dword_42DA10)(dword_42DA10, 1);
  return result;
}


/* ==== 4012F0  ?SetLength@?$CSimpleStringT@D$0A@@ATL@@AAEXH@Z  (ATL::CSimpleStringT<char,0>::SetLength(int))  size=37 ==== */
int __thiscall ATL::CSimpleStringT<char,0>::SetLength(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  if ( a2 < 0 || a2 > *(_DWORD *)(*this - 8) )
    sub_4010F0(-2147024809);
  *(_DWORD *)(*this - 12) = a2;
  *(_BYTE *)(a2 + *this) = 0;
  return result;
}


/* ==== 401320  sub_401320  ()  size=10 ==== */
void __noreturn sub_401320()
{
  sub_4010F0(-2147024882);
}


/* ==== 401330  sub_401330  ()  size=123 ==== */
int __thiscall sub_401330(int *this, int a2)
{
  volatile signed __int32 *v2; // ebx
  int v3; // ebp
  int (__thiscall ***v4)(_DWORD, int, int); // eax
  int v5; // esi
  int v6; // eax
  int result; // eax
  int v9; // [esp+14h] [ebp+4h]

  v2 = (volatile signed __int32 *)(*this - 16);
  v3 = *((_DWORD *)v2 + 1);
  v4 = (int (__thiscall ***)(_DWORD, int, int))(*(int (__thiscall **)(volatile signed __int32))(**(_DWORD **)v2 + 16))(*v2);
  v5 = a2;
  v6 = (**v4)(v4, a2, 1);
  if ( !v6 )
    sub_401320();
  if ( v3 < a2 )
    v5 = v3;
  v9 = v6 + 16;
  qmemcpy((void *)(v6 + 16), (const void *)(v2 + 4), v5 + 1);
  *(_DWORD *)(v6 + 4) = v3;
  if ( _InterlockedDecrement(v2 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v2 + 4))(v2);
  result = v9;
  *this = v9;
  return result;
}


/* ==== 4013B0  sub_4013B0  ()  size=44 ==== */
int __thiscall sub_4013B0(int *this, int a2)
{
  int v3; // eax
  int result; // eax

  v3 = (*(int (__thiscall **)(_DWORD, int, int, int))(**(_DWORD **)(*this - 16) + 8))(
         *(_DWORD *)(*this - 16),
         *this - 16,
         a2,
         1);
  if ( !v3 )
    sub_401320();
  result = v3 + 16;
  *this = result;
  return result;
}


/* ==== 4013E0  sub_4013E0  ()  size=97 ==== */
volatile signed __int32 *__thiscall sub_4013E0(volatile signed __int32 **this)
{
  volatile signed __int32 *v2; // ecx
  volatile signed __int32 *result; // eax
  int v4; // edi

  v2 = *this;
  result = v2 - 4;
  v4 = *((_DWORD *)v2 - 4);
  if ( *((_DWORD *)v2 - 3) )
  {
    if ( *((int *)result + 3) >= 0 )
    {
      if ( _InterlockedDecrement(result + 3) <= 0 )
        (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)result + 4))(result);
      result = (volatile signed __int32 *)((*(int (__thiscall **)(int))(*(_DWORD *)v4 + 12))(v4) + 16);
      *this = result;
    }
    else
    {
      if ( *((int *)v2 - 2) < 0 )
        sub_4010F0(-2147024809);
      *((_DWORD *)v2 - 3) = 0;
      result = *this;
      *(_BYTE *)*this = 0;
    }
  }
  return result;
}


/* ==== 401450  sub_401450  ()  size=76 ==== */
int __thiscall sub_401450(int *this, int a2)
{
  int v2; // edx
  _DWORD *v3; // eax
  int result; // eax
  int v5; // eax

  v2 = a2;
  v3 = (_DWORD *)(*this - 16);
  if ( v3[1] > a2 )
    v2 = v3[1];
  if ( (int)v3[3] > 1 )
    return sub_401330(this, v2);
  result = v3[2];
  if ( result < v2 )
  {
    if ( result <= 1024 )
      v5 = 2 * result;
    else
      v5 = result + 1024;
    if ( v5 < v2 )
      v5 = v2;
    return sub_4013B0(this, v5);
  }
  return result;
}


/* ==== 4014A0  sub_4014A0  ()  size=45 ==== */
int __thiscall sub_4014A0(int *this, int a2)
{
  if ( ((*(_DWORD *)(*this - 16 + 8) - a2) | (1 - *(_DWORD *)(*this - 4))) < 0 )
    sub_401450(this, a2);
  return *this;
}


/* ==== 4014D0  sub_4014D0  ()  size=35 ==== */
_DWORD *__thiscall sub_4014D0(_DWORD *this, int a2)
{
  sub_401090(this);
  *this = &off_4234CC;
  this[1] = dword_42D9A0;
  this[3] = a2;
  return this;
}


/* ==== 401520  sub_401520  ()  size=153 ==== */
volatile signed __int32 *__thiscall sub_401520(volatile signed __int32 **this, const void *a2, int Size)
{
  volatile signed __int32 *result; // eax
  const void *v5; // edx
  unsigned int v6; // esi
  unsigned int v7; // edi
  volatile signed __int32 *v8; // eax

  if ( !Size )
    return sub_4013E0(this);
  v5 = a2;
  if ( !a2 )
    goto LABEL_4;
  v6 = (_BYTE *)a2 - (_BYTE *)*this;
  v7 = *((_DWORD *)*this - 3);
  if ( ((*((_DWORD *)*this - 2) - Size) | (1 - *((_DWORD *)*this - 1))) < 0 )
  {
    sub_401450((int *)this, Size);
    v5 = a2;
  }
  v8 = *this;
  if ( v6 > v7 )
    qmemcpy((void *)v8, v5, Size);
  else
    memcpy((void *)v8, (char *)v8 + v6, Size);
  if ( Size < 0 || Size > *((_DWORD *)*this - 2) )
LABEL_4:
    sub_4010F0(-2147024809);
  *((_DWORD *)*this - 3) = Size;
  result = *this;
  *((_BYTE *)*this + Size) = 0;
  return result;
}


/* ==== 4015C0  sub_4015C0  ()  size=53 ==== */
volatile signed __int32 *__thiscall sub_4015C0(volatile signed __int32 **this, const void *a2)
{
  if ( a2 )
    return sub_401520(this, a2, strlen((const char *)a2));
  else
    return sub_401520(this, 0, 0);
}


/* ==== 401600  sub_401600  ()  size=57 ==== */
volatile signed __int32 **__thiscall sub_401600(volatile signed __int32 **this, const void *a2)
{
  if ( a2 )
    sub_401520(this, a2, strlen((const char *)a2));
  else
    sub_401520(this, 0, 0);
  return this;
}


/* ==== 401640  sub_401640  ()  size=83 ==== */
void *__thiscall sub_401640(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4234D8;
  *((_WORD *)this + 2) = 0;
  sub_401520((volatile signed __int32 **)this + 2, "Waiting", 7);
  return this;
}


/* ==== 4016A0  sub_4016A0  ()  size=87 ==== */
void *__thiscall sub_4016A0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4234EC;
  *((_WORD *)this + 2) = 1;
  sub_401520((volatile signed __int32 **)this + 2, "Wait connect response", 21);
  return this;
}


/* ==== 401700  sub_401700  ()  size=87 ==== */
void *__thiscall sub_401700(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423510;
  *((_WORD *)this + 2) = 2;
  sub_401520((volatile signed __int32 **)this + 2, "Wait initialize response", 24);
  return this;
}


/* ==== 401760  sub_401760  ()  size=87 ==== */
void *__thiscall sub_401760(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423538;
  *((_WORD *)this + 2) = 3;
  sub_401520((volatile signed __int32 **)this + 2, "Wait writer size echo back", 26);
  return this;
}


/* ==== 4017C0  sub_4017C0  ()  size=36 ==== */
volatile signed __int32 *__thiscall sub_4017C0(_DWORD *this)
{
  volatile signed __int32 *result; // eax

  result = (volatile signed __int32 *)(this[2] - 16);
  *this = &off_4234D0;
  if ( _InterlockedDecrement(result + 3) <= 0 )
    return (volatile signed __int32 *)(*(int (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)result + 4))(result);
  return result;
}


/* ==== 4017F0  sub_4017F0  ()  size=87 ==== */
void *__thiscall sub_4017F0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423560;
  *((_WORD *)this + 2) = 4;
  sub_401520((volatile signed __int32 **)this + 2, "Wait writer data echo back", 26);
  return this;
}


/* ==== 401850  sub_401850  ()  size=87 ==== */
void *__thiscall sub_401850(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423588;
  *((_WORD *)this + 2) = 5;
  sub_401520((volatile signed __int32 **)this + 2, "Wait rom deleted notification", 29);
  return this;
}


/* ==== 4018B0  sub_4018B0  ()  size=87 ==== */
void *__thiscall sub_4018B0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4235B4;
  *((_WORD *)this + 2) = 6;
  sub_401520((volatile signed __int32 **)this + 2, "Wait writer executed notification", 33);
  return this;
}


/* ==== 401910  sub_401910  ()  size=87 ==== */
void *__thiscall sub_401910(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4235E4;
  *((_WORD *)this + 2) = 7;
  sub_401520((volatile signed __int32 **)this + 2, "Wait CPU clock response", 23);
  return this;
}


/* ==== 401970  sub_401970  ()  size=87 ==== */
void *__thiscall sub_401970(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423608;
  *((_WORD *)this + 2) = 8;
  sub_401520((volatile signed __int32 **)this + 2, "Wait new baudrate response", 26);
  return this;
}


/* ==== 4019D0  sub_4019D0  ()  size=87 ==== */
void *__thiscall sub_4019D0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423630;
  *((_WORD *)this + 2) = 9;
  sub_401520((volatile signed __int32 **)this + 2, "Wait new baudrate set complete", 30);
  return this;
}


/* ==== 401A30  sub_401A30  ()  size=87 ==== */
void *__thiscall sub_401A30(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_42365C;
  *((_WORD *)this + 2) = 10;
  sub_401520((volatile signed __int32 **)this + 2, "Wait firmware data echo back", 28);
  return this;
}


/* ==== 401A90  sub_401A90  ()  size=30 ==== */
_DWORD *__thiscall sub_401A90(_DWORD *Block, char a2)
{
  sub_4017C0(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 401AB0  sub_401AB0  ()  size=87 ==== */
void *__thiscall sub_401AB0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423688;
  *((_WORD *)this + 2) = 11;
  sub_401520((volatile signed __int32 **)this + 2, "Wait complete", 13);
  return this;
}


/* ==== 401B10  sub_401B10  ()  size=87 ==== */
void *__thiscall sub_401B10(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4236A4;
  *((_WORD *)this + 2) = 12;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait init response", 27);
  return this;
}


/* ==== 401B70  sub_401B70  ()  size=87 ==== */
void *__thiscall sub_401B70(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4236CC;
  *((_WORD *)this + 2) = 13;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait device information", 32);
  return this;
}


/* ==== 401BD0  sub_401BD0  ()  size=87 ==== */
void *__thiscall sub_401BD0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4236FC;
  *((_WORD *)this + 2) = 14;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait set device information", 36);
  return this;
}


/* ==== 401C30  sub_401C30  ()  size=87 ==== */
void *__thiscall sub_401C30(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423730;
  *((_WORD *)this + 2) = 15;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait clock information", 31);
  return this;
}


/* ==== 401C90  sub_401C90  ()  size=87 ==== */
void *__thiscall sub_401C90(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_42375C;
  *((_WORD *)this + 2) = 16;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait clock information", 31);
  return this;
}


/* ==== 401CF0  sub_401CF0  ()  size=87 ==== */
void *__thiscall sub_401CF0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423768;
  *((_WORD *)this + 2) = 17;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait write size", 24);
  return this;
}


/* ==== 401D50  sub_401D50  ()  size=87 ==== */
void *__thiscall sub_401D50(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423790;
  *((_WORD *)this + 2) = 18;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait new baudrate", 26);
  return this;
}


/* ==== 401DB0  sub_401DB0  ()  size=87 ==== */
void *__thiscall sub_401DB0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4237B8;
  *((_WORD *)this + 2) = 19;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait set baudrate", 26);
  return this;
}


/* ==== 401E10  sub_401E10  ()  size=87 ==== */
void *__thiscall sub_401E10(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4237E0;
  *((_WORD *)this + 2) = 20;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait id code", 21);
  return this;
}


/* ==== 401E70  sub_401E70  ()  size=87 ==== */
void *__thiscall sub_401E70(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423804;
  *((_WORD *)this + 2) = 21;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait erase mode", 24);
  return this;
}


/* ==== 401ED0  sub_401ED0  ()  size=94 ==== */
void *__thiscall sub_401ED0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_42382C;
  *((_WORD *)this + 2) = 22;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait block erase", 25);
  *((_DWORD *)this + 4) = 22;
  return this;
}


/* ==== 401F30  sub_401F30  ()  size=94 ==== */
void *__thiscall sub_401F30(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423854;
  *((_WORD *)this + 2) = 23;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait erase end", 23);
  *((_DWORD *)this + 4) = 22;
  return this;
}


/* ==== 401F90  sub_401F90  ()  size=87 ==== */
void *__thiscall sub_401F90(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423878;
  *((_WORD *)this + 2) = 24;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait delete rom", 24);
  return this;
}


/* ==== 401FF0  sub_401FF0  ()  size=87 ==== */
void *__thiscall sub_401FF0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4238A0;
  *((_WORD *)this + 2) = 25;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait write mode", 24);
  return this;
}


/* ==== 402050  sub_402050  ()  size=87 ==== */
void *__thiscall sub_402050(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4238C8;
  *((_WORD *)this + 2) = 26;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait firmware data", 27);
  return this;
}


/* ==== 4020B0  sub_4020B0  ()  size=87 ==== */
void *__thiscall sub_4020B0(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_4238F0;
  *((_WORD *)this + 2) = 27;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait complete", 22);
  return this;
}


/* ==== 402110  sub_402110  ()  size=87 ==== */
void *__thiscall sub_402110(void *this)
{
  sub_406020();
  *(_DWORD *)this = &off_423914;
  *((_WORD *)this + 2) = 28;
  sub_401520((volatile signed __int32 **)this + 2, "H8S/2370 wait check sum", 23);
  return this;
}


/* ==== 402170  sub_402170  ()  size=6 ==== */
char **sub_402170()
{
  return &off_4239B8;
}


/* ==== 402180  sub_402180  ()  size=6 ==== */
_UNKNOWN ****sub_402180()
{
  return &off_423938;
}


/* ==== 402190  sub_402190  ()  size=11 ==== */
int __thiscall sub_402190(CGdiObject *this)
{
  *(_DWORD *)this = &CGdiObject::`vftable';
  return CGdiObject::DeleteObject(this);
}


/* ==== 4021A0  sub_4021A0  ()  size=59 ==== */
CDialog *__thiscall sub_4021A0(CDialog *this, int a2, struct CWnd *a3)
{
  CDialog::CDialog(this, 0x91u, a3);
  *(_DWORD *)this = &off_4239E8;
  *((_DWORD *)this + 29) = 0;
  *((_DWORD *)this + 28) = &CFont::`vftable';
  *((_DWORD *)this + 31) = 0;
  *((_DWORD *)this + 30) = &CFont::`vftable';
  *((_DWORD *)this + 32) = a2;
  return this;
}


/* ==== 4021E0  sub_4021E0  ()  size=13 ==== */
BOOL __thiscall sub_4021E0(HWND *this)
{
  return EnableWindow(this[7], 0);
}


/* ==== 4021F0  sub_4021F0  ()  size=13 ==== */
BOOL __thiscall sub_4021F0(HWND *this)
{
  return EnableWindow(this[7], 1);
}


/* ==== 402200  sub_402200  ()  size=17 ==== */
int __thiscall sub_402200(void *this, unsigned __int16 a2)
{
  return (*(int (__thiscall **)(void *, _DWORD))(*(_DWORD *)this + 308))(this, a2);
}


/* ==== 402220  sub_402220  ()  size=107 ==== */
int __thiscall sub_402220(_DWORD *this)
{
  CGdiObject *v2; // ecx

  *this = &off_4239E8;
  v2 = (CGdiObject *)(this + 30);
  *(_DWORD *)v2 = &CGdiObject::`vftable';
  CGdiObject::DeleteObject(v2);
  this[28] = &CGdiObject::`vftable';
  CGdiObject::DeleteObject((CGdiObject *)(this + 28));
  return sub_417B12(this);
}


/* ==== 402290  sub_402290  ()  size=359 ==== */
UINT_PTR __thiscall sub_402290(CWnd *this, int a2)
{
  UINT_PTR result; // eax
  CWnd *v4; // eax
  CWnd *v5; // eax
  CWnd *v6; // eax
  CWnd *DlgItem; // eax
  CWnd *v8; // eax
  CWnd *v9; // eax
  CWnd *v10; // eax
  CWnd *v11; // eax

  *((_DWORD *)this + 33) = a2;
  if ( a2 )
  {
    if ( a2 == 1 )
    {
      DlgItem = CWnd::GetDlgItem(this, 1023);
      CWnd::EnableWindow(DlgItem, 0);
      v8 = CWnd::GetDlgItem(this, 2);
      CWnd::EnableWindow(v8, 0);
      return SetTimer(*((HWND *)this + 7), 0x8001u, 0x3E8u, 0);
    }
    else
    {
      result = a2 - 2;
      if ( a2 == 2 )
      {
        if ( *((_DWORD *)this + 32) )
          sub_41B959(1025, &byte_423D58);
        else
          sub_41B959(
            1025,
            "Next, prepare the device you want to update.\r\n"
            "\r\n"
            "1. Switch the device you want to update to \"Program writing mode\".\r\n"
            "\r\n"
            "2. After switching mode, connect the device to your computer using a USB cable.\r\n"
            "\r\n"
            "3. Press the \"Next\" button.");
        sub_41B959(1023, "Next");
        v4 = CWnd::GetDlgItem(this, 1023);
        CWnd::EnableWindow(v4, 1);
        v5 = CWnd::GetDlgItem(this, 2);
        CWnd::EnableWindow(v5, 0);
        v6 = CWnd::GetDlgItem(this, 1026);
        CWnd::ShowWindow(v6, 0);
        return KillTimer(*((HWND *)this + 7), 0x8001u);
      }
    }
  }
  else
  {
    if ( *((_DWORD *)this + 32) )
      sub_41B959(1025, &byte_423B48);
    else
      sub_41B959(
        1025,
        "When updating the firmware of this model for the first time, installing the USB Driver is required before connec"
        "ting the update device to the computer.\r\n"
        "(Installing the driver is not required for the second and subsequent updates)\r\n"
        "\r\n"
        "Would you like to install the USB Driver?");
    sub_41B959(1023, "Install");
    v9 = CWnd::GetDlgItem(this, 1023);
    CWnd::EnableWindow(v9, 1);
    v10 = CWnd::GetDlgItem(this, 2);
    CWnd::EnableWindow(v10, 1);
    v11 = CWnd::GetDlgItem(this, 1026);
    CWnd::ShowWindow(v11, 0);
    return KillTimer(*((HWND *)this + 7), 0x8001u);
  }
  return result;
}


/* ==== 402490  sub_402490  ()  size=68 ==== */
int __thiscall sub_402490(CDialog *this, struct tagMSG *a2)
{
  if ( a2->message == 32771 )
  {
    sub_402290(this, 2);
  }
  else if ( a2->message - 32772 <= 1 )
  {
    sub_402290(this, 0);
    return CDialog::PreTranslateMessage(this, a2);
  }
  return CDialog::PreTranslateMessage(this, a2);
}


/* ==== 4024E0  sub_4024E0  ()  size=30 ==== */
CGdiObject *__thiscall sub_4024E0(CGdiObject *Block, char a2)
{
  sub_402190(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 402500  sub_402500  ()  size=30 ==== */
_DWORD *__thiscall sub_402500(_DWORD *Block, char a2)
{
  sub_402220(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 402520  sub_402520  ()  size=266 ==== */
int __thiscall sub_402520(CWnd *this)
{
  char *v2; // edi
  HFONT FontA; // eax
  struct CWnd *DlgItem; // eax
  struct CWnd *v5; // eax
  void *v6; // eax
  struct CGdiObject *v7; // eax
  char *v8; // edi
  HFONT v9; // eax
  struct CWnd *v10; // eax
  LOGFONTA pv; // [esp+Ch] [ebp-40h] BYREF

  CDialog::OnInitDialog(this);
  if ( *((_DWORD *)this + 32) == 1 )
  {
    v2 = (char *)this + 112;
    FontA = CreateFontA(14, 0, 0, 0, 0, 0, 0, 0, 0x80u, 4u, 0, 0, 0, &pszFaceName);
    sub_41DA5E(FontA);
    DlgItem = CWnd::GetDlgItem(this, 1025);
    if ( this != (CWnd *)-112 )
      v2 = (char *)*((_DWORD *)this + 29);
    SendMessageA(*((HWND *)DlgItem + 7), 0x30u, (WPARAM)v2, 1);
  }
  v5 = CWnd::GetDlgItem(this, 1026);
  v6 = (void *)SendMessageA(*((HWND *)v5 + 7), 0x31u, 0, 0);
  v7 = CGdiObject::FromHandle(v6);
  GetObjectA(*((HANDLE *)v7 + 1), 60, &pv);
  v8 = (char *)this + 120;
  pv.lfHeight = 24;
  CGdiObject::DeleteObject((CWnd *)((char *)this + 120));
  v9 = CreateFontIndirectA(&pv);
  sub_41DA5E(v9);
  v10 = CWnd::GetDlgItem(this, 1026);
  if ( this != (CWnd *)-120 )
    v8 = (char *)*((_DWORD *)this + 31);
  SendMessageA(*((HWND *)v10 + 7), 0x30u, (WPARAM)v8, 1);
  sub_402290(this, 0);
  return 1;
}


/* ==== 402630  sub_402630  ()  size=341 ==== */
int __stdcall sub_402630(HWND hWnd)
{
  _PROCESS_INFORMATION ProcessInformation; // [esp+8h] [ebp-180h] BYREF
  struct _STARTUPINFOA StartupInfo; // [esp+18h] [ebp-170h] BYREF
  int v4[74]; // [esp+5Ch] [ebp-12Ch] BYREF

  memset(v4, 0, 24);
  if ( sub_41C01C("HMSEUSBDRIVER.exe", (int)v4) )
  {
    if ( sub_41C01C("vcredist_x86.exe", (int)v4) )
    {
      memset(&StartupInfo, 0, sizeof(StartupInfo));
      StartupInfo.cb = 68;
      StartupInfo.dwFlags = 1;
      StartupInfo.wShowWindow = 1;
      if ( CreateProcessA(0, (LPSTR)"HMSEUSBDRIVER.exe", 0, 0, 0, 0, 0, 0, &StartupInfo, &ProcessInformation) )
      {
        WaitForSingleObject(ProcessInformation.hProcess, 0xFFFFFFFF);
        StartupInfo.cb = 68;
        StartupInfo.dwFlags = 1;
        StartupInfo.wShowWindow = 1;
        if ( CreateProcessA(0, (LPSTR)"vcredist_x86.exe", 0, 0, 0, 0, 0, 0, &StartupInfo, &ProcessInformation) )
        {
          WaitForSingleObject(ProcessInformation.hProcess, 0xFFFFFFFF);
          PostMessageA(hWnd, 0x8003u, 0, 0);
        }
        else
        {
          PostMessageA(hWnd, 0x8005u, 0, 0);
        }
      }
      else
      {
        PostMessageA(hWnd, 0x8004u, 0, 0);
      }
    }
    else
    {
      PostMessageA(hWnd, 0x8005u, 0, 0);
    }
  }
  else
  {
    PostMessageA(hWnd, 0x8004u, 0, 0);
  }
  return 0;
}


/* ==== 402830  sub_402830  ()  size=32 ==== */
_DWORD *__thiscall sub_402830(_DWORD *this)
{
  _DWORD *result; // eax

  result = this;
  *this = &off_423F78;
  this[1] = 0;
  this[2] = 0;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = 0;
  this[7] = 0;
  return result;
}


/* ==== 402850  sub_402850  ()  size=3 ==== */
int __thiscall sub_402850(int (**this)(void))
{
  return this[2]();
}


/* ==== 402860  sub_402860  ()  size=3 ==== */
int __thiscall sub_402860(int (**this)(void))
{
  return this[4]();
}


/* ==== 402870  sub_402870  ()  size=3 ==== */
int __thiscall sub_402870(int (**this)(void))
{
  return this[5]();
}


/* ==== 402880  sub_402880  ()  size=3 ==== */
int __thiscall sub_402880(int (**this)(void))
{
  return this[6]();
}


/* ==== 402890  sub_402890  ()  size=3 ==== */
int __thiscall sub_402890(int (**this)(void))
{
  return this[7]();
}


/* ==== 4028A0  sub_4028A0  ()  size=32 ==== */
HMODULE __thiscall sub_4028A0(_DWORD *this)
{
  HMODULE result; // eax

  result = (HMODULE)this[1];
  *this = &off_423F78;
  if ( result )
  {
    result = (HMODULE)FreeLibrary(result);
    this[1] = 0;
  }
  return result;
}


/* ==== 4028C0  sub_4028C0  ()  size=52 ==== */
_DWORD *__thiscall sub_4028C0(_DWORD *Block, char a2)
{
  HMODULE v3; // eax

  v3 = (HMODULE)Block[1];
  *Block = &off_423F78;
  if ( v3 )
  {
    FreeLibrary(v3);
    Block[1] = 0;
  }
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 402900  sub_402900  ()  size=180 ==== */
int __thiscall sub_402900(int this, LPCSTR lpLibFileName)
{
  HMODULE LibraryA; // eax
  FARPROC GetConfigInfo_RE; // eax
  FARPROC SetTimeout_RE; // eax
  FARPROC ReadData_RE; // eax
  HMODULE v8; // [esp-Ch] [ebp-14h]
  HMODULE v9; // [esp-Ch] [ebp-14h]
  HMODULE v10; // [esp-Ch] [ebp-14h]

  LibraryA = LoadLibraryA(lpLibFileName);
  *(_DWORD *)(this + 4) = LibraryA;
  if ( LibraryA )
  {
    *(_DWORD *)(this + 8) = GetProcAddress(LibraryA, "Open_RE");
    GetConfigInfo_RE = GetProcAddress(*(HMODULE *)(this + 4), "GetConfigInfo_RE");
    v8 = *(HMODULE *)(this + 4);
    *(_DWORD *)(this + 12) = GetConfigInfo_RE;
    SetTimeout_RE = GetProcAddress(v8, "SetTimeout_RE");
    v9 = *(HMODULE *)(this + 4);
    *(_DWORD *)(this + 16) = SetTimeout_RE;
    *(_DWORD *)(this + 20) = GetProcAddress(v9, "WriteData_RE");
    ReadData_RE = GetProcAddress(*(HMODULE *)(this + 4), "ReadData_RE");
    v10 = *(HMODULE *)(this + 4);
    *(_DWORD *)(this + 24) = ReadData_RE;
    *(_DWORD *)(this + 28) = GetProcAddress(v10, "Close_RE");
    if ( _InterlockedDecrement((volatile signed __int32 *)lpLibFileName - 1) <= 0 )
      (*(void (__thiscall **)(_DWORD, LPCSTR))(**((_DWORD **)lpLibFileName - 4) + 4))(
        *((_DWORD *)lpLibFileName - 4),
        lpLibFileName - 16);
    return 1;
  }
  else
  {
    if ( _InterlockedDecrement((volatile signed __int32 *)lpLibFileName - 1) <= 0 )
      (*(void (__thiscall **)(_DWORD, LPCSTR))(**((_DWORD **)lpLibFileName - 4) + 4))(
        *((_DWORD *)lpLibFileName - 4),
        lpLibFileName - 16);
    return 0;
  }
}


/* ==== 4029C0  sub_4029C0  ()  size=6 ==== */
char **sub_4029C0()
{
  return &off_423FD0;
}


/* ==== 4029D0  sub_4029D0  ()  size=44 ==== */
CDialog *__thiscall sub_4029D0(CDialog *this, struct CWnd *a2)
{
  CDialog::CDialog(this, 0x86u, a2);
  *(_DWORD *)this = &off_423FF8;
  *((_DWORD *)this + 29) = 0;
  *((_DWORD *)this + 28) = &CFont::`vftable';
  return this;
}


/* ==== 402A00  ??1strstreambuf@std@@UAE@XZ  (std::strstreambuf::~strstreambuf(void))  size=88 ==== */
void __thiscall std::strstreambuf::~strstreambuf(std::strstreambuf *this)
{
  CGdiObject *v2; // ecx

  *(_DWORD *)this = &off_423FF8;
  v2 = (std::strstreambuf *)((char *)this + 112);
  *(_DWORD *)v2 = &CGdiObject::`vftable';
  CGdiObject::DeleteObject(v2);
  sub_417B12(this);
}


/* ==== 402A60  sub_402A60  ()  size=144 ==== */
int __thiscall sub_402A60(CWnd *this)
{
  int v2; // eax
  int v3; // edi
  char *v4; // edi
  HFONT FontA; // eax
  struct CWnd *DlgItem; // eax

  CDialog::OnInitDialog(this);
  v2 = *((_DWORD *)AfxGetModuleState() + 1);
  v3 = *(_DWORD *)(v2 + 160);
  sub_41B959(1019, *(LPCSTR *)(v2 + 168));
  if ( *(_DWORD *)(v3 + 1048636) == 1 )
  {
    v4 = (char *)this + 112;
    FontA = CreateFontA(14, 0, 0, 0, 0, 0, 0, 0, 0x80u, 4u, 0, 0, 0, &pszFaceName);
    sub_41DA5E(FontA);
    DlgItem = CWnd::GetDlgItem(this, 1019);
    if ( this != (CWnd *)-112 )
      v4 = (char *)*((_DWORD *)this + 29);
    SendMessageA(*((HWND *)DlgItem + 7), 0x30u, (WPARAM)v4, 1);
  }
  return 1;
}


/* ==== 402AF0  sub_402AF0  ()  size=30 ==== */
std::strstreambuf *__thiscall sub_402AF0(std::strstreambuf *Block, char a2)
{
  std::strstreambuf::~strstreambuf(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 402B10  sub_402B10  ()  size=6 ==== */
char **sub_402B10()
{
  return &off_424150;
}


/* ==== 402B20  nullsub_3  ()  size=1 ==== */
void nullsub_3()
{
  ;
}


/* ==== 402B30  sub_402B30  ()  size=44 ==== */
CDialog *__thiscall sub_402B30(CDialog *this, struct CWnd *a2)
{
  CDialog::CDialog(this, 0x88u, a2);
  *(_DWORD *)this = &off_424178;
  *((_DWORD *)this + 29) = 0;
  *((_DWORD *)this + 28) = &CFont::`vftable';
  return this;
}


/* ==== 402B60  ??1strstreambuf@std@@UAE@XZ_0  (std::strstreambuf::~strstreambuf(void))  size=88 ==== */
void __thiscall std::strstreambuf::~strstreambuf(std::strstreambuf *this)
{
  CGdiObject *v2; // ecx

  *(_DWORD *)this = &off_424178;
  v2 = (std::strstreambuf *)((char *)this + 112);
  *(_DWORD *)v2 = &CGdiObject::`vftable';
  CGdiObject::DeleteObject(v2);
  sub_417B12(this);
}


/* ==== 402BC0  sub_402BC0  ()  size=94 ==== */
int __cdecl sub_402BC0(volatile signed __int32 *a1)
{
  int (__thiscall ***v1)(_DWORD, _DWORD, int); // eax
  int result; // eax

  v1 = (int (__thiscall ***)(_DWORD, _DWORD, int))(*(int (__thiscall **)(volatile signed __int32))(**(_DWORD **)a1 + 16))(*a1);
  if ( *((int *)a1 + 3) >= 0 && v1 == *(int (__thiscall ****)(_DWORD, _DWORD, int))a1 )
  {
    result = (int)a1;
    _InterlockedExchangeAdd(a1 + 3, 1u);
  }
  else
  {
    result = (**v1)(v1, *((_DWORD *)a1 + 1), 1);
    if ( !result )
      sub_401320();
    *(_DWORD *)(result + 4) = *((_DWORD *)a1 + 1);
    qmemcpy((void *)(result + 16), (const void *)(a1 + 4), *((_DWORD *)a1 + 1) + 1);
  }
  return result;
}


/* ==== 402C20  sub_402C20  ()  size=30 ==== */
std::strstreambuf *__thiscall sub_402C20(std::strstreambuf *Block, char a2)
{
  std::strstreambuf::~strstreambuf(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 402C40  sub_402C40  ()  size=32 ==== */
_DWORD *__thiscall sub_402C40(_DWORD *this, _DWORD *a2)
{
  *this = sub_402BC0((volatile signed __int32 *)(*a2 - 16)) + 16;
  return this;
}


/* ==== 402C60  sub_402C60  ()  size=160 ==== */
_DWORD *__stdcall sub_402C60(_DWORD *a1)
{
  int v1; // eax
  int v2; // eax
  int v4; // [esp+4h] [ebp-10h] BYREF
  int v5; // [esp+10h] [ebp-4h]

  v4 = 0;
  v1 = sub_417937();
  v4 = (*(int (__thiscall **)(int))(*(_DWORD *)v1 + 12))(v1) + 16;
  v5 = 0;
  sub_41B7B5(1014, (int)&v4);
  *a1 = sub_402BC0((volatile signed __int32 *)(v4 - 16)) + 16;
  v2 = v4 - 16;
  v5 = -1;
  if ( _InterlockedDecrement((volatile signed __int32 *)(v4 - 16 + 12)) <= 0 )
    (*(void (__stdcall **)(int))(**(_DWORD **)v2 + 4))(v2);
  return a1;
}


/* ==== 402D00  sub_402D00  ()  size=122 ==== */
int __thiscall sub_402D00(int *this, char *Format, va_list ArgList)
{
  int v4; // esi
  int result; // eax

  if ( !Format )
    sub_4010F0(-2147024809);
  v4 = sub_40A8A1(Format, ArgList);
  if ( ((*(_DWORD *)(*this - 16 + 8) - v4) | (1 - *(_DWORD *)(*this - 4))) < 0 )
    sub_401450(this, v4);
  vsprintf((char *const)*this, Format, ArgList);
  if ( v4 < 0 || (result = *this, v4 > *(_DWORD *)(*this - 8)) )
    sub_4010F0(-2147024809);
  *(_DWORD *)(result - 12) = v4;
  *(_BYTE *)(v4 + *this) = 0;
  return result;
}


/* ==== 402D80  sub_402D80  ()  size=20 ==== */
int sub_402D80(int *a1, char *Format, ...)
{
  va_list va; // [esp+Ch] [ebp+Ch] BYREF

  va_start(va, Format);
  return sub_402D00(a1, Format, va);
}


/* ==== 402DA0  sub_402DA0  ()  size=611 ==== */
int __thiscall sub_402DA0(CWnd *this)
{
  int v2; // esi
  struct CWnd *DlgItem; // ebx
  char *v4; // esi
  HFONT FontA; // eax
  WPARAM v6; // eax
  int v7; // eax
  HWND *v8; // ebx
  int i; // esi
  HWND *v10; // ebx
  unsigned int j; // esi
  LPARAM v12; // ebp
  volatile signed __int32 *v13; // ebp
  LPARAM lParam; // [esp+10h] [ebp-30h] BYREF
  int v16; // [esp+14h] [ebp-2Ch]
  char ArgList[4]; // [esp+18h] [ebp-28h]
  int v18; // [esp+1Ch] [ebp-24h]
  int v19; // [esp+20h] [ebp-20h]
  int v20; // [esp+24h] [ebp-1Ch]
  int v21; // [esp+28h] [ebp-18h]
  int v22; // [esp+2Ch] [ebp-14h]
  int v23; // [esp+30h] [ebp-10h]
  int v24; // [esp+3Ch] [ebp-4h]

  CDialog::OnInitDialog(this);
  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v16 = v2;
  DlgItem = CWnd::GetDlgItem(this, 1021);
  lParam = (LPARAM)CWnd::GetDlgItem(this, 1022);
  if ( *(_DWORD *)(v2 + 1048636) )
  {
    v4 = (char *)this + 112;
    FontA = CreateFontA(14, 0, 0, 0, 0, 0, 0, 0, 0x80u, 4u, 0, 0, 0, &pszFaceName);
    sub_41DA5E(FontA);
    if ( this == (CWnd *)-112 )
      v6 = 0;
    else
      v6 = *((_DWORD *)this + 29);
    SendMessageA(*((HWND *)DlgItem + 7), 0x30u, v6, 1);
    if ( this != (CWnd *)-112 )
      v4 = (char *)*((_DWORD *)this + 29);
    SendMessageA(*(HWND *)(lParam + 28), 0x30u, (WPARAM)v4, 1);
    sub_41BA0F(&byte_424368);
    if ( *(_DWORD *)(v16 + 1048584) == 1 )
    {
      sub_41BA0F(byte_4242E0);
      goto LABEL_12;
    }
LABEL_11:
    sub_41BA0F(ValueName);
    goto LABEL_12;
  }
  sub_41BA0F("First, complete the communication environment setting, then press the Update button.");
  if ( *(_DWORD *)(v2 + 1048584) != 1 )
    goto LABEL_11;
  sub_41BA0F(
    "When updating the firmware of this model for the first time, press the \"USB Driver Install\" button, then install the USB Driver.");
LABEL_12:
  v7 = sub_417937();
  lParam = (*(int (__thiscall **)(int))(*(_DWORD *)v7 + 12))(v7) + 16;
  v24 = 0;
  v8 = (HWND *)CWnd::GetDlgItem(this, 1014);
  for ( i = 1; i <= 256; ++i )
  {
    sub_402D80(&lParam, "COM%d", i);
    SendMessageA(v8[7], 0x143u, 0, lParam);
  }
  SendMessageA(v8[7], 0x14Eu, 0, 0);
  if ( *(_DWORD *)(v16 + 1048584) == 1 )
  {
    SendMessageA(v8[7], 0x14Eu, 0xFFFFFFFF, 0);
    CWnd::EnableWindow((CWnd *)v8, 0);
  }
  *(_DWORD *)ArgList = 115200;
  v18 = 57600;
  v19 = 38400;
  v20 = 19200;
  v21 = 9600;
  v22 = 4800;
  v23 = 2400;
  v10 = (HWND *)CWnd::GetDlgItem(this, 1007);
  for ( j = 0; j < 7; ++j )
  {
    sub_402D80(&lParam, "%d bps", *(_DWORD *)&ArgList[4 * j]);
    v12 = lParam;
    SendMessageA(v10[7], 0x143u, 0, lParam);
  }
  CWnd::EnableWindow((CWnd *)v10, 0);
  v13 = (volatile signed __int32 *)(v12 - 16);
  v24 = -1;
  if ( _InterlockedDecrement(v13 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v13 + 4))(v13);
  return 1;
}


/* ==== 403010  sub_403010  ()  size=7 ==== */
void __thiscall sub_403010(_DWORD *this)
{
  *this = &off_4244A0;
}


/* ==== 403040  sub_403040  ()  size=27 ==== */
int sub_403040()
{
  int result; // eax

  if ( dword_42DA18 )
    result = (**(int (__thiscall ***)(int, int))dword_42DA18)(dword_42DA18, 1);
  dword_42DA18 = 0;
  return result;
}


/* ==== 403060  sub_403060  ()  size=38 ==== */
int __thiscall sub_403060(_DWORD *this, int a2)
{
  int result; // eax

  result = sub_408570(a2, 0, 8, 0);
  if ( (_BYTE)result )
    this[262174] = a2;
  return result;
}


/* ==== 403090  sub_403090  ()  size=125 ==== */
UINT sub_403090()
{
  int v0; // esi
  LCID ThreadLocale; // eax
  CHAR v2; // al
  CHAR *v3; // ecx
  CHAR LCData[8]; // [esp+4h] [ebp-Ch] BYREF

  v0 = 0;
  ThreadLocale = GetThreadLocale();
  if ( !GetLocaleInfoA(ThreadLocale, 0x1004u, LCData, 7) )
    return GetACP();
  v2 = LCData[0];
  v3 = LCData;
  if ( !LCData[0] )
    return GetACP();
  do
  {
    ++v3;
    v0 = v2 + 10 * v0 - 48;
    v2 = *v3;
  }
  while ( *v3 );
  if ( v0 )
    return v0;
  else
    return GetACP();
}


/* ==== 403110  sub_403110  ()  size=6 ==== */
int sub_403110()
{
  return 3;
}


/* ==== 403120  sub_403120  ()  size=101 ==== */
int sub_403120()
{
  void *v0; // eax
  _OSVERSIONINFOA VersionInformation; // [esp+0h] [ebp-98h] BYREF

  VersionInformation.dwOSVersionInfoSize = 148;
  GetVersionExA(&VersionInformation);
  if ( VersionInformation.dwPlatformId != 2 || (v0 = sub_403110, VersionInformation.dwMajorVersion < 5) )
    v0 = sub_403090;
  InterlockedExchange(&Target, (LONG)v0);
  return ((_DWORD (__stdcall *)())Target)();
}


/* ==== 403190  sub_403190  ()  size=96 ==== */
_WORD *__cdecl sub_403190(HMODULE hModule, HRSRC hResInfo, char a3)
{
  _WORD *result; // eax
  _WORD *v4; // esi
  unsigned int v5; // eax
  int v6; // ecx

  result = LoadResource(hModule, hResInfo);
  if ( result )
  {
    v4 = LockResource(result);
    if ( !v4 )
      return 0;
    v5 = (unsigned int)v4 + SizeofResource(hModule, hResInfo);
    v6 = a3 & 0xF;
    if ( (a3 & 0xF) != 0 )
    {
      while ( (unsigned int)v4 < v5 )
      {
        --v6;
        v4 += (unsigned __int16)*v4 + 1;
        if ( !v6 )
          goto LABEL_7;
      }
      return 0;
    }
LABEL_7:
    if ( (unsigned int)v4 >= v5 )
      return 0;
    return *v4 != 0 ? v4 : 0;
  }
  return result;
}


/* ==== 4031F0  sub_4031F0  ()  size=50 ==== */
HRSRC __cdecl sub_4031F0(HMODULE hModule, unsigned int a2)
{
  HRSRC result; // eax

  result = FindResourceA(hModule, (LPCSTR)(unsigned __int16)((a2 >> 4) + 1), (LPCSTR)6);
  if ( result )
    return (HRSRC)sub_403190(hModule, result, a2);
  return result;
}


/* ==== 403230  sub_403230  ()  size=114 ==== */
int __thiscall sub_403230(int this)
{
  int v2; // ecx
  int result; // eax

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  *(_DWORD *)(this + 68) = -1;
  *(_DWORD *)(this + 72) = 0;
  *(_BYTE *)(this + 64) = 1;
  *(_BYTE *)(this + 77) = 0;
  *(_BYTE *)(this + 76) = 0;
  if ( *(_WORD *)(v2 + 1048640) == 5 )
    *(_DWORD *)(this + 84) = *(_DWORD *)(v2 + 1048584) != 0 ? -1048576 : -393216;
  else
    *(_DWORD *)(this + 84) = 0;
  *(_DWORD *)(this + 80) = 0;
  *(_DWORD *)(this + 88) = 0;
  *(_DWORD *)(this + 1048696) = 0;
  *(_DWORD *)(this + 1048700) = 0;
  result = -1;
  memset((void *)(this + 92), 0xFFu, 0x100000u);
  return result;
}


/* ==== 4032B0  sub_4032B0  ()  size=123 ==== */
BOOL __thiscall sub_4032B0(int this)
{
  int v2; // edi
  struct AFX_MODULE_STATE *ModuleState; // eax

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  if ( *(_BYTE *)(this + 64) )
  {
    TerminateThread(*(HANDLE *)(this + 68), 0);
    *(_BYTE *)(this + 64) = 0;
  }
  if ( *(_DWORD *)(this + 68) != -1 )
  {
    CloseHandle(*(HANDLE *)(this + 68));
    *(_DWORD *)(this + 68) = -1;
  }
  if ( *(_DWORD *)(v2 + 1048584) == 1 )
    sub_402890((int (**)(void))(this + 28));
  else
    sub_4084C0(this + 4);
  ModuleState = AfxGetModuleState();
  return PostMessageA(*(HWND *)(*(_DWORD *)(*((_DWORD *)ModuleState + 1) + 28) + 28), 0x8002u, 0, 0);
}


/* ==== 403330  sub_403330  ()  size=73 ==== */
int __thiscall sub_403330(int this)
{
  int v2; // edi
  int v3; // eax
  int v4; // edx

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 28);
  v3 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  *(_DWORD *)(this + 84) += 0x2000;
  v4 = *(_DWORD *)(this + 88) + 0x2000;
  *(_DWORD *)(this + 88) = v4;
  if ( v4 == *(_DWORD *)(v3 + 1048580) )
    *(_BYTE *)(this + 77) = 1;
  return sub_406390(*(_DWORD *)(v2 + 124));
}


/* ==== 403380  sub_403380  ()  size=29 ==== */
int __thiscall sub_403380(_DWORD *this)
{
  int v2; // eax

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 28);
  ++this[20];
  return sub_406390(*(_DWORD *)(v2 + 124));
}


/* ==== 4033A0  sub_4033A0  ()  size=16 ==== */
int __stdcall sub_4033A0(const CHAR *a1, WPARAM a2, LPARAM a3, WPARAM a4)
{
  AfxGetModuleState();
  return sub_406250(a1, a2, a3, a4);
}


/* ==== 4033B0  sub_4033B0  ()  size=69 ==== */
int __thiscall sub_4033B0(unsigned __int8 *this)
{
  int v2; // edi
  int v3; // edx
  int result; // eax
  int i; // ecx

  AfxGetModuleState();
  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v3 = *(_DWORD *)(v2 + 1048580);
  result = 0;
  for ( i = 0; i < v3; ++i )
    result += this[i + 92];
  if ( !*(_DWORD *)(v2 + 1048584) )
    result += 33423360;
  return result;
}


/* ==== 403400  sub_403400  ()  size=204 ==== */
int __thiscall sub_403400(_DWORD *this)
{
  _DWORD *v1; // esi
  int v2; // ebx
  signed int v3; // edx
  int v4; // eax
  int v6; // [esp+Ch] [ebp-814h]
  int v8; // [esp+14h] [ebp-80Ch]
  _BYTE v9[2052]; // [esp+18h] [ebp-808h] BYREF

  v1 = this;
  v2 = 0;
  v6 = 0;
  v8 = *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048580);
  if ( v8 <= 0 )
    return 0;
  v3 = v1[262172];
  while ( 1 )
  {
    memset(v9, 0, 0x800u);
    qmemcpy(v9, (char *)v1 + v2 + 92, v3);
    v4 = 0;
    if ( v3 > 0 )
    {
      while ( v9[v4] == 0xFF )
      {
        if ( ++v4 >= v3 )
          goto LABEL_9;
      }
      v6 += v3;
    }
LABEL_9:
    v2 += v3;
    if ( v2 >= v8 )
      return v6;
    v1 = this;
  }
}


/* ==== 4034D0  sub_4034D0  ()  size=84 ==== */
int __thiscall sub_4034D0(int (**this)(void), LPVOID lpBuffer)
{
  int v3; // eax

  v3 = *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048584);
  if ( !v3 )
    return sub_4086C0(lpBuffer, 1u);
  if ( v3 == 1 )
    return sub_402880(this + 7) != 0 ? -1 : 1;
  return -1;
}


/* ==== 403530  sub_403530  ()  size=288 ==== */
int __thiscall sub_403530(int (**this)(void), char *a2, unsigned int a3)
{
  int v4; // edi
  unsigned int v5; // eax
  int v6; // esi
  int v7; // eax
  char *v9; // esi
  int v10; // eax
  bool v11; // zf

  AfxGetModuleState();
  memset(a2, 0, a3);
  v4 = sub_4034D0(this, a2);
  v5 = (unsigned __int8)*a2;
  if ( v5 > 0x80 )
  {
    switch ( *a2 )
    {
      case -65:
      case -64:
      case -61:
      case -48:
      case -40:
      case -32:
      case -1:
        goto LABEL_12;
      case -26:
        goto LABEL_8;
      default:
LABEL_13:
        v9 = a2 + 1;
        break;
    }
    while ( 1 )
    {
      v10 = *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048584);
      if ( v10 )
      {
        if ( v10 != 1 )
          break;
        v11 = sub_402880(this + 7) == 0;
      }
      else
      {
        v11 = sub_4086C0(v9, 1u) == 1;
      }
      if ( !v11 )
        break;
      ++v9;
      ++v4;
    }
  }
  else if ( v5 == 128 )
  {
LABEL_12:
    v7 = sub_4034D0(this, a2 + 1);
LABEL_7:
    v4 += v7;
  }
  else
  {
    switch ( *a2 )
    {
      case 0:
      case 6:
      case 22:
      case 38:
        break;
      case 48:
      case 49:
      case 50:
      case 51:
      case 52:
      case 53:
      case 54:
      case 55:
      case 91:
      case 95:
        v6 = 2;
        v4 += sub_4034D0(this, a2 + 1);
        if ( (unsigned __int8)a2[1] + 2 > 2 )
        {
          do
            v4 += sub_4034D0(this, &a2[v6++]);
          while ( v6 < (unsigned __int8)a2[1] + 2 );
        }
        v7 = sub_4034D0(this, &a2[v6]);
        goto LABEL_7;
      default:
        goto LABEL_13;
    }
  }
LABEL_8:
  if ( v4 > 0 )
    sub_406590(1, a2, v4);
  return v4;
}


/* ==== 403710  sub_403710  ()  size=215 ==== */
char __thiscall sub_403710(int this)
{
  int v2; // edx
  signed int v3; // eax
  int v4; // ecx
  int v5; // ecx
  int v6; // eax
  int v7; // esi
  char result; // al
  _BYTE v9[2052]; // [esp+10h] [ebp-808h] BYREF

  AfxGetModuleState();
  v2 = *(_DWORD *)(this + 88);
  memset(v9, 0, 0x800u);
  v3 = *(_DWORD *)(this + 1048688);
  qmemcpy(v9, (const void *)(v2 + this + 92), v3);
  v4 = 0;
  if ( v3 <= 0 )
  {
LABEL_4:
    AfxGetModuleState();
    v5 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
    v6 = *(_DWORD *)(this + 1048688);
    v7 = v6 + *(_DWORD *)(this + 88);
    *(_DWORD *)(this + 84) += v6;
    *(_DWORD *)(this + 88) = v7;
    result = 1;
    if ( v7 == *(_DWORD *)(v5 + 1048580) )
      *(_BYTE *)(this + 77) = 1;
  }
  else
  {
    while ( v9[v4] == 0xFF )
    {
      if ( ++v4 >= *(_DWORD *)(this + 1048688) )
        goto LABEL_4;
    }
    return 0;
  }
  return result;
}


/* ==== 4037F0  sub_4037F0  ()  size=107 ==== */
bool __thiscall sub_4037F0(int (**this)(void), LPCVOID lpBuffer, DWORD nNumberOfBytesToWrite)
{
  int v4; // ebp
  int v5; // eax

  v4 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  sub_406590(0, lpBuffer, nNumberOfBytesToWrite);
  v5 = *(_DWORD *)(v4 + 1048584);
  if ( !v5 )
    return sub_408780(lpBuffer, nNumberOfBytesToWrite) == nNumberOfBytesToWrite;
  if ( v5 == 1 )
    return sub_402870(this + 7) == 0;
  return 0;
}


/* ==== 403860  sub_403860  ()  size=24 ==== */
char __thiscall sub_403860(_DWORD *this)
{
  return *(_BYTE *)(*((_DWORD *)AfxGetModuleState() + 1) + 172 + this[20]);
}


/* ==== 403880  sub_403880  ()  size=37 ==== */
bool __thiscall sub_403880(_DWORD *this)
{
  return this[20] >= *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048580);
}


/* ==== 4038B0  sub_4038B0  ()  size=74 ==== */
int __thiscall sub_4038B0(int this)
{
  int v2; // edi
  int v3; // ecx
  int v4; // eax
  int v5; // eax

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 28);
  AfxGetModuleState();
  v3 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v4 = *(_DWORD *)(this + 1048688);
  *(_DWORD *)(this + 84) += v4;
  v5 = v4 + *(_DWORD *)(this + 88);
  *(_DWORD *)(this + 88) = v5;
  if ( v5 == *(_DWORD *)(v3 + 1048580) )
    *(_BYTE *)(this + 77) = 1;
  return sub_406390(*(_DWORD *)(v2 + 124));
}


/* ==== 403900  sub_403900  ()  size=20 ==== */
bool __thiscall sub_403900(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 0;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403920  sub_403920  ()  size=20 ==== */
bool __thiscall sub_403920(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 6;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403940  sub_403940  ()  size=177 ==== */
bool __thiscall sub_403940(int this)
{
  int v2; // eax
  unsigned int v3; // esi
  int v4; // ecx
  unsigned int v5; // ecx
  DWORD v6; // edx
  const void *v7; // esi
  DWORD v8; // esi
  char v9; // al
  _BYTE *v10; // ecx
  _BYTE v13[5]; // [esp+10h] [ebp-808h] BYREF
  _BYTE v14[2047]; // [esp+15h] [ebp-803h] BYREF

  AfxGetModuleState();
  v2 = *(_DWORD *)(this + 84);
  v3 = *(_DWORD *)(this + 1048688);
  v13[1] = HIBYTE(v2);
  v4 = v2 >> 16;
  v13[3] = BYTE1(v2);
  LOBYTE(v2) = *(_BYTE *)(this + 84);
  v13[2] = v4;
  v13[4] = v2;
  v5 = v3;
  v6 = v3 + 6;
  v7 = (const void *)(*(_DWORD *)(this + 88) + this + 92);
  v13[0] = 80;
  qmemcpy(v14, v7, v5);
  v8 = v6 - 1;
  v9 = 0;
  v10 = v13;
  if ( (int)(v6 - 1) > 0 )
  {
    do
    {
      v9 += *v10++;
      --v8;
    }
    while ( v8 );
  }
  v13[v6 - 1] = -v9;
  return sub_4037F0((int (**)(void))this, v13, v6);
}


/* ==== 403A00  sub_403A00  ()  size=20 ==== */
bool __thiscall sub_403A00(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 85;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403A20  sub_403A20  ()  size=32 ==== */
bool __thiscall sub_403A20(int (**this)(void), __int16 a2)
{
  char v2; // dh

  v2 = HIBYTE(a2);
  HIBYTE(a2) = a2;
  LOBYTE(a2) = v2;
  return sub_4037F0(this, &a2, 2u);
}


/* ==== 403A40  sub_403A40  ()  size=48 ==== */
bool __thiscall sub_403A40(int this)
{
  char v3; // [esp+7h] [ebp-1h] BYREF

  v3 = *(_BYTE *)(*((_DWORD *)AfxGetModuleState() + 1) + *(_DWORD *)(this + 80) + 172);
  return sub_4037F0((int (**)(void))this, &v3, 1u);
}


/* ==== 403A70  sub_403A70  ()  size=55 ==== */
bool __thiscall sub_403A70(int (**this)(void))
{
  int v2; // eax
  _BYTE v4[4]; // [esp+4h] [ebp-4h] BYREF

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v4[0] = *(_BYTE *)(v2 + 1048643);
  v4[1] = *(_BYTE *)(v2 + 1048642);
  return sub_4037F0(this, v4, 2u);
}


/* ==== 403AB0  sub_403AB0  ()  size=54 ==== */
bool __thiscall sub_403AB0(int (**this)(void), int a2)
{
  int v2; // edx

  v2 = a2 / 100;
  BYTE2(a2) = a2 / 100;
  LOBYTE(a2) = 63;
  BYTE1(a2) = BYTE1(v2);
  return sub_4037F0(this, &a2, 3u);
}


/* ==== 403AF0  sub_403AF0  ()  size=189 ==== */
bool __thiscall sub_403AF0(int this)
{
  char v2; // dl
  int v3; // ecx
  int v4; // eax
  int v5; // ecx
  unsigned __int8 *v6; // eax
  int v7; // edx
  int v8; // esi
  int v9; // edi
  _BYTE v11[4]; // [esp+10h] [ebp-2010h] BYREF
  _BYTE v12[8200]; // [esp+14h] [ebp-200Ch] BYREF

  AfxGetModuleState();
  v2 = *(_BYTE *)(this + 84);
  v3 = *(_DWORD *)(this + 84);
  v11[2] = BYTE1(v3);
  v4 = *(_DWORD *)(this + 88);
  v11[1] = BYTE2(v3);
  v11[3] = v2;
  v11[0] = 80;
  qmemcpy(v12, (const void *)(v4 + this + 92), 0x2000u);
  v5 = 0;
  v6 = v12;
  v7 = 1366;
  do
  {
    v8 = v6[1] + *(v6 - 1) + *(v6 - 2) + *(v6 - 3) + *(v6 - 4);
    v9 = v5 + *v6;
    v6 += 6;
    --v7;
    v5 = v9 + v8;
  }
  while ( v7 );
  v12[0x2000] = -(char)v5;
  return sub_4037F0((int (**)(void))this, v11, 0x2005u);
}


/* ==== 403BB0  sub_403BB0  ()  size=69 ==== */
bool __thiscall sub_403BB0(int (**this)(void))
{
  _BYTE v2[8]; // [esp+0h] [ebp-Ch] BYREF

  v2[1] = -1;
  v2[2] = -1;
  v2[3] = -1;
  v2[4] = -1;
  v2[0] = 80;
  v2[5] = -76;
  return sub_4037F0(this, v2, 6u);
}


/* ==== 403C00  sub_403C00  ()  size=20 ==== */
bool __thiscall sub_403C00(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 32;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403C20  sub_403C20  ()  size=267 ==== */
bool __thiscall sub_403C20(int this)
{
  int v2; // edx
  unsigned __int8 v3; // cl
  int v4; // eax
  int v5; // esi
  char v6; // al
  char *p_Buffer; // ecx
  int v8; // edx
  DWORD v9; // esi
  int v10; // edi
  int v11; // eax
  char Buffer; // [esp+8h] [ebp-104h] BYREF
  unsigned __int8 v14; // [esp+9h] [ebp-103h]
  _BYTE v15[254]; // [esp+Ah] [ebp-102h]

  v2 = this + 1048668;
  Buffer = 16;
  v3 = strlen((const char *)(this + 1048668));
  v4 = 0;
  v14 = v3;
  v5 = 2;
  if ( v3 )
  {
    do
    {
      v15[v4] = *(_BYTE *)(v2 + v4);
      ++v5;
      ++v4;
    }
    while ( v4 < v14 );
  }
  v6 = 0;
  p_Buffer = &Buffer;
  if ( v5 > 0 )
  {
    v8 = v5;
    do
    {
      v6 += *p_Buffer++;
      --v8;
    }
    while ( v8 );
  }
  *(&Buffer + v5) = -v6;
  v9 = v5 + 1;
  v10 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  sub_406590(0, &Buffer, v9);
  v11 = *(_DWORD *)(v10 + 1048584);
  if ( !v11 )
    return sub_408780(&Buffer, v9) == v9;
  if ( v11 == 1 )
    return sub_402870((int (**)(void))(this + 28)) == 0;
  return 0;
}


/* ==== 403D30  sub_403D30  ()  size=20 ==== */
bool __thiscall sub_403D30(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 33;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403D50  sub_403D50  ()  size=47 ==== */
bool __thiscall sub_403D50(int this)
{
  _BYTE v2[2]; // [esp+0h] [ebp-4h] BYREF
  char v3; // [esp+2h] [ebp-2h]
  char v4; // [esp+3h] [ebp-1h]

  v3 = *(_BYTE *)(this + 1048684);
  v4 = -(char)(v3 + 18);
  v2[0] = 17;
  v2[1] = 1;
  return sub_4037F0((int (**)(void))this, v2, 4u);
}


/* ==== 403D80  sub_403D80  ()  size=20 ==== */
bool __thiscall sub_403D80(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 39;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403DA0  sub_403DA0  ()  size=221 ==== */
bool __thiscall sub_403DA0(int (**this)(void), int a2)
{
  int v3; // esi
  int v4; // eax
  _BYTE v6[4]; // [esp+Ch] [ebp-10h] BYREF
  char v7; // [esp+10h] [ebp-Ch]
  char v8; // [esp+11h] [ebp-Bh]
  char v9; // [esp+12h] [ebp-Ah]
  char v10; // [esp+13h] [ebp-9h]
  char v11; // [esp+14h] [ebp-8h]
  char v12; // [esp+15h] [ebp-7h]

  v3 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v6[0] = 63;
  v6[1] = 7;
  v6[2] = (unsigned __int16)((__int16)a2 / 100) >> 8;
  v6[3] = (char)a2 / 100;
  v7 = *(_BYTE *)(v3 + 1048643);
  v8 = *(_BYTE *)(v3 + 1048642);
  v9 = 2;
  v10 = *(_BYTE *)(v3 + 1048644);
  if ( *(_WORD *)(v3 + 1048640) == 6 )
    LOBYTE(v4) = *(_BYTE *)(v3 + 1048644);
  else
    v4 = *(_DWORD *)(v3 + 1048644) / 2;
  v11 = v4;
  v12 = -(char)(a2 / 100 + v7 + v8 + v10 + v4 + ((unsigned __int16)(a2 / 100) >> 8) + 72);
  return sub_4037F0(this, v6, 0xAu);
}


/* ==== 403E80  sub_403E80  ()  size=62 ==== */
bool __thiscall sub_403E80(int (**this)(void))
{
  char v3; // [esp+7h] [ebp-1h] BYREF

  if ( *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048584) == 1 )
    sub_402860(this + 7);
  v3 = 64;
  return sub_4037F0(this, &v3, 1u);
}


/* ==== 403EC0  sub_403EC0  ()  size=266 ==== */
bool __thiscall sub_403EC0(int (**this)(void))
{
  int v2; // ecx
  int i; // eax
  int v4; // ecx
  unsigned __int8 *v5; // eax
  int v6; // edx
  int v7; // esi
  int v8; // ebx
  int v9; // esi
  int v10; // eax
  _BYTE Buffer[4]; // [esp+4h] [ebp-18h] BYREF
  _BYTE v13[16]; // [esp+8h] [ebp-14h] BYREF

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  Buffer[0] = 96;
  Buffer[1] = 16;
  for ( i = 0; i < 16; ++i )
    Buffer[i + 2] = *(_BYTE *)(v2 + i + 1048648);
  v4 = 0;
  v5 = v13;
  v6 = 3;
  do
  {
    v7 = v5[1] + *(v5 - 1) + *(v5 - 2) + *(v5 - 3) + *(v5 - 4);
    v8 = v4 + *v5;
    v5 += 6;
    --v6;
    v4 = v8 + v7;
  }
  while ( v6 );
  v13[14] = -(char)v4;
  v9 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  sub_406590(0, Buffer, 19);
  v10 = *(_DWORD *)(v9 + 1048584);
  if ( !v10 )
    return sub_408780(Buffer, 0x13u) == 19;
  if ( v10 == 1 )
    return sub_402870(this + 7) == 0;
  return 0;
}


/* ==== 403FD0  sub_403FD0  ()  size=20 ==== */
bool __thiscall sub_403FD0(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 72;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 403FF0  sub_403FF0  ()  size=47 ==== */
bool __thiscall sub_403FF0(int (**this)(void), char a2)
{
  _BYTE v3[4]; // [esp+0h] [ebp-4h] BYREF

  v3[2] = a2;
  v3[3] = -(char)(a2 + 89);
  v3[0] = 88;
  v3[1] = 1;
  return sub_4037F0(this, v3, 4u);
}


/* ==== 404020  sub_404020  ()  size=62 ==== */
bool __thiscall sub_404020(int (**this)(void))
{
  char v3; // [esp+7h] [ebp-1h] BYREF

  if ( *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048584) == 1 )
    sub_402860(this + 7);
  v3 = 67;
  return sub_4037F0(this, &v3, 1u);
}


/* ==== 404060  sub_404060  ()  size=20 ==== */
bool __thiscall sub_404060(int (**this)(void))
{
  char v2; // [esp+1h] [ebp-1h] BYREF

  v2 = 75;
  return sub_4037F0(this, &v2, 1u);
}


/* ==== 404080  ??1strstreambuf@std@@UAE@XZ_1  (std::strstreambuf::~strstreambuf(void))  size=114 ==== */
void __thiscall std::strstreambuf::~strstreambuf(std::strstreambuf *this)
{
  volatile signed __int32 *v2; // eax

  *(_DWORD *)this = &off_4244A4;
  sub_4084C0(this);
  v2 = (volatile signed __int32 *)(*((_DWORD *)this + 5) - 16);
  if ( _InterlockedDecrement(v2 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v2 + 4))(v2);
  sub_409A84((char *)this + 8);
}


/* ==== 404120  sub_404120  ()  size=197 ==== */
int __thiscall sub_404120(int *this, HMODULE hModule, unsigned int a3)
{
  HRSRC ResourceA; // eax
  unsigned __int16 *v5; // eax
  unsigned __int16 *v6; // edi
  int v8; // esi
  UINT v9; // eax
  int v10; // esi
  UINT v11; // eax
  int v12; // [esp-18h] [ebp-24h]
  CHAR *v13; // [esp-14h] [ebp-20h]

  ResourceA = FindResourceA(hModule, (LPCSTR)(unsigned __int16)((a3 >> 4) + 1), (LPCSTR)6);
  if ( !ResourceA )
    return 0;
  v5 = sub_403190(hModule, ResourceA, a3);
  v6 = v5;
  if ( !v5 )
    return 0;
  v8 = *v5;
  v9 = ((int (__stdcall *)())Target)();
  v10 = WideCharToMultiByte(v9, 0, v6 + 1, v8, 0, 0, 0, 0);
  if ( ((*(_DWORD *)(*this - 16 + 8) - v10) | (1 - *(_DWORD *)(*this - 4))) < 0 )
    sub_401450(this, v10);
  v13 = (CHAR *)*this;
  v12 = *v6;
  v11 = ((int (__stdcall *)())Target)();
  WideCharToMultiByte(v11, 0, v6 + 1, v12, v13, v10, 0, 0);
  if ( v10 < 0 || v10 > *(_DWORD *)(*this - 8) )
    sub_4010F0(-2147024809);
  *(_DWORD *)(*this - 12) = v10;
  *(_BYTE *)(v10 + *this) = 0;
  return 1;
}


/* ==== 4041F0  sub_4041F0  ()  size=37 ==== */
HMODULE __thiscall sub_4041F0(int *this, unsigned int a2)
{
  HMODULE result; // eax

  result = AfxFindStringResourceHandle(a2);
  if ( result )
    return (HMODULE)sub_404120(this, result, a2);
  return result;
}


/* ==== 404220  sub_404220  ()  size=130 ==== */
void *__thiscall sub_404220(void *this)
{
  int v2; // eax

  *(_DWORD *)this = &off_4244A4;
  sub_409A35(0, 0, 0);
  v2 = sub_417937();
  *((_DWORD *)this + 5) = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  *((_DWORD *)this + 1) = -1;
  *((_DWORD *)this + 4) = 0;
  sub_401520((volatile signed __int32 **)this + 5, ValueName, 0);
  return this;
}


/* ==== 4042B0  sub_4042B0  ()  size=112 ==== */
_DWORD *__thiscall sub_4042B0(_DWORD *this)
{
  int v2; // eax

  *this = &off_4244A8;
  sub_404220(this + 1);
  sub_402830(this + 7);
  v2 = sub_417937();
  this[15] = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  sub_403230((int)this);
  return this;
}


/* ==== 404340  ??1ios_base@std@@UAE@XZ  (std::ios_base::~ios_base(void))  size=112 ==== */
void __thiscall std::ios_base::~ios_base(std::ios_base *this)
{
  volatile signed __int32 *v2; // eax

  *(_DWORD *)this = &off_4244A8;
  v2 = (volatile signed __int32 *)(*((_DWORD *)this + 15) - 16);
  if ( _InterlockedDecrement(v2 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v2 + 4))(v2);
  sub_4028A0((_DWORD *)this + 7);
  std::strstreambuf::~strstreambuf((std::ios_base *)((char *)this + 4));
}


/* ==== 4043B0  sub_4043B0  ()  size=108 ==== */
_DWORD *sub_4043B0()
{
  _DWORD *result; // eax
  _DWORD *v1; // eax

  result = (_DWORD *)dword_42DA18;
  if ( !dword_42DA18 )
  {
    v1 = operator new(0x100080u);
    if ( v1 )
    {
      result = sub_4042B0(v1);
      dword_42DA18 = (int)result;
    }
    else
    {
      result = 0;
      dword_42DA18 = 0;
    }
  }
  return result;
}


/* ==== 404420  StartAddress  ()  size=590 ==== */
unsigned int __stdcall StartAddress(void *a1)
{
  int (**v1)(void); // esi
  int v2; // edi
  int v3; // eax
  unsigned int v4; // ebp
  int v5; // edi
  int v6; // edi
  int v7; // eax
  int v8; // eax
  int v9; // edi
  int v10; // ebp
  int v11; // edi
  int v12; // eax
  int lParam; // [esp+10h] [ebp-124h]
  _DWORD *v15[2]; // [esp+14h] [ebp-120h] BYREF
  int v16; // [esp+1Ch] [ebp-118h]
  char v17[256]; // [esp+24h] [ebp-110h] BYREF
  int v18; // [esp+130h] [ebp-4h]

  v1 = (int (**)(void))sub_4043B0();
  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  lParam = 255;
  sub_4014D0(v15, (int)v1);
  v3 = *(_DWORD *)(v2 + 1048584);
  v4 = 0;
  v18 = 0;
  if ( v3 )
  {
    unknown_libname_3(v15, dword_42D9A4);
    v17[0] = 0;
    lParam = sub_401000(v15, (int)v17, 1);
  }
  else
  {
    do
    {
      v5 = dword_424490[v4];
      if ( (unsigned __int8)sub_408570(v5, 0, 8, 0) )
        v1[262174] = (int (*)(void))v5;
      nullsub_3();
      Sleep(1u);
      v6 = 0;
      while ( 1 )
      {
        sub_401000(v15, 0, 0);
        v7 = sub_403530(v1, v17, 0xAu);
        if ( v7 > 0 )
          break;
        if ( ++v6 >= 30 )
          goto LABEL_9;
      }
      lParam = sub_401000(v15, (int)v17, v7);
LABEL_9:
      if ( !lParam )
        goto LABEL_14;
      ++v4;
    }
    while ( v4 < 4 );
  }
  if ( !lParam )
  {
    while ( 1 )
    {
LABEL_14:
      v8 = sub_403530(v1, v17, 0x100u);
      if ( v8 <= 0 )
      {
        if ( v8 < 0 )
        {
          lParam = 162;
          break;
        }
      }
      else
      {
        lParam = sub_401000(v15, (int)v17, v8);
      }
      if ( lParam )
        break;
      Sleep(0xAu);
      if ( *((_BYTE *)v1 + 76) )
      {
        v9 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 28);
        v10 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
        PostMessageA(*(HWND *)(v9 + 28), 0x8001u, 0, 0);
        goto LABEL_22;
      }
    }
  }
  v11 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 28);
  v10 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  PostMessageA(*(HWND *)(v11 + 28), 0x8002u, (WPARAM)v1[262175], lParam);
LABEL_22:
  if ( *(_DWORD *)(v10 + 1048584) == 1 )
    sub_402890(v1 + 7);
  else
    sub_4084C0(v1 + 1);
  v12 = v16 - 16;
  v18 = -1;
  v15[0] = &off_4234CC;
  if ( _InterlockedDecrement((volatile signed __int32 *)(v16 - 16 + 12)) <= 0 )
    (*(void (__stdcall **)(int))(**(_DWORD **)v12 + 4))(v12);
  return 0;
}


/* ==== 404670  sub_404670  ()  size=167 ==== */
volatile signed __int32 **__thiscall sub_404670(volatile signed __int32 **this, int a2)
{
  int v3; // eax
  HMODULE StringResourceHandle; // eax
  int v6; // eax

  v3 = sub_417937();
  *this = (volatile signed __int32 *)((*(int (__thiscall **)(int))(*(_DWORD *)v3 + 12))(v3) + 16);
  if ( !a2 )
  {
    v6 = 0;
LABEL_7:
    sub_401520(this, (const void *)a2, v6);
    return this;
  }
  if ( (a2 & 0xFFFF0000) != 0 )
  {
    v6 = strlen((const char *)a2);
    goto LABEL_7;
  }
  StringResourceHandle = AfxFindStringResourceHandle((unsigned __int16)a2);
  if ( StringResourceHandle )
  {
    sub_404120((int *)this, StringResourceHandle, (unsigned __int16)a2);
    return this;
  }
  return this;
}


/* ==== 404720  sub_404720  ()  size=132 ==== */
volatile signed __int32 **__thiscall sub_404720(__time64_t *Time, volatile signed __int32 **a2, char *Format)
{
  struct tm *v3; // eax
  char Buffer[128]; // [esp+Ch] [ebp-84h] BYREF

  if ( Format )
  {
    v3 = _gmtime64(Time);
    if ( !v3 || !sub_40B19B(Buffer, 0x80u, Format, v3) )
      Buffer[0] = 0;
    sub_404670(a2, (int)Buffer);
  }
  else
  {
    sub_404670(a2, 0);
  }
  return a2;
}


/* ==== 4047B0  sub_4047B0  ()  size=231 ==== */
bool __thiscall sub_4047B0(char *this)
{
  int *v2; // esi
  BOOL v3; // ebx
  int v4; // eax
  int v6; // [esp+Ch] [ebp-320h] BYREF
  int v7; // [esp+10h] [ebp-31Ch] BYREF
  __time64_t Time; // [esp+14h] [ebp-318h] BYREF
  _UNKNOWN **v9; // [esp+1Ch] [ebp-310h]
  int v10; // [esp+328h] [ebp-4h]

  v2 = *(int **)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  Time = *v2;
  sub_404720(&Time, (volatile signed __int32 **)&v6, "%Y%m%d%H%M%S");
  v10 = 1;
  v7 = 0;
  v9 = &off_4244A0;
  sub_4082C0(v6);
  v3 = sub_408350(v2 + 1, 0x100000, this + 92, 0x100000, &v7) == 0;
  v4 = v6 - 16;
  v9 = &off_4244A0;
  v10 = -1;
  if ( _InterlockedDecrement((volatile signed __int32 *)(v6 - 16 + 12)) <= 0 )
    (*(void (__stdcall **)(int))(**(_DWORD **)v4 + 4))(v4);
  return v3;
}


/* ==== 4048A0  sub_4048A0  ()  size=225 ==== */
char __thiscall sub_4048A0(int this)
{
  int v2; // edi
  char v3; // bl
  volatile signed __int32 *v4; // ecx
  uintptr_t v6; // eax
  HANDLE v7; // eax
  volatile signed __int32 *v8[5]; // [esp-4h] [ebp-14h] BYREF

  AfxGetModuleState();
  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v3 = 0;
  sub_403230(this);
  if ( *(_DWORD *)(v2 + 1048584) )
  {
    v8[0] = v4;
    v8[4] = (volatile signed __int32 *)v8;
    sub_404670(v8, (int)"RFP_USB_VB.dll");
    if ( !sub_402900(this + 28, (LPCSTR)v8[0]) || sub_402850((int (**)(void))(this + 28)) )
      return 0;
    v8[0] = (volatile signed __int32 *)2000;
    sub_402860((int (**)(void))(this + 28));
  }
  else
  {
    if ( !(unsigned __int8)sub_408860(*(char **)(this + 60), 19200, 0, 8, 0) )
      return 0;
    sub_408830(this + 4);
  }
  if ( !sub_4047B0((char *)this) )
    return 0;
  v6 = _beginthreadex(0, 0, StartAddress, 0, 0, (unsigned int *)(this + 72));
  *(_DWORD *)(this + 68) = v6;
  if ( v6 != -1 )
  {
    *(_BYTE *)(this + 64) = 1;
    v3 = 1;
  }
  v7 = OpenThread(0x1F0022u, 1, *(_DWORD *)(this + 72));
  SetThreadPriority(v7, 15);
  return v3;
}


/* ==== 404990  sub_404990  ()  size=6 ==== */
char **sub_404990()
{
  return &off_4244E4;
}


/* ==== 4049A0  sub_4049A0  ()  size=41 ==== */
CDialog *__thiscall sub_4049A0(CDialog *this, struct CWnd *a2)
{
  CDialog::CDialog(this, 0x67u, a2);
  *(_DWORD *)this = &off_424510;
  *((_DWORD *)this + 29) = 0;
  *((_DWORD *)this + 28) = &CFont::`vftable';
  return this;
}


/* ==== 4049D0  ??1strstreambuf@std@@UAE@XZ_2  (std::strstreambuf::~strstreambuf(void))  size=88 ==== */
void __thiscall std::strstreambuf::~strstreambuf(std::strstreambuf *this)
{
  CGdiObject *v2; // ecx

  *(_DWORD *)this = &off_424510;
  v2 = (std::strstreambuf *)((char *)this + 112);
  *(_DWORD *)v2 = &CGdiObject::`vftable';
  CGdiObject::DeleteObject(v2);
  sub_417B12(this);
}


/* ==== 404A30  nullsub_4  ()  size=3 ==== */
void __stdcall nullsub_4(int a1)
{
  ;
}


/* ==== 404A40  sub_404A40  ()  size=144 ==== */
int __thiscall sub_404A40(CWnd *this)
{
  int v2; // eax
  int v3; // edi
  char *v4; // edi
  HFONT FontA; // eax
  struct CWnd *DlgItem; // eax

  CDialog::OnInitDialog(this);
  v2 = *((_DWORD *)AfxGetModuleState() + 1);
  v3 = *(_DWORD *)(v2 + 160);
  sub_41B959(1017, *(LPCSTR *)(v2 + 164));
  if ( *(_DWORD *)(v3 + 1048636) == 1 )
  {
    v4 = (char *)this + 112;
    FontA = CreateFontA(14, 0, 0, 0, 0, 0, 0, 0, 0x80u, 4u, 0, 0, 0, &pszFaceName);
    sub_41DA5E(FontA);
    DlgItem = CWnd::GetDlgItem(this, 1017);
    if ( this != (CWnd *)-112 )
      v4 = (char *)*((_DWORD *)this + 29);
    SendMessageA(*((HWND *)DlgItem + 7), 0x30u, (WPARAM)v4, 1);
  }
  return 1;
}


/* ==== 404AD0  sub_404AD0  ()  size=30 ==== */
std::strstreambuf *__thiscall sub_404AD0(std::strstreambuf *Block, char a2)
{
  std::strstreambuf::~strstreambuf(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 404AF0  sub_404AF0  ()  size=63 ==== */
int __thiscall sub_404AF0(_DWORD *this, int a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  if ( sub_403900((int (**)(void))v4) )
  {
    unknown_libname_3((_DWORD *)this[3], dword_42D9A4);
    return 0;
  }
  else
  {
    *(_DWORD *)(v4 + 1048700) = 161;
    return 255;
  }
}


/* ==== 404B30  sub_404B30  ()  size=119 ==== */
int __thiscall sub_404B30(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 0xAA )
  {
    if ( sub_403A20((int (**)(void))v4, 1632) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9AC);
      return 0;
    }
    else
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 404BB0  sub_404BB0  ()  size=143 ==== */
int __thiscall sub_404BB0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  if ( a3 == 2 && a2[1] + (*a2 << 8) == 1632 )
  {
    if ( sub_403A40(v4) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9B0);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    *(_DWORD *)(v4 + 1048700) = 162;
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return 255;
  }
}


/* ==== 404C40  sub_404C40  ()  size=113 ==== */
int __thiscall sub_404C40(_DWORD *this, _BYTE *a2, int a3)
{
  _DWORD *v4; // esi

  v4 = *(_DWORD **)(this[3] + 12);
  if ( *a2 == sub_403860(v4) )
  {
    sub_403380(v4);
    if ( sub_403880(v4) )
      unknown_libname_3((_DWORD *)this[3], dword_42D9B4);
    else
      sub_403A40((int)v4);
    return 0;
  }
  else
  {
    v4[262175] = 163;
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return 255;
  }
}


/* ==== 404CC0  sub_404CC0  ()  size=91 ==== */
int __thiscall sub_404CC0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx
  unsigned __int8 v5; // al

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 0xAA || (v5 = a2[1], v5 == 6) )
  {
    sub_403A70((int (**)(void))v4);
    unknown_libname_3((_DWORD *)this[3], dword_42D9BC);
    return 0;
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = v5;
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 404D20  sub_404D20  ()  size=85 ==== */
int __thiscall sub_404D20(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 6 )
  {
    sub_403A70((int (**)(void))v4);
    unknown_libname_3((_DWORD *)this[3], dword_42D9BC);
    return 0;
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 404D80  sub_404D80  ()  size=145 ==== */
int __thiscall sub_404D80(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 6 )
  {
    dword_42DA1C = 0;
    if ( sub_403AB0((int (**)(void))v4, 115200) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9C0);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 404E20  sub_404E20  ()  size=247 ==== */
int __thiscall sub_404E20(_DWORD *this, unsigned __int8 *a2, int a3)
{
  _DWORD *v4; // ecx
  int (**v5)(void); // edi
  unsigned __int8 v6; // al
  int v7; // eax

  v4 = (_DWORD *)this[3];
  v5 = (int (**)(void))v4[3];
  v6 = *a2;
  if ( a3 < 2 )
  {
    if ( v6 != 6 )
    {
      unknown_libname_3(v4, dword_42D9A0);
      return *a2;
    }
    if ( !(unsigned __int8)sub_403060(v5, dword_424668[dword_42DA1C]) )
    {
LABEL_7:
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
    Sleep(0xAu);
    sub_403920(v5);
    unknown_libname_3((_DWORD *)this[3], dword_42D9C4);
  }
  else
  {
    if ( v6 != 0xBF || a2[1] != 36 )
    {
      v5[262175] = (int (*)(void))a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    v7 = ++dword_42DA1C;
    if ( (unsigned int)dword_42DA1C > 7 )
    {
      unknown_libname_3(v4, dword_42D9A0);
      return 255;
    }
    if ( !sub_403AB0(v5, dword_424668[v7]) )
      goto LABEL_7;
  }
  return 0;
}


/* ==== 404F20  sub_404F20  ()  size=111 ==== */
int __thiscall sub_404F20(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 6 )
  {
    sub_4033A0((const CHAR *)1, 0, 0x100000, 0x2000u);
    sub_403AF0(v4);
    unknown_libname_3((_DWORD *)this[3], dword_42D9C8);
    return 0;
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 404F90  sub_404F90  ()  size=153 ==== */
int __thiscall sub_404F90(_DWORD *this, unsigned __int8 *a2, int a3)
{
  _DWORD *v4; // ecx
  int v5; // esi
  unsigned __int8 v6; // al

  v4 = (_DWORD *)this[3];
  v5 = v4[3];
  v6 = *a2;
  if ( a3 < 2 )
  {
    if ( v6 != 6 )
    {
      unknown_libname_3(v4, dword_42D9A0);
      return *a2;
    }
    sub_403330(v4[3]);
    if ( *(_BYTE *)(v5 + 77) )
    {
      sub_403BB0((int (**)(void))v5);
      unknown_libname_3((_DWORD *)this[3], dword_42D9CC);
      return 0;
    }
  }
  else if ( v6 != 0xD0 || a2[1] != 17 )
  {
    *(_DWORD *)(v5 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
  sub_403AF0(v5);
  return 0;
}


/* ==== 405030  sub_405030  ()  size=126 ==== */
int __thiscall sub_405030(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx
  int v5; // edx

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  if ( a3 < 2 )
  {
    if ( *a2 == 6 )
    {
      *(_BYTE *)(v5 + 76) = 1;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 0;
    }
    else
    {
      unknown_libname_3((_DWORD *)v4, dword_42D9A0);
      return *a2;
    }
  }
  else if ( *a2 == 0xD0 && a2[1] == 17 )
  {
    sub_403BB0(*(int (***)(void))(v4 + 12));
    return 0;
  }
  else
  {
    *(_DWORD *)(v5 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 4050B0  sub_4050B0  ()  size=212 ==== */
int __thiscall sub_4050B0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi
  int v5; // ebx
  _DWORD *v7; // ecx

  v4 = *(_DWORD *)(this[3] + 12);
  v5 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  if ( a3 > 0 )
  {
    if ( *a2 )
    {
      if ( a3 >= 2 )
        *(_DWORD *)(v4 + 1048700) = a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    else if ( sub_403A00((int (**)(void))v4) )
    {
      v7 = (_DWORD *)this[3];
      if ( *(_WORD *)(v5 + 1048640) )
        unknown_libname_3(v7, dword_42D9D0);
      else
        unknown_libname_3(v7, dword_42D9A8);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return 255;
  }
}


/* ==== 405190  sub_405190  ()  size=130 ==== */
int __thiscall sub_405190(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // eax
  int v5; // edi

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  if ( *a2 == 0xE6 )
  {
    if ( sub_403C00(*(int (***)(void))(v4 + 12)) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9D4);
      return 0;
    }
    else
    {
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 32;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v5 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405220  sub_405220  ()  size=212 ==== */
int __thiscall sub_405220(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx
  int v5; // edi
  unsigned __int8 v6; // al

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  v6 = *a2;
  if ( a3 < 2 )
  {
    if ( v6 != 6 )
    {
      unknown_libname_3((_DWORD *)v4, dword_42D9A0);
      return *a2;
    }
    if ( !sub_403D30(*(int (***)(void))(v4 + 12)) )
    {
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
    unknown_libname_3((_DWORD *)this[3], dword_42D9DC);
  }
  else
  {
    if ( v6 != 0x90 || a2[1] != 17 )
    {
      *(_DWORD *)(v5 + 1048700) = a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    if ( !sub_403C20(*(_DWORD *)(v4 + 12)) )
    {
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
  }
  return 0;
}


/* ==== 405300  sub_405300  ()  size=214 ==== */
int __thiscall sub_405300(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx
  int v5; // edi
  unsigned __int8 v6; // al

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  v6 = *a2;
  if ( a3 < 2 )
  {
    if ( v6 != 6 )
    {
      unknown_libname_3((_DWORD *)v4, dword_42D9A0);
      return *a2;
    }
    if ( !sub_403D80(*(int (***)(void))(v4 + 12)) )
      goto LABEL_5;
    unknown_libname_3((_DWORD *)this[3], dword_42D9E4);
  }
  else
  {
    if ( v6 != 0x91 || a2[1] != 17 )
    {
      *(_DWORD *)(v5 + 1048700) = a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    if ( !sub_403D50(*(_DWORD *)(v4 + 12)) )
    {
LABEL_5:
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  return 0;
}


/* ==== 4053E0  sub_4053E0  ()  size=227 ==== */
int __thiscall sub_4053E0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  HANDLE CurrentProcess; // eax
  int v5; // edi
  unsigned __int8 v6; // al

  CurrentProcess = GetCurrentProcess();
  SetPriorityClass(CurrentProcess, 0x100u);
  v5 = *(_DWORD *)(this[3] + 12);
  v6 = *a2;
  if ( *a2 == 22 )
  {
    if ( !sub_403EC0((int (**)(void))v5) )
    {
LABEL_3:
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
    unknown_libname_3((_DWORD *)this[3], dword_42D9F0);
    return 0;
  }
  else if ( v6 == 6 || v6 == 38 )
  {
    if ( !sub_404020((int (**)(void))v5) )
      goto LABEL_3;
    unknown_libname_3((_DWORD *)this[3], dword_42DA04);
    return 0;
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v5 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 4054D0  sub_4054D0  ()  size=187 ==== */
int __thiscall sub_4054D0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // eax
  int v5; // esi

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  if ( *a2 == 6 )
  {
    if ( sub_403710(*(_DWORD *)(v4 + 12)) )
    {
      while ( !*(_BYTE *)(v5 + 77) )
      {
        if ( !sub_403710(v5) )
          goto LABEL_8;
      }
      sub_403BB0((int (**)(void))v5);
      unknown_libname_3((_DWORD *)this[3], dword_42DA0C);
      return 0;
    }
    else
    {
LABEL_8:
      if ( sub_403940(v5) )
      {
        unknown_libname_3((_DWORD *)this[3], dword_42DA08);
        return 0;
      }
      else
      {
        *(_DWORD *)(v5 + 1048700) = 161;
        unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
        return 255;
      }
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v5 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405590  sub_405590  ()  size=382 ==== */
int __thiscall sub_405590(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // esi
  HANDLE CurrentProcess; // eax
  FILE *v6; // eax
  FILE *v7; // edi
  char v9; // [esp+0h] [ebp-Ch]

  v4 = *(_DWORD *)(this[3] + 12);
  CurrentProcess = GetCurrentProcess();
  if ( SetThreadPriorityBoost(CurrentProcess, 1) )
  {
    v6 = (FILE *)sub_40B75F("dbg.txt", (int)"a");
    v7 = v6;
    if ( !v6 )
    {
      sub_40B69D("cannot open\n");
      exit(1);
    }
    sub_40B478(v6, (int)"12:true\n", v9);
    fclose(v7);
  }
  if ( a3 >= 2 )
  {
    if ( *a2 != 0xD0 || a2[1] != 17 )
    {
      *(_DWORD *)(v4 + 1048700) = a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    ++dword_42DA20;
    if ( !sub_403940(v4) )
    {
LABEL_16:
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    while ( 1 )
    {
      if ( *a2 != 6 )
      {
        unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
        return *a2;
      }
      sub_4038B0(v4);
      if ( *(_BYTE *)(v4 + 77) )
      {
        sub_403BB0((int (**)(void))v4);
        unknown_libname_3((_DWORD *)this[3], dword_42DA0C);
        return 0;
      }
      if ( sub_403710(v4) )
        break;
LABEL_11:
      if ( !sub_403940(v4) )
        goto LABEL_16;
      sub_403530((int (**)(void))v4, (char *)a2, 4u);
    }
    while ( !*(_BYTE *)(v4 + 77) )
    {
      if ( !sub_403710(v4) )
        goto LABEL_11;
    }
    sub_403BB0((int (**)(void))v4);
    unknown_libname_3((_DWORD *)this[3], dword_42DA0C);
  }
  return 0;
}


/* ==== 405710  sub_405710  ()  size=227 ==== */
int __thiscall sub_405710(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ecx
  int v5; // esi
  unsigned __int8 v6; // al
  int (**v7)(void); // ecx

  v4 = this[3];
  v5 = *(_DWORD *)(v4 + 12);
  v6 = *a2;
  if ( a3 < 2 )
  {
    if ( v6 != 6 )
    {
      unknown_libname_3((_DWORD *)v4, dword_42D9A0);
      return *a2;
    }
    if ( !sub_404060(*(int (***)(void))(v4 + 12)) )
      goto LABEL_5;
    unknown_libname_3((_DWORD *)this[3], dword_42DA10);
  }
  else
  {
    if ( v6 != 0xD0 || a2[1] != 17 )
    {
      *(_DWORD *)(v5 + 1048700) = a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    v7 = *(int (***)(void))(v4 + 12);
    ++dword_42DA20;
    if ( !sub_403BB0(v7) )
    {
LABEL_5:
      *(_DWORD *)(v5 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  return 0;
}


/* ==== 405800  sub_405800  ()  size=167 ==== */
int __thiscall sub_405800(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // ebx
  int v6; // esi

  v4 = *(_DWORD *)(this[3] + 12);
  if ( *a2 == 91 )
  {
    v6 = a2[5] + ((a2[4] + ((a2[3] + (a2[2] << 8)) << 8)) << 8);
    if ( v6 == sub_4033B0((unsigned __int8 *)v4) )
    {
      *(_BYTE *)(v4 + 76) = 1;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 175;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 4058B0  sub_4058B0  ()  size=250 ==== */
int __thiscall sub_4058B0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  _DWORD *v4; // esi
  int v5; // ecx
  int v7; // edi

  v4 = *(_DWORD **)(this[3] + 12);
  v5 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  if ( *a2 == 48 )
  {
    if ( *(_DWORD *)(v5 + 1048584) )
      v7 = *((_DWORD *)a2 + 1);
    else
      v7 = *(_DWORD *)&a2[a2[3] + 5];
    v4[262167] = v7;
    v4[262168] = 0;
    v4[262169] = 0;
    v4[262170] = 0;
    if ( sub_403C20((int)v4) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9D8);
      return 0;
    }
    else
    {
      v4[262175] = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      v4[262175] = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 4059B0  sub_4059B0  ()  size=167 ==== */
int __thiscall sub_4059B0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi
  int v5; // eax
  char v7; // bl

  v4 = *(_DWORD *)(this[3] + 12);
  v5 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  if ( *a2 == 49 )
  {
    if ( *(_WORD *)(v5 + 1048640) == 6 )
      v7 = 1;
    else
      v7 = a2[2];
    *(_BYTE *)(v4 + 1048684) = v7;
    if ( sub_403D50(v4) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9E0);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405A60  sub_405A60  ()  size=221 ==== */
int __thiscall sub_405A60(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi
  int v5; // eax
  int v7; // eax
  int v8; // [esp-4h] [ebp-10h]

  v4 = *(_DWORD *)(this[3] + 12);
  v5 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  if ( *a2 == 55 )
  {
    *(_DWORD *)(v4 + 1048688) = a2[3] + (a2[2] << 8);
    if ( *(_WORD *)(v5 + 1048640) == 5 )
    {
      v7 = *(_DWORD *)(v5 + 1048584) != 0 ? 0 : 2;
    }
    else if ( *(_WORD *)(v5 + 1048640) == 6 )
    {
      v7 = 0;
    }
    else
    {
      v7 = 3;
    }
    v8 = dword_424688[v7];
    dword_42DA20 = v7;
    if ( sub_403DA0((int (**)(void))v4, v8) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9E8);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405B40  sub_405B40  ()  size=349 ==== */
int __thiscall sub_405B40(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int (**v4)(void); // edi
  int v5; // eax
  int v7; // [esp-4h] [ebp-10h]

  v4 = *(int (***)(void))(this[3] + 12);
  v5 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( a3 < 2 )
  {
    if ( *a2 != 6 )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    if ( !*(_DWORD *)(*(_DWORD *)(v5 + 160) + 1048584) )
    {
      nullsub_3();
      if ( !(unsigned __int8)sub_403060(v4, dword_424688[dword_42DA20]) )
        goto LABEL_5;
    }
    Sleep(0x1Eu);
    if ( !sub_403920(v4) )
    {
LABEL_7:
      v4[262175] = (int (*)(void))161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
    unknown_libname_3((_DWORD *)this[3], dword_42D9EC);
  }
  else
  {
    if ( *a2 != 0xBF || a2[1] != 36 )
    {
      v4[262175] = (int (*)(void))a2[1];
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return *a2;
    }
    if ( (unsigned int)dword_42DA20 > 7 )
    {
LABEL_5:
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
    v7 = dword_42468C[dword_42DA20++];
    if ( !sub_403DA0(v4, v7) )
      goto LABEL_7;
  }
  return 0;
}


/* ==== 405CA0  sub_405CA0  ()  size=161 ==== */
int __thiscall sub_405CA0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int (**v4)(void); // esi
  LPARAM v6; // eax
  WPARAM v7; // [esp-4h] [ebp-10h]

  v4 = *(int (***)(void))(this[3] + 12);
  AfxGetModuleState();
  if ( *a2 == 6 )
  {
    if ( sub_403E80(v4) )
    {
      v7 = (WPARAM)v4[262172];
      v6 = sub_403400(v4);
      sub_4033A0((const CHAR *)1, 0, v6, v7);
      unknown_libname_3((_DWORD *)this[3], dword_42DA00);
      return 0;
    }
    else
    {
      v4[262175] = (int (*)(void))161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      v4[262175] = (int (*)(void))a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405D50  sub_405D50  ()  size=135 ==== */
int __thiscall sub_405D50(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  AfxGetModuleState();
  if ( *a2 == 38 )
  {
    if ( sub_403FD0((int (**)(void))v4) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9F4);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405DE0  sub_405DE0  ()  size=137 ==== */
int __thiscall sub_405DE0(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  AfxGetModuleState();
  if ( *a2 == 6 )
  {
    if ( sub_403FF0((int (**)(void))v4, 0) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42D9F8);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405E70  sub_405E70  ()  size=233 ==== */
int __thiscall sub_405E70(int this, unsigned __int8 *a2, int a3)
{
  int v4; // edi
  _DWORD *v6; // ecx

  v4 = *(_DWORD *)(*(_DWORD *)(this + 12) + 12);
  AfxGetModuleState();
  if ( *a2 == 6 )
  {
    if ( *(int *)(this + 16) >= 30 )
    {
      if ( sub_403FF0((int (**)(void))v4, 255) )
      {
        v6 = *(_DWORD **)(this + 12);
        *(_DWORD *)(this + 16) = 22;
        unknown_libname_3(v6, dword_42D9FC);
        return 0;
      }
    }
    else if ( sub_403FF0((int (**)(void))v4, *(_BYTE *)(this + 16)) )
    {
      ++*(_DWORD *)(this + 16);
      return 0;
    }
    *(_DWORD *)(v4 + 1048700) = 161;
    unknown_libname_3(*(_DWORD **)(this + 12), dword_42D9A0);
    *(_DWORD *)(this + 16) = 22;
    return 255;
  }
  if ( a3 >= 2 )
    *(_DWORD *)(v4 + 1048700) = a2[1];
  unknown_libname_3(*(_DWORD **)(this + 12), dword_42D9A0);
  return *a2;
}


/* ==== 405F60  sub_405F60  ()  size=135 ==== */
int __thiscall sub_405F60(_DWORD *this, unsigned __int8 *a2, int a3)
{
  int v4; // edi

  v4 = *(_DWORD *)(this[3] + 12);
  AfxGetModuleState();
  if ( *a2 == 6 )
  {
    if ( sub_404020((int (**)(void))v4) )
    {
      unknown_libname_3((_DWORD *)this[3], dword_42DA04);
      return 0;
    }
    else
    {
      *(_DWORD *)(v4 + 1048700) = 161;
      unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
      return 255;
    }
  }
  else
  {
    if ( a3 >= 2 )
      *(_DWORD *)(v4 + 1048700) = a2[1];
    unknown_libname_3((_DWORD *)this[3], dword_42D9A0);
    return *a2;
  }
}


/* ==== 405FF0  sub_405FF0  ()  size=25 ==== */
int __thiscall sub_405FF0(int *this, int a2, int a3, int a4)
{
  int v4; // edx

  v4 = *this;
  this[3] = a2;
  return (*(int (__stdcall **)(int, int))(v4 + 8))(a3, a4);
}


/* ==== 406010  sub_406010  ()  size=8 ==== */
int __stdcall sub_406010(int a1, int a2)
{
  return 255;
}


/* ==== 406020  sub_406020  ()  size=50 ==== */
_DWORD *__thiscall sub_406020(_DWORD *this)
{
  int v2; // eax

  *this = &off_4234D0;
  v2 = sub_417937();
  this[2] = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  *((_WORD *)this + 2) = -1;
  *this = &off_4246E4;
  this[3] = 0;
  return this;
}


/* ==== 406060  sub_406060  ()  size=6 ==== */
char **sub_406060()
{
  return &off_4246F8;
}


/* ==== 406070  sub_406070  ()  size=6 ==== */
_UNKNOWN ****sub_406070()
{
  return &off_4246F0;
}


/* ==== 406080  sub_406080  ()  size=30 ==== */
void *__thiscall sub_406080(void *Block, char a2)
{
  sub_4173AF();
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 4060A0  sub_4060A0  ()  size=116 ==== */
_DWORD *__thiscall sub_4060A0(_DWORD *this, struct CWnd *a2)
{
  CDialog::CDialog((CDialog *)this, 0x85u, a2);
  *this = &off_424720;
  CWnd::CWnd((CWnd *)(this + 28));
  this[28] = &CProgressCtrl::`vftable';
  this[50] = 0;
  this[49] = &CFont::`vftable';
  return this;
}


/* ==== 406120  sub_406120  ()  size=104 ==== */
int __thiscall sub_406120(_DWORD *this)
{
  CGdiObject *v2; // ecx

  *this = &off_424720;
  v2 = (CGdiObject *)(this + 49);
  *(_DWORD *)v2 = &CGdiObject::`vftable';
  CGdiObject::DeleteObject(v2);
  sub_4173AF(this + 28);
  return sub_417B12(this);
}


/* ==== 406190  sub_406190  ()  size=22 ==== */
void __thiscall sub_406190(HWND this, struct CDataExchange *a2)
{
  DDX_Control(a2, (HWND)0x3FA, this + 28);
}


/* ==== 4061B0  sub_4061B0  ()  size=128 ==== */
int __thiscall sub_4061B0(CWnd *this)
{
  char *v2; // esi
  HFONT FontA; // eax
  struct CWnd *DlgItem; // eax

  CDialog::OnInitDialog(this);
  if ( *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048636) == 1 )
  {
    v2 = (char *)this + 196;
    FontA = CreateFontA(14, 0, 0, 0, 0, 0, 0, 0, 0x80u, 4u, 0, 0, 0, &pszFaceName);
    sub_41DA5E(FontA);
    DlgItem = CWnd::GetDlgItem(this, 1022);
    if ( this != (CWnd *)-196 )
      v2 = (char *)*((_DWORD *)this + 50);
    SendMessageA(*((HWND *)DlgItem + 7), 0x30u, (WPARAM)v2, 1);
  }
  return 1;
}


/* ==== 406230  sub_406230  ()  size=30 ==== */
_DWORD *__thiscall sub_406230(_DWORD *Block, char a2)
{
  sub_406120(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 406250  sub_406250  ()  size=306 ==== */
_DWORD *__thiscall sub_406250(int this, LPCSTR lpString, WPARAM wParam, LPARAM lParam, WPARAM a5)
{
  int v6; // ebp
  WPARAM v7; // ebx
  int v8; // eax
  int v9; // eax
  LPCSTR v10; // edi
  _DWORD *result; // eax
  char *v12; // [esp-8h] [ebp-24h]

  v6 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v7 = wParam;
  SendMessageA(*(HWND *)(this + 140), 0x406u, wParam, lParam);
  SendMessageA(*(HWND *)(this + 140), 0x404u, a5, 0);
  SendMessageA(*(HWND *)(this + 140), 0x402u, v7, 0);
  *(_DWORD *)(this + 192) = (__int16)lpString;
  v8 = sub_417937();
  lpString = (LPCSTR)((*(int (__thiscall **)(int))(*(_DWORD *)v8 + 12))(v8) + 16);
  v9 = *(_DWORD *)(this + 192);
  if ( v9 )
  {
    if ( v9 != 1 )
      goto LABEL_10;
    if ( *(_DWORD *)(v6 + 1048636) )
    {
      sub_402D80((int *)&lpString, byte_4248A4, 0);
      goto LABEL_10;
    }
    v12 = "Updating... %d%%";
  }
  else
  {
    if ( !*(_DWORD *)(v6 + 1048636) )
    {
      sub_402D80((int *)&lpString, "Initializing... %d%%", 0);
      goto LABEL_10;
    }
    v12 = (char *)&byte_424878;
  }
  sub_402D80((int *)&lpString, v12, 0);
LABEL_10:
  v10 = lpString;
  sub_41B959(1022, lpString);
  result = v10 - 16;
  if ( _InterlockedDecrement((volatile signed __int32 *)v10 - 1) <= 0 )
    return (_DWORD *)(*(int (__thiscall **)(_DWORD, LPCSTR))(*(_DWORD *)*result + 4))(*result, v10 - 16);
  return result;
}


/* ==== 406390  sub_406390  ()  size=336 ==== */
_DWORD *__thiscall sub_406390(int this)
{
  int v2; // ebx
  int v3; // eax
  int v4; // eax
  double v5; // st7
  double v6; // st7
  LPCSTR v7; // edi
  _DWORD *result; // eax
  char *v9; // [esp-8h] [ebp-30h]
  int v10; // [esp-4h] [ebp-2Ch]
  LPCSTR lpString; // [esp+Ch] [ebp-1Ch] BYREF
  float v12; // [esp+10h] [ebp-18h]
  int v13; // [esp+14h] [ebp-14h] BYREF
  int v14; // [esp+18h] [ebp-10h] BYREF
  int v15; // [esp+24h] [ebp-4h]

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  SendMessageA(*(HWND *)(this + 140), 0x405u, 0, 0);
  v12 = COERCE_FLOAT(SendMessageA(*(HWND *)(this + 140), 0x408u, 0, 0));
  CProgressCtrl::GetRange((CProgressCtrl *)(this + 112), &v14, &v13);
  v12 = (double)SLODWORD(v12) / (double)v13 * 100.0;
  v3 = sub_417937();
  lpString = (LPCSTR)((*(int (__thiscall **)(int))(*(_DWORD *)v3 + 12))(v3) + 16);
  v4 = *(_DWORD *)(this + 192);
  v15 = 0;
  if ( v4 )
  {
    if ( v4 != 1 )
      goto LABEL_10;
    v5 = v12;
    if ( *(_DWORD *)(v2 + 1048636) )
    {
      sub_402D80((int *)&lpString, byte_4248A4, (unsigned int)(unsigned __int64)v5);
      goto LABEL_10;
    }
    v10 = (unsigned __int64)v5;
    v9 = "Updating... %d%%";
  }
  else
  {
    v6 = v12;
    if ( !*(_DWORD *)(v2 + 1048636) )
    {
      sub_402D80((int *)&lpString, "Initializing... %d%%", (unsigned int)(unsigned __int64)v6);
      goto LABEL_10;
    }
    v10 = (unsigned __int64)v6;
    v9 = (char *)&byte_424878;
  }
  sub_402D80((int *)&lpString, v9, v10);
LABEL_10:
  v7 = lpString;
  sub_41B959(1022, lpString);
  result = v7 - 16;
  v15 = -1;
  if ( _InterlockedDecrement((volatile signed __int32 *)v7 - 1) <= 0 )
    return (_DWORD *)(*(int (__thiscall **)(_DWORD, LPCSTR))(*(_DWORD *)*result + 4))(*result, v7 - 16);
  return result;
}


/* ==== 4064E0  sub_4064E0  ()  size=138 ==== */
char *__thiscall sub_4064E0(char *this)
{
  memset(this + 4, 0xFFu, 0x100000u);
  *((_DWORD *)this + 262147) = 0;
  *((_DWORD *)this + 262148) = 0;
  *((_DWORD *)this + 262149) = 0;
  *((_DWORD *)this + 262150) = 0;
  *((_DWORD *)this + 262151) = 0;
  *((_DWORD *)this + 262152) = 0;
  this[1048612] = 0;
  *(_DWORD *)(this + 1048613) = 0;
  *(_DWORD *)(this + 1048617) = 0;
  *(_WORD *)(this + 1048621) = 0;
  this[1048623] = 0;
  *((_DWORD *)this + 262156) = 0;
  *((_DWORD *)this + 262157) = 0;
  *((_WORD *)this + 524316) = 0;
  this[1048634] = 0;
  *((_WORD *)this + 524321) = 0;
  *((_WORD *)this + 524320) = 6;
  *(_DWORD *)this = 0;
  *((_DWORD *)this + 262146) = 0;
  *((_DWORD *)this + 262145) = 0;
  *((_DWORD *)this + 262159) = 0;
  *((_DWORD *)this + 262161) = 0;
  *((_DWORD *)this + 262166) = 0;
  *((_DWORD *)this + 262167) = 0;
  return this;
}


/* ==== 406570  sub_406570  ()  size=6 ==== */
_UNKNOWN ***sub_406570()
{
  return &off_4248CC;
}


/* ==== 406580  sub_406580  ()  size=5 ==== */
// attributes: thunk
int __thiscall sub_406580(void *this)
{
  return sub_417B12(this);
}


/* ==== 406590  sub_406590  ()  size=200 ==== */
int __stdcall sub_406590(int a1, int a2, int a3)
{
  const char *v3; // eax
  int result; // eax
  int i; // ebx
  unsigned int v6; // eax
  char *v7; // edi
  char *v9; // edi
  char *v10; // esi
  char v11; // cl
  char v12[4]; // [esp+10h] [ebp-1410h] BYREF
  int v13; // [esp+14h] [ebp-140Ch] BYREF
  char Buffer[5124]; // [esp+18h] [ebp-1408h] BYREF

  v13 = a2;
  memset(Buffer, 0, 0x1400u);
  v3 = "Tx";
  if ( a1 )
    v3 = "Rx";
  sprintf(Buffer, "%s ", v3);
  result = a3;
  for ( i = 0; i < a3; ++i )
  {
    sprintf(v12, "%02x ", *(unsigned __int8 *)(v13 + i));
    v6 = strlen(v12) + 1;
    v7 = (char *)&v13 + 3;
    while ( *++v7 )
      ;
    qmemcpy(v7, v12, 4 * (v6 >> 2));
    v10 = &v12[4 * (v6 >> 2)];
    v9 = &v7[4 * (v6 >> 2)];
    v11 = v6;
    result = a3;
    qmemcpy(v9, v10, v11 & 3);
  }
  return result;
}


/* ==== 406660  sub_406660  ()  size=109 ==== */
int __thiscall sub_406660(_DWORD *this, int a2, int a3, int a4)
{
  int result; // eax

  result = sub_408A8A(a2, this[24], a3, a4);
  if ( !result )
  {
    if ( *(_DWORD *)(this[40] + 1048636) == 1 )
      return sub_41E4CD(&unk_424914, 8208, 0);
    else
      return sub_41E4CD("Help is not found.", 8208, 0);
  }
  return result;
}


/* ==== 4066D0  sub_4066D0  ()  size=100 ==== */
void **__thiscall sub_4066D0(
        void **this,
        const void *a2,
        signed int a3,
        int (__thiscall ***a4)(_DWORD, signed int, int))
{
  int v5; // eax
  void *v6; // eax

  if ( !a2 && a3 )
    goto LABEL_3;
  v5 = (**a4)(a4, a3, 1);
  if ( !v5 )
    sub_401320();
  v6 = (void *)(v5 + 16);
  *this = v6;
  if ( a3 < 0 || a3 > *((_DWORD *)v6 - 2) )
LABEL_3:
    sub_4010F0(-2147024809);
  *((_DWORD *)v6 - 3) = a3;
  *((_BYTE *)*this + a3) = 0;
  qmemcpy(*this, a2, a3);
  return this;
}


/* ==== 406740  sub_406740  ()  size=161 ==== */
CWinApp *__thiscall sub_406740(CWinApp *this)
{
  int v2; // eax
  int v3; // eax
  char *v4; // eax
  char *v5; // eax

  CWinApp::CWinApp(this, 0);
  *(_DWORD *)this = &off_424938;
  v2 = sub_417937();
  *((_DWORD *)this + 41) = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 12))(v2) + 16;
  v3 = sub_417937();
  *((_DWORD *)this + 42) = (*(int (__thiscall **)(int))(*(_DWORD *)v3 + 12))(v3) + 16;
  v4 = (char *)operator new(0x100060u);
  if ( v4 )
    v5 = sub_4064E0(v4);
  else
    v5 = 0;
  *((_DWORD *)this + 40) = v5;
  *((_DWORD *)this + 26) = 1;
  return this;
}


/* ==== 4067F0  sub_4067F0  ()  size=75 ==== */
void __thiscall sub_4067F0(CWinApp *this)
{
  volatile signed __int32 *v2; // eax
  volatile signed __int32 *v3; // eax

  v2 = (volatile signed __int32 *)(*((_DWORD *)this + 42) - 16);
  if ( _InterlockedDecrement(v2 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v2 + 4))(v2);
  v3 = (volatile signed __int32 *)(*((_DWORD *)this + 41) - 16);
  if ( _InterlockedDecrement(v3 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v3 + 4))(v3);
  CWinApp::~CWinApp(this);
}


/* ==== 406840  sub_406840  ()  size=30 ==== */
CWinApp *__thiscall sub_406840(CWinApp *Block, char a2)
{
  sub_4067F0(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 406860  sub_406860  ()  size=106 ==== */
volatile signed __int32 **__thiscall sub_406860(volatile signed __int32 **this, const void **a2)
{
  volatile signed __int32 *v3; // eax
  volatile signed __int32 *v4; // esi
  int v5; // ebp

  v3 = (volatile signed __int32 *)((char *)*a2 - 16);
  v4 = *this - 4;
  if ( v3 == v4 )
    return this;
  if ( *((int *)v4 + 3) < 0 || *v3 != *v4 )
  {
    sub_401520(this, *a2, *((_DWORD *)*a2 - 3));
    return this;
  }
  v5 = sub_402BC0(v3);
  if ( _InterlockedDecrement(v4 + 3) <= 0 )
    (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v4 + 4))(v4);
  *this = (volatile signed __int32 *)(v5 + 16);
  return this;
}


/* ==== 4068D0  sub_4068D0  ()  size=501 ==== */
int __thiscall sub_4068D0(int this)
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  HRSRC ResourceA; // eax
  HGLOBAL Resource; // eax
  HRSRC v5; // eax
  HGLOBAL v6; // esi
  signed int v7; // edi
  int (__thiscall ***v8)(_DWORD, signed int, int); // eax
  volatile signed __int32 *v9; // eax
  HRSRC v10; // eax
  HGLOBAL v11; // esi
  signed int v12; // edi
  int (__thiscall ***v13)(_DWORD, signed int, int); // eax
  volatile signed __int32 *v14; // eax
  volatile signed __int32 *v16; // [esp+4h] [ebp-98h] BYREF
  _BYTE v17[136]; // [esp+8h] [ebp-94h] BYREF
  int v18; // [esp+98h] [ebp-4h]

  CWinApp::InitInstance((CWinApp *)this);
  ModuleState = AfxGetModuleState();
  if ( CreateMutexA(0, 1, *((LPCSTR *)ModuleState + 4)) && GetLastError() != 183 )
  {
    ResourceA = FindResourceA(0, "RES_UPDATE_INFO", (LPCSTR)0x17);
    Resource = LoadResource(0, ResourceA);
    if ( Resource )
    {
      qmemcpy(*(void **)(this + 160), Resource, 0x100060u);
      v5 = FindResourceA(0, "RES_START_DLG", (LPCSTR)0x17);
      v6 = LoadResource(0, v5);
      if ( v6 )
      {
        v7 = *(_DWORD *)(*(_DWORD *)(this + 160) + 1048664);
        v8 = (int (__thiscall ***)(_DWORD, signed int, int))sub_417937();
        sub_4066D0((void **)&v16, v6, v7, v8);
        v18 = 0;
        sub_406860((volatile signed __int32 **)(this + 164), (const void **)&v16);
        v9 = v16 - 4;
        v18 = -1;
        if ( _InterlockedDecrement(v16 - 1) <= 0 )
          (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v9 + 4))(v9);
      }
      v10 = FindResourceA(0, "RES_END_DLG", (LPCSTR)0x17);
      v11 = LoadResource(0, v10);
      if ( v11 )
      {
        v12 = *(_DWORD *)(*(_DWORD *)(this + 160) + 1048668);
        v13 = (int (__thiscall ***)(_DWORD, signed int, int))sub_417937();
        sub_4066D0((void **)&v16, v11, v12, v13);
        v18 = 1;
        sub_406860((volatile signed __int32 **)(this + 168), (const void **)&v16);
        v14 = v16 - 4;
        v18 = -1;
        if ( _InterlockedDecrement(v16 - 1) <= 0 )
          (*(void (__stdcall **)(volatile signed __int32 *))(**(_DWORD **)v14 + 4))(v14);
      }
      sub_406B90(0);
      v18 = 2;
      *(_DWORD *)(this + 28) = v17;
      CDialog::DoModal((CDialog *)v17);
      sub_401110();
      sub_403040();
      j__free(*(void **)(this + 160));
      v18 = -1;
      sub_417B12(v17);
    }
    else
    {
      sub_41E4CD("Can't execute updater.", 16, 0);
    }
  }
  return 0;
}


/* ==== 406AF0  sub_406AF0  ()  size=6 ==== */
_UNKNOWN ****sub_406AF0()
{
  return &off_424A34;
}


/* ==== 406B00  sub_406B00  ()  size=4 ==== */
int __thiscall sub_406B00(_DWORD *this)
{
  return this[28];
}


/* ==== 406B80  sub_406B80  ()  size=14 ==== */
void __stdcall sub_406B80(void *Block)
{
  j__free(Block);
}


/* ==== 406B90  sub_406B90  ()  size=118 ==== */
CDialog *__thiscall sub_406B90(CDialog *this, struct CWnd *a2)
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  HICON IconA; // eax

  CDialog::CDialog(this, 0x66u, a2);
  *(_DWORD *)this = &off_424B30;
  AfxGetModuleState();
  ModuleState = AfxGetModuleState();
  IconA = LoadIconA(*((HINSTANCE *)ModuleState + 3), (LPCSTR)0x8F);
  *((_DWORD *)this + 29) = 0;
  *((_DWORD *)this + 30) = 0;
  *((_DWORD *)this + 31) = 0;
  *((_DWORD *)this + 32) = 0;
  *((_DWORD *)this + 28) = IconA;
  return this;
}


/* ==== 406C10  sub_406C10  ()  size=30 ==== */
void *__thiscall sub_406C10(void *Block, char a2)
{
  sub_406580(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 406C30  sub_406C30  ()  size=202 ==== */
void __thiscall sub_406C30(struct CWnd *this)
{
  int SystemMetrics; // ebx
  int v3; // edi
  struct tagRECT Rect; // [esp+4h] [ebp-68h] BYREF
  _BYTE v5[4]; // [esp+14h] [ebp-58h] BYREF
  WPARAM wParam; // [esp+18h] [ebp-54h]

  if ( IsIconic(*((HWND *)this + 7)) )
  {
    CPaintDC::CPaintDC((CPaintDC *)v5, this);
    SendMessageA(*((HWND *)this + 7), 0x27u, wParam, 0);
    SystemMetrics = GetSystemMetrics(11);
    v3 = GetSystemMetrics(12);
    GetClientRect(*((HWND *)this + 7), &Rect);
    DrawIcon(
      (HDC)wParam,
      (Rect.right - Rect.left - SystemMetrics + 1) / 2,
      (Rect.bottom - Rect.top - v3 + 1) / 2,
      *((HICON *)this + 28));
    CPaintDC::~CPaintDC((CPaintDC *)v5);
  }
  else
  {
    sub_417B50(this);
  }
}


/* ==== 406D70  sub_406D70  ()  size=118 ==== */
int sub_406D70()
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  _DWORD v2[34]; // [esp+0h] [ebp-94h] BYREF
  int v3; // [esp+90h] [ebp-4h]

  ModuleState = AfxGetModuleState();
  sub_4021A0((CDialog *)v2, *(_DWORD *)(*(_DWORD *)(*((_DWORD *)ModuleState + 1) + 160) + 1048636), 0);
  v3 = 0;
  CDialog::DoModal((CDialog *)v2);
  v3 = -1;
  return sub_402220(v2);
}


/* ==== 406DF0  sub_406DF0  ()  size=660 ==== */
LPCSTR __thiscall sub_406DF0(CWnd *this, int a2)
{
  int v3; // edi
  int v4; // ebx
  int v5; // ebp
  int v6; // eax
  CWnd *DlgItem; // eax
  CWnd *v8; // eax
  CWnd *v9; // eax
  CWnd *v10; // eax
  CWnd *v11; // eax
  CWnd *v12; // eax
  CWnd *v13; // eax
  LPCSTR v14; // eax
  LPCSTR result; // eax
  int v16; // [esp-4h] [ebp-44h]
  int v17; // [esp-4h] [ebp-44h]
  int v18; // [esp-4h] [ebp-44h]
  int v19; // [esp-4h] [ebp-44h]
  const CHAR *v20; // [esp-4h] [ebp-44h]
  const CHAR *v21; // [esp-4h] [ebp-44h]
  LPCSTR v22; // [esp+10h] [ebp-30h] BYREF
  LPCSTR lpString; // [esp+14h] [ebp-2Ch] BYREF
  int v24; // [esp+18h] [ebp-28h]
  int v25; // [esp+1Ch] [ebp-24h]
  int v26; // [esp+20h] [ebp-20h]
  int v27; // [esp+24h] [ebp-1Ch]
  int v28; // [esp+28h] [ebp-18h]
  int v29; // [esp+2Ch] [ebp-14h]
  int v30; // [esp+30h] [ebp-10h]
  int v31; // [esp+38h] [ebp-8h]
  int v32; // [esp+3Ch] [ebp-4h]

  v3 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v4 = 0;
  v5 = 1;
  v24 = 0;
  v25 = 0;
  v26 = 0;
  v29 = 1;
  v30 = 1;
  v28 = 0;
  v27 = 0;
  sub_404670((volatile signed __int32 **)&lpString, (int)"Update");
  v32 = 0;
  sub_404670((volatile signed __int32 **)&v22, (int)"Exit");
  *((_DWORD *)this + 33) = a2;
  v6 = *(_DWORD *)(v3 + 1048584);
  LOBYTE(v32) = 1;
  if ( v6 == 1 )
    v27 = 5;
  switch ( a2 )
  {
    case 0:
      v24 = 5;
      if ( v6 == 1 )
        v28 = 1;
      DlgItem = CWnd::GetDlgItem(this, 1015);
      goto LABEL_11;
    case 1:
      v25 = 5;
      sub_401600((volatile signed __int32 **)&lpString, "OK");
      sub_401600((volatile signed __int32 **)&v22, "Cancel");
      DlgItem = CWnd::GetDlgItem(this, 1015);
      goto LABEL_11;
    case 2:
      v4 = 5;
      v29 = 0;
      v30 = 0;
      sub_401600((volatile signed __int32 **)&lpString, "OK");
      sub_401600((volatile signed __int32 **)&v22, "Cancel");
      v8 = CWnd::GetDlgItem(this, 1016);
      CWnd::SetFocus(v8);
      if ( *(_DWORD *)(v3 + 1048584) == 1 )
        v5 = 0;
      break;
    case 3:
      v26 = 5;
      sub_401600((volatile signed __int32 **)&lpString, "OK");
      v5 = 1;
      sub_401600((volatile signed __int32 **)&v22, "Exit");
      DlgItem = CWnd::GetDlgItem(this, 1016);
LABEL_11:
      CWnd::SetFocus(DlgItem);
      break;
    default:
      break;
  }
  CWnd::ShowWindow(*((CWnd **)this + 29), v24);
  CWnd::ShowWindow(*((CWnd **)this + 30), v25);
  CWnd::ShowWindow(*((CWnd **)this + 31), v4);
  CWnd::ShowWindow(*((CWnd **)this + 32), v26);
  v16 = v27;
  v9 = CWnd::GetDlgItem(this, 1024);
  CWnd::ShowWindow(v9, v16);
  v17 = v28;
  v10 = CWnd::GetDlgItem(this, 1024);
  CWnd::EnableWindow(v10, v17);
  v18 = v29;
  v11 = CWnd::GetDlgItem(this, 1015);
  CWnd::EnableWindow(v11, v18);
  v19 = v30;
  v12 = CWnd::GetDlgItem(this, 1001);
  CWnd::EnableWindow(v12, v19);
  v13 = CWnd::GetDlgItem(this, 1016);
  CWnd::EnableWindow(v13, v5);
  v20 = lpString;
  CWnd::GetDlgItem(this, 1015);
  sub_41BA0F(v20);
  v21 = v22;
  CWnd::GetDlgItem(this, 1016);
  sub_41BA0F(v21);
  v14 = v22 - 16;
  LOBYTE(v32) = 0;
  if ( _InterlockedDecrement((volatile signed __int32 *)v22 - 1) <= 0 )
    (*(void (__cdecl **)(LPCSTR))(**(_DWORD **)v14 + 4))(v14);
  result = v22 - 16;
  v31 = -1;
  if ( _InterlockedDecrement((volatile signed __int32 *)v22 - 1) <= 0 )
    return (LPCSTR)(*(int (__cdecl **)(LPCSTR))(**(_DWORD **)result + 4))(result);
  return result;
}


/* ==== 4070A0  sub_4070A0  ()  size=610 ==== */
int __thiscall sub_4070A0(struct CWnd *this)
{
  const CHAR *v2; // edi
  struct CWnd *DlgItem; // eax
  CDialog *v4; // eax
  CDialog *v5; // eax
  CDialog *v6; // eax
  CDialog *v7; // eax
  _DWORD *v8; // eax
  _DWORD *v9; // eax
  CDialog *v10; // eax
  CDialog *v11; // eax
  int *v12; // ecx
  int v13; // edx
  struct tagRECT Rect; // [esp+20h] [ebp-1Ch] BYREF
  int v16; // [esp+38h] [ebp-4h]

  CDialog::OnInitDialog(this);
  SendMessageA(*((HWND *)this + 7), 0x80u, 1u, *((_DWORD *)this + 28));
  SendMessageA(*((HWND *)this + 7), 0x80u, 0, *((_DWORD *)this + 28));
  v2 = *(const CHAR **)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  sub_41B959(1003, v2 + 1048588);
  sub_41B959(1004, v2 + 1048613);
  sub_41B959(1005, v2 + 1048624);
  DlgItem = CWnd::GetDlgItem(this, 1020);
  GetWindowRect(*((HWND *)DlgItem + 7), &Rect);
  sub_41D7EB(this, (LPPOINT)&Rect);
  v4 = (CDialog *)operator new(0x78u);
  v16 = 0;
  if ( v4 )
    v5 = sub_402B30(v4, this);
  else
    v5 = 0;
  v16 = -1;
  *((_DWORD *)this + 29) = v5;
  v6 = (CDialog *)operator new(0x78u);
  v16 = 1;
  if ( v6 )
    v7 = sub_4049A0(v6, this);
  else
    v7 = 0;
  v16 = -1;
  *((_DWORD *)this + 30) = v7;
  v8 = operator new(0xCCu);
  v16 = 2;
  if ( v8 )
    v9 = sub_4060A0(v8, this);
  else
    v9 = 0;
  v16 = -1;
  *((_DWORD *)this + 31) = v9;
  v10 = (CDialog *)operator new(0x78u);
  v16 = 3;
  if ( v10 )
    v11 = sub_4029D0(v10, this);
  else
    v11 = 0;
  v12 = (int *)*((_DWORD *)this + 29);
  *((_DWORD *)this + 32) = v11;
  v13 = *v12;
  v16 = -1;
  (*(void (__thiscall **)(int *, int, struct CWnd *))(v13 + 304))(v12, 136, this);
  (*(void (__thiscall **)(_DWORD, int, struct CWnd *))(**((_DWORD **)this + 30) + 304))(
    *((_DWORD *)this + 30),
    103,
    this);
  (*(void (__thiscall **)(_DWORD, int, struct CWnd *))(**((_DWORD **)this + 31) + 304))(
    *((_DWORD *)this + 31),
    133,
    this);
  (*(void (__thiscall **)(_DWORD, int, struct CWnd *))(**((_DWORD **)this + 32) + 304))(
    *((_DWORD *)this + 32),
    134,
    this);
  CWnd::MoveWindow(*((CWnd **)this + 29), Rect.left, Rect.top, Rect.right - Rect.left, Rect.bottom - Rect.top, 1);
  CWnd::MoveWindow(*((CWnd **)this + 30), Rect.left, Rect.top, Rect.right - Rect.left, Rect.bottom - Rect.top, 1);
  CWnd::MoveWindow(*((CWnd **)this + 31), Rect.left, Rect.top, Rect.right - Rect.left, Rect.bottom - Rect.top, 1);
  CWnd::MoveWindow(*((CWnd **)this + 32), Rect.left, Rect.top, Rect.right - Rect.left, Rect.bottom - Rect.top, 1);
  sub_406DF0(this, 0);
  return 1;
}


/* ==== 4073E0  sub_4073E0  ()  size=83 ==== */
LPCSTR __thiscall sub_4073E0(CWnd *this)
{
  int v2; // ecx
  const char *v3; // eax

  v2 = *(_DWORD *)(*(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160) + 1048636);
  v3 = "Firmware Update is complete.";
  if ( v2 )
    v3 = (const char *)&unk_424CA4;
  sub_41E4CD(v3, 64, 0);
  SendMessageA(*(HWND *)(*((_DWORD *)this + 31) + 140), 0x402u, 0, 0);
  return sub_406DF0(this, 3);
}


/* ==== 407440  sub_407440  ()  size=248 ==== */
_DWORD *__thiscall sub_407440(CWnd *this, int a2, int a3)
{
  int v4; // esi
  int v5; // eax
  bool v6; // zf
  int v7; // eax
  const char *v8; // eax
  int v9; // esi
  _DWORD *result; // eax
  int v11; // [esp+8h] [ebp-10h] BYREF
  int v12; // [esp+14h] [ebp-4h]

  v4 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v5 = sub_417937();
  v11 = (*(int (__thiscall **)(int))(*(_DWORD *)v5 + 12))(v5) + 16;
  v6 = *(_DWORD *)(v4 + 1048584) == 1;
  v7 = *(_DWORD *)(v4 + 1048636);
  v12 = 0;
  if ( v6 )
  {
    v6 = v7 == 0;
    v8 = "Power is not turned on or cable is disconnected. Please check it.";
    if ( !v6 )
      v8 = (const char *)&unk_424D48;
  }
  else
  {
    v6 = v7 == 0;
    v8 = "Firmware Update was canceled.";
    if ( !v6 )
      v8 = (const char *)&unk_424D00;
  }
  sub_402D80(&v11, "%s (H'%02X,H'%02X)", v8, a2, a3);
  v9 = v11;
  sub_41E4CD(v11, 8208, 0);
  SendMessageA(*(HWND *)(*((_DWORD *)this + 31) + 140), 0x402u, 0, 0);
  sub_406DF0(this, 0);
  result = (_DWORD *)(v9 - 16);
  v12 = -1;
  if ( _InterlockedDecrement((volatile signed __int32 *)(v9 - 16 + 12)) <= 0 )
    return (_DWORD *)(*(int (__thiscall **)(_DWORD, int))(*(_DWORD *)*result + 4))(*result, v9 - 16);
  return result;
}


/* ==== 407540  sub_407540  ()  size=671 ==== */
char __thiscall sub_407540(CWnd *this)
{
  int v2; // ebx
  LPCSTR v3; // eax
  const void **v4; // edi
  volatile signed __int32 **v5; // eax
  int v6; // eax
  _DWORD *v7; // eax
  int v8; // ebp
  int v9; // edi
  bool v10; // zf
  CWnd *DlgItem; // eax
  CWnd *v12; // eax
  CWnd *v13; // eax
  CWnd *v14; // eax
  CWnd *v15; // eax
  CWnd *v16; // eax
  LPCSTR v17; // eax
  const CHAR *v19; // [esp-8h] [ebp-28h]
  const CHAR *v20; // [esp-8h] [ebp-28h]
  LPCSTR v21; // [esp+8h] [ebp-18h] BYREF
  LPCSTR lpString; // [esp+Ch] [ebp-14h] BYREF
  int v23; // [esp+10h] [ebp-10h] BYREF
  int v24; // [esp+1Ch] [ebp-4h]

  v2 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
  v3 = (LPCSTR)*((_DWORD *)this + 33);
  switch ( (unsigned int)v3 )
  {
    case 0u:
      LOBYTE(v3) = (unsigned __int8)sub_406DF0(this, 1);
      break;
    case 1u:
      v4 = (const void **)sub_402C60(&v23);
      v24 = 0;
      v5 = (volatile signed __int32 **)sub_4043B0();
      sub_406860(v5 + 15, v4);
      v6 = v23 - 16;
      v24 = -1;
      if ( _InterlockedDecrement((volatile signed __int32 *)(v23 - 16 + 12)) <= 0 )
        (*(void (__stdcall **)(int))(**(_DWORD **)v6 + 4))(v6);
      sub_406250(*((_DWORD *)this + 31), (LPCSTR)1, 0, *(_DWORD *)(v2 + 1048580), 0x2000u);
      sub_406DF0(this, 2);
      v7 = sub_4043B0();
      LOBYTE(v3) = sub_4048A0((int)v7);
      if ( !(_BYTE)v3 )
        LOBYTE(v3) = (unsigned __int8)sub_407440(this, 0, 160);
      break;
    case 2u:
      v8 = *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 160);
      v9 = 0;
      sub_404670((volatile signed __int32 **)&lpString, (int)"Update");
      v24 = 1;
      sub_404670((volatile signed __int32 **)&v21, (int)"Exit");
      *((_DWORD *)this + 33) = 3;
      v10 = *(_DWORD *)(v8 + 1048584) == 1;
      LOBYTE(v24) = 2;
      if ( v10 )
        v9 = 5;
      sub_401600((volatile signed __int32 **)&lpString, "OK");
      sub_401600((volatile signed __int32 **)&v21, "Exit");
      DlgItem = CWnd::GetDlgItem(this, 1016);
      CWnd::SetFocus(DlgItem);
      CWnd::ShowWindow(*((CWnd **)this + 29), 0);
      CWnd::ShowWindow(*((CWnd **)this + 30), 0);
      CWnd::ShowWindow(*((CWnd **)this + 31), 0);
      CWnd::ShowWindow(*((CWnd **)this + 32), 5);
      v12 = CWnd::GetDlgItem(this, 1024);
      CWnd::ShowWindow(v12, v9);
      v13 = CWnd::GetDlgItem(this, 1024);
      CWnd::EnableWindow(v13, 0);
      v14 = CWnd::GetDlgItem(this, 1015);
      CWnd::EnableWindow(v14, 1);
      v15 = CWnd::GetDlgItem(this, 1001);
      CWnd::EnableWindow(v15, 1);
      v16 = CWnd::GetDlgItem(this, 1016);
      CWnd::EnableWindow(v16, 1);
      v19 = lpString;
      CWnd::GetDlgItem(this, 1015);
      sub_41BA0F(v19);
      v20 = v21;
      CWnd::GetDlgItem(this, 1016);
      sub_41BA0F(v20);
      v17 = v21 - 16;
      LOBYTE(v24) = 1;
      if ( _InterlockedDecrement((volatile signed __int32 *)v21 - 1) <= 0 )
        (*(void (__stdcall **)(LPCSTR))(**(_DWORD **)v17 + 4))(v17);
      v3 = lpString - 16;
      v24 = -1;
      if ( _InterlockedDecrement((volatile signed __int32 *)lpString - 1) <= 0 )
        LOBYTE(v3) = (*(int (__stdcall **)(LPCSTR))(**(_DWORD **)v3 + 4))(v3);
      break;
    case 3u:
      LOBYTE(v3) = (unsigned __int8)sub_406DF0(this, 0);
      break;
    default:
      return (char)v3;
  }
  return (char)v3;
}


/* ==== 4077F0  sub_4077F0  ()  size=69 ==== */
int __thiscall sub_4077F0(CDialog *this, struct tagMSG *a2)
{
  if ( a2->message == 32769 )
  {
    sub_4073E0(this);
  }
  else if ( a2->message == 32770 )
  {
    sub_407440(this, a2->lParam, a2->wParam);
    return CDialog::PreTranslateMessage(this, a2);
  }
  return CDialog::PreTranslateMessage(this, a2);
}


/* ==== 407840  j_?Unlock@CSingleLock@@QAEHXZ  (CSingleLock::Unlock(void))  size=5 ==== */
// attributes: thunk
int __thiscall CSingleLock::Unlock(CSingleLock *this)
{
  return ?Unlock@CSingleLock@@QAEHXZ(this);
}


/* ==== 407850  sub_407850  ()  size=295 ==== */
int __thiscall sub_407850(char *this, const void *a2)
{
  _DWORD *v2; // ebp
  char *v3; // edx
  char v4; // al
  char v5; // al
  char v6; // al
  char v7; // al
  int result; // eax
  _BYTE v10[56]; // [esp+Ch] [ebp-3Ch] BYREF

  qmemcpy(v10, a2, sizeof(v10));
  v2 = &unk_424DE0;
  v3 = this + 5;
  do
  {
    v4 = v10[0];
    qmemcpy(v10, &v10[1], 0x1Bu);
    v10[27] = v4;
    v5 = v10[28];
    qmemcpy(&v10[28], &v10[29], 0x1Bu);
    v10[55] = v5;
    if ( *v2 == 2 )
    {
      v6 = v10[0];
      qmemcpy(v10, &v10[1], 0x1Bu);
      v10[27] = v6;
      v7 = v10[28];
      qmemcpy(&v10[28], &v10[29], 0x1Bu);
      v10[55] = v7;
    }
    for ( result = 0; result < 48; result += 6 )
    {
      v3[result - 1] = v10[(unsigned __int8)byte_424E20[result] - 1];
      v3[result] = v10[(unsigned __int8)byte_424E21[result] - 1];
      v3[result + 1] = v10[(unsigned __int8)byte_424E22[result] - 1];
      v3[result + 2] = v10[(unsigned __int8)byte_424E23[result] - 1];
      v3[result + 3] = v10[(unsigned __int8)byte_424E24[result] - 1];
      v3[result + 4] = v10[(unsigned __int8)byte_424E25[result] - 1];
    }
    ++v2;
    v3 += 48;
  }
  while ( (int)v2 < (int)byte_424E20 );
  return result;
}


/* ==== 407980  sub_407980  ()  size=1268 ==== */
_BYTE *__thiscall sub_407980(_BYTE *this, _BYTE *a2, int a3)
{
  _BYTE *v3; // esi
  int v4; // ebp
  int v5; // edi
  int i; // eax
  int v7; // ecx
  char v8; // bl
  int v9; // ecx
  char v10; // bl
  int v11; // ecx
  char v12; // bl
  int v13; // ecx
  char v14; // bl
  int v15; // ecx
  char v16; // bl
  int v17; // ecx
  char v18; // bl
  char *v19; // edi
  int v20; // esi
  _BYTE *result; // eax
  char v22; // cl
  bool v23; // cc
  char v24; // [esp+13h] [ebp-65h]
  char v25; // [esp+13h] [ebp-65h]
  char v26; // [esp+13h] [ebp-65h]
  char v27; // [esp+13h] [ebp-65h]
  int v28; // [esp+14h] [ebp-64h]
  int v29; // [esp+18h] [ebp-60h]
  int v30; // [esp+18h] [ebp-60h]
  int v31; // [esp+1Ch] [ebp-5Ch]
  _DWORD v32[8]; // [esp+20h] [ebp-58h]
  int v33; // [esp+40h] [ebp-38h]
  unsigned __int8 v34; // [esp+44h] [ebp-34h]
  unsigned __int8 v35; // [esp+45h] [ebp-33h]
  unsigned __int8 v36; // [esp+46h] [ebp-32h]
  unsigned __int8 v37; // [esp+47h] [ebp-31h]
  _BYTE v38[44]; // [esp+48h] [ebp-30h]

  v3 = this;
  v4 = 15;
  v5 = a3;
  v32[0] = this;
  v28 = 0;
  v31 = 15;
  do
  {
    for ( i = 0; i < 48; *((_BYTE *)&v33 + i + 3) = v18 )
    {
      v7 = v28;
      if ( !v5 )
        v7 = v4;
      v8 = v3[48 * v7 + 4 + i] ^ a2[(unsigned __int8)byte_424E50[i] + 31];
      v9 = v28;
      *(&v34 + i) = v8;
      if ( !v5 )
        v9 = v4;
      v10 = v3[48 * v9 + 5 + i] ^ a2[(unsigned __int8)byte_424E51[i] + 31];
      v11 = v28;
      *(&v35 + i) = v10;
      if ( !v5 )
        v11 = v4;
      v12 = v3[48 * v11 + 6 + i] ^ a2[(unsigned __int8)byte_424E52[i] + 31];
      v13 = v28;
      *(&v36 + i) = v12;
      if ( !v5 )
        v13 = v4;
      v14 = v3[48 * v13 + 7 + i] ^ a2[(unsigned __int8)byte_424E53[i] + 31];
      v15 = v28;
      v38[i - 1] = v14;
      if ( !v5 )
        v15 = v4;
      v16 = v3[48 * v15 + 8 + i] ^ a2[(unsigned __int8)byte_424E54[i] + 31];
      v17 = v28;
      v38[i] = v16;
      if ( !v5 )
        v17 = v4;
      v18 = v3[48 * v17 + 9 + i] ^ a2[(unsigned __int8)byte_424E55[i] + 31];
      i += 6;
    }
    v32[1] = *(int *)((char *)&dword_424E80
                    + ((v38[0] + 2) | (32 * v34 + 2) | (16 * v38[1] + 2) | (8 * v35 + 2) | (4 * v36 + 2) | (2 * v37 + 2)));
    v32[2] = *(int *)((char *)&dword_424F80
                    + ((v38[6] + 2)
                     | (32 * v38[2] + 2)
                     | (16 * v38[7] + 2)
                     | (8 * v38[3] + 2)
                     | (4 * v38[4] + 2)
                     | (2 * v38[5] + 2)));
    v32[3] = *(int *)((char *)&dword_425080
                    + ((v38[12] + 2)
                     | (32 * v38[8] + 2)
                     | (16 * v38[13] + 2)
                     | (8 * v38[9] + 2)
                     | (4 * v38[10] + 2)
                     | (2 * v38[11] + 2)));
    v32[4] = *(int *)((char *)&dword_425180
                    + ((v38[18] + 2)
                     | (32 * v38[14] + 2)
                     | (16 * v38[19] + 2)
                     | (8 * v38[15] + 2)
                     | (4 * v38[16] + 2)
                     | (2 * v38[17] + 2)));
    v32[5] = *(int *)((char *)&dword_425280
                    + ((v38[24] + 2)
                     | (32 * v38[20] + 2)
                     | (16 * v38[25] + 2)
                     | (8 * v38[21] + 2)
                     | (4 * v38[22] + 2)
                     | (2 * v38[23] + 2)));
    v32[6] = *(int *)((char *)&dword_425380
                    + ((v38[30] + 2)
                     | (32 * v38[26] + 2)
                     | (16 * v38[31] + 2)
                     | (8 * v38[27] + 2)
                     | (4 * v38[28] + 2)
                     | (2 * v38[29] + 2)));
    v32[7] = *(int *)((char *)&dword_425480
                    + ((v38[36] + 2)
                     | (32 * v38[32] + 2)
                     | (16 * v38[37] + 2)
                     | (8 * v38[33] + 2)
                     | (4 * v38[34] + 2)
                     | (2 * v38[35] + 2)));
    v19 = (char *)(&unk_425681 - (_UNKNOWN *)a2);
    v20 = &unk_425680 - (_UNKNOWN *)a2;
    v33 = *(int *)((char *)&dword_425580
                 + ((v38[42] + 2)
                  | (32 * v38[38] + 2)
                  | (16 * v38[43] + 2)
                  | (8 * v38[39] + 2)
                  | (4 * v38[40] + 2)
                  | (2 * v38[41] + 2)));
    result = a2;
    if ( v4 <= 0 )
    {
      v30 = 8;
      do
      {
        *result ^= *((_BYTE *)v32 + (unsigned __int8)result[v20] + 3);
        result[1] ^= *((_BYTE *)v32 + (unsigned __int8)v19[(_DWORD)result] + 3);
        result[2] ^= *((_BYTE *)v32 + (unsigned __int8)result[&unk_425682 - (_UNKNOWN *)a2] + 3);
        result[3] ^= *((_BYTE *)v32 + (unsigned __int8)result[byte_425683 - a2] + 3);
        result += 4;
        --v30;
      }
      while ( v30 );
    }
    else
    {
      v29 = 8;
      do
      {
        v24 = result[32];
        v22 = *result ^ *((_BYTE *)v32 + (unsigned __int8)result[v20] + 3);
        result += 4;
        result[28] = v22;
        *(result - 4) = v24;
        v25 = result[29];
        result[29] = *(result - 3) ^ *((_BYTE *)v32 + (unsigned __int8)result[(_DWORD)v19 - 4] + 3);
        *(result - 3) = v25;
        v26 = result[30];
        result[30] = *(result - 2) ^ *((_BYTE *)v32 + (unsigned __int8)result[&unk_425682 - (_UNKNOWN *)a2 - 4] + 3);
        *(result - 2) = v26;
        v27 = result[31];
        result[31] = *(result - 1) ^ *((_BYTE *)v32 + (unsigned __int8)result[byte_425683 - a2 - 4] + 3);
        *(result - 1) = v27;
        --v29;
      }
      while ( v29 );
    }
    v5 = a3;
    v3 = (_BYTE *)v32[0];
    v4 = v31 - 1;
    v23 = v31 - 1 <= -1;
    ++v28;
    --v31;
  }
  while ( !v23 );
  return result;
}


/* ==== 407E80  sub_407E80  ()  size=1073 ==== */
_BYTE *__thiscall sub_407E80(char *this, _BYTE *a2, _BYTE *a3, const void *a4)
{
  _BYTE *v4; // edi
  int v5; // eax
  char v7; // cl
  char v8; // dl
  char v9; // cl
  char v10; // dl
  char v11; // cl
  char v12; // dl
  int v13; // eax
  char v14; // dl
  char v15; // cl
  char v16; // dl
  char v17; // cl
  char v18; // dl
  char v19; // cl
  char v20; // dl
  int v21; // eax
  char v22; // cl
  char v23; // dl
  char v24; // cl
  char v25; // dl
  char v26; // cl
  char v27; // dl
  int v28; // eax
  char v29; // dl
  char v30; // cl
  char v31; // dl
  char v32; // cl
  char v33; // dl
  char v34; // cl
  char v35; // dl
  int v36; // eax
  char v37; // cl
  char v38; // dl
  char v39; // cl
  char v40; // dl
  char v41; // cl
  char v42; // dl
  int v43; // eax
  char v44; // dl
  char v45; // cl
  char v46; // dl
  char v47; // cl
  char v48; // dl
  char v49; // cl
  char v50; // dl
  int v51; // eax
  char v52; // cl
  char v53; // dl
  char v54; // cl
  char v55; // dl
  char v56; // cl
  char v57; // dl
  int v58; // eax
  char v59; // dl
  char v60; // cl
  char v61; // dl
  char v62; // cl
  char v63; // dl
  char v64; // cl

  v4 = a2;
  v5 = (char)*a2;
  if ( *a2 )
    v4 = a2 + 1;
  v7 = a3[1];
  *a3 ^= ((char)*a2 >> 7) & 1;
  v8 = a3[2];
  a3[1] = (v5 >> 6) & 1 ^ v7;
  v9 = a3[3];
  a3[2] = (v5 >> 5) & 1 ^ v8;
  v10 = a3[4];
  a3[3] = (v5 >> 4) & 1 ^ v9;
  v11 = a3[5];
  a3[4] = (v5 >> 3) & 1 ^ v10;
  v12 = a3[6];
  a3[5] = (v5 >> 2) & 1 ^ v11;
  a3[6] = (v5 >> 1) & 1 ^ v12;
  a3[7] ^= v5 & 1;
  v13 = (char)*v4;
  if ( *v4 )
    ++v4;
  v14 = a3[9];
  a3[8] ^= (v13 >> 7) & 1;
  v15 = a3[10];
  a3[9] = (v13 >> 6) & 1 ^ v14;
  v16 = a3[11];
  a3[10] = (v13 >> 5) & 1 ^ v15;
  v17 = a3[12];
  a3[11] = (v13 >> 4) & 1 ^ v16;
  v18 = a3[13];
  a3[12] = (v13 >> 3) & 1 ^ v17;
  v19 = a3[14];
  a3[13] = (v13 >> 2) & 1 ^ v18;
  v20 = v13 & 1 ^ a3[15];
  a3[14] = (v13 >> 1) & 1 ^ v19;
  a3[15] = v20;
  v21 = (char)*v4;
  if ( *v4 )
    ++v4;
  v22 = a3[17];
  a3[16] ^= (v21 >> 7) & 1;
  v23 = a3[18];
  a3[17] = (v21 >> 6) & 1 ^ v22;
  v24 = a3[19];
  a3[18] = (v21 >> 5) & 1 ^ v23;
  v25 = a3[20];
  a3[19] = (v21 >> 4) & 1 ^ v24;
  v26 = a3[21];
  a3[20] = (v21 >> 3) & 1 ^ v25;
  v27 = a3[22];
  a3[21] = (v21 >> 2) & 1 ^ v26;
  a3[22] = (v21 >> 1) & 1 ^ v27;
  a3[23] ^= v21 & 1;
  v28 = (char)*v4;
  if ( *v4 )
    ++v4;
  v29 = a3[25];
  a3[24] ^= (v28 >> 7) & 1;
  v30 = a3[26];
  a3[25] = (v28 >> 6) & 1 ^ v29;
  v31 = a3[27];
  a3[26] = (v28 >> 5) & 1 ^ v30;
  v32 = a3[28];
  a3[27] = (v28 >> 4) & 1 ^ v31;
  v33 = a3[29];
  a3[28] = (v28 >> 3) & 1 ^ v32;
  v34 = a3[30];
  a3[29] = (v28 >> 2) & 1 ^ v33;
  v35 = v28 & 1 ^ a3[31];
  a3[30] = (v28 >> 1) & 1 ^ v34;
  a3[31] = v35;
  v36 = (char)*v4;
  if ( *v4 )
    ++v4;
  v37 = a3[33];
  a3[32] ^= (v36 >> 7) & 1;
  v38 = a3[34];
  a3[33] = (v36 >> 6) & 1 ^ v37;
  v39 = a3[35];
  a3[34] = (v36 >> 5) & 1 ^ v38;
  v40 = a3[36];
  a3[35] = (v36 >> 4) & 1 ^ v39;
  v41 = a3[37];
  a3[36] = (v36 >> 3) & 1 ^ v40;
  v42 = a3[38];
  a3[37] = (v36 >> 2) & 1 ^ v41;
  a3[38] = (v36 >> 1) & 1 ^ v42;
  a3[39] ^= v36 & 1;
  v43 = (char)*v4;
  if ( *v4 )
    ++v4;
  v44 = a3[41];
  a3[40] ^= (v43 >> 7) & 1;
  v45 = a3[42];
  a3[41] = (v43 >> 6) & 1 ^ v44;
  v46 = a3[43];
  a3[42] = (v43 >> 5) & 1 ^ v45;
  v47 = a3[44];
  a3[43] = (v43 >> 4) & 1 ^ v46;
  v48 = a3[45];
  a3[44] = (v43 >> 3) & 1 ^ v47;
  v49 = a3[46];
  a3[45] = (v43 >> 2) & 1 ^ v48;
  v50 = v43 & 1 ^ a3[47];
  a3[46] = (v43 >> 1) & 1 ^ v49;
  a3[47] = v50;
  v51 = (char)*v4;
  if ( *v4 )
    ++v4;
  v52 = a3[49];
  a3[48] ^= (v51 >> 7) & 1;
  v53 = a3[50];
  a3[49] = (v51 >> 6) & 1 ^ v52;
  v54 = a3[51];
  a3[50] = (v51 >> 5) & 1 ^ v53;
  v55 = a3[52];
  a3[51] = (v51 >> 4) & 1 ^ v54;
  v56 = a3[53];
  a3[52] = (v51 >> 3) & 1 ^ v55;
  v57 = a3[54];
  a3[53] = (v51 >> 2) & 1 ^ v56;
  a3[54] = (v51 >> 1) & 1 ^ v57;
  a3[55] ^= v51 & 1;
  v58 = (char)*v4;
  if ( *v4 )
    ++v4;
  v59 = a3[57];
  a3[56] ^= (v58 >> 7) & 1;
  v60 = a3[58];
  a3[57] = (v58 >> 6) & 1 ^ v59;
  v61 = a3[59];
  a3[58] = (v58 >> 5) & 1 ^ v60;
  v62 = a3[60];
  a3[59] = (v58 >> 4) & 1 ^ v61;
  v63 = a3[61];
  a3[60] = (v58 >> 3) & 1 ^ v62;
  v64 = a3[62];
  a3[61] = (v58 >> 2) & 1 ^ v63;
  a3[62] = (v58 >> 1) & 1 ^ v64;
  a3[63] ^= v58 & 1;
  sub_407850(this, a4);
  sub_407980(this, a3, 1);
  return v4;
}


/* ==== 4082C0  sub_4082C0  ()  size=138 ==== */
int __thiscall sub_4082C0(char *this, _BYTE *a2)
{
  _BYTE *v3; // eax
  _BYTE *v4; // eax
  _BYTE *v5; // eax
  _BYTE v7[64]; // [esp+8h] [ebp-44h] BYREF

  memset(v7, 0, sizeof(v7));
  v3 = sub_407E80(this, a2, v7, &unk_42C114);
  v4 = sub_407E80(this, v3, v7, &unk_42C14C);
  v5 = sub_407E80(this, v4, v7, &unk_42C184);
  sub_407E80(this, v5, v7, &unk_42C1BC);
  return sub_407850(this, v7);
}


/* ==== 408350  sub_408350  ()  size=362 ==== */
int __thiscall sub_408350(_BYTE *this, char *a2, int a3, int a4, int a5, _DWORD *a6)
{
  int v6; // edx
  int v8; // ebp
  int v9; // esi
  unsigned int i; // ecx
  char v11; // al
  _BYTE *v12; // eax
  int v14; // [esp+10h] [ebp-54h]
  _BYTE v16[64]; // [esp+20h] [ebp-44h] BYREF

  v6 = a3;
  v8 = 0;
  memset(v16, 0, sizeof(v16));
  if ( a3 <= 0 )
  {
LABEL_13:
    *a6 = v8;
    return 0;
  }
  else
  {
    while ( 1 )
    {
      v9 = v6;
      if ( v6 >= 8 )
        v9 = 8;
      v14 = v6 - v9;
      for ( i = 0; i < 0x40; i += 8 )
      {
        v11 = *a2;
        v16[i] = (unsigned __int8)*a2 >> 7;
        v16[i + 1] = (v11 & 0x40) != 0;
        v16[i + 2] = (v11 & 0x20) != 0;
        v16[i + 3] = (v11 & 0x10) != 0;
        v16[i + 4] = (v11 & 8) != 0;
        v16[i + 5] = (v11 & 4) != 0;
        v16[i + 6] = (v11 & 2) != 0;
        v16[i + 7] = v11 & 1;
        ++a2;
      }
      sub_407980(this, v16, 0);
      if ( v9 )
        break;
LABEL_12:
      if ( v14 <= 0 )
        goto LABEL_13;
      v6 = v14;
    }
    v12 = &v16[1];
    while ( 1 )
    {
      --v9;
      if ( v8 >= a5 )
        return -101;
      *(_BYTE *)(a4 + v8++) = v12[6]
                            | (2
                             * (v12[5]
                              | (2
                               * (v12[4]
                                | (2 * (v12[3] | (2 * (v12[2] | (2 * (v12[1] | (2 * (*v12 | (2 * *(v12 - 1))))))))))))));
      v12 += 8;
      if ( !v9 )
        goto LABEL_12;
    }
  }
}


/* ==== 4084C0  sub_4084C0  ()  size=46 ==== */
BOOL __thiscall sub_4084C0(HANDLE *this)
{
  BOOL result; // eax

  PurgeComm(this[1], 0xFu);
  EscapeCommFunction(this[1], 6u);
  result = CloseHandle(this[1]);
  this[1] = (HANDLE)-1;
  return result;
}


/* ==== 4084F0  sub_4084F0  ()  size=127 ==== */
HLOCAL __thiscall sub_4084F0(volatile signed __int32 **this)
{
  DWORD LastError; // eax
  volatile signed __int32 **v3; // ecx
  CHAR Buffer[4]; // [esp+4h] [ebp-4h] BYREF

  *(_DWORD *)Buffer = 0;
  LastError = GetLastError();
  this[4] = (volatile signed __int32 *)LastError;
  FormatMessageA(0x1100u, 0, LastError, 0x400u, Buffer, 0, 0);
  v3 = this + 5;
  if ( *(_DWORD *)Buffer )
    sub_401520(v3, *(const void **)Buffer, strlen(*(const char **)Buffer));
  else
    sub_401520(v3, 0, 0);
  return LocalFree(*(HLOCAL *)Buffer);
}


/* ==== 408570  sub_408570  ()  size=328 ==== */
char __thiscall sub_408570(int this, signed int a2, __int16 a3, __int16 a4, __int16 a5)
{
  _DCB DCB; // [esp+4h] [ebp-1Ch] BYREF

  memset(&DCB, 0, sizeof(DCB));
  GetCommState(*(HANDLE *)(this + 4), &DCB);
  DCB.DCBlength = 28;
  if ( a2 > 9600 )
  {
    if ( a2 > 38400 )
    {
      if ( a2 == 57600 || a2 == 115200 )
        goto LABEL_19;
    }
    else if ( a2 == 38400 || a2 == 14400 || a2 == 19200 )
    {
      goto LABEL_19;
    }
  }
  else
  {
    if ( a2 == 9600 )
      goto LABEL_19;
    if ( a2 <= 1200 )
    {
      if ( a2 != 1200 && a2 != 110 && a2 != 300 && a2 != 600 )
        goto LABEL_20;
LABEL_19:
      DCB.BaudRate = a2;
      goto LABEL_20;
    }
    if ( a2 == 2400 || a2 == 4800 )
      goto LABEL_19;
  }
LABEL_20:
  *((_DWORD *)&DCB + 2) |= 1u;
  if ( a3 )
  {
    if ( a3 == 1 )
    {
      *((_DWORD *)&DCB + 2) |= 2u;
      DCB.Parity = 1;
    }
    else if ( a3 == 2 )
    {
      *((_DWORD *)&DCB + 2) |= 2u;
      DCB.Parity = 2;
    }
  }
  else
  {
    DCB.Parity = 0;
  }
  if ( a4 >= 7 && a4 <= 8 )
    DCB.ByteSize = a4;
  if ( a5 )
  {
    if ( a5 == 1 )
    {
      DCB.StopBits = 1;
    }
    else if ( a5 == 2 )
    {
      DCB.StopBits = 2;
    }
  }
  else
  {
    DCB.StopBits = 0;
  }
  if ( SetCommState(*(HANDLE *)(this + 4), &DCB) )
    return 1;
  sub_4084F0((volatile signed __int32 **)this);
  CloseHandle(*(HANDLE *)(this + 4));
  return 0;
}


/* ==== 4086C0  sub_4086C0  ()  size=190 ==== */
DWORD __thiscall sub_4086C0(int this, LPVOID lpBuffer, DWORD nNumberOfBytesToRead)
{
  DWORD v4; // esi
  DWORD NumberOfBytesRead; // [esp+4h] [ebp-20h] BYREF
  DWORD Errors; // [esp+8h] [ebp-1Ch] BYREF
  _BYTE v8[12]; // [esp+Ch] [ebp-18h] BYREF
  int v9; // [esp+20h] [ebp-4h]

  Errors = 0;
  NumberOfBytesRead = 0;
  CSingleLock::CSingleLock((CSingleLock *)v8, (struct CSyncObject *)(this + 8), 0);
  v9 = 0;
  CSingleLock::Lock((CSingleLock *)v8, 0xFFFFFFFF);
  ClearCommError(*(HANDLE *)(this + 4), &Errors, 0);
  if ( !ReadFile(*(HANDLE *)(this + 4), lpBuffer, nNumberOfBytesToRead, &NumberOfBytesRead, 0) )
  {
    sub_4084F0((volatile signed __int32 **)this);
    NumberOfBytesRead = -1;
  }
  CSingleLock::Unlock((CSingleLock *)v8);
  v4 = NumberOfBytesRead;
  v9 = -1;
  CSingleLock::Unlock((CSingleLock *)v8);
  return v4;
}


/* ==== 408780  sub_408780  ()  size=173 ==== */
DWORD __thiscall sub_408780(int this, LPCVOID lpBuffer, DWORD nNumberOfBytesToWrite)
{
  DWORD v4; // edi
  DWORD NumberOfBytesWritten; // [esp+8h] [ebp-20h] BYREF
  DWORD Errors; // [esp+Ch] [ebp-1Ch] BYREF
  _BYTE v8[12]; // [esp+10h] [ebp-18h] BYREF
  int v9; // [esp+24h] [ebp-4h]

  v4 = 0;
  Errors = 0;
  NumberOfBytesWritten = 0;
  CSingleLock::CSingleLock((CSingleLock *)v8, (struct CSyncObject *)(this + 8), 0);
  v9 = 0;
  CSingleLock::Lock((CSingleLock *)v8, 0xFFFFFFFF);
  if ( WriteFile(*(HANDLE *)(this + 4), lpBuffer, nNumberOfBytesToWrite, &NumberOfBytesWritten, 0) )
  {
    ClearCommError(*(HANDLE *)(this + 4), &Errors, 0);
    v4 = NumberOfBytesWritten;
  }
  else
  {
    sub_4084F0((volatile signed __int32 **)this);
  }
  CSingleLock::Unlock((CSingleLock *)v8);
  v9 = -1;
  CSingleLock::Unlock((CSingleLock *)v8);
  return v4;
}


/* ==== 408830  sub_408830  ()  size=37 ==== */
DWORD __thiscall sub_408830(void *this)
{
  DWORD result; // eax
  char Buffer; // [esp+7h] [ebp-1h] BYREF

  Buffer = 0;
  do
    result = sub_4086C0((int)this, &Buffer, 1u);
  while ( result );
  return result;
}


/* ==== 408860  sub_408860  ()  size=461 ==== */
bool __thiscall sub_408860(int this, char *Str, int a3, __int16 a4, __int16 a5, __int16 a6)
{
  char *v7; // eax
  HANDLE FileA; // eax
  void *v10; // [esp-8h] [ebp-38h]
  _COMMTIMEOUTS CommTimeouts; // [esp+8h] [ebp-28h] BYREF
  char Buffer[4]; // [esp+1Ch] [ebp-14h] BYREF
  int v13; // [esp+20h] [ebp-10h]
  int v14; // [esp+24h] [ebp-Ch]
  __int16 v15; // [esp+28h] [ebp-8h]
  char v16; // [esp+2Ah] [ebp-6h]

  *(_DWORD *)Buffer = 0;
  v13 = 0;
  v14 = 0;
  v15 = 0;
  v16 = 0;
  v7 = strstr(Str, "COM");
  if ( j__atol(v7 + 3) >= 10 )
    sprintf(Buffer, "\\\\.\\%s", Str);
  else
    strcpy(Buffer, Str);
  FileA = CreateFileA(Buffer, 0xC0000000, 0, 0, 3u, 0x80u, 0);
  *(_DWORD *)(this + 4) = FileA;
  if ( FileA == (HANDLE)-1 )
  {
    sub_4084F0((volatile signed __int32 **)this);
    return 0;
  }
  else if ( SetCommMask(FileA, 0) && SetupComm(*(HANDLE *)(this + 4), 0x7D0u, 0x7D0u) )
  {
    PurgeComm(*(HANDLE *)(this + 4), 0xFu);
    CommTimeouts.WriteTotalTimeoutMultiplier = 0;
    CommTimeouts.ReadIntervalTimeout = 50;
    CommTimeouts.ReadTotalTimeoutConstant = 50;
    CommTimeouts.ReadTotalTimeoutMultiplier = 50;
    CommTimeouts.WriteTotalTimeoutConstant = 50;
    v10 = *(void **)(this + 4);
    CommTimeouts.WriteTotalTimeoutMultiplier = 500;
    if ( SetCommTimeouts(v10, &CommTimeouts) )
    {
      return sub_408570(this, a3, a4, a5, a6) != 0;
    }
    else
    {
      sub_4084F0((volatile signed __int32 **)this);
      CloseHandle(*(HANDLE *)(this + 4));
      return 0;
    }
  }
  else
  {
    sub_4084F0((volatile signed __int32 **)this);
    CloseHandle(*(HANDLE *)(this + 4));
    return 0;
  }
}


/* ==== 408A2D  sub_408A2D  ()  size=93 ==== */
BOOL __stdcall sub_408A2D(LPBYTE lpData)
{
  BOOL v1; // esi
  DWORD cbData; // [esp+4h] [ebp-8h] BYREF
  HKEY phkResult; // [esp+8h] [ebp-4h] BYREF

  if ( RegOpenKeyExA(
         HKEY_CLASSES_ROOT,
         "CLSID\\{ADB880A6-D8FF-11CF-9377-00AA003B7A11}\\InprocServer32",
         0,
         0x20019u,
         &phkResult) )
  {
    return 0;
  }
  cbData = 260;
  v1 = RegQueryValueExA(phkResult, ValueName, 0, 0, lpData, &cbData) == 0;
  RegCloseKey(phkResult);
  return v1;
}


/* ==== 408A8A  sub_408A8A  ()  size=153 ==== */
int __stdcall sub_408A8A(int a1, int a2, int a3, int a4)
{
  HMODULE LibraryA; // ecx
  FARPROC ProcAddress; // eax
  CHAR LibFileName[260]; // [esp+4h] [ebp-104h] BYREF

  LibraryA = hModule;
  if ( hModule || dword_42E150 )
    goto LABEL_13;
  if ( sub_408A2D((LPBYTE)LibFileName) )
    hModule = LoadLibraryA(LibFileName);
  LibraryA = hModule;
  if ( hModule || (LibraryA = LoadLibraryA("hhctrl.ocx"), (hModule = LibraryA) != 0) )
  {
LABEL_13:
    ProcAddress = (FARPROC)dword_42E148;
    if ( dword_42E148 )
      return ((int (__stdcall *)(int, int, int, int))ProcAddress)(a1, a2, a3, a4);
    ProcAddress = GetProcAddress(LibraryA, (LPCSTR)0xE);
    dword_42E148 = (int)ProcAddress;
    if ( ProcAddress )
      return ((int (__stdcall *)(int, int, int, int))ProcAddress)(a1, a2, a3, a4);
  }
  dword_42E150 = 1;
  return 0;
}


/* ==== 408B23  ??0COleException@@QAE@XZ  (COleException::COleException(void))  size=22 ==== */
COleException *__thiscall COleException::COleException(COleException *this)
{
  CException::CException(this);
  *((_DWORD *)this + 2) = 0;
  *(_DWORD *)this = &COleException::`vftable';
  return this;
}


/* ==== 408B39  sub_408B39  ()  size=28 ==== */
void *__thiscall sub_408B39(void *Block, char a2)
{
  sub_408B55();
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408B55  sub_408B55  ()  size=7 ==== */
void __thiscall sub_408B55(_DWORD *this)
{
  *this = &COleException::`vftable';
}


/* ==== 408B5C  ?Append@?$CSimpleStringT@D$0A@@ATL@@QAEXPBDH@Z  (ATL::CSimpleStringT<char,0>::Append(char const *,int))  size=76 ==== */
int __thiscall ATL::CSimpleStringT<char,0>::Append(int *this, char *a2, size_t Size)
{
  unsigned int v4; // edi
  char *v5; // esi
  int v6; // eax
  char *v7; // esi

  v4 = *(_DWORD *)(*this - 12);
  v5 = &a2[-*this];
  v6 = sub_4014A0(this, v4 + Size);
  if ( (unsigned int)v5 > v4 )
    v7 = a2;
  else
    v7 = &v5[v6];
  memcpy_0((void *)(v4 + v6), v7, Size);
  return ATL::CSimpleStringT<char,0>::SetLength(this, v4 + Size);
}


/* ==== 408BA8  sub_408BA8  ()  size=7 ==== */
void __thiscall sub_408BA8(_DWORD *this)
{
  *this = &CMemoryException::`vftable';
}


/* ==== 408BAF  sub_408BAF  ()  size=7 ==== */
void __thiscall sub_408BAF(_DWORD *this)
{
  *this = &CNotSupportedException::`vftable';
}


/* ==== 408BB6  sub_408BB6  ()  size=7 ==== */
void __thiscall sub_408BB6(_DWORD *this)
{
  *this = &CInvalidArgException::`vftable';
}


/* ==== 408BBD  ??0CSimpleException@@QAE@H@Z  (CSimpleException::CSimpleException(int))  size=24 ==== */
CSimpleException *__thiscall CSimpleException::CSimpleException(CSimpleException *this, int a2)
{
  CSimpleException *v2; // edx

  CException::CException(this, a2);
  *((_DWORD *)v2 + 3) = 0;
  *((_DWORD *)v2 + 4) = 0;
  return v2;
}


/* ==== 408BD5  sub_408BD5  ()  size=28 ==== */
_DWORD *__thiscall sub_408BD5(_DWORD *Block, char a2)
{
  sub_408BA8(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408BF1  sub_408BF1  ()  size=34 ==== */
CSimpleException *__thiscall sub_408BF1(CSimpleException *this, int a2, int a3)
{
  CSimpleException::CSimpleException(this, a2);
  *((_DWORD *)this + 37) = a3;
  *(_DWORD *)this = &CMemoryException::`vftable';
  return this;
}


/* ==== 408C13  sub_408C13  ()  size=28 ==== */
_DWORD *__thiscall sub_408C13(_DWORD *Block, char a2)
{
  sub_408BAF(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408C2F  sub_408C2F  ()  size=34 ==== */
CSimpleException *__thiscall sub_408C2F(CSimpleException *this, int a2, int a3)
{
  CSimpleException::CSimpleException(this, a2);
  *((_DWORD *)this + 37) = a3;
  *(_DWORD *)this = &CNotSupportedException::`vftable';
  return this;
}


/* ==== 408C51  sub_408C51  ()  size=28 ==== */
_DWORD *__thiscall sub_408C51(_DWORD *Block, char a2)
{
  sub_408BB6(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408C6D  sub_408C6D  ()  size=34 ==== */
CSimpleException *__thiscall sub_408C6D(CSimpleException *this, int a2, int a3)
{
  CSimpleException::CSimpleException(this, a2);
  *((_DWORD *)this + 37) = a3;
  *(_DWORD *)this = &CInvalidArgException::`vftable';
  return this;
}


/* ==== 408C8F  ??_9@$BBEM@AE  ([thunk]: `vcall'{332,{flat}})  size=8 ==== */
int __thiscall  __thiscall `vcall'{332,{flat}}(void *this)
{
  return (*(int (__thiscall **)(void *))(*(_DWORD *)this + 332))(this);
}


/* ==== 408C9F  ?AfxGetMainWnd@@YGPAVCWnd@@XZ  (AfxGetMainWnd(void))  size=19 ==== */
struct CWnd *__stdcall AfxGetMainWnd()
{
  struct CWinThread *Thread; // eax

  Thread = AfxGetThread();
  if ( Thread )
    return (struct CWnd *)(*(int (__thiscall **)(struct CWinThread *))(*(_DWORD *)Thread + 116))(Thread);
  else
    return 0;
}


/* ==== 408CB2  ??3CObject@@SGXPAX0@Z  (CObject::operator delete(void *,void *))  size=13 ==== */
void __stdcall CObject::operator delete(void *Block, void *a2)
{
  j__free(Block);
}


/* ==== 408CBF  sub_408CBF  ()  size=34 ==== */
CSimpleException *__thiscall sub_408CBF(CSimpleException *this, int a2, int a3)
{
  CSimpleException::CSimpleException(this, a2);
  *((_DWORD *)this + 37) = a3;
  *(_DWORD *)this = &CResourceException::`vftable';
  return this;
}


/* ==== 408CE1  sub_408CE1  ()  size=7 ==== */
void __thiscall sub_408CE1(_DWORD *this)
{
  *this = &CResourceException::`vftable';
}


/* ==== 408CE8  sub_408CE8  ()  size=34 ==== */
CSimpleException *__thiscall sub_408CE8(CSimpleException *this, int a2, int a3)
{
  CSimpleException::CSimpleException(this, a2);
  *((_DWORD *)this + 37) = a3;
  *(_DWORD *)this = &CUserException::`vftable';
  return this;
}


/* ==== 408D0A  sub_408D0A  ()  size=7 ==== */
void __thiscall sub_408D0A(_DWORD *this)
{
  *this = &CUserException::`vftable';
}


/* ==== 408D11  sub_408D11  ()  size=20 ==== */
BOOL __thiscall sub_408D11(HDC *this, int x, int y)
{
  return PtVisible(this[1], x, y);
}


/* ==== 408D25  sub_408D25  ()  size=16 ==== */
BOOL __thiscall sub_408D25(HDC *this, RECT *lprect)
{
  return RectVisible(this[1], lprect);
}


/* ==== 408D35  sub_408D35  ()  size=28 ==== */
BOOL __thiscall sub_408D35(HDC *this, int x, int y, LPCSTR lpString, int c)
{
  return TextOutA(this[1], x, y, lpString, c);
}


/* ==== 408D51  ?ExtTextOutA@CDC@@UAEHHHIPBUtagRECT@@PBDIPAH@Z  (CDC::ExtTextOutA(int,int,uint,tagRECT const *,char const *,uint,int *))  size=37 ==== */
BOOL __thiscall CDC::ExtTextOutA(
        HDC *this,
        int x,
        int y,
        UINT options,
        RECT *lprect,
        LPCSTR lpString,
        UINT c,
        int *lpDx)
{
  return ExtTextOutA(this[1], x, y, options, lprect, lpString, c, lpDx);
}


/* ==== 408D76  ?TabbedTextOutA@CDC@@UAE?AVCSize@@HHPBDHHPAHH@Z  (CDC::TabbedTextOutA(int,int,char const *,int,int,int *,int))  size=56 ==== */
_DWORD *__thiscall CDC::TabbedTextOutA(
        HDC *this,
        _DWORD *a2,
        int x,
        int y,
        const CHAR *lpString,
        int chCount,
        int nTabPositions,
        INT *lpnTabStopPositions,
        int nTabOrigin)
{
  LONG v9; // eax

  v9 = TabbedTextOutA(this[1], x, y, lpString, chCount, nTabPositions, lpnTabStopPositions, nTabOrigin);
  a2[1] = SHIWORD(v9);
  *a2 = (__int16)v9;
  return a2;
}


/* ==== 408DAE  sub_408DAE  ()  size=28 ==== */
int __thiscall sub_408DAE(HDC *this, LPCSTR lpchText, int cchText, LPRECT lprc, UINT format)
{
  return DrawTextA(this[1], lpchText, cchText, lprc, format);
}


/* ==== 408DCA  ?DrawTextExA@CDC@@UAEHPADHPAUtagRECT@@IPAUtagDRAWTEXTPARAMS@@@Z  (CDC::DrawTextExA(char *,int,tagRECT *,uint,tagDRAWTEXTPARAMS *))  size=31 ==== */
int __thiscall CDC::DrawTextExA(
        HDC *this,
        LPSTR lpchText,
        int cchText,
        LPRECT lprc,
        UINT format,
        struct tagDRAWTEXTPARAMS *lpdtp)
{
  return DrawTextExA(this[1], lpchText, cchText, lprc, format, lpdtp);
}


/* ==== 408DE9  ?GrayStringA@CDC@@UAEHPAVCBrush@@P6GHPAUHDC__@@JH@ZJHHHHH@Z  (CDC::GrayStringA(CBrush *,int (*)(HDC__ *,long,int),long,int,int,int,int,int))  size=48 ==== */
BOOL __thiscall CDC::GrayStringA(
        HDC *this,
        HBRUSH hBrush,
        GRAYSTRINGPROC lpOutputFunc,
        LPARAM lpData,
        int nCount,
        int X,
        int Y,
        int nWidth,
        int nHeight)
{
  HBRUSH v9; // eax

  v9 = hBrush;
  if ( hBrush )
    v9 = (HBRUSH)*((_DWORD *)hBrush + 1);
  return GrayStringA(this[1], v9, lpOutputFunc, lpData, nCount, X, Y, nWidth, nHeight);
}


/* ==== 408E19  sub_408E19  ()  size=28 ==== */
int __thiscall sub_408E19(HDC *this, int iEscape, int cjIn, LPCSTR pvIn, LPVOID pvOut)
{
  return Escape(this[1], iEscape, cjIn, pvIn, pvOut);
}


/* ==== 408E35  sub_408E35  ()  size=28 ==== */
_DWORD *__thiscall sub_408E35(_DWORD *Block, char a2)
{
  sub_408CE1(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408E51  sub_408E51  ()  size=28 ==== */
_DWORD *__thiscall sub_408E51(_DWORD *Block, char a2)
{
  sub_408D0A(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 408E6D  sub_408E6D  ()  size=81 ==== */
BOOL sub_408E6D()
{
  struct _OSVERSIONINFOA VersionInformation; // [esp+4h] [ebp-98h] BYREF

  memset(&VersionInformation.dwMajorVersion, 0, 0x90u);
  VersionInformation.dwOSVersionInfoSize = 148;
  GetVersionExA(&VersionInformation);
  return VersionInformation.dwPlatformId == 2;
}


/* ==== 408EBE  _InitMultipleMonitorStubs  ()  size=250 ==== */
BOOL InitMultipleMonitorStubs()
{
  BOOL result; // eax
  HMODULE ModuleHandleA; // eax
  HMODULE v2; // edi

  if ( dword_42FC9C )
    return GetMonitorInfoA != 0;
  dword_42FCA0 = sub_408E6D();
  ModuleHandleA = GetModuleHandleA("USER32");
  v2 = ModuleHandleA;
  if ( ModuleHandleA
    && (GetSystemMetrics_0 = (int (__stdcall *)(int))GetProcAddress(ModuleHandleA, "GetSystemMetrics")) != 0
    && (MonitorFromWindow = (HMONITOR (__stdcall *)(HWND, DWORD))GetProcAddress(v2, "MonitorFromWindow")) != 0
    && (MonitorFromRect = (HMONITOR (__stdcall *)(LPCRECT, DWORD))GetProcAddress(v2, "MonitorFromRect")) != 0
    && (MonitorFromPoint = (HMONITOR (__stdcall *)(POINT, DWORD))GetProcAddress(v2, "MonitorFromPoint")) != 0
    && (EnumDisplayMonitors = (BOOL (__stdcall *)(HDC, LPCRECT, MONITORENUMPROC, LPARAM))GetProcAddress(
                                                                                           v2,
                                                                                           "EnumDisplayMonitors")) != 0
    && (GetMonitorInfoA = (BOOL (__stdcall *)(HMONITOR, LPMONITORINFO))GetProcAddress(v2, "GetMonitorInfoA")) != 0
    && (EnumDisplayDevicesA = (BOOL (__stdcall *)(LPCSTR, DWORD, PDISPLAY_DEVICEA, DWORD))GetProcAddress(
                                                                                            v2,
                                                                                            "EnumDisplayDevicesA")) != 0 )
  {
    result = 1;
    dword_42FC9C = 1;
  }
  else
  {
    GetSystemMetrics_0 = 0;
    MonitorFromWindow = 0;
    MonitorFromRect = 0;
    MonitorFromPoint = 0;
    GetMonitorInfoA = 0;
    EnumDisplayMonitors = 0;
    EnumDisplayDevicesA = 0;
    dword_42FC9C = 1;
    return 0;
  }
  return result;
}


/* ==== 408FB8  _xMonitorFromRect@8  (xMonitorFromRect(x,x))  size=76 ==== */
HMONITOR __stdcall xMonitorFromRect(LPCRECT a1, DWORD a2)
{
  if ( InitMultipleMonitorStubs() )
    return MonitorFromRect(a1, a2);
  if ( (a2 & 3) != 0
    || a1->right > 0 && a1->bottom > 0 && a1->left < GetSystemMetrics(0) && a1->top < GetSystemMetrics(1) )
  {
    return (HMONITOR)305397826;
  }
  return 0;
}


/* ==== 409004  _xMonitorFromWindow@8  (xMonitorFromWindow(x,x))  size=107 ==== */
HMONITOR __stdcall xMonitorFromWindow(HWND hWnd, DWORD a2)
{
  BOOL WindowPlacement; // eax
  WINDOWPLACEMENT wndpl; // [esp+0h] [ebp-2Ch] BYREF

  if ( InitMultipleMonitorStubs() )
    return MonitorFromWindow(hWnd, a2);
  if ( (a2 & 3) != 0 )
    return (HMONITOR)305397826;
  if ( IsIconic(hWnd) )
    WindowPlacement = GetWindowPlacement(hWnd, &wndpl);
  else
    WindowPlacement = GetWindowRect(hWnd, &wndpl.rcNormalPosition);
  if ( WindowPlacement )
    return xMonitorFromRect(&wndpl.rcNormalPosition, a2);
  else
    return 0;
}


/* ==== 40906F  _xGetMonitorInfo@8  (xGetMonitorInfo(x,x))  size=149 ==== */
BOOL __stdcall xGetMonitorInfo(HMONITOR a1, LPMONITORINFO a2)
{
  LONG SystemMetrics; // eax
  bool v4; // cf
  RECT pvParam; // [esp+0h] [ebp-10h] BYREF

  if ( InitMultipleMonitorStubs() )
    return GetMonitorInfoA(a1, a2);
  if ( a1 != (HMONITOR)305397826 || !a2 || a2->cbSize < 0x28 || !SystemParametersInfoA(0x30u, 0, &pvParam, 0) )
    return 0;
  a2->rcMonitor.left = 0;
  a2->rcMonitor.top = 0;
  a2->rcMonitor.right = GetSystemMetrics(0);
  SystemMetrics = GetSystemMetrics(1);
  a2->rcWork = pvParam;
  v4 = a2->cbSize < 0x48;
  a2->rcMonitor.bottom = SystemMetrics;
  a2->dwFlags = 1;
  if ( !v4 )
    lstrcpynA((LPSTR)&a2[1], "DISPLAY", 32);
  return 1;
}


/* ==== 409104  ?AtlIAccessibleInvokeHelper@ATL@@YGJPAUIAccessible@@JABU_GUID@@KGPAUtagDISPPARAMS@@PAUtagVARIANT@@PAUtagEXCEPINFO@@PAI@Z  (ATL::AtlIAccessibleInvokeHelper(IAccessible *,long,_GUID const &,ulong,ushort,tagDISPPARAMS *,tagVARIANT *,tagEXCEPINFO *,uint *))  size=1435 ==== */
HRESULT __stdcall ATL::AtlIAccessibleInvokeHelper(
        struct IAccessible *a1,
        int a2,
        const struct _GUID *a3,
        unsigned int a4,
        int lVal,
        DISPID *a6,
        struct tagVARIANT *a7,
        struct tagEXCEPINFO *a8,
        unsigned int *a9)
{
  int v10; // edx
  DISPID *v12; // edi
  VARIANTARG *v13; // ecx
  VARIANTARG *v14; // eax
  DISPID v15; // esi
  int v16; // eax
  int v17; // ecx
  int *v18; // edx
  HRESULT v19; // esi
  int v20; // ecx
  int v21; // eax
  VARIANTARG *p_pvarg; // eax
  VARIANTARG *v23; // eax
  VARIANTARG *v24; // eax
  int v25; // edi
  VARIANTARG **v26; // esi
  VARIANTARG **v27; // eax
  VARTYPE vt; // cx
  VARIANTARG *v29; // eax
  int v30; // eax
  VARIANTARG *v31; // eax
  int v32; // eax
  VARIANTARG *v33; // esi
  VARTYPE v34; // ax
  LONG p_lVal; // eax
  int v36; // eax
  VARIANTARG *v37; // eax
  bool v38; // zf
  VARIANTARG *v39; // eax
  int v40; // eax
  _BYTE v41[4]; // [esp+8h] [ebp-48h] BYREF
  VARIANTARG *pvarSrc; // [esp+Ch] [ebp-44h] BYREF
  VARIANTARG *v43; // [esp+10h] [ebp-40h]
  _DWORD *v44; // [esp+1Ch] [ebp-34h]
  __int16 v45; // [esp+20h] [ebp-30h] BYREF
  VARIANTARG v46; // [esp+30h] [ebp-20h]
  VARIANTARG pvarg; // [esp+40h] [ebp-10h] BYREF
  struct IAccessible *v48; // [esp+58h] [ebp+8h]

  v10 = 0;
  v45 = 0;
  if ( !a1 )
    return -2147024809;
  v12 = a6;
  if ( !a6 )
    return -2147352568;
  v13 = (VARIANTARG *)a6[2];
  if ( (unsigned int)v13 > 5 )
    return -2147352562;
  v48 = 0;
  if ( a6[3] )
  {
    a6 = (DISPID *)a6[1];
    do
    {
      v14 = (VARIANTARG *)*a6;
      if ( *a6 >= (unsigned int)v13 )
        return -2147352562;
      v15 = *v12;
      ++a6;
      v48 = (struct IAccessible *)((char *)v48 + 1);
      *(&pvarSrc + (_DWORD)v14) = (VARIANTARG *)(v10 + v15);
      v10 += 16;
    }
    while ( (unsigned int)v48 < v12[3] );
  }
  if ( v48 < (struct IAccessible *)v13 )
  {
    v16 = *v12 + 16 * (_DWORD)v48;
    v17 = (char *)v13 - (char *)v48;
    v18 = (int *)&v41[4 * v17];
    do
    {
      *v18 = v16;
      v16 += 16;
      --v18;
      --v17;
    }
    while ( v17 );
  }
  v19 = -2147352573;
  if ( !a9 )
    a9 = (unsigned int *)&lVal;
  if ( !a7 )
    a7 = (struct tagVARIANT *)&v45;
  VariantInit(&pvarg);
  LOBYTE(v20) = lVal;
  switch ( a2 )
  {
    case -5018:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG))a1->lpVtbl->accDoDefaultAction)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi);
      goto LABEL_22;
    case -5017:
      if ( v12[2] != 2 )
        goto LABEL_20;
      p_pvarg = pvarSrc;
      if ( pvarSrc->vt == 3 )
        goto LABEL_28;
      v19 = VariantChangeType(&pvarg, pvarSrc, 0, 3u);
      if ( v19 < 0 )
        goto LABEL_26;
      p_pvarg = &pvarg;
LABEL_28:
      lVal = p_pvarg->lVal;
      v23 = v43;
      if ( v43->vt == 3 )
        goto LABEL_32;
      v19 = VariantChangeType(&pvarg, v43, 0, 3u);
      if ( v19 < 0 )
        goto LABEL_30;
      v23 = &pvarg;
LABEL_32:
      v21 = a1->lpVtbl->accHitTest(a1, lVal, v23->lVal, a7);
      goto LABEL_22;
    case -5016:
      if ( v12[2] != 2 )
        goto LABEL_20;
      v24 = pvarSrc;
      if ( pvarSrc->vt == 3 )
        goto LABEL_37;
      v19 = VariantChangeType(&pvarg, pvarSrc, 0, 3u);
      if ( v19 < 0 )
        goto LABEL_26;
      v24 = &pvarg;
LABEL_37:
      v21 = ((int (__stdcall *)(struct IAccessible *, LONG, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))a1->lpVtbl->accNavigate)(
              a1,
              v24->lVal,
              *(_DWORD *)&v43->vt,
              v43->decVal.Hi32,
              v43->lVal,
              v43->cyVal.Hi,
              a7);
      goto LABEL_22;
    case -5015:
      if ( v12[2] != 5 )
        goto LABEL_20;
      v25 = 0;
      while ( 1 )
      {
        v26 = &pvarSrc + v25;
        v27 = (VARIANTARG **)*v26;
        vt = (*v26)->vt;
        if ( (vt & 0x4000) == 0 || (vt & 0xF) == 0 )
          break;
        if ( (vt & 0xC) != 0 )
        {
          VariantClear(v27[2]);
          v29 = *v26;
          *(*v26)->bstrVal = 3;
          v30 = v29->lVal + 8;
        }
        else
        {
          v30 = (int)v27[2];
        }
        *((_DWORD *)&v46.vt + v25++) = v30;
        if ( v25 >= 4 )
          goto LABEL_48;
      }
      *a9 = v25;
LABEL_48:
      v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, _DWORD, _DWORD, _DWORD, _DWORD))a1->lpVtbl->accLocation)(
              a1,
              *(_DWORD *)&v46.vt,
              v46.decVal.Hi32,
              v46.lVal,
              v46.cyVal.Hi,
              *v44,
              v44[1],
              v44[2],
              v44[3]);
      goto LABEL_22;
    case -5014:
      if ( v12[2] != 2 )
        goto LABEL_20;
      v31 = pvarSrc;
      if ( pvarSrc->vt == 3 )
        goto LABEL_53;
      v19 = VariantChangeType(&pvarg, pvarSrc, 0, 3u);
      if ( v19 < 0 )
        goto LABEL_26;
      v31 = &pvarg;
LABEL_53:
      v21 = ((int (__stdcall *)(struct IAccessible *, LONG, _DWORD, ULONG, LONG, LONG))a1->lpVtbl->accSelect)(
              a1,
              v31->lVal,
              *(_DWORD *)&v43->vt,
              v43->decVal.Hi32,
              v43->lVal,
              v43->cyVal.Hi);
      goto LABEL_22;
    case -5013:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accDefaultAction)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              &a7->decVal.Lo32);
      goto LABEL_56;
    case -5012:
      v21 = ((int (__fastcall *)(int, int, struct IAccessible *, struct tagVARIANT *))a1->lpVtbl->get_accSelection)(
              v20,
              2,
              a1,
              a7);
      goto LABEL_22;
    case -5011:
      v21 = ((int (__fastcall *)(int, int, struct IAccessible *, struct tagVARIANT *))a1->lpVtbl->get_accFocus)(
              v20,
              2,
              a1,
              a7);
      goto LABEL_22;
    case -5010:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accKeyboardShortcut)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              &a7->decVal.Lo32);
      goto LABEL_56;
    case -5009:
      if ( v12[2] != 2 )
        goto LABEL_20;
      v33 = pvarSrc;
      v34 = pvarSrc->vt;
      if ( (pvarSrc->vt & 0x4000) == 0 || (v34 & 0xC) != 0 )
      {
        if ( v34 == 16396 )
        {
          VariantClear(pvarSrc->pvarVal);
          *v33->bstrVal = 8;
          p_lVal = v33->lVal + 8;
        }
        else if ( v34 == 16392 )
        {
          p_lVal = pvarSrc->lVal;
        }
        else
        {
          VariantClear(pvarSrc);
          p_lVal = (LONG)&v33->lVal;
          v33->vt = 8;
        }
        v36 = ((int (__stdcall *)(struct IAccessible *, LONG, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accHelpTopic)(
                a1,
                p_lVal,
                *(_DWORD *)&v43->vt,
                v43->decVal.Hi32,
                v43->lVal,
                v43->cyVal.Hi,
                &a7->decVal.Lo32);
LABEL_72:
        v19 = v36;
        if ( v36 >= 0 )
          a7->vt = 3;
      }
      else
      {
        v19 = -2147352571;
LABEL_26:
        *a9 = 0;
      }
      goto LABEL_106;
    case -5008:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accHelp)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              &a7->decVal.Lo32);
      goto LABEL_56;
    case -5007:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))a1->lpVtbl->get_accState)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              a7);
      goto LABEL_22;
    case -5006:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))a1->lpVtbl->get_accRole)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              a7);
      goto LABEL_22;
    case -5005:
      if ( v12[2] != 1 )
        goto LABEL_20;
      v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accDescription)(
              a1,
              *(_DWORD *)&pvarSrc->vt,
              pvarSrc->decVal.Hi32,
              pvarSrc->lVal,
              pvarSrc->cyVal.Hi,
              &a7->decVal.Lo32);
      goto LABEL_56;
    case -5004:
      if ( (lVal & 2) != 0 )
      {
        if ( v12[2] == 1 )
        {
          v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accValue)(
                  a1,
                  *(_DWORD *)&pvarSrc->vt,
                  pvarSrc->decVal.Hi32,
                  pvarSrc->lVal,
                  pvarSrc->cyVal.Hi,
                  &a7->decVal.Lo32);
          goto LABEL_56;
        }
        goto LABEL_20;
      }
      if ( (lVal & 4) == 0 )
      {
LABEL_91:
        if ( (lVal & 2) != 0 )
        {
          if ( v12[2] == 1 )
          {
            v32 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accName)(
                    a1,
                    *(_DWORD *)&pvarSrc->vt,
                    pvarSrc->decVal.Hi32,
                    pvarSrc->lVal,
                    pvarSrc->cyVal.Hi,
                    &a7->decVal.Lo32);
LABEL_56:
            v19 = v32;
            if ( v32 >= 0 )
              a7->vt = 8;
            goto LABEL_106;
          }
LABEL_20:
          v19 = -2147352562;
          goto LABEL_106;
        }
        if ( (lVal & 4) == 0 )
        {
LABEL_100:
          if ( v12[2] == 1 )
          {
            v40 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, ULONG *))a1->lpVtbl->get_accChild)(
                    a1,
                    *(_DWORD *)&pvarSrc->vt,
                    pvarSrc->decVal.Hi32,
                    pvarSrc->lVal,
                    pvarSrc->cyVal.Hi,
                    &a7->decVal.Lo32);
LABEL_104:
            v19 = v40;
            if ( v40 >= 0 )
              a7->vt = 9;
            goto LABEL_106;
          }
          goto LABEL_20;
        }
        if ( v12[2] != 2 )
          goto LABEL_20;
        v39 = v43;
        v38 = v43->vt == 8;
        v46 = *pvarSrc;
        if ( !v38 )
        {
          v19 = VariantChangeType(&pvarg, v43, 0, 3u);
          if ( v19 < 0 )
            goto LABEL_30;
          v39 = &pvarg;
        }
        v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, LONG))a1->lpVtbl->put_accName)(
                a1,
                *(_DWORD *)&v46.vt,
                v46.decVal.Hi32,
                v46.lVal,
                v46.cyVal.Hi,
                v39->lVal);
        goto LABEL_22;
      }
      if ( v12[2] != 2 )
        goto LABEL_20;
      v37 = v43;
      v38 = v43->vt == 8;
      v46 = *pvarSrc;
      if ( v38 )
        goto LABEL_90;
      v19 = VariantChangeType(&pvarg, v43, 0, 3u);
      if ( v19 >= 0 )
      {
        v37 = &pvarg;
LABEL_90:
        v21 = ((int (__stdcall *)(struct IAccessible *, _DWORD, ULONG, LONG, LONG, LONG))a1->lpVtbl->put_accValue)(
                a1,
                *(_DWORD *)&v46.vt,
                v46.decVal.Hi32,
                v46.lVal,
                v46.cyVal.Hi,
                v37->lVal);
LABEL_22:
        v19 = v21;
        goto LABEL_106;
      }
LABEL_30:
      *a9 = 1;
LABEL_106:
      VariantClear(&pvarg);
      return v19;
    case -5003:
      goto LABEL_91;
    case -5002:
      goto LABEL_100;
    case -5001:
      v36 = a1->lpVtbl->get_accChildCount(a1, (int *)&a7->decVal.Lo32);
      goto LABEL_72;
    case -5000:
      v40 = a1->lpVtbl->get_accParent(a1, (IDispatch **)&a7->decVal.Lo32);
      goto LABEL_104;
    default:
      goto LABEL_106;
  }
}


/* ==== 4096EC  ?AtlIAccessibleGetIDsOfNamesHelper@ATL@@YGJABU_GUID@@PAPA_WIKPAJ@Z  (ATL::AtlIAccessibleGetIDsOfNamesHelper(_GUID const &,wchar_t * *,uint,ulong,long *))  size=96 ==== */
int __stdcall ATL::AtlIAccessibleGetIDsOfNamesHelper(
        const struct _GUID *a1,
        wchar_t **a2,
        unsigned int a3,
        unsigned int a4,
        int *a5)
{
  int v5; // ebx
  unsigned int i; // esi
  char v8; // [esp+Fh] [ebp-1h]

  v5 = 0;
  if ( !a3 )
    return 0;
  while ( 1 )
  {
    v8 = 0;
    for ( i = 0; i < 19; ++i )
    {
      if ( !lstrcmpW(a2[v5], off_42C618[i]) )
      {
        v8 = 1;
        a5[v5] = dword_42C5C8[i];
      }
    }
    if ( !v8 )
      break;
    if ( ++v5 >= a3 )
      return 0;
  }
  return -2147352570;
}


/* ==== 40974C  ?GetSubMenu@CMenu@@QBEPAV1@H@Z  (CMenu::GetSubMenu(int))  size=22 ==== */
struct CMenu *__thiscall CMenu::GetSubMenu(HMENU *this, int nPos)
{
  HMENU SubMenu; // eax

  SubMenu = GetSubMenu(this[1], nPos);
  return CMenu::FromHandle(SubMenu);
}


/* ==== 40976F  ?ReleaseBuffer@?$CSimpleStringT@D$0A@@ATL@@QAEXH@Z  (ATL::CSimpleStringT<char,0>::ReleaseBuffer(int))  size=37 ==== */
int __thiscall ATL::CSimpleStringT<char,0>::ReleaseBuffer(const char **this, const char *a2)
{
  const char *v2; // eax

  v2 = a2;
  if ( a2 == (const char *)-1 )
  {
    v2 = *this;
    if ( *this )
      v2 = (const char *)strlen(*this);
  }
  return ATL::CSimpleStringT<char,0>::SetLength(this, (int)v2);
}


/* ==== 409794  sub_409794  ()  size=5 ==== */
int __stdcall sub_409794(int a1, int a2)
{
  return 0;
}


/* ==== 409799  sub_409799  ()  size=8 ==== */
int __stdcall sub_409799(int a1, int a2)
{
  return -2147467263;
}


/* ==== 4097A1  ?FinalRelease@CAccessibleProxy@ATL@@QAEJXZ  (ATL::CAccessibleProxy::FinalRelease(void))  size=21 ==== */
int __thiscall ATL::CAccessibleProxy::FinalRelease(ATL::CAccessibleProxy *this)
{
  if ( *((_DWORD *)this + 3) )
    return (*(int (__stdcall **)(_DWORD, _DWORD))(**((_DWORD **)this + 3) + 12))(*((_DWORD *)this + 3), 0);
  else
    return 0;
}


/* ==== 4097B6  ?AtlInternalQueryInterface@ATL@@YGJPAXPBU_ATL_INTMAP_ENTRY@1@ABU_GUID@@PAPAX@Z  (ATL::AtlInternalQueryInterface(void *,ATL::_ATL_INTMAP_ENTRY const *,_GUID const &,void * *))  size=206 ==== */
int __stdcall ATL::AtlInternalQueryInterface(
        char *a1,
        const struct ATL::_ATL_INTMAP_ENTRY *a2,
        const struct _GUID *a3,
        void **a4)
{
  const struct ATL::_ATL_INTMAP_ENTRY *v4; // esi
  int result; // eax
  int (__stdcall *v6)(char *, const struct _GUID *, void **, _DWORD); // ecx
  _DWORD *v7; // eax
  char *v8; // esi
  BOOL v9; // [esp+18h] [ebp+Ch]

  if ( !a1 )
    return -2147024809;
  v4 = a2;
  if ( !a2 )
    return -2147024809;
  if ( !a4 )
    return -2147467261;
  *a4 = 0;
  if ( !a3->Data1 && !*(_DWORD *)&a3->Data2 && *(_DWORD *)a3->Data4 == 192 && *(_DWORD *)&a3->Data4[4] == 1174405120 )
  {
LABEL_21:
    v8 = &a1[*((_DWORD *)v4 + 1)];
    (*(void (__stdcall **)(char *))(*(_DWORD *)v8 + 4))(v8);
    *a4 = v8;
    return 0;
  }
  else
  {
    v6 = (int (__stdcall *)(char *, const struct _GUID *, void **, _DWORD))*((_DWORD *)a2 + 2);
    if ( v6 )
    {
      while ( 1 )
      {
        v7 = *(_DWORD **)v4;
        v9 = *(_DWORD *)v4 == 0;
        if ( !*(_DWORD *)v4
          || *v7 == a3->Data1
          && v7[1] == *(_DWORD *)&a3->Data2
          && v7[2] == *(_DWORD *)a3->Data4
          && v7[3] == *(_DWORD *)&a3->Data4[4] )
        {
          if ( v6 == (int (__stdcall *)(char *, const struct _GUID *, void **, _DWORD))1 )
            goto LABEL_21;
          result = v6(a1, a3, a4, *((_DWORD *)v4 + 1));
          if ( !result || !v9 && result < 0 )
            break;
        }
        v6 = (int (__stdcall *)(char *, const struct _GUID *, void **, _DWORD))*((_DWORD *)v4 + 5);
        v4 = (const struct ATL::_ATL_INTMAP_ENTRY *)((char *)v4 + 12);
        if ( !v6 )
          return -2147467262;
      }
    }
    else
    {
      return -2147467262;
    }
  }
  return result;
}


/* ==== 409884  ?GetOwner@CWnd@@QBEPAV1@XZ  (CWnd::GetOwner(void))  size=23 ==== */
struct CWnd *__thiscall CWnd::GetOwner(CWnd *this)
{
  HWND Parent; // eax

  Parent = (HWND)*((_DWORD *)this + 13);
  if ( !Parent )
    Parent = GetParent(*((HWND *)this + 7));
  return CWnd::FromHandle(Parent);
}


/* ==== 40989B  sub_40989B  ()  size=33 ==== */
int __thiscall sub_40989B(int *this, int a2)
{
  int v3; // edi

  v3 = sub_4014A0(this, a2);
  ATL::CSimpleStringT<char,0>::SetLength(this, a2);
  return v3;
}


/* ==== 4098BC  unknown_libname_4  ()  size=24 ==== */
// MFC 3.1-14.0 32bit
BOOL __cdecl unknown_libname_4(void *Buf1, void *Buf2)
{
  return memcmp(Buf1, Buf2, 0x10u) == 0;
}


/* ==== 4098D4  sub_4098D4  ()  size=28 ==== */
BOOL __thiscall sub_4098D4(HMENU *this, UINT uPosition, UINT uFlags, UINT_PTR uIDNewItem, LPCSTR lpNewItem)
{
  return ModifyMenuA(this[1], uPosition, uFlags, uIDNewItem, lpNewItem);
}


/* ==== 4098F0  ?IsValidFILETIME@CTime@ATL@@SGHABU_FILETIME@@@Z  (ATL::CTime::IsValidFILETIME(_FILETIME const &))  size=47 ==== */
BOOL __stdcall ATL::CTime::IsValidFILETIME(FILETIME *lpFileTime)
{
  BOOL result; // eax
  struct _SYSTEMTIME SystemTime; // [esp+0h] [ebp-18h] BYREF
  struct _FILETIME LocalFileTime; // [esp+10h] [ebp-8h] BYREF

  result = FileTimeToLocalFileTime(lpFileTime, &LocalFileTime);
  if ( result )
    return FileTimeToSystemTime(&LocalFileTime, &SystemTime);
  return result;
}


/* ==== 40991F  ??0CTime@ATL@@QAE@HHHHHHH@Z  (ATL::CTime::CTime(int,int,int,int,int,int,int))  size=96 ==== */
ATL::CTime *__thiscall ATL::CTime::CTime(ATL::CTime *this, int a2, int a3, int a4, int a5, int a6, int a7, int a8)
{
  __time64_t v9; // rax
  tm Tm; // [esp+4h] [ebp-24h] BYREF

  Tm.tm_sec = a7;
  Tm.tm_min = a6;
  Tm.tm_hour = a5;
  Tm.tm_mday = a4;
  Tm.tm_mon = a3 - 1;
  Tm.tm_year = a2 - 1900;
  Tm.tm_isdst = a8;
  v9 = _mktime64(&Tm);
  *(_QWORD *)this = v9;
  if ( (HIDWORD(v9) & (unsigned int)v9) == 0xFFFFFFFF )
    sub_4010F0(-2147024809);
  return this;
}


/* ==== 40997F  ??0CTime@ATL@@QAE@ABU_SYSTEMTIME@@H@Z  (ATL::CTime::CTime(_SYSTEMTIME const &,int))  size=88 ==== */
ATL::CTime *__thiscall ATL::CTime::CTime(ATL::CTime *this, const struct _SYSTEMTIME *a2, int a3)
{
  _DWORD v5[2]; // [esp+4h] [ebp-8h] BYREF

  if ( a2->wYear >= 0x76Cu )
  {
    ATL::CTime::CTime((ATL::CTime *)v5, a2->wYear, a2->wMonth, a2->wDay, a2->wHour, a2->wMinute, a2->wSecond, a3);
    *(_DWORD *)this = v5[0];
    *((_DWORD *)this + 1) = v5[1];
  }
  else
  {
    *(_DWORD *)this = 0;
    *((_DWORD *)this + 1) = 0;
  }
  return this;
}


/* ==== 4099D7  ??0CTime@ATL@@QAE@ABU_FILETIME@@H@Z  (ATL::CTime::CTime(_FILETIME const &,int))  size=94 ==== */
ATL::CTime *__thiscall ATL::CTime::CTime(ATL::CTime *this, FILETIME *lpFileTime, int a3)
{
  struct _SYSTEMTIME SystemTime; // [esp+4h] [ebp-20h] BYREF
  struct _FILETIME LocalFileTime; // [esp+14h] [ebp-10h] BYREF
  _DWORD v7[2]; // [esp+1Ch] [ebp-8h] BYREF

  if ( !FileTimeToLocalFileTime(lpFileTime, &LocalFileTime) || !FileTimeToSystemTime(&LocalFileTime, &SystemTime) )
  {
    *(_DWORD *)this = 0;
    *((_DWORD *)this + 1) = 0;
    sub_4010F0(-2147024809);
  }
  ATL::CTime::CTime((ATL::CTime *)v7, &SystemTime, a3);
  *(_DWORD *)this = v7[0];
  *((_DWORD *)this + 1) = v7[1];
  return this;
}


/* ==== 409A35  sub_409A35  ()  size=79 ==== */
_DWORD *__thiscall sub_409A35(_DWORD *this, BOOL bInitialOwner, LPCSTR lpName, LPSECURITY_ATTRIBUTES lpMutexAttributes)
{
  HANDLE MutexA; // eax

  unknown_libname_9(lpName);
  *this = &CMutex::`vftable';
  MutexA = CreateMutexA(lpMutexAttributes, bInitialOwner, lpName);
  this[1] = MutexA;
  if ( !MutexA )
    unknown_libname_38();
  return this;
}


/* ==== 409A84  sub_409A84  ()  size=11 ==== */
int __thiscall sub_409A84(_DWORD *this)
{
  *this = &CMutex::`vftable';
  return sub_409DE1();
}


/* ==== 409A8F  sub_409A8F  ()  size=10 ==== */
BOOL __thiscall sub_409A8F(HANDLE *this)
{
  return ReleaseMutex(this[1]);
}


/* ==== 409A99  ?Lock@CSingleLock@@QAEHK@Z  (CSingleLock::Lock(ulong))  size=21 ==== */
int __thiscall CSingleLock::Lock(CSingleLock *this, unsigned int a2)
{
  int result; // eax

  result = (*(int (__thiscall **)(_DWORD, unsigned int))(**(_DWORD **)this + 12))(*(_DWORD *)this, a2);
  *((_DWORD *)this + 2) = result;
  return result;
}


/* ==== 409AAE  ?Unlock@CSingleLock@@QAEHXZ  (CSingleLock::Unlock(void))  size=34 ==== */
BOOL __thiscall CSingleLock::Unlock(CSingleLock *this)
{
  if ( *((_DWORD *)this + 2) )
    *((_DWORD *)this + 2) = (*(int (**)(void))(**(_DWORD **)this + 20))() == 0;
  return *((_DWORD *)this + 2) == 0;
}


/* ==== 409AD0  sub_409AD0  ()  size=6 ==== */
int __stdcall sub_409AD0(int a1, int a2)
{
  return 1;
}


/* ==== 409AD6  sub_409AD6  ()  size=28 ==== */
_DWORD *__thiscall sub_409AD6(_DWORD *Block, char a2)
{
  sub_409A84(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 409AF2  ??0CSingleLock@@QAE@PAVCSyncObject@@H@Z  (CSingleLock::CSingleLock(CSyncObject *,int))  size=50 ==== */
CSingleLock *__thiscall CSingleLock::CSingleLock(CSingleLock *this, struct CSyncObject *a2, int a3)
{
  int v4; // eax

  if ( !a2 )
    unknown_libname_13();
  *(_DWORD *)this = a2;
  v4 = *((_DWORD *)a2 + 1);
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 1) = v4;
  if ( a3 )
    CSingleLock::Lock(this, 0xFFFFFFFF);
  return this;
}


/* ==== 409B24  unknown_libname_5  ()  size=27 ==== */
// MFC 3.1-14.0 32bit
BOOL __thiscall unknown_libname_5(_DWORD *this, int a2, int a3)
{
  return *this == a2 && this[1] == a3;
}


/* ==== 409B3F  ??6CArchive@@QAEAAV0@G@Z  (CArchive::operator<<(ushort))  size=60 ==== */
CArchive *__thiscall CArchive::operator<<(CArchive *this, __int16 a2)
{
  if ( (*((_BYTE *)this + 24) & 1) != 0 )
    sub_41DFF7(2, *((_DWORD *)this + 5));
  if ( (unsigned int)(*((_DWORD *)this + 10) + 2) > *((_DWORD *)this + 11) )
    CArchive::Flush(this);
  **((_WORD **)this + 10) = a2;
  *((_DWORD *)this + 10) += 2;
  return this;
}


/* ==== 409B7B  unknown_libname_6  ()  size=59 ==== */
// MFC 3.1-14.0 32bit
CArchive *__thiscall unknown_libname_6(CArchive *this, int a2)
{
  if ( (*((_BYTE *)this + 24) & 1) != 0 )
    sub_41DFF7(2, *((_DWORD *)this + 5));
  if ( (unsigned int)(*((_DWORD *)this + 10) + 4) > *((_DWORD *)this + 11) )
    CArchive::Flush(this);
  **((_DWORD **)this + 10) = a2;
  *((_DWORD *)this + 10) += 4;
  return this;
}


/* ==== 409BB6  unknown_libname_7  ()  size=67 ==== */
// MFC 3.1-14.0 32bit
CArchive *__thiscall unknown_libname_7(CArchive *this, _WORD *a2)
{
  int v3; // eax
  unsigned int v4; // ecx

  if ( (*((_BYTE *)this + 24) & 1) == 0 )
    sub_41DFF7(4, *((_DWORD *)this + 5));
  v3 = *((_DWORD *)this + 10);
  v4 = *((_DWORD *)this + 11);
  if ( v3 + 2 > v4 )
    CArchive::FillBuffer(this, v3 - v4 + 2);
  *a2 = **((_WORD **)this + 10);
  *((_DWORD *)this + 10) += 2;
  return this;
}


/* ==== 409BF9  unknown_libname_8  ()  size=66 ==== */
// MFC 3.1-14.0 32bit
CArchive *__thiscall unknown_libname_8(CArchive *this, _DWORD *a2)
{
  int v3; // eax
  unsigned int v4; // ecx

  if ( (*((_BYTE *)this + 24) & 1) == 0 )
    sub_41DFF7(4, *((_DWORD *)this + 5));
  v3 = *((_DWORD *)this + 10);
  v4 = *((_DWORD *)this + 11);
  if ( v3 + 4 > v4 )
    CArchive::FillBuffer(this, v3 - v4 + 4);
  *a2 = **((_DWORD **)this + 10);
  *((_DWORD *)this + 10) += 4;
  return this;
}


/* ==== 409C3B  sub_409C3B  ()  size=77 ==== */
volatile signed __int32 **__thiscall sub_409C3B(
        volatile signed __int32 **this,
        volatile signed __int32 *a2,
        const void *a3)
{
  CException::CException((CException *)this);
  *this = (volatile signed __int32 *)&CArchiveException::`vftable';
  sub_401050(this + 3);
  this[2] = a2;
  sub_4015C0(this + 3, a3);
  return this;
}


/* ==== 409C88  sub_409C88  ()  size=28 ==== */
CArchiveException *__thiscall sub_409C88(CArchiveException *Block, char a2)
{
  CArchiveException::~CArchiveException(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 409CA4  ??1CArchiveException@@UAE@XZ  (CArchiveException::~CArchiveException(void))  size=17 ==== */
void __thiscall CArchiveException::~CArchiveException(CArchiveException *this)
{
  *(_DWORD *)this = &CArchiveException::`vftable';
  ATL::CStringData::Release((ATL::CStringData *)(*((_DWORD *)this + 3) - 16));
}


/* ==== 409CB5  ??0CComCriticalSection@ATL@@QAE@XZ  (ATL::CComCriticalSection::CComCriticalSection(void))  size=20 ==== */
ATL::CComCriticalSection *__thiscall ATL::CComCriticalSection::CComCriticalSection(ATL::CComCriticalSection *this)
{
  memset(this, 0, 0x18u);
  return this;
}


/* ==== 409CC9  ?Init@CComCriticalSection@ATL@@QAEJXZ  (ATL::CComCriticalSection::Init(void))  size=80 ==== */
int __thiscall ATL::CComCriticalSection::Init(struct _RTL_CRITICAL_SECTION *this)
{
  InitializeCriticalSection(this);
  return 0;
}


/* ==== 409D19  ??_GCHandleMap@@UAEPAXI@Z  (CHandleMap::`scalar deleting destructor'(uint))  size=28 ==== */
CHandleMap *__thiscall CHandleMap::`scalar deleting destructor'(CHandleMap *this, char a2)
{
  CHandleMap::~CHandleMap(this);
  if ( (a2 & 1) != 0 )
    j__free(this);
  return this;
}


/* ==== 409D35  ??1CHandleMap@@UAE@XZ  (CHandleMap::~CHandleMap(void))  size=84 ==== */
void __thiscall CHandleMap::~CHandleMap(CHandleMap *this)
{
  *(_DWORD *)this = &CHandleMap::`vftable';
  CHandleMap::DeleteTemp(this);
  sub_417870((char *)this + 56);
  sub_417870((char *)this + 28);
  CFixedAllocNoSync::FreeAll((CHandleMap *)((char *)this + 4));
}


/* ==== 409D89  sub_409D89  ()  size=11 ==== */
BOOL __thiscall sub_409D89(_DWORD *this)
{
  HMENU v2; // eax

  *this = &CMenu::`vftable';
  if ( !this[1] )
    return 0;
  v2 = (HMENU)sub_41D3E3();
  return DestroyMenu(v2);
}


/* ==== 409D94  sub_409D94  ()  size=28 ==== */
_DWORD *__thiscall sub_409D94(_DWORD *Block, char a2)
{
  sub_409D89(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 409DB0  ?Lock@CSyncObject@@UAEHK@Z  (CSyncObject::Lock(ulong))  size=34 ==== */
BOOL __thiscall CSyncObject::Lock(HANDLE *this, DWORD dwMilliseconds)
{
  DWORD v2; // eax

  v2 = WaitForSingleObject(this[1], dwMilliseconds);
  return !v2 || v2 == 128;
}


/* ==== 409DD2  unknown_libname_9  ()  size=15 ==== */
// MFC 3.1-14.0 32bit
_DWORD *__thiscall unknown_libname_9(_DWORD *this, int a2)
{
  _DWORD *result; // eax

  result = this;
  this[1] = 0;
  *this = &CSyncObject::`vftable';
  return result;
}


/* ==== 409DE1  sub_409DE1  ()  size=29 ==== */
void *__thiscall sub_409DE1(_DWORD *this)
{
  void *result; // eax

  result = (void *)this[1];
  *this = &CSyncObject::`vftable';
  if ( result )
  {
    result = (void *)CloseHandle(result);
    this[1] = 0;
  }
  return result;
}


/* ==== 409DFE  sub_409DFE  ()  size=28 ==== */
_DWORD *__thiscall sub_409DFE(_DWORD *Block, char a2)
{
  sub_409DE1(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 409E1A  ??0CFixedAllocNoSync@@QAE@II@Z  (CFixedAllocNoSync::CFixedAllocNoSync(uint,uint))  size=42 ==== */
CFixedAllocNoSync *__thiscall CFixedAllocNoSync::CFixedAllocNoSync(
        CFixedAllocNoSync *this,
        unsigned int a2,
        unsigned int a3)
{
  CFixedAllocNoSync *result; // eax
  unsigned int v4; // ecx
  unsigned int v5; // edx

  result = this;
  v4 = a2;
  if ( a2 < 4 )
    v4 = 4;
  v5 = a3;
  if ( a3 <= 1 )
    v5 = 64;
  *((_DWORD *)result + 3) = 0;
  *((_DWORD *)result + 2) = 0;
  *(_DWORD *)result = v4;
  *((_DWORD *)result + 1) = v5;
  return result;
}


/* ==== 409E44  ?FreeAll@CFixedAllocNoSync@@QAEXXZ  (CFixedAllocNoSync::FreeAll(void))  size=21 ==== */
void __thiscall CFixedAllocNoSync::FreeAll(CPlex **this)
{
  CPlex::FreeDataChain(this[2]);
  this[2] = 0;
  this[3] = 0;
}


/* ==== 409E59  j_?FreeAll@CFixedAllocNoSync@@QAEXXZ  (CFixedAllocNoSync::FreeAll(void))  size=5 ==== */
// attributes: thunk
void __thiscall CFixedAllocNoSync::FreeAll(CPlex **this)
{
  ?FreeAll@CFixedAllocNoSync@@QAEXXZ(this);
}


/* ==== 409E5E  ?Alloc@CFixedAllocNoSync@@QAEPAXXZ  (CFixedAllocNoSync::Alloc(void))  size=65 ==== */
_DWORD *__thiscall CFixedAllocNoSync::Alloc(CFixedAllocNoSync *this)
{
  int v2; // eax
  int v3; // ecx
  _DWORD *v4; // eax
  int v5; // ecx
  _DWORD *result; // eax

  if ( !*((_DWORD *)this + 3) )
  {
    v2 = unknown_libname_17((char *)this + 8, *((_DWORD *)this + 1), *(_DWORD *)this);
    v3 = *((_DWORD *)this + 1) - 1;
    v4 = (_DWORD *)(v3 * *(_DWORD *)this + v2 + 4);
    if ( v3 >= 0 )
    {
      v5 = *((_DWORD *)this + 1);
      do
      {
        *v4 = *((_DWORD *)this + 3);
        *((_DWORD *)this + 3) = v4;
        v4 = (_DWORD *)((char *)v4 - *(_DWORD *)this);
        --v5;
      }
      while ( v5 );
    }
  }
  result = (_DWORD *)*((_DWORD *)this + 3);
  *((_DWORD *)this + 3) = *result;
  return result;
}


/* ==== 409EA0  _memcpy  ()  size=829 ==== */
void *__cdecl memcpy(void *a1, const void *Src, size_t Size)
{
  char *v3; // esi
  char *v4; // edi
  size_t v5; // ecx
  void *result; // eax
  char *v7; // esi
  char *v8; // edi
  size_t v9; // ecx

  v3 = (char *)Src;
  v4 = (char *)a1;
  if ( a1 > Src && a1 < (char *)Src + Size )
  {
    v7 = (char *)Src + Size - 4;
    v8 = (char *)a1 + Size - 4;
    if ( ((unsigned __int8)v8 & 3) == 0 )
    {
      v9 = Size >> 2;
      if ( Size >> 2 >= 8 )
      {
        while ( v9 )
        {
          *(_DWORD *)v8 = *(_DWORD *)v7;
          v7 -= 4;
          v8 -= 4;
          --v9;
        }
        switch ( Size & 3 )
        {
          case 0u:
            goto TrailDown0;
          case 1u:
            goto TrailDown1;
          case 2u:
            goto TrailDown2;
          case 3u:
            goto TrailDown3;
        }
      }
      switch ( Size & 3 )
      {
        case 0u:
          goto TrailDown0;
        case 1u:
          goto TrailDown1;
        case 2u:
          goto TrailDown2;
        case 3u:
          goto TrailDown3;
      }
    }
    switch ( Size )
    {
      case 0u:
TrailDown0:
        result = a1;
        break;
      case 1u:
TrailDown1:
        v8[3] = v7[3];
        result = a1;
        break;
      case 2u:
TrailDown2:
        v8[3] = v7[3];
        v8[2] = v7[2];
        result = a1;
        break;
      case 3u:
TrailDown3:
        v8[3] = v7[3];
        v8[2] = v7[2];
        v8[1] = v7[1];
        result = a1;
        break;
      default:
        __asm { jmp     dword ptr ds:ByteCopyDown+4[eax*4] }
        return result;
    }
  }
  else
  {
    if ( ((unsigned __int8)a1 & 3) != 0 )
    {
      if ( Size >= 4 )
        __asm { jmp     dword ptr ds:CopyUnwindUp+4[eax*4] }
      __asm { jmp     dword ptr ds:TrailUp0[ecx*4]; jumptable 00409ED5 case 0 }
    }
    v5 = Size >> 2;
    switch ( v5 )
    {
      case 0u:
        goto UnwindUp0;
      case 1u:
        goto UnwindUp1;
      case 2u:
        goto UnwindUp2;
      case 3u:
        goto UnwindUp3;
      case 4u:
        goto UnwindUp4;
      case 5u:
        goto UnwindUp5;
      case 6u:
        goto UnwindUp6;
      case 7u:
        *((_DWORD *)a1 + v5 - 7) = *((_DWORD *)Src + v5 - 7);
UnwindUp6:
        *((_DWORD *)a1 + v5 - 6) = *((_DWORD *)Src + v5 - 6);
UnwindUp5:
        *((_DWORD *)a1 + v5 - 5) = *((_DWORD *)Src + v5 - 5);
UnwindUp4:
        *((_DWORD *)a1 + v5 - 4) = *((_DWORD *)Src + v5 - 4);
UnwindUp3:
        *((_DWORD *)a1 + v5 - 3) = *((_DWORD *)Src + v5 - 3);
UnwindUp2:
        *((_DWORD *)a1 + v5 - 2) = *((_DWORD *)Src + v5 - 2);
UnwindUp1:
        *((_DWORD *)a1 + v5 - 1) = *((_DWORD *)Src + v5 - 1);
        v3 = (char *)Src + 4 * v5;
        v4 = (char *)a1 + 4 * v5;
UnwindUp0:
        switch ( Size & 3 )
        {
          case 0u:
            goto TrailUp0;
          case 1u:
            goto TrailUp1;
          case 2u:
            goto TrailUp2;
          case 3u:
            goto TrailUp3;
        }
      default:
        qmemcpy(a1, Src, 4 * v5);
        v3 = (char *)Src + 4 * v5;
        v4 = (char *)a1 + 4 * v5;
        switch ( Size & 3 )
        {
          case 0u:
TrailUp0:
            result = a1;
            break;
          case 1u:
TrailUp1:
            *v4 = *v3;
            result = a1;
            break;
          case 2u:
TrailUp2:
            *v4 = *v3;
            v4[1] = v3[1];
            result = a1;
            break;
          case 3u:
TrailUp3:
            *v4 = *v3;
            v4[1] = v3[1];
            v4[2] = v3[2];
            result = a1;
            break;
        }
        break;
    }
  }
  return result;
}


/* ==== 40A1DD  __purecall  ()  size=18 ==== */
void __noreturn _purecall()
{
  if ( dword_4300BC )
    dword_4300BC();
  _amsg_exit(25);
}


/* ==== 40A1F1  ?_JumpToContinuation@@YGXPAXPAUEHRegistrationNode@@@Z  (_JumpToContinuation(void *,EHRegistrationNode *))  size=43 ==== */
void __stdcall _JumpToContinuation(
        void (__stdcall *a1)(void *, struct EHRegistrationNode *),
        struct EHRegistrationNode *a2)
{
  a1(a1, a2);
}


/* ==== 40A221  sub_40A221  ()  size=7 ==== */
// ?_CallMemberFunction0@@YGXPAX0@Z
// doubtful name
// positive sp value has been detected, the output may be wrong!
int __cdecl sub_40A221(int a1, int a2)
{
  __int32 v3; // [esp-8h] [ebp-8h]
  _UNKNOWN *retaddr; // [esp+0h] [ebp+0h] BYREF

  return ((int (*)(void))_InterlockedExchange((volatile __int32 *)&retaddr, v3))();
}


/* ==== 40A228  ?_UnwindNestedFrames@@YGXPAUEHRegistrationNode@@PAUEHExceptionRecord@@@Z  (_UnwindNestedFrames(EHRegistrationNode *,EHExceptionRecord *))  size=82 ==== */
void __userpurge _UnwindNestedFrames(
        struct _EXCEPTION_REGISTRATION_RECORD **a1@<ebx>,
        PVOID TargetFrame,
        PEXCEPTION_RECORD ExceptionRecord)
{
  RtlUnwind(TargetFrame, &loc_40A251, ExceptionRecord, 0);
  ExceptionRecord->ExceptionFlags &= ~2u;
  *a1 = NtCurrentTeb()->NtTib.ExceptionList;
}


/* ==== 40A27A  ___CxxFrameHandler  ()  size=54 ==== */
int __usercall __CxxFrameHandler@<eax>(
        struct _s_FuncInfo *a1@<eax>,
        struct EHExceptionRecord *a2,
        struct EHRegistrationNode *a3,
        struct _CONTEXT *a4,
        void *a5)
{
  return __InternalCxxFrameHandler(a2, a3, a4, a5, a1, 0, 0, 0);
}


/* ==== 40A2B0  ?CatchGuardHandler@@YA?AW4_EXCEPTION_DISPOSITION@@PAUEHExceptionRecord@@PAUCatchGuardRN@@PAX2@Z  (CatchGuardHandler(EHExceptionRecord *,CatchGuardRN *,void *,void *))  size=59 ==== */
int __cdecl CatchGuardHandler(struct EHExceptionRecord *a1, struct EHRegistrationNode *a2, struct _CONTEXT *a3)
{
  if ( a2->state == __security_cookie )
    return __InternalCxxFrameHandler(
             a1,
             (struct EHRegistrationNode *)a2[1].frameHandler,
             a3,
             0,
             (struct _s_FuncInfo *)a2[1].pNext,
             a2[1].state,
             a2,
             0);
  a1->ExceptionFlags |= 8u;
  return 1;
}


/* ==== 40A2EB  ?_CallSETranslator@@YAHPAUEHExceptionRecord@@PAUEHRegistrationNode@@PAX2PBU_s_FuncInfo@@H1@Z  (_CallSETranslator(EHExceptionRecord *,EHRegistrationNode *,void *,void *,_s_FuncInfo const *,int,EHRegistrationNode *))  size=199 ==== */
int __cdecl _CallSETranslator(
        struct EHExceptionRecord *a1,
        struct EHRegistrationNode *a2,
        void *a3,
        void *a4,
        const struct _s_FuncInfo *a5,
        int a6,
        struct EHRegistrationNode *a7)
{
  int v8; // eax
  int v9; // [esp+0h] [ebp-38h] BYREF
  int v10; // [esp+4h] [ebp-34h]
  _DWORD v11[2]; // [esp+8h] [ebp-30h] BYREF
  struct _EXCEPTION_REGISTRATION_RECORD *ExceptionList; // [esp+10h] [ebp-28h]
  enum _EXCEPTION_DISPOSITION (__cdecl *v13)(PEXCEPTION_RECORD, PVOID, void *, void *); // [esp+14h] [ebp-24h]
  const struct _s_FuncInfo *v14; // [esp+1Ch] [ebp-1Ch]
  struct EHRegistrationNode *v15; // [esp+20h] [ebp-18h]
  int v16; // [esp+24h] [ebp-14h]
  struct EHRegistrationNode *v17; // [esp+28h] [ebp-10h]
  int *v18; // [esp+2Ch] [ebp-Ch]
  int *v19; // [esp+30h] [ebp-8h]
  int v20; // [esp+34h] [ebp-4h]
  int savedregs; // [esp+38h] [ebp+0h] BYREF

  if ( a1 == (struct EHExceptionRecord *)291 )
  {
    a2->pNext = (EHRegistrationNode *)&loc_40A386;
    return 1;
  }
  else
  {
    v13 = TranslatorGuardHandler;
    v14 = a5;
    v15 = a2;
    v16 = a6;
    v17 = a7;
    v20 = 0;
    v18 = &v9;
    v19 = &savedregs;
    ExceptionList = NtCurrentTeb()->NtTib.ExceptionList;
    v10 = 1;
    v11[0] = a1;
    v11[1] = a3;
    v8 = _getptd(a1->ExceptionCode, v11);
    (*(void (**)(void))(v8 + 116))();
    v10 = 0;
    if ( v20 )
      ExceptionList->Next = NtCurrentTeb()->NtTib.ExceptionList->Next;
    return v10;
  }
}


/* ==== 40A3B2  ?TranslatorGuardHandler@@YA?AW4_EXCEPTION_DISPOSITION@@PAUEHExceptionRecord@@PAUTranslatorGuardRN@@PAX2@Z  (TranslatorGuardHandler(EHExceptionRecord *,TranslatorGuardRN *,void *,void *))  size=178 ==== */
int __usercall TranslatorGuardHandler@<eax>(
        struct _EXCEPTION_REGISTRATION_RECORD **a1@<ebx>,
        struct EHExceptionRecord *ExceptionRecord,
        PVOID TargetFrame,
        struct _CONTEXT *a4)
{
  int (*v5)(void); // [esp+4h] [ebp-4h] BYREF

  if ( *((_DWORD *)TargetFrame + 2) == __security_cookie )
  {
    if ( (ExceptionRecord->ExceptionFlags & 0x66) != 0 )
    {
      *((_DWORD *)TargetFrame + 9) = 1;
      return 1;
    }
    else
    {
      __InternalCxxFrameHandler(
        ExceptionRecord,
        *((struct EHRegistrationNode **)TargetFrame + 4),
        a4,
        0,
        *((struct _s_FuncInfo **)TargetFrame + 3),
        *((_DWORD *)TargetFrame + 5),
        *((struct EHRegistrationNode **)TargetFrame + 6),
        1u);
      if ( !*((_DWORD *)TargetFrame + 9) )
        _UnwindNestedFrames(a1, TargetFrame, (PEXCEPTION_RECORD)ExceptionRecord);
      _CallSETranslator((struct EHExceptionRecord *)0x123, (struct EHRegistrationNode *)&v5, 0, 0, 0, 0, 0);
      return v5();
    }
  }
  else
  {
    ExceptionRecord->ExceptionFlags |= 8u;
    return 1;
  }
}


/* ==== 40A464  ?_GetRangeOfTrysToCheck@@YAPBU_s_TryBlockMapEntry@@PBU_s_FuncInfo@@HHPAI1@Z  (_GetRangeOfTrysToCheck(_s_FuncInfo const *,int,int,uint *,uint *))  size=122 ==== */
TryBlockMapEntry *__cdecl _GetRangeOfTrysToCheck(
        const struct _s_FuncInfo *a1,
        int a2,
        int a3,
        unsigned int *a4,
        unsigned int *a5)
{
  unsigned int nTryBlocks; // esi
  TryBlockMapEntry *pTryBlockMap; // ebx
  unsigned int v8; // eax
  TryBlockMapEntry *v9; // eax
  unsigned int v10; // esi
  unsigned int v12; // [esp+Ch] [ebp-4h]
  const struct _s_FuncInfo *v13; // [esp+18h] [ebp+8h]

  nTryBlocks = a1->nTryBlocks;
  pTryBlockMap = a1->pTryBlockMap;
  v8 = nTryBlocks;
  v12 = nTryBlocks;
  v13 = (const struct _s_FuncInfo *)nTryBlocks;
  if ( a2 >= 0 )
  {
    do
    {
      if ( nTryBlocks == -1 )
        sub_40E773();
      v9 = &pTryBlockMap[--nTryBlocks];
      if ( v9->tryHigh < a3 && a3 <= v9->catchHigh || nTryBlocks == -1 )
      {
        --a2;
        v12 = (unsigned int)v13;
        v13 = (const struct _s_FuncInfo *)nTryBlocks;
      }
    }
    while ( a2 >= 0 );
    v8 = v12;
  }
  v10 = nTryBlocks + 1;
  *a4 = v10;
  *a5 = v8;
  if ( v8 > a1->nTryBlocks || v10 > v8 )
    sub_40E773();
  return &pTryBlockMap[v10];
}


/* ==== 40A573  ?_CallCatchBlock2@@YAPAXPAUEHRegistrationNode@@PBU_s_FuncInfo@@PAXHK@Z  (_CallCatchBlock2(EHRegistrationNode *,_s_FuncInfo const *,void *,int,ulong))  size=89 ==== */
void *__cdecl _CallCatchBlock2(
        struct EHRegistrationNode *a1,
        const struct _s_FuncInfo *a2,
        void *a3,
        int a4,
        unsigned int a5)
{
  return (void *)_CallSettingFrame(a3, a1, a5);
}


/* ==== 40A5CC  __global_unwind2  ()  size=32 ==== */
void __cdecl _global_unwind2(PVOID TargetFrame)
{
  RtlUnwind(TargetFrame, &gu_return, 0, 0);
}


/* ==== 40A5EC  __unwind_handler  ()  size=34 ==== */
int __cdecl _unwind_handler(int a1, int a2, int a3, _DWORD *a4)
{
  int result; // eax

  result = 1;
  if ( (*(_DWORD *)(a1 + 4) & 6) != 0 )
  {
    *a4 = a2;
    return 3;
  }
  return result;
}


/* ==== 40A60E  __local_unwind2  ()  size=104 ==== */
int __cdecl _local_unwind2(int a1, int a2)
{
  int result; // eax
  int v3; // ebx
  int v4; // esi
  int v5; // esi
  struct _EXCEPTION_REGISTRATION_RECORD *ExceptionList; // [esp-8h] [ebp-1Ch]
  int (__cdecl *v7)(int, int, int, _DWORD *); // [esp-4h] [ebp-18h]

  v7 = _unwind_handler;
  ExceptionList = NtCurrentTeb()->NtTib.ExceptionList;
  while ( 1 )
  {
    result = a1;
    v3 = *(_DWORD *)(a1 + 8);
    v4 = *(_DWORD *)(a1 + 12);
    if ( v4 == -1 || v4 == a2 )
      break;
    v5 = 3 * v4;
    *(_DWORD *)(a1 + 12) = *(_DWORD *)(v3 + 4 * v5);
    if ( !*(_DWORD *)(v3 + 4 * v5 + 4) )
    {
      _NLG_Notify(257);
      (*(void (__cdecl **)(struct _EXCEPTION_REGISTRATION_RECORD *, int (__cdecl *)(int, int, int, _DWORD *)))(v3 + 4 * v5 + 8))(
        ExceptionList,
        v7);
    }
  }
  return result;
}


/* ==== 40A676  __abnormal_termination  ()  size=35 ==== */
int __cdecl _abnormal_termination()
{
  int result; // eax
  struct _EXCEPTION_REGISTRATION_RECORD *ExceptionList; // ecx

  result = 0;
  ExceptionList = NtCurrentTeb()->NtTib.ExceptionList;
  if ( (int (__cdecl *)(int, int, int, _DWORD *))ExceptionList->Handler == _unwind_handler )
    return ExceptionList[1].Next == (struct _EXCEPTION_REGISTRATION_RECORD *)*((_DWORD *)ExceptionList[1].Handler + 3);
  return result;
}


/* ==== 40A699  __NLG_Notify1  ()  size=9 ==== */
void __stdcall _NLG_Notify1(int a1)
{
  JUMPOUT(0x40A6AC);
}


/* ==== 40A6A2  __NLG_Notify  ()  size=24 ==== */
int __userpurge _NLG_Notify@<eax>(int result@<eax>, int a2@<ebp>, int a3)
{
  unk_42CAC8 = *(_DWORD *)(a2 + 8);
  unk_42CAC4 = result;
  unk_42CACC = a2;
  return result;
}


/* ==== 40A6BA  _report_failure  ()  size=48 ==== */
void __noreturn report_failure()
{
  sub_40E852(1, 0);
}


/* ==== 40A6EB  @__security_check_cookie@4  (__security_check_cookie(x))  size=14 ==== */
void __fastcall __security_check_cookie(uintptr_t StackCookie)
{
  if ( StackCookie != __security_cookie )
    report_failure();
}


/* ==== 40A72A  __threadstartex@4  (_threadstartex(x))  size=149 ==== */
void __stdcall __noreturn _threadstartex(DWORD *lpThreadParameter)
{
  DWORD *v1; // esi
  unsigned int v2; // eax
  int v3; // [esp+0h] [ebp-28h]

  v1 = (DWORD *)dword_430148(dword_42CE5C);
  if ( v1 )
  {
    v1[19] = lpThreadParameter[19];
    v1[20] = lpThreadParameter[20];
    free(lpThreadParameter);
  }
  else
  {
    v1 = lpThreadParameter;
    if ( !dword_43014C(dword_42CE5C, lpThreadParameter) )
      _amsg_exit(16);
    *lpThreadParameter = GetCurrentThreadId();
  }
  if ( off_42CBAC )
    off_42CBAC();
  v2 = ((int (__stdcall *)(DWORD, int))v1[19])(v1[20], v3);
  _endthreadex(v2);
}


/* ==== 40A7BF  __beginthreadex  ()  size=139 ==== */
uintptr_t __cdecl _beginthreadex(
        void *Security,
        unsigned int StackSize,
        _beginthreadex_proc_type StartAddress,
        void *ArgList,
        unsigned int InitFlag,
        unsigned int *ThrdAddr)
{
  _beginthreadex_proc_type v6; // edi
  DWORD LastError; // ebx
  uintptr_t result; // eax
  _DWORD *v9; // eax
  _DWORD *v10; // esi
  void *v11; // eax
  DWORD *p_StartAddress; // eax
  bool v13; // zf

  v6 = StartAddress;
  LastError = 0;
  if ( !StartAddress )
  {
    *_errno() = 22;
    return 0;
  }
  v9 = (_DWORD *)sub_40DAAE(1, 140);
  v10 = v9;
  if ( !v9 )
    goto LABEL_8;
  _initptd(v9);
  v11 = ArgList;
  v10[1] = -1;
  v10[20] = v11;
  p_StartAddress = ThrdAddr;
  v13 = ThrdAddr == 0;
  v10[19] = v6;
  if ( v13 )
    p_StartAddress = (DWORD *)&StartAddress;
  result = (uintptr_t)CreateThread(
                        (LPSECURITY_ATTRIBUTES)Security,
                        StackSize,
                        (LPTHREAD_START_ROUTINE)_threadstartex,
                        v10,
                        InitFlag,
                        p_StartAddress);
  if ( !result )
  {
    LastError = GetLastError();
LABEL_8:
    free(v10);
    if ( LastError )
      _dosmaperr(LastError);
    return 0;
  }
  return result;
}


/* ==== 40A84A  _vsprintf  ()  size=87 ==== */
int __cdecl vsprintf(char *const Buffer, const char *const Format, va_list ArgList)
{
  int v3; // edi
  FILE File; // [esp+8h] [ebp-20h] BYREF

  File._cnt = 0x7FFFFFFF;
  File._flag = 66;
  File._base = Buffer;
  File._ptr = Buffer;
  v3 = sub_40ECA8(&File, Format, ArgList);
  if ( Buffer )
  {
    if ( --File._cnt < 0 )
      _flsbuf(0, &File);
    else
      *File._ptr = 0;
  }
  return v3;
}


/* ==== 40A8A1  sub_40A8A1  ()  size=48 ==== */
int __cdecl sub_40A8A1(int a1, int a2)
{
  _DWORD v3[8]; // [esp+0h] [ebp-20h] BYREF

  v3[2] = 0;
  v3[0] = 0;
  v3[1] = 0x7FFFFFFF;
  v3[3] = 66;
  return sub_40ECA8(v3, a1, a2);
}


/* ==== 40A8E0  __alloca_probe  ()  size=61 ==== */
void __usercall _alloca_probe(unsigned int a1@<eax>, char a2)
{
  char *v2; // ecx

  if ( a1 < 0x1000 )
    __asm { retn }
  v2 = &a2;
  do
  {
    v2 -= 4096;
    a1 -= 4096;
  }
  while ( a1 >= 0x1000 );
  __asm { retn }
}


/* ==== 40A91D  __store_str  ()  size=32 ==== */
_DWORD *__usercall _store_str@<eax>(_DWORD *result@<eax>, _BYTE *a2@<edx>, _DWORD *a3@<ecx>)
{
  for ( ; *result; --*result )
  {
    if ( !*a2 )
      break;
    *(_BYTE *)(*a3)++ = *a2++;
  }
  return result;
}


/* ==== 40A93D  __store_num  ()  size=121 ==== */
int __usercall _store_num@<eax>(int result@<eax>, unsigned int a2@<edx>, unsigned int *a3@<ecx>, int *a4@<edi>, int a5)
{
  _BYTE *v5; // esi
  int v6; // et2
  char *v7; // esi
  char v8; // cl
  unsigned int v9; // esi
  int v10; // et2
  int v11; // [esp+8h] [ebp-4h]

  v11 = 0;
  if ( a5 )
  {
    v5 = (_BYTE *)*a4;
    if ( *a3 > 1 )
    {
      do
      {
        v6 = result % 10;
        result /= 10;
        *v5++ = v6 + 48;
        --*a3;
      }
      while ( result > 0 && *a3 > 1 );
    }
    result = *a4;
    *a4 = (int)v5;
    v7 = v5 - 1;
    do
    {
      v8 = *v7;
      *v7-- = *(_BYTE *)result;
      *(_BYTE *)result++ = v8;
    }
    while ( result < (unsigned int)v7 );
  }
  else if ( a2 >= *a3 )
  {
    *a3 = 0;
  }
  else
  {
    v9 = a2 - 1;
    if ( a2 )
    {
      do
      {
        v10 = result % 10;
        result /= 10;
        ++v11;
        *(_BYTE *)(v9 + *a4) = v10 + 48;
        --v9;
      }
      while ( v9 != -1 );
    }
    result = v11;
    *a4 += v11;
    *a3 -= v11;
  }
  return result;
}


/* ==== 40A9B6  __expandtime  ()  size=614 ==== */
BOOL __usercall _expandtime@<eax>(char a1@<al>, int *a2@<ecx>, unsigned int *a3@<ebx>, int a4, int *a5, int a6, int a7)
{
  int v8; // eax
  int v9; // eax
  int v10; // eax
  int v11; // eax
  int v12; // eax
  LPSTR v13; // edx
  int v14; // eax
  int v15; // eax
  int v16; // eax
  int v17; // eax
  int v19; // eax
  int v20; // ecx
  int v21; // eax
  int v22; // eax
  int v23; // eax
  int v24; // eax
  int v25; // eax
  int v26; // eax
  int v27; // eax
  int v28; // eax
  int v29; // [esp-14h] [ebp-1Ch]
  int *v30; // [esp-10h] [ebp-18h]
  int *v31; // [esp-Ch] [ebp-14h]
  unsigned int v32; // [esp-8h] [ebp-10h]
  unsigned int *v33; // [esp-8h] [ebp-10h]
  int v34; // [esp-4h] [ebp-Ch]
  int v35; // [esp-4h] [ebp-Ch]

  if ( a1 > 90 )
  {
    if ( a1 <= 109 )
    {
      if ( a1 != 109 )
      {
        v21 = a1 - 97;
        if ( !v21 )
        {
          v13 = *(LPSTR *)(a6 + 4 * a5[6]);
          goto LABEL_66;
        }
        v22 = v21 - 1;
        if ( !v22 )
        {
          v13 = *(LPSTR *)(a6 + 4 * a5[4] + 56);
          goto LABEL_66;
        }
        v23 = v22 - 1;
        if ( v23 )
        {
          v24 = v23 - 1;
          if ( v24 )
          {
            if ( v24 != 6 )
              return 1;
            v34 = a7;
            v12 = a5[7] + 1;
            v32 = 3;
          }
          else
          {
            v34 = a7;
            v12 = a5[3];
            v32 = 2;
          }
          goto LABEL_23;
        }
        if ( !_store_winword(a4, a7 != 0, a5, a2, a3, a6) || !*a3 )
          return 0;
        *(_BYTE *)(*a2)++ = 32;
        --*a3;
        goto LABEL_24;
      }
      v12 = a5[4];
      goto LABEL_51;
    }
    v25 = a1 - 112;
    if ( !v25 )
    {
      if ( a5[2] > 11 )
        v13 = *(LPSTR *)(a6 + 156);
      else
        v13 = *(LPSTR *)(a6 + 152);
      goto LABEL_66;
    }
    v26 = v25 - 7;
    if ( !v26 )
    {
      _store_num(a5[6], 1u, a3, a2, a7);
      return 1;
    }
    v27 = v26 - 1;
    if ( !v27 )
    {
      v35 = a6;
      v33 = a3;
      v31 = a2;
      v30 = a5;
      v29 = a7 != 0;
      return _store_winword(a4, v29, v30, v31, v33, v35) != 0;
    }
    v28 = v27 - 1;
    if ( !v28 )
    {
      v34 = a7;
      v12 = a5[5] % 100;
      goto LABEL_53;
    }
    if ( v28 != 1 )
      return 1;
LABEL_59:
    __tzset();
    v13 = (&Destination)[a5[8] != 0];
    goto LABEL_66;
  }
  if ( a1 == 90 )
    goto LABEL_59;
  if ( a1 > 77 )
  {
    v14 = a1 - 83;
    if ( !v14 )
    {
      v34 = a7;
      v12 = *a5;
      v32 = 2;
      goto LABEL_23;
    }
    v15 = v14 - 2;
    if ( v15 )
    {
      v16 = v15 - 2;
      if ( v16 )
      {
        v17 = v16 - 1;
        if ( v17 )
        {
          if ( v17 != 1 )
            return 1;
          v34 = a7;
          v32 = 4;
          v12 = a5[5] % 100 + 100 * (a5[5] / 100 + 19);
LABEL_23:
          _store_num(v12, v32, a3, a2, v34);
          return 1;
        }
LABEL_24:
        v35 = a6;
        v33 = a3;
        v31 = a2;
        v30 = a5;
        v29 = 2;
        return _store_winword(a4, v29, v30, v31, v33, v35) != 0;
      }
      v19 = a5[6];
      if ( v19 )
        v20 = v19 - 1;
      else
        v20 = 6;
    }
    else
    {
      v20 = a5[6];
    }
    if ( a5[7] < v20 )
    {
      v12 = 0;
LABEL_52:
      v34 = a7;
LABEL_53:
      v32 = 2;
      goto LABEL_23;
    }
    v12 = a5[7] / 7;
    if ( a5[7] % 7 < v20 )
      goto LABEL_52;
LABEL_51:
    ++v12;
    goto LABEL_52;
  }
  if ( a1 == 77 )
  {
    v34 = a7;
    v12 = a5[1];
    v32 = 2;
    goto LABEL_23;
  }
  v8 = a1 - 37;
  if ( !v8 )
  {
    *(_BYTE *)(*a2)++ = 37;
    --*a3;
    return 1;
  }
  v9 = v8 - 28;
  if ( !v9 )
  {
    v13 = *(LPSTR *)(a6 + 4 * a5[6] + 28);
    goto LABEL_66;
  }
  v10 = v9 - 1;
  if ( !v10 )
  {
    v13 = *(LPSTR *)(a6 + 4 * a5[4] + 104);
LABEL_66:
    _store_str(a3, v13, a2);
    return 1;
  }
  v11 = v10 - 6;
  if ( !v11 )
  {
    v34 = a7;
    v12 = a5[2];
    v32 = 2;
    goto LABEL_23;
  }
  if ( v11 == 1 )
  {
    v12 = a5[2] % 12;
    if ( !v12 )
      v12 = 12;
    goto LABEL_52;
  }
  return 1;
}


/* ==== 40AC1C  __store_winword  ()  size=1162 ==== */
int __cdecl _store_winword(int a1, int a2, WORD *a3, int *a4, unsigned int *a5, _DWORD *a6)
{
  const CHAR *v6; // eax
  int (__stdcall *v7)(LCID, DWORD, const SYSTEMTIME *, LPCSTR, LPSTR, int); // eax
  WORD *v8; // ebx
  int v9; // eax
  void *v10; // esp
  CHAR *v11; // edi
  int i; // eax
  CHAR v14; // cl
  int v15; // edx
  LPCSTR v16; // eax
  LPCSTR v17; // ebx
  const CHAR *v18; // ebx
  LPCSTR v19; // eax
  LPCSTR v20; // ecx
  LPCSTR v21; // eax
  unsigned __int8 v22; // al
  int v23; // ecx
  int v24; // ecx
  int v25; // ecx
  int v26; // ecx
  unsigned __int8 *v27; // eax
  unsigned __int8 v28; // cl
  unsigned __int8 v29; // cl
  LPCSTR v30; // ecx
  _BYTE v31[12]; // [esp+0h] [ebp-54h] BYREF
  SYSTEMTIME Date; // [esp+Ch] [ebp-48h] BYREF
  _BYTE *v33; // [esp+1Ch] [ebp-38h]
  int v34; // [esp+20h] [ebp-34h]
  int (__stdcall *v35)(LCID, DWORD, const SYSTEMTIME *, LPCSTR, LPSTR, int); // [esp+24h] [ebp-30h]
  size_t Size; // [esp+28h] [ebp-2Ch]
  int v37; // [esp+2Ch] [ebp-28h]
  const CHAR *v38; // [esp+30h] [ebp-24h]
  LPCSTR lpFormat; // [esp+34h] [ebp-20h]
  char v40; // [esp+3Bh] [ebp-19h]
  CPPEH_RECORD ms_exc; // [esp+3Ch] [ebp-18h]

  if ( a2 )
  {
    if ( a2 == 1 )
      v6 = (const CHAR *)a6[41];
    else
      v6 = (const CHAR *)a6[42];
  }
  else
  {
    v6 = (const CHAR *)a6[40];
  }
  lpFormat = v6;
  if ( a6[44] == 1 )
  {
    v8 = a3;
  }
  else
  {
    v7 = GetDateFormatA;
    if ( a2 == 2 )
      v7 = GetTimeFormatA;
    v35 = v7;
    v8 = a3;
    Date.wYear = a3[10] + 1900;
    Date.wMonth = a3[8] + 1;
    Date.wDay = a3[6];
    Date.wHour = a3[4];
    Date.wMinute = a3[2];
    Date.wSecond = *a3;
    Date.wMilliseconds = 0;
    v9 = v7(a6[43], 0, &Date, lpFormat, 0, 0);
    Size = v9;
    if ( v9 )
    {
      v34 = 0;
      v10 = alloca(v9);
      ms_exc.old_esp = (DWORD)v31;
      v11 = v31;
      v33 = v31;
      ms_exc.registration.TryLevel = -1;
      if ( v31 )
      {
LABEL_13:
        v38 = v11;
        for ( i = v35(a6[43], 0, &Date, lpFormat, v11, Size) - 1; i > 0; --i )
        {
          if ( !*a5 )
            break;
          *(_BYTE *)(*a4)++ = *v38++;
          --*a5;
        }
        if ( v34 )
          free(v11);
        return 1;
      }
      v11 = (CHAR *)malloc(Size);
      if ( v11 )
      {
        v34 = 1;
        goto LABEL_13;
      }
    }
  }
  v14 = *lpFormat;
  if ( *lpFormat )
  {
    while ( 1 )
    {
      if ( !*a5 )
        return 1;
      v40 = 0;
      v15 = 0;
      v37 = 0;
      v16 = lpFormat;
      do
      {
        ++v16;
        ++v15;
      }
      while ( *v16 == v14 );
      v38 = v16;
      if ( v14 > 100 )
      {
        v23 = v14 - 104;
        if ( v23 )
        {
          v24 = v23 - 5;
          if ( v24 )
          {
            v25 = v24 - 6;
            if ( v25 )
            {
              v26 = v25 - 1;
              if ( !v26 )
              {
                if ( *((int *)v8 + 2) > 11 )
                  v27 = (unsigned __int8 *)a6[39];
                else
                  v27 = (unsigned __int8 *)a6[38];
                if ( v15 == 1 && *a5 )
                {
                  v28 = *v27;
                  if ( *(char *)(*(_DWORD *)(a1 + 72) + 2 * *v27 + 1) < 0 && *a5 > 1 )
                  {
                    if ( !*++v27 )
                      return 0;
                    *(_BYTE *)(*a4)++ = v28;
                    --*a5;
                  }
                  *(_BYTE *)(*a4)++ = *v27;
                  --*a5;
                }
                else
                {
                  while ( 1 )
                  {
                    v29 = *v27;
                    if ( !*v27 || !*a5 )
                      break;
                    if ( *(char *)(*(_DWORD *)(a1 + 72) + 2 * v29 + 1) < 0 && *a5 > 1 )
                    {
                      if ( !*++v27 )
                        return 0;
                      *(_BYTE *)(*a4)++ = v29;
                      --*a5;
                    }
                    *(_BYTE *)(*a4)++ = *v27++;
                    --*a5;
                  }
                }
LABEL_99:
                lpFormat = v38;
                goto LABEL_123;
              }
              if ( v26 == 5 )
              {
                if ( v15 == 2 )
                {
                  v40 = 121;
                }
                else if ( v15 == 4 )
                {
                  v40 = 89;
                }
              }
              goto LABEL_115;
            }
            if ( v15 == 1 )
            {
              v37 = 1;
            }
            else if ( v15 != 2 )
            {
              goto LABEL_115;
            }
            v40 = 83;
          }
          else
          {
            if ( v15 == 1 )
            {
              v37 = 1;
            }
            else if ( v15 != 2 )
            {
              goto LABEL_115;
            }
            v40 = 77;
          }
        }
        else
        {
          if ( v15 == 1 )
          {
            v37 = 1;
          }
          else if ( v15 != 2 )
          {
            goto LABEL_115;
          }
          v40 = 73;
        }
      }
      else
      {
        switch ( v14 )
        {
          case 'd':
            if ( v15 == 1 )
            {
              v37 = 1;
            }
            else if ( v15 != 2 )
            {
              if ( v15 == 3 )
              {
                v40 = 97;
              }
              else if ( v15 == 4 )
              {
                v40 = 65;
              }
              break;
            }
            v40 = 100;
            break;
          case '\'':
            lpFormat += v15;
            if ( (v15 & 1) != 0 )
            {
              v19 = lpFormat;
              while ( 1 )
              {
                v22 = *v19;
                if ( !v22 || !*a5 )
                  break;
                if ( v22 == 39 )
                {
                  ++lpFormat;
                  goto LABEL_123;
                }
                if ( *(char *)(*(_DWORD *)(a1 + 72) + 2 * v22 + 1) >= 0 || *a5 <= 1 )
                {
                  v21 = lpFormat;
                }
                else
                {
                  v20 = lpFormat + 1;
                  if ( !lpFormat[1] )
                    return 0;
                  *(_BYTE *)(*a4)++ = v22;
                  v21 = v20;
                  --*a5;
                }
                *(_BYTE *)(*a4)++ = *v21;
                v19 = v21 + 1;
                lpFormat = v19;
                --*a5;
              }
            }
            goto LABEL_123;
          case 'A':
LABEL_33:
            v17 = lpFormat;
            if ( !__ascii_stricmp(lpFormat, "am/pm") )
            {
              v18 = v17 + 5;
              goto LABEL_50;
            }
            if ( !__ascii_stricmp(v17, "a/p") )
            {
              v18 = v17 + 3;
LABEL_50:
              v38 = v18;
            }
            v40 = 112;
            break;
          case 'H':
            if ( v15 == 1 )
            {
              v37 = 1;
            }
            else if ( v15 != 2 )
            {
              break;
            }
            v40 = 72;
            break;
          case 'M':
            if ( v15 == 1 )
            {
              v37 = 1;
            }
            else if ( v15 != 2 )
            {
              if ( v15 == 3 )
              {
                v40 = 98;
              }
              else if ( v15 == 4 )
              {
                v40 = 66;
              }
              break;
            }
            v40 = 109;
            break;
          case 'a':
            goto LABEL_33;
        }
      }
LABEL_115:
      if ( v40 )
      {
        if ( !_expandtime(v40, a4, a5, a1, (int *)a3, (int)a6, v37) )
          return 0;
        goto LABEL_99;
      }
      v30 = lpFormat;
      if ( *(char *)(*(_DWORD *)(a1 + 72) + 2 * *(unsigned __int8 *)lpFormat + 1) < 0 && *a5 > 1 )
      {
        v30 = lpFormat + 1;
        if ( !lpFormat[1] )
          return 0;
        *(_BYTE *)(*a4)++ = *lpFormat;
        --*a5;
      }
      *(_BYTE *)(*a4)++ = *v30;
      lpFormat = v30 + 1;
      --*a5;
LABEL_123:
      v14 = *lpFormat;
      if ( !*lpFormat )
        return 1;
      v8 = a3;
    }
  }
  return 1;
}


/* ==== 40B0A6  sub_40B0A6  ()  size=195 ==== */
unsigned int __cdecl sub_40B0A6(
        int a1,
        unsigned __int8 *a2,
        unsigned int a3,
        unsigned __int8 *a4,
        int *a5,
        unsigned int a6)
{
  unsigned int v6; // eax
  unsigned int result; // eax
  unsigned __int8 *v8; // esi
  unsigned __int8 v9; // al
  char *v10; // esi
  int v11; // eax
  unsigned __int8 *v12; // [esp+4h] [ebp-8h]
  int v13; // [esp+8h] [ebp-4h]

  v12 = a2;
  v6 = a6;
  if ( !a6 )
    v6 = *(_DWORD *)(a1 + 76);
  v13 = v6;
  result = a3;
  if ( a3 )
  {
    a6 = a3;
    v8 = a4;
    do
    {
      v9 = *v8;
      if ( !*v8 )
        break;
      if ( v9 == 37 )
      {
        v10 = (char *)(v8 + 1);
        v11 = 0;
        if ( *v10 == 35 )
        {
          v11 = 1;
          ++v10;
        }
        if ( !_expandtime(*v10, (int *)&a2, &a6, a1, a5, v13, v11) )
          goto LABEL_19;
        v8 = (unsigned __int8 *)(v10 + 1);
      }
      else
      {
        if ( *(char *)(*(_DWORD *)(a1 + 72) + 2 * v9 + 1) < 0 && a6 > 1 )
        {
          if ( !*++v8 )
            goto LABEL_19;
          *a2++ = v9;
          --a6;
        }
        *a2++ = *v8++;
        --a6;
      }
    }
    while ( a6 );
    if ( a6 )
    {
      *a2 = 0;
      return a3 - a6;
    }
LABEL_19:
    *v12 = 0;
    return 0;
  }
  return result;
}


/* ==== 40B19B  sub_40B19B  ()  size=27 ==== */
size_t __cdecl sub_40B19B(char *Buffer, size_t Max_size, char *Format, struct tm *Timeptr)
{
  return _Strftime(Buffer, Max_size, Format, Timeptr, 0);
}


/* ==== 40B1B6  __gmtime64  ()  size=549 ==== */
struct tm *__cdecl _gmtime64(const __time64_t *Time)
{
  int v1; // ebx
  unsigned int v2; // edi
  int v3; // eax
  int v4; // esi
  void *v5; // eax
  struct tm *v6; // esi
  __int64 v7; // rax
  unsigned int v8; // edi
  int v9; // et0
  int v10; // et0
  unsigned int v11; // edi
  unsigned int v12; // et0
  int *v13; // edx
  int tm_yday; // eax
  int i; // ecx
  int v16; // ecx
  signed __int64 v17; // kr28_8
  __int64 v19; // [esp+Ch] [ebp-14h]
  int v20; // [esp+10h] [ebp-10h]
  unsigned int v21; // [esp+10h] [ebp-10h]
  int v22; // [esp+14h] [ebp-Ch]
  int v23; // [esp+18h] [ebp-8h]
  int v24; // [esp+1Ch] [ebp-4h]

  v23 = 0;
  v1 = *((_DWORD *)Time + 1);
  v2 = *(_DWORD *)Time;
  LODWORD(v19) = *(_DWORD *)Time;
  HIDWORD(v19) = v1;
  v3 = _getptd();
  v4 = v3;
  if ( (unsigned int)v1 > 0x1000 || v1 >= 4096 && v2 )
    return 0;
  if ( *(_DWORD *)(v3 + 68) || (v5 = malloc(0x24u), (*(_DWORD *)(v4 + 68) = v5) != 0) )
    v6 = *(struct tm **)(v4 + 68);
  else
    v6 = (struct tm *)&unk_4300C0;
  v7 = __SPAIR64__(v1, v2) / 31536000;
  v22 = __SPAIR64__(v1, v2) / 31536000 + 69;
  v24 = __SPAIR64__(v1, v2) / 31536000 + 70;
  v8 = 86400 * (-365 * v7 - (((int)v7 + 369) / 400 - ((int)v7 + 69) / 100 + ((int)v7 + 69) / 4 - 17)) + v19;
  v20 = (unsigned __int64)(86400
                         * (-365LL * (int)v7 - (((int)v7 + 369) / 400 - ((int)v7 + 69) / 100 + ((int)v7 + 69) / 4 - 17))
                         + v19) >> 32;
  if ( v20 >= 0 )
  {
    if ( (v24 % 4 || !(v24 % 100)) && (v24 + 1900) % 400 )
      goto LABEL_17;
  }
  else
  {
    v24 = v22;
    v9 = (__PAIR64__(v20, v8) + 31536000) >> 32;
    v8 += 31536000;
    v20 = v9;
    if ( (v22 % 4 || !(v22 % 100)) && (v22 + 1900) % 400 )
      goto LABEL_17;
    v10 = (__PAIR64__(v20, v8) + 86400) >> 32;
    v8 += 86400;
    v20 = v10;
  }
  v23 = 1;
LABEL_17:
  v6->tm_year = v24;
  v6->tm_yday = __SPAIR64__(v20, v8) / 86400;
  v12 = (-86400LL * (int)(__SPAIR64__(v20, v8) / 86400) + __PAIR64__(v20, v8)) >> 32;
  v11 = __SPAIR64__(v20, v8) % 86400;
  v21 = v12;
  v13 = &dword_42D144;
  if ( !v23 )
    v13 = &dword_42D178;
  tm_yday = v6->tm_yday;
  for ( i = 1; v13[i] < tm_yday; ++i )
    ;
  v16 = i - 1;
  v6->tm_mon = v16;
  v6->tm_mday = tm_yday - v13[v16];
  v6->tm_wday = (int)(*Time / 86400 + 4) % 7;
  v6->tm_hour = __SPAIR64__(v21, v11) / 3600;
  v17 = -3600LL * (int)(__SPAIR64__(v21, v11) / 3600) + __PAIR64__(v21, v11);
  v6->tm_min = v17 / 60;
  v6->tm_sec = v17 % 60;
  v6->tm_isdst = 0;
  return v6;
}


/* ==== 40B3DB  __fclose_lk  ()  size=76 ==== */
int __cdecl _fclose_lk(int a1)
{
  int v1; // edi

  v1 = -1;
  if ( (*(_BYTE *)(a1 + 12) & 0x83) != 0 )
  {
    v1 = _flush(a1);
    _freebuf(a1);
    if ( _close(*(_DWORD *)(a1 + 16)) >= 0 )
    {
      if ( *(_DWORD *)(a1 + 28) )
      {
        free(*(void **)(a1 + 28));
        *(_DWORD *)(a1 + 28) = 0;
      }
    }
    else
    {
      v1 = -1;
    }
  }
  *(_DWORD *)(a1 + 12) = 0;
  return v1;
}


/* ==== 40B427  _fclose  ()  size=81 ==== */
int __cdecl fclose(FILE *Stream)
{
  int v2; // [esp+Ch] [ebp-1Ch]

  v2 = -1;
  if ( (Stream->_flag & 0x40) != 0 )
  {
    Stream->_flag = 0;
  }
  else
  {
    _lock_file(Stream);
    v2 = _fclose_lk((int)Stream);
    _unlock_file(Stream);
  }
  return v2;
}


/* ==== 40B478  sub_40B478  ()  size=94 ==== */
int sub_40B478(FILE *Stream, int a2, ...)
{
  int v3; // [esp+Ch] [ebp-24h]
  int v4; // [esp+14h] [ebp-1Ch]
  va_list va; // [esp+40h] [ebp+10h] BYREF

  va_start(va, a2);
  _lock_file(Stream);
  v4 = _stbuf(Stream);
  v3 = sub_40ECA8(Stream, a2, va);
  _ftbuf(v4, Stream);
  _unlock_file(Stream);
  return v3;
}


/* ==== 40B4D6  ___crtExitProcess  ()  size=47 ==== */
void __cdecl __noreturn __crtExitProcess(UINT uExitCode)
{
  HMODULE ModuleHandleA; // eax
  FARPROC CorExitProcess; // eax

  ModuleHandleA = GetModuleHandleA("mscoree.dll");
  if ( ModuleHandleA )
  {
    CorExitProcess = GetProcAddress(ModuleHandleA, "CorExitProcess");
    if ( CorExitProcess )
      ((void (__stdcall *)(UINT))CorExitProcess)(uExitCode);
  }
  ExitProcess(uExitCode);
}


/* ==== 40B506  __lockexit  ()  size=9 ==== */
int _lockexit()
{
  return _lock(8);
}


/* ==== 40B50F  __unlockexit  ()  size=9 ==== */
int _unlockexit()
{
  return _unlock(8);
}


/* ==== 40B518  __initterm  ()  size=24 ==== */
void __cdecl _initterm(_PVFV *First, _PVFV *Last)
{
  void (**v2)(void); // eax
  void (**i)(void); // esi

  for ( i = v2; i < First; ++i )
  {
    if ( *i )
      (*i)();
  }
}


/* ==== 40B530  __cinit  ()  size=106 ==== */
int __cdecl _cinit(int a1)
{
  int result; // eax
  int (**v2)(void); // esi
  void (**v3)(void); // esi

  if ( off_42CBA8 )
    off_42CBA8(a1);
  result = 0;
  v2 = (int (**)(void))&unk_42C0D8;
  if ( &unk_42C0D8 >= (_UNKNOWN *)&dword_42C0EC )
  {
LABEL_9:
    atexit(sub_41031E);
    v3 = (void (**)(void))&unk_42C000;
    if ( &unk_42C000 < (_UNKNOWN *)&dword_42C0D4 )
    {
      do
      {
        if ( *v3 )
          (*v3)();
        ++v3;
      }
      while ( v3 < &dword_42C0D4 );
    }
    return 0;
  }
  else
  {
    while ( !result )
    {
      if ( *v2 )
        result = (*v2)();
      if ( ++v2 >= &dword_42C0EC )
      {
        if ( result )
          return result;
        goto LABEL_9;
      }
    }
  }
  return result;
}


/* ==== 40B59A  _doexit  ()  size=195 ==== */
void __cdecl doexit(UINT uExitCode, int a2, int a3)
{
  HANDLE CurrentProcess; // eax
  void (**v4)(void); // eax
  void (*v5)(void); // eax
  _PVFV *v6; // [esp+0h] [ebp-24h]

  _lock(8);
  if ( dword_430128 == 1 )
  {
    CurrentProcess = GetCurrentProcess();
    TerminateProcess(CurrentProcess, uExitCode);
  }
  dword_430124 = 1;
  byte_430120 = a3;
  if ( !a2 )
  {
    if ( dword_4319AC )
    {
      while ( 1 )
      {
        v4 = (void (**)(void))(dword_4319A8 - 4);
        dword_4319A8 = (int)v4;
        if ( v4 < dword_4319AC )
          break;
        v5 = *v4;
        if ( v5 )
          v5();
      }
    }
    _initterm(&First, v6);
  }
  _initterm(&dword_42C104, v6);
  if ( a3 )
    _unlock(8);
  if ( !a3 )
  {
    dword_430128 = 1;
    __crtExitProcess(uExitCode);
  }
}


/* ==== 40B65D  _exit  ()  size=17 ==== */
void __cdecl __noreturn exit(int Code)
{
  doexit(Code, 0, 0);
}


/* ==== 40B66E  __exit  ()  size=17 ==== */
void __cdecl __noreturn _exit(int Code)
{
  doexit(Code, 1, 0);
}


/* ==== 40B67F  __cexit  ()  size=15 ==== */
void __cdecl _cexit()
{
  doexit(0, 0, 1);
}


/* ==== 40B68E  __c_exit  ()  size=15 ==== */
void __cdecl _c_exit()
{
  doexit(0, 1, 1);
}


/* ==== 40B69D  sub_40B69D  ()  size=102 ==== */
int sub_40B69D(int a1, ...)
{
  int v2; // [esp+Ch] [ebp-20h]
  int v3; // [esp+10h] [ebp-1Ch]
  va_list va; // [esp+38h] [ebp+Ch] BYREF

  va_start(va, a1);
  _lock_file2(1, &unk_42D1D0);
  v3 = _stbuf(&unk_42D1D0);
  v2 = sub_40ECA8(&unk_42D1D0, a1, va);
  _ftbuf(v3, &unk_42D1D0);
  _unlock_file2(1, &unk_42D1D0);
  return v2;
}


/* ==== 40B703  sub_40B703  ()  size=92 ==== */
int __cdecl sub_40B703(char *FileName, int a2, int ShareFlag)
{
  int v3; // eax
  int v5; // [esp+Ch] [ebp-20h]
  FILE *Stream; // [esp+10h] [ebp-1Ch]

  v3 = _getstream();
  Stream = (FILE *)v3;
  if ( v3 )
  {
    v5 = _openfile(FileName, a2, ShareFlag, v3);
    _unlock_file(Stream);
    return v5;
  }
  else
  {
    *_errno() = 24;
    return 0;
  }
}


/* ==== 40B75F  sub_40B75F  ()  size=19 ==== */
int __cdecl sub_40B75F(char *FileName, int a2)
{
  return sub_40B703(FileName, a2, 64);
}


/* ==== 40B772  __heap_alloc  ()  size=123 ==== */
LPVOID __cdecl _heap_alloc(SIZE_T dwBytes)
{
  SIZE_T v1; // esi
  LPVOID result; // eax
  int v3; // [esp+Ch] [ebp-1Ch]

  v1 = dwBytes;
  if ( dword_430740 != 3
    || dwBytes > dword_43072C
    || (_lock(4), v3 = __sbh_alloc_block(dwBytes), _unlock(4), (result = (LPVOID)v3) == 0) )
  {
    if ( !dwBytes )
      v1 = 1;
    if ( dword_430740 != 1 )
      v1 = (v1 + 15) & 0xFFFFFFF0;
    return HeapAlloc(hHeap, 0, v1);
  }
  return result;
}


/* ==== 40B7ED  __nh_malloc  ()  size=44 ==== */
LPVOID __cdecl _nh_malloc(size_t Size, int a2)
{
  LPVOID result; // eax

  if ( Size > 0xFFFFFFE0 )
    return 0;
  while ( 1 )
  {
    result = _heap_alloc(Size);
    if ( result || !a2 )
      break;
    if ( !_callnewh(Size) )
      return 0;
  }
  return result;
}


/* ==== 40B819  _malloc  ()  size=18 ==== */
void *__cdecl malloc(size_t Size)
{
  return _nh_malloc(Size, dword_43037C);
}


/* ==== 40B82B  _free  ()  size=113 ==== */
void __cdecl free(void *Block)
{
  int v1; // eax
  int v2; // [esp+Ch] [ebp-1Ch]

  if ( Block )
  {
    if ( dword_430740 != 3 )
      goto LABEL_6;
    _lock(4);
    v1 = __sbh_find_block(Block);
    v2 = v1;
    if ( v1 )
      __sbh_free_block(v1, Block);
    _unlock(4);
    if ( !v2 )
LABEL_6:
      HeapFree(hHeap, 0, Block);
  }
}


/* ==== 40B89C  __resetstkoflw  ()  size=227 ==== */
int __cdecl _resetstkoflw()
{
  void *v0; // esp
  char *AllocationBase; // ebx
  int v2; // eax
  char *v3; // edi
  char *v4; // esi
  _BYTE v6[16]; // [esp-4h] [ebp-5Ch] BYREF
  struct _SYSTEM_INFO SystemInfo; // [esp+Ch] [ebp-4Ch] BYREF
  struct _MEMORY_BASIC_INFORMATION Buffer; // [esp+30h] [ebp-28h] BYREF
  DWORD flOldProtect; // [esp+4Ch] [ebp-Ch] BYREF
  SIZE_T dwSize; // [esp+50h] [ebp-8h]
  LPCVOID lpAddress; // [esp+54h] [ebp-4h]

  v0 = alloca(4);
  if ( !VirtualQuery(v6, &Buffer, 0x1Cu) )
    return 0;
  AllocationBase = (char *)Buffer.AllocationBase;
  GetSystemInfo(&SystemInfo);
  v2 = dword_4300E8;
  v3 = (char *)(((unsigned int)v6 & ~(SystemInfo.dwPageSize - 1)) - SystemInfo.dwPageSize);
  v4 = &AllocationBase[SystemInfo.dwPageSize * (dword_4300E8 != 1 ? 2 : 17)];
  dwSize = SystemInfo.dwPageSize;
  if ( v3 < v4 )
    return 0;
  if ( dword_4300E8 != 1 )
  {
    lpAddress = AllocationBase;
    while ( VirtualQuery(lpAddress, &Buffer, 0x1Cu) )
    {
      lpAddress = (char *)lpAddress + Buffer.RegionSize;
      if ( (Buffer.State & 0x1000) != 0 )
      {
        lpAddress = Buffer.BaseAddress;
        if ( (Buffer.Protect & 0x100) != 0 )
          return 1;
        if ( v3 >= Buffer.BaseAddress )
        {
          if ( Buffer.BaseAddress < v4 )
            lpAddress = v4;
          VirtualAlloc((LPVOID)lpAddress, dwSize, 0x1000u, 4u);
          v2 = dword_4300E8;
          return VirtualProtect((LPVOID)lpAddress, dwSize, v2 != 1 ? 260 : 1, &flOldProtect);
        }
        return 0;
      }
    }
    return 0;
  }
  lpAddress = (LPCVOID)(((unsigned int)v6 & ~(SystemInfo.dwPageSize - 1)) - SystemInfo.dwPageSize);
  return VirtualProtect((LPVOID)lpAddress, dwSize, v2 != 1 ? 260 : 1, &flOldProtect);
}


/* ==== 40B988  __except_handler3  ()  size=230 ==== */
int __cdecl _except_handler3(int a1, _DWORD *TargetFrame, int a3)
{
  int *v3; // ebp
  _DWORD *v4; // ebx
  int v5; // esi
  int v6; // edi
  int (__fastcall *v7)(_DWORD, _DWORD); // eax
  int v8; // eax
  int v9; // edi
  int v10; // ecx
  _DWORD v12[2]; // [esp+10h] [ebp-8h] BYREF
  int savedregs; // [esp+18h] [ebp+0h] BYREF

  v3 = &savedregs;
  v4 = TargetFrame;
  if ( (*(_DWORD *)(a1 + 4) & 6) != 0 )
  {
    _local_unwind2((int)TargetFrame, -1);
    return 1;
  }
  else
  {
    v12[0] = a1;
    v12[1] = a3;
    *(TargetFrame - 1) = v12;
    v5 = TargetFrame[3];
    v6 = TargetFrame[2];
    if ( _ValidateEH3RN(TargetFrame) )
    {
      while ( v5 != -1 )
      {
        v7 = *(int (__fastcall **)(_DWORD, _DWORD))(v6 + 12 * v5 + 4);
        if ( v7 )
        {
          v8 = v7(0, 0);
          v4 = (_DWORD *)v3[3];
          if ( v8 )
          {
            if ( v8 < 0 )
              return 0;
            v9 = v4[2];
            _global_unwind2((PVOID)v3[3]);
            v3 = v4 + 4;
            _local_unwind2((int)v4, v5);
            _NLG_Notify(*(_DWORD *)(v9 + 12 * v5 + 8), (int)(v4 + 4), 1);
            v4[3] = *(_DWORD *)(v9 + 4 * v10);
            v4 = 0;
            v5 = 0;
            (*(void (__fastcall **)(_DWORD, _DWORD))(v9 + 4 * v10 + 8))(0, 0);
          }
        }
        v6 = v4[2];
        v5 = *(_DWORD *)(v6 + 12 * v5);
      }
    }
    else
    {
      *(_DWORD *)(a1 + 4) |= 8u;
    }
    return 1;
  }
}


/* ==== 40BA6E  __seh_longjmp_unwind@4  (_seh_longjmp_unwind(x))  size=27 ==== */
int __stdcall _seh_longjmp_unwind(int a1)
{
  return _local_unwind2(*(_DWORD *)(a1 + 24), *(_DWORD *)(a1 + 28));
}


/* ==== 40BA89  nullsub_1  ()  size=1 ==== */
void nullsub_1()
{
  ;
}


/* ==== 40BA8A  __cfltcvt_init  ()  size=56 ==== */
int (__cdecl *_cfltcvt_init())(int, int, int, size_t Size, int)
{
  int (__cdecl *result)(int, int, int, size_t, int); // eax

  result = _cfltcvt;
  off_42D554[0] = (void (__noreturn *)())_cfltcvt;
  off_42D558[0] = (void (__noreturn *)())_cropzeros;
  off_42D55C[0] = (void (__noreturn *)())_fassign;
  off_42D560[0] = (void (__noreturn *)())_forcdecpt;
  off_42D564[0] = (void (__noreturn *)())_positive;
  off_42D568 = (void (__noreturn *)())_cfltcvt;
  return result;
}


/* ==== 40BAC2  __fpmath  ()  size=30 ==== */
int __cdecl _fpmath(int a1)
{
  int result; // eax

  _cfltcvt_init();
  result = _ms_p5_mp_test_fdiv();
  dword_430130 = result;
  if ( a1 )
    result = _setdefaultprecision();
  __asm { fnclex }
  return result;
}


/* ==== 40BAE0  __ftol2  ()  size=117 ==== */
unsigned int __usercall _ftol2@<eax>(double a1@<st0>)
{
  int v1; // edx
  unsigned int result; // eax
  float v3; // [esp+0h] [ebp-20h]
  int v4; // [esp+18h] [ebp-8h]

  *(float *)&v4 = a1;
  v1 = v4;
  result = (__int64)a1;
  if ( result || (v1 = (unsigned __int64)(__int64)a1 >> 32, (v1 & 0x7FFFFFFF) != 0) )
  {
    if ( v1 >= 0 )
    {
      v3 = a1 - (double)(__int64)a1;
      result -= __CFADD__(LODWORD(v3), 0x7FFFFFFF);
    }
    else
    {
      return (__PAIR64__(result, -(float)(a1 - (double)(__int64)a1)) + 0x7FFFFFFF) >> 32;
    }
  }
  return result;
}


/* ==== 40BB55  _sprintf  ()  size=88 ==== */
int sprintf(char *const Buffer, const char *const Format, ...)
{
  int v2; // edi
  FILE File; // [esp+8h] [ebp-20h] BYREF
  va_list va; // [esp+38h] [ebp+10h] BYREF

  va_start(va, Format);
  File._cnt = 0x7FFFFFFF;
  File._flag = 66;
  File._base = Buffer;
  File._ptr = Buffer;
  v2 = sub_40ECA8(&File, Format, va);
  if ( Buffer )
  {
    if ( --File._cnt < 0 )
      _flsbuf(0, &File);
    else
      *File._ptr = 0;
  }
  return v2;
}


/* ==== 40BBAD  __onexit_lk  ()  size=128 ==== */
char *__usercall _onexit_lk@<eax>(int a1@<edi>)
{
  size_t v1; // eax
  char *v2; // ecx
  size_t v3; // esi
  int v4; // ecx
  char *result; // eax
  int v6; // ecx

  v1 = _msize(dword_4319AC);
  v2 = (char *)dword_4319A8;
  v3 = v1;
  if ( v1 >= dword_4319A8 - (int)dword_4319AC + 4 )
    goto LABEL_7;
  v4 = 2048;
  if ( v1 < 0x800 )
    v4 = v1;
  result = (char *)sub_40C034(dword_4319AC, v1 + v4);
  if ( result || (result = (char *)sub_40C034(dword_4319AC, v3 + 16)) != 0 )
  {
    v6 = dword_4319A8 - (_DWORD)dword_4319AC;
    dword_4319AC = result;
    v2 = &result[4 * (v6 >> 2)];
    dword_4319A8 = (int)v2;
LABEL_7:
    *(_DWORD *)v2 = a1;
    dword_4319A8 += 4;
    return (char *)a1;
  }
  return result;
}


/* ==== 40BC55  __onexit  ()  size=56 ==== */
_onexit_t __cdecl _onexit(_onexit_t Func)
{
  char *v2; // [esp+Ch] [ebp-1Ch]

  _lockexit();
  v2 = _onexit_lk((int)Func);
  _unlockexit();
  return (_onexit_t)v2;
}


/* ==== 40BC8D  _atexit  ()  size=18 ==== */
int __cdecl atexit(void (__cdecl *Func)())
{
  return (_onexit((_onexit_t)Func) != 0) - 1;
}


/* ==== 40BC9F  ??1type_info@@UAE@XZ  (type_info::~type_info(void))  size=70 ==== */
void __thiscall type_info::~type_info(type_info *this)
{
  void *v2; // esi

  *(_DWORD *)this = &type_info::`vftable';
  _lock(14);
  v2 = (void *)*((_DWORD *)this + 1);
  if ( v2 )
    free(v2);
  _unlock(14);
}


/* ==== 40BCE5  ??_Gtype_info@@UAEPAXI@Z  (type_info::`scalar deleting destructor'(uint))  size=28 ==== */
type_info *__thiscall type_info::`scalar deleting destructor'(type_info *this, char a2)
{
  type_info::~type_info(this);
  if ( (a2 & 1) != 0 )
    j__free(this);
  return this;
}


/* ==== 40BD01  _atol  ()  size=136 ==== */
int __cdecl atol(const char *String)
{
  int v1; // edi
  int v3; // eax
  int v5; // ecx
  const char *v6; // esi
  int v7; // edx
  int result; // eax
  int v9; // ecx

  v1 = *(_DWORD *)(_getptd() + 100);
  if ( (_UNKNOWN *)v1 != off_42D00C )
    v1 = __updatetlocinfo();
  while ( 1 )
  {
    v3 = *(unsigned __int8 *)String;
    if ( !(*(int *)(v1 + 40) <= 1 ? *(_BYTE *)(*(_DWORD *)(v1 + 72) + 2 * v3) & 8 : __isctype_mt(v1, v3, 8)) )
      break;
    ++String;
  }
  v5 = *(unsigned __int8 *)String;
  v6 = String + 1;
  v7 = v5;
  if ( v5 == 45 || v5 == 43 )
    v5 = *(unsigned __int8 *)v6++;
  result = 0;
  while ( 1 )
  {
    v9 = v5 < 48 || v5 > 57 ? -1 : v5 - 48;
    if ( v9 == -1 )
      break;
    result = v9 + 10 * result;
    v5 = *(unsigned __int8 *)v6++;
  }
  if ( v7 == 45 )
    return -result;
  return result;
}


/* ==== 40BD89  j__atol  ()  size=5 ==== */
// attributes: thunk
int __cdecl j__atol(const char *String)
{
  return atol(String);
}


/* ==== 40BD90  _strstr  ()  size=134 ==== */
char *__cdecl strstr(const char *Str, const char *SubStr)
{
  char v2; // dl
  const char *v3; // edi
  char v4; // dh
  const char *v5; // ecx
  char *v6; // esi
  char v7; // al
  char v9; // ah
  char v10; // al
  char v11; // al

  v2 = *SubStr;
  v3 = Str;
  if ( !*SubStr )
    return (char *)Str;
  v4 = SubStr[1];
  if ( !v4 )
    JUMPOUT(0x411966);
findnext:
  v5 = SubStr;
  v6 = (char *)(v3 + 1);
  if ( *v3 == v2 )
    goto first_char_found;
  if ( *v3 )
  {
    while ( 2 )
    {
      v7 = *v6++;
      while ( v7 == v2 )
      {
first_char_found:
        v7 = *v6++;
        if ( v7 == v4 )
        {
          v3 = v6 - 1;
          while ( 1 )
          {
            v9 = v5[2];
            if ( !v9 )
              break;
            v10 = *v6;
            v6 += 2;
            if ( v10 != v9 )
              goto findnext;
            v11 = v5[3];
            if ( !v11 )
              break;
            v5 += 2;
            if ( v11 != *(v6 - 1) )
              goto findnext;
          }
          return (char *)(v3 - 1);
        }
      }
      if ( v7 )
        continue;
      break;
    }
  }
  return 0;
}


/* ==== 40BE16  __amsg_exit  ()  size=34 ==== */
void __cdecl __noreturn _amsg_exit(int a1)
{
  if ( dword_43013C == 1 )
    _FF_MSGBANNER();
  sub_411A1E(a1);
  off_42CBD0(255);
}


/* ==== 40BE3B  _fast_error_exit  ()  size=33 ==== */
void __cdecl __noreturn fast_error_exit(int a1)
{
  if ( dword_43013C == 1 )
    _FF_MSGBANNER();
  sub_411A1E(a1);
  __crtExitProcess(0xFFu);
}


/* ==== 40BE5F  start  ()  size=469 ==== */
int start()
{
  void *v0; // esp
  HMODULE ModuleHandleA; // eax
  char *v2; // ecx
  int v3; // eax
  int v4; // eax
  bool v5; // zf
  int v6; // eax
  int wShowWindow; // eax
  HMODULE v8; // eax
  int v9; // eax
  int v10; // edi
  CHAR *v12; // [esp-9Ch] [ebp-118h]
  int v13; // [esp-98h] [ebp-114h]
  struct _OSVERSIONINFOA v14; // [esp-94h] [ebp-110h] BYREF
  struct _STARTUPINFOA StartupInfo; // [esp+Ch] [ebp-70h] BYREF
  int v16; // [esp+50h] [ebp-2Ch]
  int v17; // [esp+54h] [ebp-28h]
  LPSTR lpCmdLine; // [esp+5Ch] [ebp-20h]
  int v19; // [esp+60h] [ebp-1Ch]
  CPPEH_RECORD ms_exc; // [esp+64h] [ebp-18h]

  v0 = alloca(148);
  ms_exc.old_esp = (DWORD)&v14;
  v14.dwOSVersionInfoSize = 148;
  GetVersionExA(&v14);
  dword_4300E8 = v14.dwPlatformId;
  dword_4300F4 = v14.dwMajorVersion;
  dword_4300F8 = v14.dwMinorVersion;
  dword_4300EC = v14.dwBuildNumber & 0x7FFF;
  if ( v14.dwPlatformId != 2 )
    dword_4300EC = v14.dwBuildNumber & 0x7FFF | 0x8000;
  dword_4300F0 = v14.dwMinorVersion + (v14.dwMajorVersion << 8);
  ModuleHandleA = GetModuleHandleA(0);
  if ( *(_WORD *)ModuleHandleA != 23117 )
    goto LABEL_7;
  v2 = (char *)ModuleHandleA + *((_DWORD *)ModuleHandleA + 15);
  if ( *(_DWORD *)v2 != 17744 )
    goto LABEL_7;
  v3 = *((unsigned __int16 *)v2 + 12);
  if ( v3 == 267 )
  {
    if ( *((_DWORD *)v2 + 29) > 0xEu )
    {
      v4 = 0;
      v5 = *((_DWORD *)v2 + 58) == 0;
      goto LABEL_12;
    }
LABEL_7:
    v19 = 0;
    goto LABEL_13;
  }
  if ( v3 != 523 || *((_DWORD *)v2 + 33) <= 0xEu )
    goto LABEL_7;
  v4 = 0;
  v5 = *((_DWORD *)v2 + 62) == 0;
LABEL_12:
  LOBYTE(v4) = !v5;
  v19 = v4;
LABEL_13:
  if ( !_heap_init(1) )
    fast_error_exit(28);
  if ( !_mtinit() )
    fast_error_exit(16);
  sub_4102DA();
  ms_exc.registration.TryLevel = 0;
  if ( _ioinit() < 0 )
    _amsg_exit(27);
  dword_4319A0 = (int)GetCommandLineA();
  dword_430134 = (char *)__crtGetEnvironmentStringsA();
  if ( _setargv() < 0 )
    _amsg_exit(8);
  if ( _setenvp() < 0 )
    _amsg_exit(9);
  v6 = _cinit(1);
  v17 = v6;
  if ( v6 )
    _amsg_exit(v6);
  StartupInfo.dwFlags = 0;
  GetStartupInfoA(&StartupInfo);
  lpCmdLine = (LPSTR)_wincmdln();
  if ( (StartupInfo.dwFlags & 1) != 0 )
    wShowWindow = StartupInfo.wShowWindow;
  else
    wShowWindow = 10;
  v13 = wShowWindow;
  v12 = lpCmdLine;
  v8 = GetModuleHandleA(0);
  v9 = WinMain(v8, 0, v12, v13);
  v10 = v9;
  v16 = v9;
  if ( !v19 )
    exit(v9);
  _cexit();
  return v10;
}


/* ==== 40C034  sub_40C034  ()  size=434 ==== */
void *__cdecl sub_40C034(_DWORD *lpMem, SIZE_T dwBytes)
{
  void *result; // eax
  SIZE_T v3; // esi
  int block; // eax
  size_t v5; // eax
  size_t v6; // eax
  int v7; // [esp+10h] [ebp-20h]
  LPVOID v8; // [esp+14h] [ebp-1Ch]

  if ( !lpMem )
    return malloc(dwBytes);
  v3 = dwBytes;
  if ( dwBytes )
  {
    if ( dword_430740 == 3 )
    {
      while ( 1 )
      {
        v8 = 0;
        if ( v3 > 0xFFFFFFE0 )
          break;
        _lock(4);
        block = __sbh_find_block(lpMem);
        v7 = block;
        if ( block )
        {
          if ( v3 <= dword_43072C )
          {
            if ( __sbh_resize_block(block, lpMem, v3) )
            {
              v8 = lpMem;
            }
            else
            {
              v8 = (LPVOID)__sbh_alloc_block(v3);
              if ( v8 )
              {
                v5 = *(lpMem - 1) - 1;
                if ( v5 >= v3 )
                  v5 = v3;
                memcpy_0(v8, lpMem, v5);
                v7 = __sbh_find_block(lpMem);
                __sbh_free_block(v7, lpMem);
              }
            }
          }
          if ( !v8 )
          {
            if ( !v3 )
              v3 = 1;
            v3 = (v3 + 15) & 0xFFFFFFF0;
            v8 = HeapAlloc(hHeap, 0, v3);
            if ( v8 )
            {
              v6 = *(lpMem - 1) - 1;
              if ( v6 >= v3 )
                v6 = v3;
              memcpy_0(v8, lpMem, v6);
              __sbh_free_block(v7, lpMem);
            }
          }
        }
        _unlock(4);
        if ( !v7 )
        {
          if ( !v3 )
            v3 = 1;
          v3 = (v3 + 15) & 0xFFFFFFF0;
          v8 = HeapReAlloc(hHeap, 0, lpMem, v3);
        }
        result = v8;
        if ( v8 || !dword_43037C )
          return result;
        if ( !_callnewh(v3) )
          return 0;
      }
    }
    else
    {
      while ( v3 <= 0xFFFFFFE0 )
      {
        if ( !v3 )
          v3 = 1;
        result = HeapReAlloc(hHeap, 0, lpMem, v3);
        if ( result || !dword_43037C )
          return result;
        if ( !_callnewh(v3) )
          return 0;
      }
    }
    _callnewh(v3);
  }
  else
  {
    free(lpMem);
  }
  return 0;
}


/* ==== 40C1E6  _wcslen  ()  size=22 ==== */
size_t __cdecl wcslen(const wchar_t *String)
{
  const wchar_t *v1; // eax

  v1 = String;
  while ( *v1++ )
    ;
  return v1 - String - 1;
}


/* ==== 40C200  _memcpy_0  ()  size=829 ==== */
void *__cdecl memcpy_0(void *a1, const void *Src, size_t Size)
{
  char *v3; // esi
  char *v4; // edi
  size_t v5; // ecx
  void *result; // eax
  char *v7; // esi
  char *v8; // edi
  size_t v9; // ecx

  v3 = (char *)Src;
  v4 = (char *)a1;
  if ( a1 > Src && a1 < (char *)Src + Size )
  {
    v7 = (char *)Src + Size - 4;
    v8 = (char *)a1 + Size - 4;
    if ( ((unsigned __int8)v8 & 3) == 0 )
    {
      v9 = Size >> 2;
      if ( Size >> 2 >= 8 )
      {
        while ( v9 )
        {
          *(_DWORD *)v8 = *(_DWORD *)v7;
          v7 -= 4;
          v8 -= 4;
          --v9;
        }
        switch ( Size & 3 )
        {
          case 0u:
            goto TrailDown0_0;
          case 1u:
            goto TrailDown1_0;
          case 2u:
            goto TrailDown2_0;
          case 3u:
            goto TrailDown3_0;
        }
      }
      switch ( Size & 3 )
      {
        case 0u:
          goto TrailDown0_0;
        case 1u:
          goto TrailDown1_0;
        case 2u:
          goto TrailDown2_0;
        case 3u:
          goto TrailDown3_0;
      }
    }
    switch ( Size )
    {
      case 0u:
TrailDown0_0:
        result = a1;
        break;
      case 1u:
TrailDown1_0:
        v8[3] = v7[3];
        result = a1;
        break;
      case 2u:
TrailDown2_0:
        v8[3] = v7[3];
        v8[2] = v7[2];
        result = a1;
        break;
      case 3u:
TrailDown3_0:
        v8[3] = v7[3];
        v8[2] = v7[2];
        v8[1] = v7[1];
        result = a1;
        break;
      default:
        __asm { jmp     dword ptr ds:ByteCopyDown_0+4[eax*4] }
        return result;
    }
  }
  else
  {
    if ( ((unsigned __int8)a1 & 3) != 0 )
    {
      if ( Size >= 4 )
        __asm { jmp     dword ptr ds:CopyUnwindUp_0+4[eax*4] }
      __asm { jmp     dword ptr ds:TrailUp0_0[ecx*4]; jumptable 0040C235 case 0 }
    }
    v5 = Size >> 2;
    switch ( v5 )
    {
      case 0u:
        goto UnwindUp0_0;
      case 1u:
        goto UnwindUp1_0;
      case 2u:
        goto UnwindUp2_0;
      case 3u:
        goto UnwindUp3_0;
      case 4u:
        goto UnwindUp4_0;
      case 5u:
        goto UnwindUp5_0;
      case 6u:
        goto UnwindUp6_0;
      case 7u:
        *((_DWORD *)a1 + v5 - 7) = *((_DWORD *)Src + v5 - 7);
UnwindUp6_0:
        *((_DWORD *)a1 + v5 - 6) = *((_DWORD *)Src + v5 - 6);
UnwindUp5_0:
        *((_DWORD *)a1 + v5 - 5) = *((_DWORD *)Src + v5 - 5);
UnwindUp4_0:
        *((_DWORD *)a1 + v5 - 4) = *((_DWORD *)Src + v5 - 4);
UnwindUp3_0:
        *((_DWORD *)a1 + v5 - 3) = *((_DWORD *)Src + v5 - 3);
UnwindUp2_0:
        *((_DWORD *)a1 + v5 - 2) = *((_DWORD *)Src + v5 - 2);
UnwindUp1_0:
        *((_DWORD *)a1 + v5 - 1) = *((_DWORD *)Src + v5 - 1);
        v3 = (char *)Src + 4 * v5;
        v4 = (char *)a1 + 4 * v5;
UnwindUp0_0:
        switch ( Size & 3 )
        {
          case 0u:
            goto TrailUp0_0;
          case 1u:
            goto TrailUp1_0;
          case 2u:
            goto TrailUp2_0;
          case 3u:
            goto TrailUp3_0;
        }
      default:
        qmemcpy(a1, Src, 4 * v5);
        v3 = (char *)Src + 4 * v5;
        v4 = (char *)a1 + 4 * v5;
        switch ( Size & 3 )
        {
          case 0u:
TrailUp0_0:
            result = a1;
            break;
          case 1u:
TrailUp1_0:
            *v4 = *v3;
            result = a1;
            break;
          case 2u:
TrailUp2_0:
            *v4 = *v3;
            v4[1] = v3[1];
            result = a1;
            break;
          case 3u:
TrailUp3_0:
            *v4 = *v3;
            v4[1] = v3[1];
            v4[2] = v3[2];
            result = a1;
            break;
        }
        break;
    }
  }
  return result;
}


/* ==== 40C540  _strlen  ()  size=139 ==== */
size_t __cdecl strlen(const char *Str)
{
  const char *v1; // ecx
  int v3; // eax
  int v4; // eax

  v1 = Str;
  if ( ((unsigned __int8)Str & 3) == 0 )
    goto main_loop;
  do
  {
    if ( !*v1++ )
      return v1 - 1 - Str;
  }
  while ( ((unsigned __int8)v1 & 3) != 0 );
  while ( 1 )
  {
    do
    {
main_loop:
      v3 = (*(_DWORD *)v1 + 2130640639) ^ ~*(_DWORD *)v1;
      v1 += 4;
    }
    while ( (v3 & 0x81010100) == 0 );
    v4 = *((_DWORD *)v1 - 1);
    if ( !(_BYTE)v4 )
      break;
    if ( !BYTE1(v4) )
      return v1 - 3 - Str;
    if ( (v4 & 0xFF0000) == 0 )
      return v1 - 2 - Str;
    if ( (v4 & 0xFF000000) == 0 )
      return v1 - 1 - Str;
  }
  return v1 - 4 - Str;
}


/* ==== 40C5CC  __EH_prolog  ()  size=31 ==== */
void _EH_prolog()
{
  __asm { retn }
}


/* ==== 40C5EB  __CxxThrowException@8  (_CxxThrowException(x,x))  size=58 ==== */
void __stdcall __noreturn _CxxThrowException(void *pExceptionObject, _ThrowInfo *pThrowInfo)
{
  DWORD dwExceptionCode[8]; // [esp+8h] [ebp-20h] BYREF

  qmemcpy(dwExceptionCode, &unk_4271B4, sizeof(dwExceptionCode));
  dwExceptionCode[6] = (DWORD)pExceptionObject;
  dwExceptionCode[7] = (DWORD)pThrowInfo;
  RaiseException(dwExceptionCode[0], dwExceptionCode[1], dwExceptionCode[4], &dwExceptionCode[5]);
}


/* ==== 40C630  _memset  ()  size=96 ==== */
void *__cdecl memset(void *a1, int Val, size_t Size)
{
  size_t v3; // edx
  int v4; // eax
  _BYTE *v5; // edi
  int v6; // ecx
  size_t v7; // ecx
  unsigned int v8; // ecx

  v3 = Size;
  if ( !Size )
    return a1;
  LOBYTE(v4) = Val;
  v5 = a1;
  if ( Size < 4 )
    goto LABEL_13;
  v6 = -(int)a1 & 3;
  if ( v6 )
  {
    v3 = Size - v6;
    do
    {
      *v5++ = Val;
      --v6;
    }
    while ( v6 );
  }
  v4 = 16843009 * (unsigned __int8)Val;
  v7 = v3;
  v3 &= 3u;
  v8 = v7 >> 2;
  if ( !v8 || (memset32(v5, v4, v8), v5 += 4 * v8, v3) )
  {
LABEL_13:
    do
    {
      *v5++ = v4;
      --v3;
    }
    while ( v3 );
  }
  return a1;
}


/* ==== 40C690  __mbscmp  ()  size=148 ==== */
int __cdecl _mbscmp(const unsigned __int8 *Str1, const unsigned __int8 *Str2)
{
  _DWORD *v2; // esi
  const unsigned __int8 *v4; // edi
  unsigned __int16 v5; // ax
  unsigned __int8 v6; // cl
  unsigned __int16 v7; // dx
  unsigned __int16 v8; // cx
  unsigned __int8 v9; // dl
  unsigned __int16 v10; // bx

  v2 = *(_DWORD **)(_getptd() + 96);
  if ( v2 != Block )
    v2 = (_DWORD *)__updatetmbcinfo();
  if ( !v2[2] )
    return strcmp((const char *)Str1, (const char *)Str2);
  v4 = Str2;
  while ( 1 )
  {
    v5 = *Str1++;
    if ( (*((_BYTE *)v2 + (unsigned __int8)v5 + 29) & 4) != 0 )
    {
      v6 = *Str1;
      if ( *Str1 )
      {
        ++Str1;
        HIBYTE(v7) = v5;
        LOBYTE(v7) = v6;
        v5 = v7;
      }
      else
      {
        v5 = 0;
      }
    }
    v8 = *v4++;
    if ( (*((_BYTE *)v2 + (unsigned __int8)v8 + 29) & 4) != 0 )
    {
      v9 = *v4;
      if ( *v4 )
      {
        HIBYTE(v10) = v8;
        ++v4;
        LOBYTE(v10) = v9;
        v8 = v10;
      }
      else
      {
        v8 = 0;
      }
    }
    if ( v8 != v5 )
      break;
    if ( !v5 )
      return 0;
  }
  return v8 < v5 ? 1 : -1;
}


/* ==== 40C730  _memcmp  ()  size=184 ==== */
int __cdecl memcmp(const void *Buf1, const void *Buf2, size_t Size)
{
  int result; // eax
  char *v4; // esi
  char *v5; // edi
  bool v6; // cf
  unsigned __int8 v7; // cl
  unsigned __int8 v8; // dl
  bool v9; // zf
  size_t v10; // ecx
  unsigned int v11; // ecx
  unsigned int v12; // edx
  unsigned int v13; // ecx
  unsigned int v14; // edx
  int v15; // edx
  int v16; // ecx
  unsigned int v17; // ecx
  unsigned int v18; // edx

  result = Size;
  if ( !Size )
    return result;
  v4 = (char *)Buf1;
  v5 = (char *)Buf2;
  if ( (((unsigned __int8)Buf2 | (unsigned __int8)Buf1) & 3) == 0 )
  {
    result = Size & 3;
    v10 = Size >> 2;
    v9 = Size >> 2 == 0;
    if ( !(Size >> 2) )
      goto tail_loop_start;
    do
    {
      if ( !v10 )
        break;
      v9 = *(_DWORD *)v4 == *(_DWORD *)v5;
      v4 += 4;
      v5 += 4;
      --v10;
    }
    while ( v9 );
    if ( v9 )
    {
tail_loop_start:
      if ( (Size & 3) == 0 )
        return result;
      v15 = *(_DWORD *)v4;
      v16 = *(_DWORD *)v5;
      v6 = (unsigned __int8)*(_DWORD *)v4 < (unsigned __int8)*(_DWORD *)v5;
      if ( (unsigned __int8)*(_DWORD *)v4 == (unsigned __int8)*(_DWORD *)v5 )
      {
        if ( !--result )
          return result;
        v6 = BYTE1(v15) < BYTE1(v16);
        if ( BYTE1(v15) == BYTE1(v16) )
        {
          if ( !--result )
            return result;
          v17 = v16 & 0xFF0000;
          v18 = v15 & 0xFF0000;
          v6 = v18 < v17;
          if ( v18 == v17 )
            return --result;
        }
      }
    }
    else
    {
      v11 = *((_DWORD *)v4 - 1);
      v12 = *((_DWORD *)v5 - 1);
      v6 = (unsigned __int8)v11 < (unsigned __int8)v12;
      if ( (_BYTE)v11 == (_BYTE)v12 )
      {
        v6 = BYTE1(v11) < BYTE1(v12);
        if ( BYTE1(v11) == BYTE1(v12) )
        {
          v13 = HIWORD(v11);
          v14 = HIWORD(v12);
          v6 = (unsigned __int8)v13 < (unsigned __int8)v14;
          if ( (_BYTE)v13 == (_BYTE)v14 )
            v6 = BYTE1(v13) < BYTE1(v14);
        }
      }
    }
    return -v6 - (v6 - 1);
  }
  if ( (Size & 1) == 0 )
  {
main_loop_0:
    while ( 1 )
    {
      v6 = (unsigned __int8)*v4 < (unsigned __int8)*v5;
      if ( *v4 != *v5 )
        break;
      v7 = v4[1];
      v8 = v5[1];
      v6 = v7 < v8;
      if ( v7 != v8 )
        break;
      v5 += 2;
      v4 += 2;
      result -= 2;
      if ( !result )
        return result;
    }
    return -v6 - (v6 - 1);
  }
  v6 = *(_BYTE *)Buf1 < *(_BYTE *)Buf2;
  if ( *(_BYTE *)Buf1 != *(_BYTE *)Buf2 )
    return -v6 - (v6 - 1);
  v4 = (char *)Buf1 + 1;
  v5 = (char *)Buf2 + 1;
  result = Size - 1;
  if ( Size != 1 )
    goto main_loop_0;
  return result;
}


/* ==== 40C7E8  __make__time64_t  ()  size=592 ==== */
int __usercall _make__time64_t@<eax>(int *a1@<eax>, int a2)
{
  signed int v3; // eax
  int v4; // ecx
  __int64 v5; // rax
  bool v6; // cf
  int v7; // esi
  __time64_t v8; // kr10_8
  struct tm *v9; // eax
  int v10; // ecx
  struct tm *v11; // esi
  int result; // eax
  __int64 v13; // [esp+14h] [ebp-14h]
  __time64_t Time; // [esp+1Ch] [ebp-Ch] BYREF
  int v15; // [esp+24h] [ebp-4h]

  Time = a1[5];
  if ( Time < 69 || Time > 1100 )
    return -1;
  v3 = a1[4];
  if ( (unsigned int)v3 >= 0xC )
  {
    v4 = v3 % 12;
    v5 = v3 / 12;
    v6 = __CFADD__((_DWORD)v5, (_DWORD)Time);
    LODWORD(Time) = v5 + Time;
    a1[4] = v4;
    HIDWORD(Time) += HIDWORD(v5) + v6;
    if ( v4 < 0 )
    {
      v6 = (_DWORD)Time != 0;
      LODWORD(Time) = Time - 1;
      a1[4] = v4 + 12;
      HIDWORD(Time) = v6 + HIDWORD(Time) - 1;
    }
    if ( Time < 69 || Time > 1100 )
      return -1;
  }
  v7 = a1[4];
  v13 = dword_42D178[v7];
  if ( (!(Time % 4) && Time % 100 || !((Time + 1900) % 400)) && v7 > 1 )
    ++v13;
  v8 = v13 + 365 * Time + (Time - 1) / 4 + a1[3] + (Time + 299) / 400 - (Time - 1) / 100;
  v15 = v8 - 25567;
  Time = 60 * (60 * (24 * (v8 - 25567) + a1[2]) + a1[1]) + *a1;
  if ( a2 )
  {
    __tzset();
    Time += dword_42CF00;
    v9 = _localtime64(&Time);
    if ( !v9 )
      return -1;
    v10 = a1[8];
    if ( v10 <= 0 && (v10 >= 0 || v9->tm_isdst <= 0) )
      goto LABEL_21;
    Time += dword_42CF08;
    v9 = _localtime64(&Time);
  }
  else
  {
    v9 = _gmtime64(&Time);
  }
  if ( v9 )
  {
LABEL_21:
    v11 = v9;
    result = Time;
    qmemcpy(a1, v11, 0x24u);
    return result;
  }
  return -1;
}


/* ==== 40CA38  __mktime64  ()  size=13 ==== */
__time64_t __cdecl _mktime64(struct tm *Tm)
{
  __time64_t result; // rax

  LODWORD(result) = _make__time64_t(&Tm->tm_sec, 1);
  return result;
}


/* ==== 40CA45  __localtime64  ()  size=526 ==== */
struct tm *__cdecl _localtime64(const __time64_t *Time)
{
  int v1; // ecx
  struct tm *v2; // eax
  struct tm *v3; // esi
  struct tm *v4; // eax
  __int64 v5; // kr00_8
  __time64_t v6; // rax
  __time64_t v7; // rax
  __time64_t v8; // rax
  int tm_mday; // eax
  __time64_t Timea; // [esp+8h] [ebp-8h] BYREF

  v1 = *((_DWORD *)Time + 1);
  if ( (unsigned int)v1 > 0x1000 || v1 >= 4096 && *(_DWORD *)Time )
    return 0;
  __tzset();
  if ( *Time <= 259200 )
  {
    v4 = _gmtime64(Time);
    v3 = v4;
    if ( dword_42CF04 && _isindst(v4) )
    {
      Timea = v3->tm_sec - (__int64)(dword_42CF08 + dword_42CF00);
      v3->tm_isdst = 1;
      v5 = Timea;
    }
    else
    {
      v5 = v3->tm_sec - (__int64)dword_42CF00;
      Timea = v5;
    }
    v3->tm_sec = v5 % 60;
    if ( v5 % 60 < 0 )
    {
      v3->tm_sec = v5 % 60 + 60;
      Timea -= 60LL;
    }
    Timea = v3->tm_min + Timea / 60;
    v6 = Timea % 60;
    v3->tm_min = Timea % 60;
    if ( (int)v6 < 0 )
    {
      v3->tm_min = v6 + 60;
      Timea -= 60LL;
    }
    Timea = v3->tm_hour + Timea / 60;
    v7 = Timea % 24;
    v3->tm_hour = Timea % 24;
    if ( (int)v7 < 0 )
    {
      v3->tm_hour = v7 + 24;
      Timea -= 24LL;
    }
    v8 = Timea / 24;
    Timea = v8;
    if ( v8 < 0 )
    {
      v3->tm_wday = (v3->tm_wday + (int)v8 + 7) % 7;
      v3->tm_mday += Timea;
      tm_mday = v3->tm_mday;
      if ( tm_mday > 0 )
      {
        v3->tm_yday += Timea;
      }
      else
      {
        --v3->tm_year;
        v3->tm_mday = tm_mday + 31;
        v3->tm_yday = 364;
        v3->tm_mon = 11;
      }
    }
  }
  else
  {
    Timea = *Time - dword_42CF00;
    v2 = _gmtime64(&Timea);
    v3 = v2;
    if ( dword_42CF04 )
    {
      if ( _isindst(v2) )
      {
        Timea -= dword_42CF08;
        v3 = _gmtime64(&Timea);
        v3->tm_isdst = 1;
      }
    }
  }
  return v3;
}


/* ==== 40CC53  __mbschr  ()  size=123 ==== */
unsigned __int8 *__cdecl _mbschr(const unsigned __int8 *Str, unsigned int C)
{
  _DWORD *v2; // eax
  const unsigned __int8 *i; // ecx
  unsigned __int16 v5; // dx

  v2 = *(_DWORD **)(_getptd() + 96);
  if ( v2 != Block )
    v2 = (_DWORD *)__updatetmbcinfo();
  if ( !v2[2] )
    return (unsigned __int8 *)strchr((const char *)Str, C);
  for ( i = Str; ; ++i )
  {
    v5 = *i;
    if ( !*i )
      return *i == C ? (unsigned __int8 *)i : 0;
    if ( (*((_BYTE *)v2 + (unsigned __int8)v5 + 29) & 4) != 0 )
      break;
    if ( C == *i )
      return *i == C ? (unsigned __int8 *)i : 0;
LABEL_11:
    ;
  }
  if ( *++i )
  {
    if ( C == (*i | (v5 << 8)) )
      return (unsigned __int8 *)(i - 1);
    goto LABEL_11;
  }
  return 0;
}


/* ==== 40CCCE  _sscanf  ()  size=52 ==== */
int sscanf(const char *const Buffer, const char *const Format, ...)
{
  _DWORD v3[8]; // [esp+0h] [ebp-20h] BYREF
  va_list va; // [esp+30h] [ebp+10h] BYREF

  va_start(va, Format);
  v3[3] = 73;
  v3[2] = Buffer;
  v3[0] = Buffer;
  v3[1] = strlen(Buffer);
  return sub_412358(v3, Format, va);
}


/* ==== 40CD02  __snprintf  ()  size=87 ==== */
int _snprintf(char *const Buffer, const size_t BufferCount, const char *const Format, ...)
{
  int v3; // edi
  FILE File; // [esp+8h] [ebp-20h] BYREF
  va_list va; // [esp+3Ch] [ebp+14h] BYREF

  va_start(va, Format);
  File._cnt = BufferCount;
  File._flag = 66;
  File._base = Buffer;
  File._ptr = Buffer;
  v3 = sub_40ECA8(&File, Format, va);
  if ( Buffer )
  {
    if ( --File._cnt < 0 )
      _flsbuf(0, &File);
    else
      *File._ptr = 0;
  }
  return v3;
}


/* ==== 40CD59  __strdup  ()  size=43 ==== */
char *__cdecl _strdup(const char *Source)
{
  size_t v1; // eax
  char *v2; // eax

  if ( Source && (v1 = strlen(Source), (v2 = (char *)malloc(v1 + 1)) != 0) )
    return strcpy(v2, Source);
  else
    return 0;
}


/* ==== 40CD84  __set_osfhnd  ()  size=124 ==== */
int __cdecl _set_osfhnd(int a1, HANDLE hHandle)
{
  int v2; // esi

  if ( a1 < uNumber && (v2 = 36 * (a1 & 0x1F), *(_DWORD *)(v2 + dword_430620[a1 >> 5]) == -1) )
  {
    if ( dword_42CBD4 == 1 )
    {
      if ( a1 )
      {
        if ( a1 == 1 )
        {
          SetStdHandle(0xFFFFFFF5, hHandle);
        }
        else if ( a1 == 2 )
        {
          SetStdHandle(0xFFFFFFF4, hHandle);
        }
      }
      else
      {
        SetStdHandle(0xFFFFFFF6, hHandle);
      }
    }
    *(_DWORD *)(v2 + dword_430620[a1 >> 5]) = hHandle;
    return 0;
  }
  else
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
}


/* ==== 40CE00  __free_osfhnd  ()  size=127 ==== */
int __cdecl _free_osfhnd(int a1)
{
  int v1; // esi
  int v2; // eax

  if ( a1 >= uNumber
    || (v1 = 36 * (a1 & 0x1F), v2 = v1 + dword_430620[a1 >> 5], (*(_BYTE *)(v2 + 4) & 1) == 0)
    || *(_DWORD *)v2 == -1 )
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
  else
  {
    if ( dword_42CBD4 == 1 )
    {
      if ( a1 )
      {
        if ( a1 == 1 )
        {
          SetStdHandle(0xFFFFFFF5, 0);
        }
        else if ( a1 == 2 )
        {
          SetStdHandle(0xFFFFFFF4, 0);
        }
      }
      else
      {
        SetStdHandle(0xFFFFFFF6, 0);
      }
    }
    *(_DWORD *)(v1 + dword_430620[a1 >> 5]) = -1;
    return 0;
  }
}


/* ==== 40CE7F  __get_osfhandle  ()  size=65 ==== */
intptr_t __cdecl _get_osfhandle(int FileHandle)
{
  int v1; // eax

  if ( FileHandle < uNumber )
  {
    v1 = dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F);
    if ( (*(_BYTE *)(v1 + 4) & 1) != 0 )
      return *(_DWORD *)v1;
  }
  *_errno() = 9;
  *__doserrno() = 0;
  return -1;
}


/* ==== 40CEC0  __lock_fhandle  ()  size=160 ==== */
int __cdecl _lock_fhandle(int a1)
{
  int v1; // esi
  CPPEH_RECORD ms_exc; // [esp+Ch] [ebp-18h] BYREF

  v1 = dword_430620[a1 >> 5] + 36 * (a1 & 0x1F);
  if ( !*(_DWORD *)(v1 + 8) )
  {
    _lock(10);
    ms_exc.registration.TryLevel = 0;
    if ( !*(_DWORD *)(v1 + 8) )
    {
      if ( !__crtInitCritSecAndSpinCount(v1 + 12, 4000) )
      {
        _local_unwind2((int)&ms_exc.registration, -1);
        return 0;
      }
      ++*(_DWORD *)(v1 + 8);
    }
    ms_exc.registration.TryLevel = -1;
    _unlock(10);
  }
  EnterCriticalSection((LPCRITICAL_SECTION)(dword_430620[a1 >> 5] + 36 * (a1 & 0x1F) + 12));
  return 1;
}


/* ==== 40CF60  __unlock_fhandle  ()  size=34 ==== */
void __cdecl _unlock_fhandle(int a1)
{
  LeaveCriticalSection((LPCRITICAL_SECTION)(dword_430620[a1 >> 5] + 36 * (a1 & 0x1F) + 12));
}


/* ==== 40CF82  __alloc_osfhnd  ()  size=380 ==== */
int _alloc_osfhnd()
{
  int v0; // edi
  unsigned int v1; // esi
  char *v3; // eax
  int v4; // [esp+14h] [ebp-1Ch]
  CPPEH_RECORD ms_exc; // [esp+18h] [ebp-18h] BYREF

  v4 = -1;
  if ( !_mtinitlocknum(11) )
    return -1;
  _lock(11);
  v0 = 0;
  ms_exc.registration.TryLevel = 0;
  while ( v0 < 64 )
  {
    v1 = dword_430620[v0];
    if ( !v1 )
    {
      v3 = (char *)malloc(0x480u);
      if ( v3 )
      {
        dword_430620[v0] = (int)v3;
        uNumber += 32;
        while ( (unsigned int)v3 < dword_430620[v0] + 1152 )
        {
          v3[4] = 0;
          *(_DWORD *)v3 = -1;
          v3[5] = 10;
          *((_DWORD *)v3 + 2) = 0;
          v3 += 36;
        }
        v4 = 32 * v0;
        if ( !_lock_fhandle(32 * v0) )
          v4 = -1;
      }
      break;
    }
    while ( v1 < dword_430620[v0] + 1152 )
    {
      if ( (*(_BYTE *)(v1 + 4) & 1) == 0 )
      {
        if ( !*(_DWORD *)(v1 + 8) )
        {
          _lock(10);
          ms_exc.registration.TryLevel = 1;
          if ( !*(_DWORD *)(v1 + 8) )
          {
            if ( !__crtInitCritSecAndSpinCount(v1 + 12, 4000) )
            {
              _local_unwind2((int)&ms_exc.registration, -1);
              return -1;
            }
            ++*(_DWORD *)(v1 + 8);
          }
          ms_exc.registration.TryLevel = 0;
          _unlock(10);
        }
        EnterCriticalSection((LPCRITICAL_SECTION)(v1 + 12));
        if ( (*(_BYTE *)(v1 + 4) & 1) == 0 )
        {
          *(_DWORD *)v1 = -1;
          v4 = 32 * v0 + (int)(v1 - dword_430620[v0]) / 36;
          break;
        }
        LeaveCriticalSection((LPCRITICAL_SECTION)(v1 + 12));
      }
      v1 += 36;
    }
    if ( v4 != -1 )
      break;
    ++v0;
  }
  _unlock(11);
  return v4;
}


/* ==== 40D0FE  __errno  ()  size=9 ==== */
int *__cdecl _errno()
{
  return (int *)(_getptd() + 8);
}


/* ==== 40D107  ___doserrno  ()  size=9 ==== */
unsigned int *__cdecl __doserrno()
{
  return (unsigned int *)(_getptd() + 12);
}


/* ==== 40D110  __dosmaperr  ()  size=115 ==== */
int __cdecl _dosmaperr(unsigned int a1)
{
  unsigned int i; // esi
  int result; // eax

  *(_DWORD *)(_getptd() + 12) = a1;
  for ( i = 0; i < 0x2D; ++i )
  {
    if ( a1 == dword_42CBF0[2 * i] )
    {
      result = _getptd();
      *(_DWORD *)(result + 8) = dword_42CBF4[2 * i];
      return result;
    }
  }
  if ( a1 < 0x13 || a1 > 0x24 )
  {
    if ( a1 < 0xBC || a1 > 0xCA )
    {
      result = _getptd();
      *(_DWORD *)(result + 8) = 22;
    }
    else
    {
      result = _getptd();
      *(_DWORD *)(result + 8) = 8;
    }
  }
  else
  {
    result = _getptd();
    *(_DWORD *)(result + 8) = 13;
  }
  return result;
}


/* ==== 40D183  __flush  ()  size=93 ==== */
int __cdecl _flush(_DWORD *a1)
{
  int v1; // eax
  int v2; // ebx
  const void *v3; // eax
  DWORD v4; // edi
  int v5; // eax
  int v6; // eax

  v1 = a1[3];
  v2 = 0;
  if ( (v1 & 3) == 2 && (v1 & 0x108) != 0 )
  {
    v3 = (const void *)a1[2];
    if ( *a1 - (int)v3 > 0 )
    {
      v4 = *a1 - (_DWORD)v3;
      if ( sub_413743(a1[4], v3, v4) == v4 )
      {
        v5 = a1[3];
        if ( (v5 & 0x80u) != 0 )
          a1[3] = v5 & 0xFFFFFFFD;
      }
      else
      {
        a1[3] |= 0x20u;
        v2 = -1;
      }
    }
  }
  v6 = a1[2];
  a1[1] = 0;
  *a1 = v6;
  return v2;
}


/* ==== 40D1E0  __fflush_lk  ()  size=46 ==== */
int __cdecl _fflush_lk(int a1)
{
  if ( _flush((_DWORD *)a1) )
    return -1;
  if ( (*(_BYTE *)(a1 + 13) & 0x40) != 0 )
    return -(_commit(*(_DWORD *)(a1 + 16)) != 0);
  return 0;
}


/* ==== 40D20E  _flsall  ()  size=155 ==== */
int __cdecl flsall(int a1)
{
  int i; // esi
  int v2; // eax
  int v3; // ecx
  int result; // eax
  int v5; // [esp+Ch] [ebp-24h]
  int v6; // [esp+14h] [ebp-1Ch]

  v6 = 0;
  v5 = 0;
  _lock(1);
  for ( i = 0; i < dword_431760; ++i )
  {
    v2 = *(_DWORD *)(dword_430744 + 4 * i);
    if ( v2 && (*(_BYTE *)(v2 + 12) & 0x83) != 0 )
    {
      _lock_file2(i, *(_DWORD *)(dword_430744 + 4 * i));
      v3 = *(_DWORD *)(*(_DWORD *)(dword_430744 + 4 * i) + 12);
      if ( (v3 & 0x83) != 0 )
      {
        if ( a1 == 1 )
        {
          if ( _fflush_lk(*(_DWORD *)(dword_430744 + 4 * i)) != -1 )
            ++v6;
        }
        else if ( !a1 && (v3 & 2) != 0 && _fflush_lk(*(_DWORD *)(dword_430744 + 4 * i)) == -1 )
        {
          v5 = -1;
        }
      }
      _unlock_file2(i, *(_DWORD *)(dword_430744 + 4 * i));
    }
  }
  _unlock(1);
  result = v6;
  if ( a1 != 1 )
    return v5;
  return result;
}


/* ==== 40D2E3  sub_40D2E3  ()  size=9 ==== */
int sub_40D2E3()
{
  return flsall(1);
}


/* ==== 40D2EC  __SEH_prolog  ()  size=59 ==== */
_DWORD *__cdecl _SEH_prolog(int a1, int a2)
{
  void *v4; // esp
  _DWORD v6[2]; // [esp-8h] [ebp-8h] BYREF
  int v7; // [esp+4h] [ebp+4h]

  v6[1] = _except_handler3;
  v6[0] = NtCurrentTeb()->NtTib.ExceptionList;
  v4 = alloca(a2);
  v7 = -1;
  return v6;
}


/* ==== 40D327  __SEH_epilog  ()  size=17 ==== */
// positive sp value has been detected, the output may be wrong!
void _SEH_epilog()
{
  __asm { retn }
}


/* ==== 40D340  __allmul  ()  size=52 ==== */
unsigned __int64 __stdcall _allmul(__int64 a1, __int64 a2)
{
  if ( HIDWORD(a1) | HIDWORD(a2) )
    return a1 * a2;
  else
    return (unsigned int)a2 * (unsigned __int64)(unsigned int)a1;
}


/* ==== 40D380  __alldiv  ()  size=170 ==== */
int __stdcall _alldiv(unsigned __int64 a1, __int64 a2)
{
  int v2; // edi
  int v3; // eax
  unsigned __int64 v4; // rtt
  __int64 v5; // rax
  unsigned __int64 v6; // rcx
  unsigned __int64 v7; // rax
  unsigned int v8; // esi
  unsigned __int64 v9; // rax

  v2 = 0;
  if ( (a1 & 0x8000000000000000uLL) != 0LL )
  {
    v2 = 1;
    HIDWORD(a1) = -HIDWORD(a1) - ((_DWORD)a1 != 0);
    LODWORD(a1) = -(int)a1;
  }
  v3 = HIDWORD(a2);
  if ( a2 < 0 )
  {
    ++v2;
    v3 = -HIDWORD(a2) - ((_DWORD)a2 != 0);
    HIDWORD(a2) = v3;
    LODWORD(a2) = -(int)a2;
  }
  if ( v3 )
  {
    v6 = __PAIR64__(v3, a2);
    v7 = a1;
    do
    {
      v6 >>= 1;
      v7 >>= 1;
    }
    while ( HIDWORD(v6) );
    v8 = v7 / (unsigned int)v6;
    v9 = v8 * (unsigned __int64)(unsigned int)a2;
    if ( __CFADD__(HIDWORD(a2) * v8, HIDWORD(v9)) || (HIDWORD(v9) = (a2 * (unsigned __int64)v8) >> 32, v9 > a1) )
      --v8;
    v5 = v8;
  }
  else
  {
    LODWORD(v4) = a1;
    HIDWORD(v4) = HIDWORD(a1) % (unsigned int)a2;
    LODWORD(v5) = v4 / (unsigned int)a2;
    HIDWORD(v5) = HIDWORD(a1) / (unsigned int)a2;
  }
  if ( v2 == 1 )
    return -v5;
  return v5;
}


/* ==== 40D42A  __expand  ()  size=170 ==== */
void *__cdecl _expand(void *Block, size_t Size)
{
  size_t v2; // esi
  int v4; // eax
  int v5; // [esp+Ch] [ebp-20h]
  void *v6; // [esp+10h] [ebp-1Ch]

  v2 = Size;
  if ( Size > 0xFFFFFFE0 )
    return 0;
  if ( dword_430740 == 3 )
  {
    _lock(4);
    v4 = __sbh_find_block(Block);
    v5 = v4;
    if ( v4 )
    {
      v6 = 0;
      if ( Size <= dword_43072C )
      {
        if ( __sbh_resize_block(v4, Block, Size) )
          v6 = Block;
      }
    }
    _unlock(4);
    if ( v5 )
      return v6;
    if ( !Size )
      v2 = 1;
    v2 = (v2 + 15) & 0xFFFFFFF0;
  }
  else if ( !Size )
  {
    v2 = 1;
  }
  return HeapReAlloc(hHeap, 0x10u, Block, v2);
}


/* ==== 40D4D4  __msize  ()  size=118 ==== */
size_t __cdecl _msize(void *Block)
{
  size_t v1; // esi
  int v3; // [esp+Ch] [ebp-20h]
  int v4; // [esp+10h] [ebp-1Ch]

  if ( dword_430740 != 3 )
    return HeapSize(hHeap, 0, Block);
  _lock(4);
  v3 = __sbh_find_block(Block);
  v1 = v3 ? *((_DWORD *)Block - 1) - 9 : v4;
  _unlock(4);
  if ( !v3 )
    return HeapSize(hHeap, 0, Block);
  return v1;
}


/* ==== 40D54A  _CPtoLCID  ()  size=47 ==== */
int __usercall CPtoLCID@<eax>(int a1@<eax>)
{
  int v1; // eax
  int v2; // eax
  int v3; // eax

  v1 = a1 - 932;
  if ( !v1 )
    return 1041;
  v2 = v1 - 4;
  if ( !v2 )
    return 2052;
  v3 = v2 - 13;
  if ( !v3 )
    return 1042;
  if ( v3 == 1 )
    return 1028;
  return 0;
}


/* ==== 40D579  _setSBCS  ()  size=41 ==== */
int setSBCS()
{
  int result; // eax

  memset(&byte_431780, 0, 0x100u);
  unk_431880 = 0;
  result = 0;
  CodePage = 0;
  dword_43176C = 0;
  Locale = 0;
  *(_DWORD *)&word_431890 = 0;
  *(_DWORD *)&algn_431892[2] = 0;
  *(_DWORD *)&algn_431892[6] = 0;
  return result;
}


/* ==== 40D5A2  sub_40D5A2  ()  size=411 ==== */
unsigned int sub_40D5A2()
{
  unsigned int i; // eax
  BYTE v1; // al
  BYTE *v2; // edx
  unsigned int v3; // ecx
  BYTE *v4; // edx
  unsigned int result; // eax
  WORD v6; // cx
  char v7; // cl
  char v8; // cl
  _cpinfo CPInfo; // [esp+4h] [ebp-80h] BYREF
  WORD CharType[256]; // [esp+18h] [ebp-6Ch] BYREF
  WCHAR v11[128]; // [esp+218h] [ebp+194h] BYREF
  WCHAR DestStr[128]; // [esp+318h] [ebp+294h] BYREF
  CHAR MultiByteStr[256]; // [esp+418h] [ebp+394h] BYREF

  if ( GetCPInfo(CodePage, &CPInfo) )
  {
    for ( i = 0; i < 0x100; ++i )
      MultiByteStr[i] = i;
    v1 = CPInfo.LeadByte[0];
    MultiByteStr[0] = 32;
    if ( CPInfo.LeadByte[0] )
    {
      v2 = &CPInfo.LeadByte[1];
      do
      {
        v3 = *v2;
        if ( v1 <= v3 )
          memset(&MultiByteStr[v1], 0x20u, v3 - v1 + 1);
        v4 = v2 + 1;
        v1 = *v4;
        v2 = v4 + 1;
      }
      while ( v1 );
    }
    __crtGetStringTypeA(1u, MultiByteStr, 256, CharType, CodePage, Locale, 0);
    sub_4139C9(Locale, 0x100u, MultiByteStr, 256, DestStr, 256, CodePage, 0);
    sub_4139C9(Locale, 0x200u, MultiByteStr, 256, v11, 256, CodePage, 0);
    result = 0;
    while ( 1 )
    {
      v6 = CharType[result];
      if ( (v6 & 1) != 0 )
      {
        byte_431781[result] |= 0x10u;
        v7 = *((_BYTE *)DestStr + result);
      }
      else
      {
        if ( (v6 & 2) == 0 )
        {
          byte_4318A0[result] = 0;
          goto LABEL_16;
        }
        byte_431781[result] |= 0x20u;
        v7 = *((_BYTE *)v11 + result);
      }
      byte_4318A0[result] = v7;
LABEL_16:
      if ( ++result >= 0x100 )
        return result;
    }
  }
  for ( result = 0; result < 0x100; ++result )
  {
    if ( result >= 0x41 && result <= 0x5A )
    {
      byte_431781[result] |= 0x10u;
      v8 = result + 32;
LABEL_22:
      byte_4318A0[result] = v8;
      continue;
    }
    if ( result >= 0x61 && result <= 0x7A )
    {
      byte_431781[result] |= 0x20u;
      v8 = result - 32;
      goto LABEL_22;
    }
    byte_4318A0[result] = 0;
  }
  return result;
}


/* ==== 40D73D  ___updatetmbcinfo  ()  size=111 ==== */
_DWORD *__updatetmbcinfo()
{
  int v0; // edi
  _DWORD *v1; // esi

  _lock(13);
  v0 = _getptd();
  v1 = *(_DWORD **)(v0 + 96);
  if ( v1 != Block )
  {
    if ( v1 )
    {
      if ( (*v1)-- == 1 )
        free(v1);
    }
    *(_DWORD *)(v0 + 96) = Block;
    v1 = Block;
    ++*(_DWORD *)Block;
  }
  _unlock(13);
  return v1;
}


/* ==== 40D7AC  sub_40D7AC  ()  size=404 ==== */
int __cdecl sub_40D7AC(UINT CodePage)
{
  int v1; // edx
  unsigned int i; // eax
  BYTE *v3; // ecx
  BYTE v4; // dl
  unsigned int k; // eax
  _BYTE *v6; // ebx
  unsigned int v7; // eax
  _BYTE *j; // esi
  unsigned __int8 v9; // dl
  unsigned int v10; // edi
  char v11; // dl
  int v12; // eax
  int v13; // ecx
  _DWORD *v14; // ecx
  unsigned int m; // eax
  int v16; // ecx
  unsigned int v18; // [esp+Ch] [ebp-1Ch]
  struct _cpinfo CPInfo; // [esp+10h] [ebp-18h] BYREF

  if ( CodePage )
  {
    v1 = 0;
    for ( i = 0; i < 60; i += 12 )
    {
      if ( dword_42CD68[i] == CodePage )
      {
        memset(&byte_431780, 0, 0x100u);
        v18 = 0;
        unk_431880 = 0;
        v6 = (char *)&unk_42CD78 + 48 * v1;
        do
        {
          LOBYTE(v7) = *v6;
          for ( j = v6; (_BYTE)v7; LOBYTE(v7) = *j )
          {
            v9 = j[1];
            if ( !v9 )
              break;
            v7 = (unsigned __int8)v7;
            v10 = v9;
            if ( (unsigned __int8)v7 <= (unsigned int)v9 )
            {
              v11 = byte_42CD60[v18];
              do
                byte_431781[v7++] |= v11;
              while ( v7 <= v10 );
            }
            j += 2;
          }
          ++v18;
          v6 += 8;
        }
        while ( v18 < 4 );
        ::CodePage = CodePage;
        dword_43176C = 1;
        v12 = CPtoLCID(CodePage);
        v14 = (_DWORD *)((char *)&unk_42CD6C + v13);
        *(_DWORD *)&word_431890 = *v14;
        *(_DWORD *)&algn_431892[2] = v14[1];
        Locale = v12;
        *(_DWORD *)&algn_431892[6] = v14[2];
        goto LABEL_31;
      }
      ++v1;
    }
    if ( GetCPInfo(CodePage, &CPInfo) )
    {
      memset(&byte_431780, 0, 0x100u);
      unk_431880 = 0;
      ::CodePage = CodePage;
      Locale = 0;
      if ( CPInfo.MaxCharSize <= 1 )
      {
        dword_43176C = 0;
      }
      else
      {
        if ( CPInfo.LeadByte[0] )
        {
          v3 = &CPInfo.LeadByte[1];
          do
          {
            v4 = *v3;
            if ( !*v3 )
              break;
            for ( k = *(v3 - 1); k <= v4; ++k )
              byte_431781[k] |= 4u;
            v3 += 2;
          }
          while ( *(v3 - 1) );
        }
        for ( m = 1; m < 0xFF; ++m )
          byte_431781[m] |= 8u;
        Locale = CPtoLCID(CodePage);
        dword_43176C = v16;
      }
      *(_DWORD *)&word_431890 = 0;
      *(_DWORD *)&algn_431892[2] = 0;
      *(_DWORD *)&algn_431892[6] = 0;
      goto LABEL_31;
    }
    if ( dword_430140 )
      goto LABEL_30;
    return -1;
  }
  else
  {
LABEL_30:
    setSBCS();
LABEL_31:
    sub_40D5A2();
    return 0;
  }
}


/* ==== 40D940  __setmbcp  ()  size=336 ==== */
int __cdecl _setmbcp(int CodePage)
{
  UINT OEMCP; // eax
  _DWORD *v2; // esi
  int i; // eax
  int j; // eax
  int k; // eax
  int v7; // [esp+10h] [ebp-20h]
  UINT CodePagea; // [esp+38h] [ebp+8h]

  v7 = -1;
  _lock(13);
  dword_430140 = 0;
  OEMCP = CodePage;
  switch ( CodePage )
  {
    case -2:
      dword_430140 = 1;
      OEMCP = GetOEMCP();
      break;
    case -3:
      dword_430140 = 1;
      OEMCP = GetACP();
      break;
    case -4:
      dword_430140 = 1;
      OEMCP = dword_430500;
      break;
  }
  CodePagea = OEMCP;
  if ( OEMCP == ::CodePage )
  {
    v7 = 0;
  }
  else
  {
    v2 = Block;
    if ( !Block || *(_DWORD *)Block )
      v2 = malloc(0x220u);
    if ( v2 )
    {
      v7 = sub_40D7AC(CodePagea);
      if ( !v7 )
      {
        *v2 = 0;
        v2[1] = ::CodePage;
        v2[2] = dword_43176C;
        v2[3] = Locale;
        for ( i = 0; i < 5; ++i )
          *((_WORD *)v2 + i + 8) = word_431890[i];
        for ( j = 0; j < 257; ++j )
          *((_BYTE *)v2 + j + 28) = byte_431780[j];
        for ( k = 0; k < 256; ++k )
          *((_BYTE *)v2 + k + 285) = byte_4318A0[k];
        Block = v2;
      }
    }
    if ( v7 == -1 && v2 != Block )
      free(v2);
  }
  _unlock(13);
  return v7;
}


/* ==== 40DA90  ___initmbctable  ()  size=30 ==== */
int __initmbctable()
{
  if ( !dword_4319B0 )
  {
    _setmbcp(-3);
    dword_4319B0 = 1;
  }
  return 0;
}


/* ==== 40DAAE  sub_40DAAE  ()  size=215 ==== */
LPVOID __cdecl sub_40DAAE(unsigned int a1, unsigned int a2)
{
  SIZE_T v3; // esi
  LPVOID v4; // edi
  unsigned int Size; // [esp+Ch] [ebp-20h]
  void *v6; // [esp+10h] [ebp-1Ch]

  if ( a1 && 0xFFFFFFE0 / a1 < a2 )
    return 0;
  v3 = a2 * a1;
  Size = a2 * a1;
  if ( !(a2 * a1) )
    v3 = 1;
  while ( 1 )
  {
    v4 = 0;
    if ( v3 <= 0xFFFFFFE0 )
    {
      if ( dword_430740 == 3 )
      {
        v3 = (v3 + 15) & 0xFFFFFFF0;
        if ( Size <= dword_43072C )
        {
          _lock(4);
          v6 = (void *)__sbh_alloc_block(Size);
          _unlock(4);
          v4 = v6;
          if ( !v6 )
          {
LABEL_12:
            v4 = HeapAlloc(hHeap, 8u, v3);
            goto LABEL_13;
          }
          memset(v6, 0, Size);
        }
      }
      if ( v4 )
        return v4;
      goto LABEL_12;
    }
LABEL_13:
    if ( v4 || !dword_43037C )
      return v4;
    if ( !_callnewh(v3) )
      return 0;
  }
}


/* ==== 40DB85  ?TypeMatch@@YAHPBU_s_HandlerType@@PBU_s_CatchableType@@PBU_s_ThrowInfo@@@Z  (TypeMatch(_s_HandlerType const *,_s_CatchableType const *,_s_ThrowInfo const *))  size=79 ==== */
BOOL __usercall TypeMatch@<eax>(int a1@<edi>, int a2@<esi>, const struct _s_HandlerType *a3)
{
  int v3; // eax
  int v4; // ecx
  BOOL result; // eax

  v3 = *(_DWORD *)(a2 + 4);
  result = 1;
  if ( v3 && *(_BYTE *)(v3 + 8) )
  {
    v4 = *(_DWORD *)(a1 + 4);
    if ( v3 != v4 )
    {
      if ( strcmp((const char *)(v3 + 8), (const char *)(v4 + 8)) )
        return 0;
    }
    if ( (*(_BYTE *)a1 & 2) != 0 && (*(_BYTE *)a2 & 8) == 0
      || (a3->adjectives & 1) != 0 && (*(_BYTE *)a2 & 1) == 0
      || (a3->adjectives & 2) != 0 && (*(_BYTE *)a2 & 2) == 0 )
    {
      return 0;
    }
  }
  return result;
}


/* ==== 40DBD4  ?FrameUnwindFilter@@YAHPAU_EXCEPTION_POINTERS@@@Z  (FrameUnwindFilter(_EXCEPTION_POINTERS *))  size=30 ==== */
int __usercall FrameUnwindFilter@<eax>(_DWORD **a1@<eax>)
{
  if ( **a1 == -529697949 )
  {
    *(_DWORD *)(_getptd() + 132) = 0;
    terminate();
  }
  return 0;
}


/* ==== 40DBF2  ___FrameUnwindToState  ()  size=206 ==== */
_DWORD *__cdecl __FrameUnwindToState(int a1, int a2, int a3, int a4)
{
  int v4; // esi
  int v5; // eax
  int v6; // eax
  int *v7; // ecx
  _DWORD *result; // eax

  v4 = *(_DWORD *)(a1 + 8);
  v5 = _getptd();
  ++*(_DWORD *)(v5 + 132);
  while ( v4 != a4 )
  {
    if ( v4 <= -1 || v4 >= *(_DWORD *)(a3 + 4) )
      sub_40E773();
    v6 = 8 * v4;
    v7 = (int *)(8 * v4 + *(_DWORD *)(a3 + 8));
    v4 = *v7;
    if ( v7[1] )
    {
      *(_DWORD *)(a1 + 8) = v4;
      _CallSettingFrame(*(_DWORD *)(*(_DWORD *)(a3 + 8) + v6 + 4), a1, 259);
    }
  }
  result = (_DWORD *)_getptd();
  if ( (int)result[33] > 0 )
  {
    result = (_DWORD *)(_getptd() + 132);
    --*result;
  }
  if ( v4 != a4 )
    sub_40E773();
  *(_DWORD *)(a1 + 8) = v4;
  return result;
}


/* ==== 40DCC0  ___DestructExceptionObject  ()  size=69 ==== */
int __cdecl __DestructExceptionObject(int a1)
{
  int result; // eax
  int v2; // ecx

  result = a1;
  if ( a1 )
  {
    v2 = *(_DWORD *)(*(_DWORD *)(a1 + 28) + 4);
    if ( v2 )
      return sub_40A221(*(_DWORD *)(a1 + 24), v2);
  }
  return result;
}


/* ==== 40DD05  ?AdjustPointer@@YAPAXPAXABUPMD@@@Z  (AdjustPointer(void *,PMD const &))  size=31 ==== */
char *__usercall AdjustPointer@<eax>(int a1@<eax>, _DWORD *a2@<ecx>)
{
  char *result; // eax

  result = (char *)(a1 + *a2);
  if ( (int)a2[1] >= 0 )
    result += a2[1] + *(_DWORD *)(*(_DWORD *)(a2[1] + a1) + a2[2]);
  return result;
}


/* ==== 40DD24  ?CallCatchBlock@@YAPAXPAUEHExceptionRecord@@PAUEHRegistrationNode@@PAU_CONTEXT@@PBU_s_FuncInfo@@PAXHK@Z  (CallCatchBlock(EHExceptionRecord *,EHRegistrationNode *,_CONTEXT *,_s_FuncInfo const *,void *,int,ulong))  size=452 ==== */
void *__cdecl CallCatchBlock(
        struct EHExceptionRecord *a1,
        struct EHRegistrationNode *a2,
        struct _CONTEXT *a3,
        const struct _s_FuncInfo *a4,
        void *a5,
        unsigned int a6)
{
  void *v6; // ecx
  void *v7; // ebx
  unsigned int magicNumber; // eax
  _BYTE v10[8]; // [esp+Ch] [ebp-50h] BYREF
  int v11; // [esp+14h] [ebp-48h]
  int v12; // [esp+18h] [ebp-44h]
  int v13; // [esp+1Ch] [ebp-40h]
  struct FrameInfo *FrameInfo; // [esp+20h] [ebp-3Ch]
  __ehstate_t state; // [esp+24h] [ebp-38h]
  void *v16; // [esp+3Ch] [ebp-20h]
  CPPEH_RECORD ms_exc; // [esp+44h] [ebp-18h]

  v7 = v6;
  v16 = v6;
  v11 = 0;
  state = a2[-1].state;
  FrameInfo = _CreateFrameInfo((struct FrameInfo *)v10, a1->params.pExceptionObject);
  v13 = *(_DWORD *)(_getptd() + 124);
  v12 = *(_DWORD *)(_getptd() + 128);
  *(_DWORD *)(_getptd() + 124) = a1;
  *(_DWORD *)(_getptd() + 128) = a3;
  ms_exc.registration.TryLevel = 1;
  v16 = _CallCatchBlock2(a2, a4, v7, (int)a5, a6);
  ms_exc.registration.TryLevel = -1;
  a2[-1].state = state;
  _FindAndUnlinkFrame(FrameInfo);
  *(_DWORD *)(_getptd() + 124) = v13;
  *(_DWORD *)(_getptd() + 128) = v12;
  if ( a1->ExceptionCode == -529697949 && a1->NumberParameters == 3 )
  {
    magicNumber = a1->params.magicNumber;
    if ( (magicNumber == 429065504 || magicNumber == 429065505)
      && !v11
      && v16
      && IsExceptionObjectToBeDestroyed(a1->params.pExceptionObject) )
    {
      _abnormal_termination();
      __DestructExceptionObject((int)a1);
    }
  }
  return v16;
}


/* ==== 40DEE8  ?BuildCatchObject@@YAXPAUEHExceptionRecord@@PAXPBU_s_HandlerType@@PBU_s_CatchableType@@@Z  (BuildCatchObject(EHExceptionRecord *,void *,_s_HandlerType const *,_s_CatchableType const *))  size=380 ==== */
void __fastcall BuildCatchObject(int a1, char **a2, struct EHExceptionRecord *a3, char *a4)
{
  char **v5; // edi
  int v6; // ecx
  int v7; // ecx
  char *v8; // eax
  char *v9; // eax
  void *v10; // eax
  _DWORD *v11; // ecx
  void *pExceptionObject; // [esp-8h] [ebp-2Ch]
  size_t v13; // [esp-4h] [ebp-28h]

  v5 = a2;
  v6 = *((_DWORD *)a4 + 1);
  if ( v6 )
  {
    if ( *(_BYTE *)(v6 + 8) )
    {
      v7 = *((_DWORD *)a4 + 2);
      if ( v7 || a4[3] < 0 )
      {
        if ( *(int *)a4 >= 0 )
          v5 = (char **)((char *)a2 + v7 + 12);
        pExceptionObject = a3->params.pExceptionObject;
        if ( (*(_DWORD *)a4 & 8) != 0 )
        {
          if ( _ValidateRead(pExceptionObject, 1u) && _ValidateWrite(v5, 1u) )
          {
            v8 = (char *)a3->params.pExceptionObject;
            *v5 = v8;
LABEL_11:
            *v5 = AdjustPointer((int)v8, (_DWORD *)(a1 + 8));
            return;
          }
LABEL_28:
          sub_40E773();
        }
        if ( (*(_BYTE *)a1 & 1) != 0 )
        {
          if ( !_ValidateRead(pExceptionObject, 1u) || !_ValidateWrite(v5, 1u) )
            goto LABEL_28;
          memcpy(v5, a3->params.pExceptionObject, *(_DWORD *)(a1 + 20));
          if ( *(_DWORD *)(a1 + 20) == 4 )
          {
            v8 = *v5;
            if ( *v5 )
              goto LABEL_11;
          }
        }
        else if ( *(_DWORD *)(a1 + 24) )
        {
          if ( !_ValidateRead(pExceptionObject, 1u)
            || !_ValidateWrite(v5, 1u)
            || !_ValidateExecute(*(FARPROC *)(a1 + 24)) )
          {
            goto LABEL_28;
          }
          v10 = a3->params.pExceptionObject;
          v11 = (_DWORD *)(a1 + 8);
          if ( (*(_BYTE *)a1 & 4) != 0 )
          {
            AdjustPointer((int)v10, v11);
            sub_40A221((int)v5, *(_DWORD *)(a1 + 24));
          }
          else
          {
            AdjustPointer((int)v10, v11);
            sub_40A221((int)v5, *(_DWORD *)(a1 + 24));
          }
        }
        else
        {
          if ( !_ValidateRead(pExceptionObject, 1u) || !_ValidateWrite(v5, 1u) )
            goto LABEL_28;
          v13 = *(_DWORD *)(a1 + 20);
          v9 = AdjustPointer((int)a3->params.pExceptionObject, (_DWORD *)(a1 + 8));
          memcpy(v5, v9, v13);
        }
      }
    }
  }
}


/* ==== 40E064  ?CatchIt@@YAXPAUEHExceptionRecord@@PAUEHRegistrationNode@@PAU_CONTEXT@@PAXPBU_s_FuncInfo@@PBU_s_HandlerType@@PBU_s_CatchableType@@PBU_s_TryBlockMapEntry@@H1E@Z  (CatchIt(EHExceptionRecord *,EHRegistrationNode *,_CONTEXT *,void *,_s_FuncInfo const *,_s_HandlerType const *,_s_CatchableType const *,_s_TryBlockMapEntry const *,int,EHRegistrationNode *,uchar))  size=103 ==== */
void __usercall CatchIt(
        int a1@<ecx>,
        char *a2@<ebx>,
        int *a3@<edi>,
        int a4@<esi>,
        struct EHExceptionRecord *ExceptionRecord,
        struct _CONTEXT *a6,
        struct _CONTEXT *a7,
        struct _s_FuncInfo *a8,
        struct _s_FuncInfo *a9,
        struct _s_HandlerType *TargetFrame)
{
  void (__stdcall *v10)(void *, struct EHRegistrationNode *); // eax

  if ( a1 )
    BuildCatchObject(a1, (char **)a4, ExceptionRecord, a2);
  if ( TargetFrame )
    _UnwindNestedFrames((struct _EXCEPTION_REGISTRATION_RECORD **)a2, TargetFrame, (PEXCEPTION_RECORD)ExceptionRecord);
  else
    _UnwindNestedFrames((struct _EXCEPTION_REGISTRATION_RECORD **)a2, (PVOID)a4, (PEXCEPTION_RECORD)ExceptionRecord);
  __FrameUnwindToState(a4, (int)a7, (int)a8, *a3);
  *(_DWORD *)(a4 + 8) = a3[1] + 1;
  v10 = (void (__stdcall *)(void *, struct EHRegistrationNode *))CallCatchBlock(
                                                                   ExceptionRecord,
                                                                   (struct EHRegistrationNode *)a4,
                                                                   a6,
                                                                   a8,
                                                                   a9,
                                                                   0x100u);
  if ( v10 )
    _JumpToContinuation(v10, (struct EHRegistrationNode *)a4);
}


/* ==== 40E0CB  ?FindHandlerForForeignException@@YAXPAUEHExceptionRecord@@PAUEHRegistrationNode@@PAU_CONTEXT@@PAXPBU_s_FuncInfo@@HH1@Z  (FindHandlerForForeignException(EHExceptionRecord *,EHRegistrationNode *,_CONTEXT *,void *,_s_FuncInfo const *,int,int,EHRegistrationNode *))  size=190 ==== */
void __cdecl FindHandlerForForeignException(
        struct EHExceptionRecord *a1,
        struct EHRegistrationNode *a2,
        struct EHRegistrationNode *a3,
        struct _CONTEXT *a4,
        struct _s_FuncInfo *a5,
        int a6,
        struct _s_FuncInfo *a7,
        struct EHRegistrationNode *a8)
{
  int v8; // esi
  TryBlockMapEntry *i; // edi
  int v10; // eax
  int v11; // ecx
  unsigned int v12; // [esp+4h] [ebp-8h] BYREF
  unsigned int v13; // [esp+8h] [ebp-4h] BYREF

  if ( a1->ExceptionCode != -2147483645
    && (!*(_DWORD *)(_getptd() + 116) || !_CallSETranslator(a1, a2, a3, a4, a5, (int)a7, a8)) )
  {
    v8 = a6;
    for ( i = _GetRangeOfTrysToCheck(a5, (int)a7, a6, &v13, &v12); v13 < v12; ++i )
    {
      if ( v8 >= i->tryLow && v8 <= i->tryHigh )
      {
        v10 = (int)i->pHandlerArray + 16 * i->nCatches;
        v11 = *(_DWORD *)(v10 - 12);
        if ( !v11 || !*(_BYTE *)(v11 + 8) )
        {
          CatchIt(
            0,
            (char *)(v10 - 16),
            &i->tryLow,
            (int)a2,
            a1,
            (struct _CONTEXT *)a3,
            a4,
            a5,
            a7,
            (struct _s_HandlerType *)a8);
          v8 = a6;
        }
      }
      ++v13;
    }
  }
}


/* ==== 40E189  ?FindHandler@@YAXPAUEHExceptionRecord@@PAUEHRegistrationNode@@PAU_CONTEXT@@PAXPBU_s_FuncInfo@@EH1@Z  (FindHandler(EHExceptionRecord *,EHRegistrationNode *,_CONTEXT *,void *,_s_FuncInfo const *,uchar,int,EHRegistrationNode *))  size=516 ==== */
void __cdecl FindHandler(
        struct EHExceptionRecord *a1,
        struct EHRegistrationNode *a2,
        struct EHRegistrationNode *a3,
        struct _CONTEXT *a4,
        struct _s_FuncInfo *a5,
        unsigned __int8 a6,
        struct _s_FuncInfo *a7,
        struct EHRegistrationNode *a8)
{
  __ehstate_t state; // eax
  struct EHExceptionRecord *v9; // ebx
  unsigned int magicNumber; // eax
  struct EHExceptionRecord *v11; // esi
  unsigned int v12; // eax
  unsigned int v13; // eax
  int v14; // esi
  TryBlockMapEntry *v15; // eax
  char *pHandlerArray; // esi
  CatchableTypeArray *pCatchableTypeArray; // ecx
  int *arrayOfCatchableTypes; // edx
  int nCatchableTypes; // ecx
  int *p_tryLow; // edi
  int v21; // [esp+0h] [ebp-24h]
  unsigned int v22; // [esp+4h] [ebp-20h] BYREF
  int v23; // [esp+8h] [ebp-1Ch]
  int nCatches; // [esp+Ch] [ebp-18h]
  int v25; // [esp+10h] [ebp-14h]
  int *v26; // [esp+14h] [ebp-10h]
  unsigned int v27; // [esp+18h] [ebp-Ch] BYREF
  TryBlockMapEntry *v28; // [esp+1Ch] [ebp-8h]
  char v29; // [esp+23h] [ebp-1h]

  state = a2->state;
  v29 = 0;
  v23 = state;
  if ( state < -1 || state >= a5->maxState )
    sub_40E773();
  v9 = a1;
  if ( a1->ExceptionCode != -529697949 )
    goto LABEL_41;
  if ( a1->NumberParameters == 3 )
  {
    magicNumber = a1->params.magicNumber;
    if ( (magicNumber == 429065504 || magicNumber == 429065505) && !a1->params.pThrowInfo )
    {
      if ( !*(_DWORD *)(_getptd() + 124) )
        return;
      v11 = *(struct EHExceptionRecord **)(_getptd() + 124);
      a1 = v11;
      a3 = *(struct EHRegistrationNode **)(_getptd() + 128);
      v29 = 1;
      if ( !_ValidateRead(v11, 1u) )
        sub_40E773();
      if ( v11->ExceptionCode != -529697949 )
      {
        v9 = v11;
LABEL_41:
        if ( a6 )
          terminate();
        FindHandlerForForeignException(v9, a2, a3, a4, a5, v23, a7, a8);
        return;
      }
      if ( v11->NumberParameters == 3 )
      {
        v12 = v11->params.magicNumber;
        if ( (v12 == 429065504 || v12 == 429065505) && !v11->params.pThrowInfo )
          sub_40E773();
      }
      v9 = v11;
    }
  }
  if ( v9->ExceptionCode != -529697949 )
    goto LABEL_41;
  if ( v9->NumberParameters != 3 )
    goto LABEL_41;
  v13 = v9->params.magicNumber;
  if ( v13 != 429065504 && v13 != 429065505 )
    goto LABEL_41;
  v14 = v23;
  v15 = _GetRangeOfTrysToCheck(a5, (int)a7, v23, &v27, &v22);
  v28 = v15;
  if ( v27 < v22 )
  {
    while ( 1 )
    {
      if ( v15->tryLow <= v14 && v14 <= v15->tryHigh )
      {
        pHandlerArray = (char *)v15->pHandlerArray;
        nCatches = v15->nCatches;
        if ( nCatches > 0 )
        {
          while ( 1 )
          {
            pCatchableTypeArray = v9->params.pThrowInfo->pCatchableTypeArray;
            arrayOfCatchableTypes = (int *)pCatchableTypeArray->arrayOfCatchableTypes;
            nCatchableTypes = pCatchableTypeArray->nCatchableTypes;
            v26 = arrayOfCatchableTypes;
            v25 = nCatchableTypes;
            if ( nCatchableTypes > 0 )
              break;
LABEL_33:
            --nCatches;
            pHandlerArray += 16;
            if ( nCatches <= 0 )
              goto LABEL_36;
          }
          while ( 1 )
          {
            v21 = *v26;
            if ( TypeMatch(*v26, (int)pHandlerArray, (const struct _s_HandlerType *)v9->params.pThrowInfo) )
              break;
            --v25;
            ++v26;
            if ( v25 <= 0 )
            {
              v15 = v28;
              goto LABEL_33;
            }
          }
          p_tryLow = &v28->tryLow;
          CatchIt(
            v21,
            pHandlerArray,
            &v28->tryLow,
            (int)a2,
            v9,
            (struct _CONTEXT *)a3,
            a4,
            a5,
            a7,
            (struct _s_HandlerType *)a8);
          v9 = a1;
          v15 = (TryBlockMapEntry *)p_tryLow;
        }
      }
LABEL_36:
      ++v27;
      v28 = ++v15;
      if ( v27 >= v22 )
        break;
      v14 = v23;
    }
  }
  if ( a6 )
    __DestructExceptionObject((int)v9);
}


/* ==== 40E38D  ___InternalCxxFrameHandler  ()  size=162 ==== */
int __cdecl __InternalCxxFrameHandler(
        struct EHExceptionRecord *a1,
        struct EHRegistrationNode *a2,
        struct EHRegistrationNode *a3,
        struct _CONTEXT *a4,
        struct _s_FuncInfo *a5,
        struct _s_FuncInfo *a6,
        struct EHRegistrationNode *a7,
        unsigned __int8 a8)
{
  int (__cdecl *pForwardCompat)(); // ecx

  if ( (*(_DWORD *)a5 & 0x1FFFFFFF) != 0x19930520 )
    sub_40E773();
  if ( (a1->ExceptionFlags & 0x66) != 0 )
  {
    if ( a5->maxState )
    {
      if ( !a6 )
        __FrameUnwindToState((int)a2, (int)a4, (int)a5, -1);
    }
  }
  else if ( a5->nTryBlocks )
  {
    if ( a1->ExceptionCode == -529697949 && a1->params.magicNumber > 0x19930520 )
    {
      pForwardCompat = a1->params.pThrowInfo->pForwardCompat;
      if ( pForwardCompat )
        return ((int (__cdecl *)(struct EHExceptionRecord *, struct EHRegistrationNode *, struct EHRegistrationNode *, struct _CONTEXT *, struct _s_FuncInfo *, struct _s_FuncInfo *, struct EHRegistrationNode *, _DWORD))pForwardCompat)(
                 a1,
                 a2,
                 a3,
                 a4,
                 a5,
                 a6,
                 a7,
                 a8);
    }
    FindHandler(a1, a2, a3, a4, a5, a8, a6, a7);
  }
  return 1;
}


/* ==== 40E42F  ___crtTlsAlloc@4  (__crtTlsAlloc(x))  size=9 ==== */
// attributes: thunk
DWORD __stdcall __crtTlsAlloc(int a1)
{
  return TlsAlloc();
}


/* ==== 40E438  __mtterm  ()  size=29 ==== */
int _mtterm()
{
  if ( dword_42CE5C != -1 )
  {
    dword_430150(dword_42CE5C);
    dword_42CE5C = -1;
  }
  return _mtdeletelocks();
}


/* ==== 40E455  __initptd  ()  size=19 ==== */
int __cdecl _initptd(int a1)
{
  int result; // eax

  result = a1;
  *(_DWORD *)(a1 + 84) = &unk_42CE70;
  *(_DWORD *)(a1 + 20) = 1;
  return result;
}


/* ==== 40E468  __getptd  ()  size=113 ==== */
DWORD *__cdecl _getptd()
{
  DWORD LastError; // ebx
  DWORD *v1; // esi
  DWORD *v2; // eax
  DWORD CurrentThreadId; // eax

  LastError = GetLastError();
  v1 = (DWORD *)dword_430148(dword_42CE5C);
  if ( !v1 )
  {
    v2 = (DWORD *)sub_40DAAE(1u, 0x8Cu);
    v1 = v2;
    if ( !v2 || !dword_43014C(dword_42CE5C, v2) )
      _amsg_exit(16);
    v1[21] = (DWORD)&unk_42CE70;
    v1[5] = 1;
    CurrentThreadId = GetCurrentThreadId();
    v1[1] = -1;
    *v1 = CurrentThreadId;
  }
  SetLastError(LastError);
  return v1;
}


/* ==== 40E4D9  __freefls@4  (_freefls(x))  size=327 ==== */
void __stdcall _freefls(void **Block)
{
  _DWORD *v1; // eax
  _DWORD **v3; // eax
  int savedregs; // [esp+2Ch] [ebp+0h]

  if ( Block )
  {
    if ( Block[9] )
      free(Block[9]);
    if ( Block[11] )
      free(Block[11]);
    if ( Block[13] )
      free(Block[13]);
    if ( Block[15] )
      free(Block[15]);
    if ( Block[17] )
      free(Block[17]);
    if ( Block[18] )
      free(Block[18]);
    if ( Block[21] != &unk_42CE70 )
      free(Block[21]);
    _lock(13);
    v1 = Block[24];
    if ( v1 )
    {
      if ( (*v1)-- == 1 && v1 != ::Block )
        free(v1);
    }
    _unlock(13);
    _lock(12);
    v3 = (_DWORD **)Block[25];
    if ( v3 )
    {
      *v3 = (_DWORD *)((char *)*v3 - 1);
      if ( v3[11] )
        --*v3[11];
      if ( v3[13] )
        --*v3[13];
      if ( v3[12] )
        --*v3[12];
      if ( v3[16] )
        --*v3[16];
      --v3[19][45];
      if ( v3 != (_DWORD **)off_42D00C && v3 != (_DWORD **)&unk_42CFB8 && !*v3 )
        __freetlocinfo(v3);
    }
    savedregs = 4253175;
    _unlock(12);
    free(Block);
  }
}


/* ==== 40E620  __freeptd  ()  size=47 ==== */
void __cdecl _freeptd(void **Block)
{
  void **v1; // eax

  if ( dword_42CE5C != -1 )
  {
    v1 = Block;
    if ( !Block )
      v1 = (void **)dword_430148(dword_42CE5C);
    _freefls(v1);
    dword_43014C(dword_42CE5C, 0);
  }
}


/* ==== 40E64F  __mtinit  ()  size=239 ==== */
int _mtinit()
{
  HMODULE ModuleHandleA; // eax
  HMODULE v1; // edi
  DWORD *v2; // eax
  DWORD *v3; // esi
  DWORD CurrentThreadId; // eax

  if ( !_mtinitlocks() )
    goto LABEL_9;
  ModuleHandleA = GetModuleHandleA("kernel32.dll");
  v1 = ModuleHandleA;
  if ( ModuleHandleA )
  {
    FlsAlloc = (DWORD (__stdcall *)(PFLS_CALLBACK_FUNCTION))GetProcAddress(ModuleHandleA, "FlsAlloc");
    FlsGetValue = (PVOID (__stdcall *)(DWORD))GetProcAddress(v1, "FlsGetValue");
    FlsSetValue = (BOOL (__stdcall *)(DWORD, PVOID))GetProcAddress(v1, "FlsSetValue");
    FlsFree = (BOOL (__stdcall *)(DWORD))GetProcAddress(v1, "FlsFree");
    if ( !FlsGetValue )
    {
      FlsGetValue = TlsGetValue;
      FlsSetValue = TlsSetValue;
      FlsAlloc = (DWORD (__stdcall *)(PFLS_CALLBACK_FUNCTION))__crtTlsAlloc;
      FlsFree = TlsFree;
    }
  }
  dword_42CE5C = FlsAlloc((PFLS_CALLBACK_FUNCTION)_freefls);
  if ( dword_42CE5C != -1 && (v2 = (DWORD *)sub_40DAAE(1u, 0x8Cu), (v3 = v2) != 0) && FlsSetValue(dword_42CE5C, v2) )
  {
    v3[21] = (DWORD)&unk_42CE70;
    v3[5] = 1;
    CurrentThreadId = GetCurrentThreadId();
    v3[1] = -1;
    *v3 = CurrentThreadId;
    return 1;
  }
  else
  {
LABEL_9:
    _mtterm();
    return 0;
  }
}


/* ==== 40E73E  ?terminate@@YAXXZ  (terminate(void))  size=53 ==== */
void __cdecl __noreturn terminate()
{
  DWORD *v0; // eax

  if ( _getptd()[27] )
  {
    v0 = _getptd();
    ((void (*)(void))v0[27])();
  }
  abort();
}


/* ==== 40E773  sub_40E773  ()  size=45 ==== */
void __noreturn sub_40E773()
{
  if ( off_42CE60 )
    off_42CE60();
  terminate();
}


/* ==== 40E7A0  __CallSettingFrame@12  (_CallSettingFrame(x,x,x))  size=76 ==== */
void __stdcall _CallSettingFrame(int a1, int a2, int a3)
{
  void (*v3)(void); // eax
  int v4; // ecx

  _NLG_Notify1(a3);
  v3();
  v4 = a3;
  if ( a3 == 256 )
    v4 = 2;
  _NLG_Notify1(v4);
}


/* ==== 40E7EC  ___security_init_cookie  ()  size=102 ==== */
void __cdecl __security_init_cookie()
{
  DWORD v0; // esi
  DWORD v1; // esi
  DWORD v2; // esi
  DWORD v3; // esi
  LARGE_INTEGER PerformanceCount; // [esp+0h] [ebp-10h] BYREF
  _FILETIME SystemTimeAsFileTime; // [esp+8h] [ebp-8h] BYREF

  if ( !__security_cookie || __security_cookie == -1153374642 )
  {
    GetSystemTimeAsFileTime(&SystemTimeAsFileTime);
    v0 = SystemTimeAsFileTime.dwLowDateTime ^ SystemTimeAsFileTime.dwHighDateTime;
    v1 = GetCurrentProcessId() ^ v0;
    v2 = GetCurrentThreadId() ^ v1;
    v3 = GetTickCount() ^ v2;
    QueryPerformanceCounter(&PerformanceCount);
    __security_cookie = PerformanceCount.LowPart ^ PerformanceCount.HighPart ^ v3;
    if ( !__security_cookie )
      __security_cookie = -1153374642;
  }
}


/* ==== 40E852  sub_40E852  ()  size=331 ==== */
void __cdecl __noreturn sub_40E852(int a1, int a2)
{
  const char *v2; // edi
  int v3; // esi
  char *v4; // ebx
  void *v5; // esp
  _BYTE v6[33]; // [esp-21h] [ebp-155h] BYREF
  char v7[12]; // [esp+0h] [ebp-134h] BYREF
  char *Source; // [esp+Ch] [ebp-128h]
  CHAR Filename[264]; // [esp+10h] [ebp-124h] BYREF
  CPPEH_RECORD ms_exc; // [esp+11Ch] [ebp-18h]

  if ( dword_430154 )
  {
    dword_430154(a1, a2);
    ms_exc.registration.TryLevel = -1;
  }
  else
  {
    if ( a1 == 1 )
    {
      v2 = "Buffer overrun detected!";
      Source = "A buffer overrun has been detected which has corrupted the program's\n"
               "internal state.  The program cannot safely continue execution and must\n"
               "now be terminated.\n";
      v3 = 185;
    }
    else
    {
      v2 = "Unknown security failure detected!";
      Source = "A security error of unknown cause has been detected which has\n"
               "corrupted the program's internal state.  The program cannot safely\n"
               "continue execution and must now be terminated.\n";
      v3 = 212;
    }
    Filename[260] = 0;
    if ( !GetModuleFileNameA(0, Filename, 0x104u) )
      strcpy(Filename, "<program name unknown>");
    v4 = Filename;
    if ( strlen(Filename) + 11 > 0x3C )
    {
      v4 = &v6[strlen(Filename)];
      strncpy(v4, "...", 3u);
    }
    v5 = alloca(strlen(v4) + v3 + 12);
    ms_exc.old_esp = (DWORD)v7;
    strcpy(v7, v2);
    strcat(v7, "\n\n");
    strcat(v7, "Program: ");
    strcat(v7, v4);
    strcat(v7, "\n\n");
    strcat(v7, Source);
    __crtMessageBoxA(v7, "Microsoft Visual C++ Runtime Library", 8208);
  }
  _exit(3);
}


/* ==== 40E99D  __XcptFilter  ()  size=356 ==== */
LONG __cdecl _XcptFilter(int a1, struct _EXCEPTION_POINTERS *ExceptionInfo)
{
  DWORD *v2; // esi
  int *v3; // edx
  int *v4; // ecx
  void (__cdecl *v5)(int); // ebx
  int v7; // eax
  int v8; // edx
  int v9; // eax
  int v10; // ecx
  DWORD v11; // edi
  DWORD v12; // [esp+Ch] [ebp-4h]

  v2 = _getptd();
  v3 = (int *)v2[21];
  v4 = v3;
  do
  {
    if ( *v4 == a1 )
      break;
    v4 += 3;
  }
  while ( v4 < &v3[3 * dword_42CEF4] );
  if ( v4 >= &v3[3 * dword_42CEF4] || *v4 != a1 )
    v4 = 0;
  if ( !v4 )
    return UnhandledExceptionFilter(ExceptionInfo);
  v5 = (void (__cdecl *)(int))v4[2];
  if ( !v5 )
    return UnhandledExceptionFilter(ExceptionInfo);
  if ( v5 == (void (__cdecl *)(int))5 )
  {
    v4[2] = 0;
    return 1;
  }
  else
  {
    if ( v5 != (void (__cdecl *)(int))1 )
    {
      v12 = v2[22];
      v2[22] = (DWORD)ExceptionInfo;
      v7 = v4[1];
      if ( v7 == 8 )
      {
        v8 = dword_42CEE8;
        if ( dword_42CEE8 < dword_42CEE8 + dword_42CEEC )
        {
          v9 = 12 * dword_42CEE8;
          do
          {
            *(_DWORD *)(v9 + v2[21] + 8) = 0;
            ++v8;
            v9 += 12;
          }
          while ( v8 < dword_42CEE8 + dword_42CEEC );
        }
        v10 = *v4;
        v11 = v2[23];
        switch ( v10 )
        {
          case -1073741682:
            v2[23] = 131;
            break;
          case -1073741680:
            v2[23] = 129;
            break;
          case -1073741679:
            v2[23] = 132;
            break;
          case -1073741677:
            v2[23] = 133;
            break;
          case -1073741683:
            v2[23] = 130;
            break;
          case -1073741681:
            v2[23] = 134;
            break;
          case -1073741678:
            v2[23] = 138;
            break;
        }
        v5(8);
        v2[23] = v11;
      }
      else
      {
        v4[2] = 0;
        v5(v7);
      }
      v2[22] = v12;
    }
    return -1;
  }
}


/* ==== 40EB01  __flsbuf  ()  size=281 ==== */
int __cdecl _flsbuf(int Ch, FILE *File)
{
  FILE *v2; // esi
  int flag; // eax
  int v4; // ebx
  int v5; // eax
  unsigned int v6; // eax
  char *base; // eax
  char *ptr; // edi
  signed int v9; // edi
  _BYTE *v10; // eax

  v2 = File;
  flag = File->_flag;
  v4 = File->_file;
  if ( (flag & 0x82) == 0 || (flag & 0x40) != 0 )
    goto LABEL_24;
  if ( (flag & 1) == 0 )
    goto LABEL_6;
  File->_cnt = 0;
  if ( (flag & 0x10) == 0 )
  {
LABEL_24:
    v2->_flag = flag | 0x20;
    return -1;
  }
  v2->_ptr = v2->_base;
  v2->_flag = flag & 0xFFFFFFFE;
LABEL_6:
  v5 = v2->_flag;
  v2->_cnt = 0;
  File = 0;
  v6 = v5 & 0xFFFFFFED | 2;
  v2->_flag = v6;
  if ( (v6 & 0x10C) == 0 && (v2 != (FILE *)&unk_42D1D0 && v2 != (FILE *)&unk_42D1F0 || !_isatty(v4)) )
    _getbuf(v2);
  if ( (v2->_flag & 0x108) != 0 )
  {
    base = v2->_base;
    ptr = v2->_ptr;
    v2->_ptr = base + 1;
    v9 = ptr - base;
    v2->_cnt = v2->_bufsiz - 1;
    if ( v9 <= 0 )
    {
      if ( v4 == -1 )
        v10 = &unk_42D608;
      else
        v10 = (_BYTE *)(dword_430620[v4 >> 5] + 36 * (v4 & 0x1F));
      if ( (v10[4] & 0x20) != 0 )
        _lseek(v4, 0, 2);
    }
    else
    {
      File = (FILE *)sub_413743(v4, base, v9);
    }
    *v2->_base = Ch;
  }
  else
  {
    v9 = 1;
    File = (FILE *)sub_413743(v4, &Ch, 1u);
  }
  if ( File == (FILE *)v9 )
    return (unsigned __int8)Ch;
  v2->_flag |= 0x20u;
  return -1;
}


/* ==== 40EC1A  _write_char  ()  size=51 ==== */
int __usercall write_char@<eax>(FILE *File@<ecx>, int result@<eax>, _DWORD *a3@<esi>)
{
  bool v3; // sf

  if ( ((File->_flag & 0x40) == 0 || File->_base)
    && ((v3 = File->_cnt - 1 < 0, --File->_cnt, v3)
      ? (result = _flsbuf((char)result, File))
      : (*File->_ptr = result, ++File->_ptr, result = (unsigned __int8)result),
        result == -1) )
  {
    *a3 = -1;
  }
  else
  {
    ++*a3;
  }
  return result;
}


/* ==== 40EC4D  _write_multi_char  ()  size=36 ==== */
_DWORD *__usercall write_multi_char@<eax>(_DWORD *result@<eax>, char a2, int a3, FILE *File)
{
  _DWORD *v4; // esi

  v4 = result;
  do
  {
    if ( a3 <= 0 )
      break;
    LOBYTE(result) = a2;
    --a3;
    result = (_DWORD *)write_char(File, (int)result, v4);
  }
  while ( *v4 != -1 );
  return result;
}


/* ==== 40EC71  _write_string  ()  size=55 ==== */
int __usercall write_string@<eax>(int result@<eax>, _BYTE *a2@<ecx>, int a3@<edi>, int a4)
{
  _DWORD *v4; // esi

  v4 = (_DWORD *)result;
  if ( (*(_BYTE *)(a3 + 12) & 0x40) == 0 || *(_DWORD *)(a3 + 8) )
  {
    do
    {
      if ( a4 <= 0 )
        break;
      LOBYTE(result) = *a2;
      --a4;
      result = write_char((FILE *)a3, result, v4);
      ++a2;
    }
    while ( *v4 != -1 );
  }
  else
  {
    result = a4;
    *v4 += a4;
  }
  return result;
}


/* ==== 40ECA8  sub_40ECA8  ()  size=1946 ==== */
int __cdecl sub_40ECA8(FILE *a1, char *a2, __int64 *a3)
{
  char v3; // bl
  int v4; // ecx
  char *v5; // edi
  char *v6; // edi
  int v7; // eax
  char v8; // al
  int v9; // eax
  int v10; // ecx
  char *v11; // eax
  char *v12; // eax
  __int64 v13; // rax
  __int16 *v14; // eax
  char *v15; // ecx
  int v16; // eax
  char *v17; // eax
  char *j; // eax
  _WORD *v19; // eax
  unsigned int v20; // ebx
  unsigned int v21; // edi
  char *i; // esi
  int v23; // eax
  int v24; // ecx
  unsigned __int64 v25; // kr08_8
  char *v26; // eax
  char *v27; // esi
  char v28; // bl
  int v29; // esi
  wchar_t *v30; // ebx
  int v31; // eax
  int v33; // [esp+10h] [ebp-74h]
  int v34; // [esp+14h] [ebp-70h]
  char v35; // [esp+1Ch] [ebp-68h]
  int v36; // [esp+20h] [ebp-64h]
  int v37; // [esp+28h] [ebp-5Ch]
  int v38; // [esp+2Ch] [ebp-58h]
  char *v39; // [esp+34h] [ebp-50h]
  int v40; // [esp+38h] [ebp-4Ch]
  _BYTE v41[4]; // [esp+3Ch] [ebp-48h] BYREF
  int v42; // [esp+40h] [ebp-44h] BYREF
  int v43; // [esp+44h] [ebp-40h]
  char *v44; // [esp+48h] [ebp-3Ch]
  int v45; // [esp+4Ch] [ebp-38h]
  __int64 *v46; // [esp+50h] [ebp-34h]
  int v47; // [esp+54h] [ebp-30h]
  char MbCh[511]; // [esp+58h] [ebp-2Ch] BYREF
  char v49; // [esp+257h] [ebp+1D3h] BYREF
  char v50[8]; // [esp+258h] [ebp+1D4h] BYREF

  v3 = *a2;
  v46 = a3;
  v4 = 0;
  v43 = 0;
  v42 = 0;
  if ( v3 )
  {
    v5 = a2;
    while ( 1 )
    {
      v6 = v5 + 1;
      v39 = v6;
      if ( v42 < 0 )
        return v42;
      if ( v3 < 32 || v3 > 120 )
        v7 = 0;
      else
        v7 = aUnknownSecurit[v3 + 20] & 0xF;
      v34 = byte_427518[8 * v7 + v4] >> 4;
      switch ( v34 )
      {
        case 0:
          goto LABEL_50;
        case 1:
          v45 = -1;
          v36 = 0;
          v38 = 0;
          v40 = 0;
          v47 = 0;
          v37 = 0;
          goto LABEL_182;
        case 2:
          switch ( v3 )
          {
            case ' ':
              v47 |= 2u;
              break;
            case '#':
              LOBYTE(v47) = v47 | 0x80;
              break;
            case '+':
              v47 |= 1u;
              break;
            case '-':
              v47 |= 4u;
              break;
            case '0':
              v47 |= 8u;
              break;
          }
          goto LABEL_182;
        case 3:
          if ( v3 == 42 )
          {
            v46 = (__int64 *)((char *)v46 + 4);
            v38 = *((_DWORD *)v46 - 1);
            if ( v38 < 0 )
            {
              v47 |= 4u;
              v38 = -v38;
            }
          }
          else
          {
            v38 = v3 + 10 * v38 - 48;
          }
          goto LABEL_182;
        case 4:
          v45 = 0;
          goto LABEL_182;
        case 5:
          if ( v3 == 42 )
          {
            v46 = (__int64 *)((char *)v46 + 4);
            v45 = *((_DWORD *)v46 - 1);
            if ( v45 < 0 )
              v45 = -1;
          }
          else
          {
            v45 = v3 + 10 * v45 - 48;
          }
          goto LABEL_182;
        case 6:
          switch ( v3 )
          {
            case 'I':
              v8 = *v6;
              if ( *v6 == 54 && v6[1] == 52 )
              {
                BYTE1(v47) |= 0x80u;
                v39 = v6 + 2;
              }
              else if ( v8 == 51 && v6[1] == 50 )
              {
                BYTE1(v47) &= ~0x80u;
                v39 = v6 + 2;
              }
              else if ( v8 != 100 && v8 != 105 && v8 != 111 && v8 != 117 && v8 != 120 && v8 != 88 )
              {
                v34 = 0;
LABEL_50:
                v37 = 0;
                v9 = (unsigned __int8)v3;
                if ( (off_42D640[(unsigned __int8)v3] & 0x8000u) != 0 )
                {
                  LOBYTE(v9) = v3;
                  v9 = write_char(a1, v9, &v42);
                  v3 = *v6;
                  v39 = v6 + 1;
                }
                LOBYTE(v9) = v3;
                write_char(a1, v9, &v42);
              }
              break;
            case 'h':
              v47 |= 0x20u;
              break;
            case 'l':
              v47 |= 0x10u;
              break;
            case 'w':
              BYTE1(v47) |= 8u;
              break;
          }
          goto LABEL_182;
        case 7:
          if ( v3 > 103 )
          {
            switch ( v3 )
            {
              case 'i':
                goto LABEL_80;
              case 'n':
                v46 = (__int64 *)((char *)v46 + 4);
                v19 = (_WORD *)*((_DWORD *)v46 - 1);
                if ( (v47 & 0x20) != 0 )
                  *v19 = v42;
                else
                  *(_DWORD *)v19 = v42;
                v36 = 1;
                goto LABEL_182;
              case 'o':
                v43 = 8;
                if ( (v47 & 0x80u) != 0 )
                  BYTE1(v47) |= 2u;
                break;
              default:
                switch ( v3 )
                {
                  case 'p':
                    v45 = 8;
LABEL_121:
                    v35 = 7;
                    break;
                  case 's':
                    goto LABEL_63;
                  case 'u':
                    goto LABEL_81;
                  case 'x':
                    v35 = 39;
                    break;
                  default:
                    goto LABEL_159;
                }
                v43 = 16;
                if ( (v47 & 0x80u) != 0 )
                {
                  v41[0] = 48;
                  v41[1] = v35 + 81;
                  v40 = 2;
                }
                break;
            }
LABEL_82:
            if ( (v47 & 0x8000) != 0 )
            {
              v13 = *v46++;
            }
            else
            {
              v46 = (__int64 *)((char *)v46 + 4);
              if ( (v47 & 0x20) != 0 )
              {
                if ( (v47 & 0x40) != 0 )
                  LODWORD(v13) = *((__int16 *)v46 - 2);
                else
                  LODWORD(v13) = *((unsigned __int16 *)v46 - 2);
              }
              else
              {
                LODWORD(v13) = *((_DWORD *)v46 - 1);
                if ( (v47 & 0x40) == 0 )
                {
                  HIDWORD(v13) = 0;
                  goto LABEL_137;
                }
              }
              v13 = (int)v13;
            }
LABEL_137:
            if ( (v47 & 0x40) != 0 && v13 < 0 )
            {
              v13 = -v13;
              BYTE1(v47) |= 1u;
            }
            v21 = HIDWORD(v13);
            v20 = v13;
            if ( (v47 & 0x8000) == 0 )
              v21 = 0;
            if ( v45 >= 0 )
            {
              v47 &= ~8u;
              if ( v45 > 512 )
                v45 = 512;
            }
            else
            {
              v45 = 1;
            }
            if ( !(v21 | (unsigned int)v13) )
              v40 = 0;
            for ( i = &v49; ; --i )
            {
              v23 = v45--;
              if ( v23 <= 0 && !(v21 | v20) )
                break;
              v24 = __PAIR64__(v21, v20) % v43 + 48;
              v25 = __PAIR64__(v21, v20) / v43;
              v21 = HIDWORD(v25);
              v20 = v25;
              if ( v24 > 57 )
                LOBYTE(v24) = v35 + v24;
              *i = v24;
            }
            v26 = (char *)(&v49 - i);
            v27 = i + 1;
            v43 = (int)v26;
            v44 = v27;
            if ( (v47 & 0x200) != 0 && (*v27 != 48 || !v26) )
            {
              *--v44 = 48;
              v16 = (int)(v26 + 1);
              goto LABEL_158;
            }
            goto LABEL_159;
          }
          if ( v3 >= 101 )
            goto LABEL_70;
          if ( v3 > 88 )
          {
            if ( v3 == 90 )
            {
              v46 = (__int64 *)((char *)v46 + 4);
              v14 = (__int16 *)*((_DWORD *)v46 - 1);
              if ( v14 && (v15 = (char *)*((_DWORD *)v14 + 1)) != 0 )
              {
                v16 = *v14;
                v44 = v15;
                if ( (v47 & 0x800) != 0 )
                {
                  v16 /= 2;
                  v37 = 1;
                }
                else
                {
                  v37 = 0;
                }
              }
              else
              {
                v44 = Str;
                v16 = strlen(Str);
              }
              goto LABEL_158;
            }
            if ( v3 == 99 )
              goto LABEL_74;
            if ( v3 != 100 )
              goto LABEL_159;
LABEL_80:
            v47 |= 0x40u;
LABEL_81:
            v43 = 10;
            goto LABEL_82;
          }
          switch ( v3 )
          {
            case 'X':
              goto LABEL_121;
            case 'C':
              if ( (v47 & 0x830) == 0 )
                BYTE1(v47) |= 8u;
LABEL_74:
              v46 = (__int64 *)((char *)v46 + 4);
              if ( (v47 & 0x810) != 0 )
              {
                v43 = wctomb(MbCh, *((_WORD *)v46 - 2));
                if ( v43 < 0 )
                  v36 = 1;
              }
              else
              {
                MbCh[0] = *((_BYTE *)v46 - 4);
                v43 = 1;
              }
              v44 = MbCh;
              break;
            case 'E':
            case 'G':
              v3 += 32;
LABEL_70:
              v47 |= 0x40u;
              v44 = MbCh;
              if ( v45 >= 0 )
              {
                if ( v45 )
                {
                  if ( v45 > 512 )
                    v45 = 512;
                  if ( v45 > 163 )
                  {
                    v17 = (char *)malloc(v45 + 349);
                    if ( v17 )
                      v44 = v17;
                    else
                      v45 = 163;
                  }
                }
                else
                {
                  v45 = v3 == 103;
                }
              }
              else
              {
                v45 = 6;
              }
              ++v46;
              off_42D554[0]();
            case 'S':
              if ( (v47 & 0x830) == 0 )
                BYTE1(v47) |= 8u;
LABEL_63:
              v10 = v45;
              if ( v45 == -1 )
                v10 = 0x7FFFFFFF;
              v46 = (__int64 *)((char *)v46 + 4);
              v11 = (char *)*((_DWORD *)v46 - 1);
              v44 = v11;
              if ( (v47 & 0x810) != 0 )
              {
                if ( !v11 )
                  v44 = (char *)off_42CEFC;
                v12 = v44;
                v37 = 1;
                while ( v10 )
                {
                  --v10;
                  if ( !*(_WORD *)v12 )
                    break;
                  v12 += 2;
                }
                v16 = (v12 - v44) >> 1;
              }
              else
              {
                if ( !v11 )
                  v44 = Str;
                for ( j = v44; v10; ++j )
                {
                  --v10;
                  if ( !*j )
                    break;
                }
                v16 = j - v44;
              }
LABEL_158:
              v43 = v16;
              break;
          }
LABEL_159:
          if ( v36 )
            goto LABEL_182;
          v28 = v47;
          if ( (v47 & 0x40) == 0 )
            goto LABEL_168;
          if ( (v47 & 0x100) != 0 )
          {
            v41[0] = 45;
LABEL_167:
            v40 = 1;
            goto LABEL_168;
          }
          if ( (v47 & 1) != 0 )
          {
            v41[0] = 43;
            goto LABEL_167;
          }
          if ( (v47 & 2) != 0 )
          {
            v41[0] = 32;
            goto LABEL_167;
          }
LABEL_168:
          v29 = v38 - v40 - v43;
          if ( (v47 & 0xC) == 0 )
            write_multi_char(&v42, 32, v38 - v40 - v43, a1);
          write_string((int)&v42, v41, (int)a1, v40);
          if ( (v28 & 8) != 0 && (v28 & 4) == 0 )
            write_multi_char(&v42, 48, v29, a1);
          if ( v37 && v43 > 0 )
          {
            v30 = (wchar_t *)v44;
            v33 = v43;
            do
            {
              --v33;
              v31 = wctomb(v50, *v30++);
              if ( v31 <= 0 )
                break;
              write_string((int)&v42, v50, (int)a1, v31);
            }
            while ( v33 );
          }
          else
          {
            write_string((int)&v42, v44, (int)a1, v43);
          }
          if ( (v47 & 4) != 0 )
            write_multi_char(&v42, 32, v29, a1);
LABEL_182:
          v5 = v39;
          v3 = *v39;
          if ( !*v39 )
            return v42;
          v4 = v34;
          break;
        default:
          goto LABEL_182;
      }
    }
  }
  return v42;
}


/* ==== 40F470  _strcpy  ()  size=7 ==== */
char *__cdecl strcpy(char *Destination, const char *Source)
{
  JUMPOUT(0x40F4E5);
}


/* ==== 40F480  _strcat  ()  size=232 ==== */
char *__cdecl strcat(char *Destination, const char *Source)
{
  char *v2; // ecx
  int v4; // eax
  int v5; // eax
  char *v6; // edi
  const char *v7; // ecx
  int v8; // edx
  int v9; // eax
  char *result; // eax

  v2 = Destination;
  if ( ((unsigned __int8)Destination & 3) == 0 )
    goto find_end_of_dest_string_loop;
  do
  {
    if ( !*v2++ )
    {
start_byte_3:
      v6 = v2 - 1;
      goto copy_start;
    }
  }
  while ( ((unsigned __int8)v2 & 3) != 0 );
  while ( 1 )
  {
    do
    {
find_end_of_dest_string_loop:
      v4 = (*(_DWORD *)v2 + 2130640639) ^ ~*(_DWORD *)v2;
      v2 += 4;
    }
    while ( (v4 & 0x81010100) == 0 );
    v5 = *((_DWORD *)v2 - 1);
    if ( !(_BYTE)v5 )
      break;
    if ( !BYTE1(v5) )
    {
      v6 = v2 - 3;
      goto copy_start;
    }
    if ( (v5 & 0xFF0000) == 0 )
    {
      v6 = v2 - 2;
      goto copy_start;
    }
    if ( (v5 & 0xFF000000) == 0 )
      goto start_byte_3;
  }
  v6 = v2 - 4;
copy_start:
  v7 = Source;
  if ( ((unsigned __int8)Source & 3) == 0 )
    goto main_loop_entrance;
  while ( 1 )
  {
    LOBYTE(v8) = *v7++;
    if ( !(_BYTE)v8 )
      break;
    *v6++ = v8;
    if ( ((unsigned __int8)v7 & 3) == 0 )
    {
      while ( 1 )
      {
main_loop_entrance:
        v9 = (*(_DWORD *)v7 + 2130640639) ^ ~*(_DWORD *)v7;
        v8 = *(_DWORD *)v7;
        v7 += 4;
        if ( (v9 & 0x81010100) != 0 )
        {
          if ( !(_BYTE)v8 )
            goto LABEL_26;
          if ( !BYTE1(v8) )
          {
            *(_WORD *)v6 = (unsigned __int8)v8;
            return Destination;
          }
          if ( (v8 & 0xFF0000) == 0 )
          {
            *(_WORD *)v6 = v8;
            result = Destination;
            v6[2] = 0;
            return result;
          }
          if ( (v8 & 0xFF000000) == 0 )
          {
            *(_DWORD *)v6 = v8;
            return Destination;
          }
        }
        *(_DWORD *)v6 = v8;
        v6 += 4;
      }
    }
  }
LABEL_26:
  *v6 = v8;
  return Destination;
}


/* ==== 40F568  __tzset_lk  ()  size=680 ==== */
LPSTR _tzset_lk()
{
  UINT v0; // ebx
  char *v1; // eax
  const char *v2; // esi
  size_t v3; // eax
  char *v4; // eax
  const char *v5; // esi
  char v6; // al
  LPSTR result; // eax
  int v8; // [esp+14h] [ebp-20h]
  BOOL UsedDefaultChar; // [esp+18h] [ebp-1Ch] BYREF
  CPPEH_RECORD ms_exc; // [esp+1Ch] [ebp-18h] BYREF

  v8 = 0;
  _lock(7);
  ms_exc.registration.TryLevel = 0;
  v0 = dword_430500;
  dword_430204 = 0;
  dword_42CFA4 = -1;
  dword_42CF98 = -1;
  v1 = getenv("TZ");
  v2 = v1;
  if ( !v1 || !*v1 )
  {
    if ( dword_430208 )
    {
      free(dword_430208);
      dword_430208 = 0;
    }
    if ( GetTimeZoneInformation(&TimeZoneInformation) != -1 )
    {
      dword_430204 = 1;
      dword_42CF00 = 60 * TimeZoneInformation.Bias;
      if ( TimeZoneInformation.StandardDate.wMonth )
        dword_42CF00 = 60 * TimeZoneInformation.StandardBias + 60 * TimeZoneInformation.Bias;
      if ( TimeZoneInformation.DaylightDate.wMonth && TimeZoneInformation.DaylightBias )
      {
        dword_42CF04 = 1;
        dword_42CF08 = 60 * (TimeZoneInformation.DaylightBias - TimeZoneInformation.StandardBias);
      }
      else
      {
        dword_42CF04 = 0;
        dword_42CF08 = 0;
      }
      if ( !WideCharToMultiByte(v0, 0, TimeZoneInformation.StandardName, -1, Destination, 63, 0, &UsedDefaultChar)
        || UsedDefaultChar )
      {
        *Destination = 0;
      }
      else
      {
        Destination[63] = 0;
      }
      if ( !WideCharToMultiByte(v0, 0, TimeZoneInformation.DaylightName, -1, off_42CF94, 63, 0, &UsedDefaultChar)
        || UsedDefaultChar )
      {
        *off_42CF94 = 0;
      }
      else
      {
        off_42CF94[63] = 0;
      }
    }
    return (LPSTR)_local_unwind2((int)&ms_exc.registration, -1);
  }
  if ( dword_430208 )
  {
    if ( !strcmp(v1, dword_430208) )
      return (LPSTR)_local_unwind2((int)&ms_exc.registration, -1);
    if ( dword_430208 )
      free(dword_430208);
  }
  v3 = strlen(v2);
  v4 = (char *)malloc(v3 + 1);
  dword_430208 = v4;
  if ( !v4 )
    return (LPSTR)_local_unwind2((int)&ms_exc.registration, -1);
  strcpy(v4, v2);
  ms_exc.registration.TryLevel = -1;
  _unlock(7);
  strncpy(Destination, v2, 3u);
  Destination[3] = 0;
  v5 = v2 + 3;
  if ( *v5 == 45 )
  {
    v8 = 1;
    ++v5;
  }
  dword_42CF00 = 3600 * atol(v5);
  while ( 1 )
  {
    v6 = *v5;
    if ( *v5 != 43 && (v6 < 48 || v6 > 57) )
      break;
    ++v5;
  }
  if ( *v5 == 58 )
  {
    dword_42CF00 += 60 * atol(++v5);
    while ( *v5 >= 48 && *v5 <= 57 )
      ++v5;
    if ( *v5 == 58 )
    {
      dword_42CF00 += atol(++v5);
      while ( *v5 >= 48 && *v5 <= 57 )
        ++v5;
    }
  }
  if ( v8 )
    dword_42CF00 = -dword_42CF00;
  dword_42CF04 = *v5;
  if ( dword_42CF04 )
  {
    strncpy(off_42CF94, v5, 3u);
    result = off_42CF94;
    off_42CF94[3] = 0;
  }
  else
  {
    result = off_42CF94;
    *off_42CF94 = 0;
  }
  return result;
}


/* ==== 40F810  _cvtdate  ()  size=440 ==== */
int __usercall cvtdate@<eax>(
        int a1@<eax>,
        int a2@<ecx>,
        int a3,
        int a4,
        int a5,
        int a6,
        int a7,
        int a8,
        int a9,
        int a10,
        int a11)
{
  int v11; // edi
  int v13; // edx
  int v14; // eax
  int v15; // esi
  int v16; // esi
  int v17; // edx
  int result; // eax
  int v19; // esi
  int v20; // esi
  int v21; // ecx
  int v22; // ecx
  bool v23; // sf
  int v24; // ecx
  int v25; // ecx
  int v26; // esi
  int v27; // [esp+20h] [ebp+Ch]

  v11 = a5;
  v13 = a5 % 4;
  if ( a4 == 1 )
  {
    if ( (v13 || !(a5 % 100)) && (a5 + 1900) % 400 )
    {
      v14 = 4 * a1;
      v15 = dword_42D174[a1];
    }
    else
    {
      v14 = 4 * a1;
      v15 = dword_42D140[a1];
    }
    v27 = v14;
    v16 = v15 + 1;
    v11 = a5;
    v17 = (365 * a5 + (a5 + 299) / 400 - (a5 - 1) / 100 + v16 + (a5 - 1) / 4 - 25563) % 7;
    result = a7 + 7 * a6 - v17;
    if ( v17 > a7 )
      v19 = result + v16;
    else
      v19 = v16 + result - 7;
    if ( a6 == 5 )
    {
      if ( (a5 % 4 || !(a5 % 100)) && (a5 + 1900) % 400 )
        result = *(int *)((char *)dword_42D178 + v27);
      else
        result = *(int *)((char *)&dword_42D144 + v27);
      if ( v19 > result )
        v19 -= 7;
    }
  }
  else
  {
    if ( (v13 || (result = a5 / 100, !(a5 % 100))) && (result = (a5 + 1900) / 400, (a5 + 1900) % 400) )
      v20 = dword_42D174[a1];
    else
      v20 = dword_42D140[a1];
    v19 = a8 + v20;
  }
  v21 = 60 * (a9 + 60 * a2);
  if ( a3 == 1 )
  {
    dword_42CF9C = v19;
    dword_42CF98 = v11;
    dword_42CFA0 = a11 + 1000 * (a10 + v21);
    return result;
  }
  dword_42CFA8 = v19;
  v22 = 1000 * (a10 + dword_42CF08 + v21);
  v23 = a11 + v22 < 0;
  v24 = a11 + v22;
  dword_42CFAC = v24;
  if ( v23 )
  {
    v25 = v24 + 86400000;
    v26 = v19 - 1;
LABEL_30:
    dword_42CFAC = v25;
    dword_42CFA8 = v26;
    goto LABEL_31;
  }
  result = 86400000;
  if ( v24 >= 86400000 )
  {
    v25 = v24 - 86400000;
    v26 = v19 + 1;
    goto LABEL_30;
  }
LABEL_31:
  dword_42CFA4 = v11;
  return result;
}


/* ==== 40F9C8  __isindst_lk  ()  size=391 ==== */
BOOL __usercall _isindst_lk@<eax>(_DWORD *a1@<ebx>)
{
  int v2; // edi
  int v3; // ecx
  int v4; // eax

  if ( !dword_42CF04 )
    return 0;
  v2 = a1[5];
  if ( v2 != dword_42CF98 || v2 != dword_42CFA4 )
  {
    if ( dword_430204 )
    {
      if ( TimeZoneInformation.DaylightDate.wYear )
        cvtdate(
          TimeZoneInformation.DaylightDate.wMonth,
          TimeZoneInformation.DaylightDate.wHour,
          1,
          0,
          v2,
          0,
          0,
          TimeZoneInformation.DaylightDate.wDay,
          TimeZoneInformation.DaylightDate.wMinute,
          TimeZoneInformation.DaylightDate.wSecond,
          TimeZoneInformation.DaylightDate.wMilliseconds);
      else
        cvtdate(
          TimeZoneInformation.DaylightDate.wMonth,
          TimeZoneInformation.DaylightDate.wHour,
          1,
          1,
          v2,
          TimeZoneInformation.DaylightDate.wDay,
          TimeZoneInformation.DaylightDate.wDayOfWeek,
          0,
          TimeZoneInformation.DaylightDate.wMinute,
          TimeZoneInformation.DaylightDate.wSecond,
          TimeZoneInformation.DaylightDate.wMilliseconds);
      if ( TimeZoneInformation.StandardDate.wYear )
        cvtdate(
          TimeZoneInformation.StandardDate.wMonth,
          TimeZoneInformation.StandardDate.wHour,
          0,
          0,
          v2,
          0,
          0,
          TimeZoneInformation.StandardDate.wDay,
          TimeZoneInformation.StandardDate.wMinute,
          TimeZoneInformation.StandardDate.wSecond,
          TimeZoneInformation.StandardDate.wMilliseconds);
      else
        cvtdate(
          TimeZoneInformation.StandardDate.wMonth,
          TimeZoneInformation.StandardDate.wHour,
          0,
          1,
          v2,
          TimeZoneInformation.StandardDate.wDay,
          TimeZoneInformation.StandardDate.wDayOfWeek,
          0,
          TimeZoneInformation.StandardDate.wMinute,
          TimeZoneInformation.StandardDate.wSecond,
          TimeZoneInformation.StandardDate.wMilliseconds);
    }
    else
    {
      cvtdate(4, 2, 1, 1, v2, 1, 0, 0, 0, 0, 0);
      cvtdate(10, 2, 0, 1, v2, 5, 0, 0, 0, 0, 0);
    }
  }
  v3 = a1[7];
  if ( dword_42CF9C < dword_42CFA8 )
  {
    if ( v3 >= dword_42CF9C && v3 <= dword_42CFA8 )
    {
      if ( v3 > dword_42CF9C && v3 < dword_42CFA8 )
        return 1;
      goto LABEL_26;
    }
    return 0;
  }
  if ( v3 < dword_42CFA8 || v3 > dword_42CF9C )
    return 1;
  if ( v3 > dword_42CFA8 && v3 < dword_42CF9C )
    return 0;
LABEL_26:
  v4 = 1000 * (*a1 + 60 * (a1[1] + 60 * a1[2]));
  if ( v3 == dword_42CF9C )
    return v4 >= dword_42CFA0;
  else
    return v4 < dword_42CFAC;
}


/* ==== 40FB4F  ___tzset  ()  size=76 ==== */
int __tzset()
{
  int result; // eax

  if ( !dword_43020C )
  {
    _lock(6);
    if ( !dword_43020C )
    {
      _tzset_lk();
      ++dword_43020C;
    }
    return _unlock(6);
  }
  return result;
}


/* ==== 40FB9B  __isindst  ()  size=62 ==== */
BOOL __cdecl _isindst(_DWORD *a1)
{
  BOOL v2; // [esp+Ch] [ebp-1Ch]

  _lock(6);
  v2 = _isindst_lk(a1);
  _unlock(6);
  return v2;
}


/* ==== 40FBE0  ___ascii_stricmp  ()  size=78 ==== */
int __cdecl __ascii_stricmp(_BYTE *a1, _BYTE *a2)
{
  int result; // eax
  char v5; // t0

  LOBYTE(result) = -1;
  while ( (_BYTE)result )
  {
    LOBYTE(result) = *a2++;
    BYTE1(result) = *a1++;
    if ( BYTE1(result) != (_BYTE)result )
    {
      v5 = BYTE1(result);
      BYTE1(result) = ((unsigned __int8)(result - 65) < 0x1Au ? 0x20 : 0) + result;
      LOBYTE(result) = ((unsigned __int8)(v5 - 65) < 0x1Au ? 0x20 : 0) + v5;
      if ( (_BYTE)result != BYTE1(result) )
      {
        LOBYTE(result) = -((unsigned __int8)result < BYTE1(result)) - (((unsigned __int8)result < BYTE1(result)) - 1);
        return (char)result;
      }
    }
  }
  return (char)result;
}


/* ==== 40FC2E  ___freetlocinfo  ()  size=208 ==== */
void __cdecl __freetlocinfo(void *Block)
{
  int v1; // eax
  _DWORD *v2; // eax
  _DWORD *v3; // eax
  _DWORD *v4; // eax
  int v5; // eax

  v1 = *((_DWORD *)Block + 15);
  if ( v1 != dword_43052C && v1 && !**((_DWORD **)Block + 11) )
  {
    v2 = (_DWORD *)*((_DWORD *)Block + 13);
    if ( v2 && !*v2 && v2 != (_DWORD *)dword_4305F8 )
    {
      free(*((void **)Block + 13));
      __free_lconv_mon(*((_DWORD *)Block + 15));
    }
    v3 = (_DWORD *)*((_DWORD *)Block + 12);
    if ( v3 && !*v3 && v3 != (_DWORD *)dword_4305FC )
    {
      free(*((void **)Block + 12));
      __free_lconv_num(*((_DWORD *)Block + 15));
    }
    free(*((void **)Block + 11));
    free(*((void **)Block + 15));
  }
  v4 = (_DWORD *)*((_DWORD *)Block + 16);
  if ( v4 != (_DWORD *)dword_4305F4 && v4 && !*v4 )
  {
    free(*((void **)Block + 16));
    free((void *)(*((_DWORD *)Block + 17) - 254));
  }
  v5 = *((_DWORD *)Block + 20);
  if ( v5 != dword_430528 && v5 && !*(_DWORD *)(v5 + 180) )
  {
    _free_lc_time(*((_DWORD *)Block + 20));
    free(*((void **)Block + 20));
  }
  free(Block);
}


/* ==== 40FCFE  ___updatetlocinfo_lk  ()  size=193 ==== */
DWORD __updatetlocinfo_lk()
{
  DWORD *v0; // esi
  _DWORD *v1; // ecx
  _DWORD *v2; // eax
  _DWORD *v3; // eax
  _DWORD *v4; // eax
  _DWORD *v5; // eax
  _DWORD **v6; // eax

  v0 = _getptd();
  v1 = (_DWORD *)v0[25];
  if ( v1 != (_DWORD *)off_42D00C )
  {
    if ( v1 )
    {
      v2 = (_DWORD *)v1[11];
      --*v1;
      if ( v2 )
        --*v2;
      v3 = (_DWORD *)v1[13];
      if ( v3 )
        --*v3;
      v4 = (_DWORD *)v1[12];
      if ( v4 )
        --*v4;
      v5 = (_DWORD *)v1[16];
      if ( v5 )
        --*v5;
      --*(_DWORD *)(v1[19] + 180);
    }
    v0[25] = (DWORD)off_42D00C;
    ++*(_DWORD *)off_42D00C;
    v6 = (_DWORD **)off_42D00C;
    if ( *((_DWORD *)off_42D00C + 11) )
    {
      ++**((_DWORD **)off_42D00C + 11);
      v6 = (_DWORD **)off_42D00C;
    }
    if ( v6[13] )
    {
      ++*v6[13];
      v6 = (_DWORD **)off_42D00C;
    }
    if ( v6[12] )
    {
      ++*v6[12];
      v6 = (_DWORD **)off_42D00C;
    }
    if ( v6[16] )
    {
      ++*v6[16];
      v6 = (_DWORD **)off_42D00C;
    }
    ++v6[19][45];
    if ( v1 && !*v1 && v1 != (_DWORD *)&unk_42CFB8 )
      __freetlocinfo(v1);
  }
  return v0[25];
}


/* ==== 40FDBF  ___updatetlocinfo  ()  size=59 ==== */
DWORD __updatetlocinfo()
{
  DWORD v1; // [esp+Ch] [ebp-1Ch]

  _lock(12);
  v1 = __updatetlocinfo_lk();
  _unlock(12);
  return v1;
}


/* ==== 40FDFA  __close_lk  ()  size=131 ==== */
int __cdecl _close_lk(int FileHandle)
{
  intptr_t osfhandle; // edi
  void *v2; // eax
  DWORD LastError; // edi

  if ( _get_osfhandle(FileHandle) == -1
    || (FileHandle == 1 || FileHandle == 2) && (osfhandle = _get_osfhandle(2), _get_osfhandle(1) == osfhandle)
    || (v2 = (void *)_get_osfhandle(FileHandle), CloseHandle(v2)) )
  {
    LastError = 0;
  }
  else
  {
    LastError = GetLastError();
  }
  _free_osfhnd(FileHandle);
  *(_BYTE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F) + 4) = 0;
  if ( !LastError )
    return 0;
  _dosmaperr(LastError);
  return -1;
}


/* ==== 40FE7D  __close  ()  size=155 ==== */
int __cdecl _close(int FileHandle)
{
  int v1; // esi
  int v3; // [esp+Ch] [ebp-1Ch]

  if ( FileHandle < uNumber
    && (v1 = 36 * (FileHandle & 0x1F), (*(_BYTE *)(dword_430620[FileHandle >> 5] + v1 + 4) & 1) != 0) )
  {
    _lock_fhandle(FileHandle);
    if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v1 + 4) & 1) != 0 )
    {
      v3 = _close_lk(FileHandle);
    }
    else
    {
      *_errno() = 9;
      v3 = -1;
    }
    _unlock_fhandle(FileHandle);
    return v3;
  }
  else
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
}


/* ==== 40FF18  __freebuf  ()  size=43 ==== */
int __cdecl _freebuf(int a1)
{
  int result; // eax

  result = *(_DWORD *)(a1 + 12);
  if ( (result & 0x83) != 0 && (result & 8) != 0 )
  {
    free(*(void **)(a1 + 8));
    *(_WORD *)(a1 + 12) &= 0xFBF7u;
    result = 0;
    *(_DWORD *)a1 = 0;
    *(_DWORD *)(a1 + 8) = 0;
    *(_DWORD *)(a1 + 4) = 0;
  }
  return result;
}


/* ==== 410000  __lock_file  ()  size=47 ==== */
void __cdecl _lock_file(FILE *Stream)
{
  if ( Stream < (FILE *)&off_42D1B0 || Stream > &stru_42D410 )
    EnterCriticalSection((LPCRITICAL_SECTION)&Stream[1]);
  else
    _lock((((char *)Stream - (char *)&off_42D1B0) >> 5) + 16);
}


/* ==== 41002F  __lock_file2  ()  size=35 ==== */
void __cdecl _lock_file2(int a1, int a2)
{
  if ( a1 >= 20 )
    EnterCriticalSection((LPCRITICAL_SECTION)(a2 + 32));
  else
    _lock(a1 + 16);
}


/* ==== 410052  __unlock_file  ()  size=47 ==== */
void __cdecl _unlock_file(FILE *Stream)
{
  if ( Stream < (FILE *)&off_42D1B0 || Stream > &stru_42D410 )
    LeaveCriticalSection((LPCRITICAL_SECTION)&Stream[1]);
  else
    _unlock((((char *)Stream - (char *)&off_42D1B0) >> 5) + 16);
}


/* ==== 410081  __unlock_file2  ()  size=35 ==== */
void __cdecl _unlock_file2(int a1, int a2)
{
  if ( a1 >= 20 )
    LeaveCriticalSection((LPCRITICAL_SECTION)(a2 + 32));
  else
    _unlock(a1 + 16);
}


/* ==== 4100A4  __stbuf  ()  size=136 ==== */
int __cdecl _stbuf(int a1)
{
  int v1; // eax
  int *v2; // edi
  void *v3; // eax
  int v4; // edi

  if ( !_isatty(*(_DWORD *)(a1 + 16)) )
    return 0;
  if ( (_UNKNOWN *)a1 == &unk_42D1D0 )
  {
    v1 = 0;
  }
  else
  {
    if ( (_UNKNOWN *)a1 != &unk_42D1F0 )
      return 0;
    v1 = 1;
  }
  ++dword_43021C;
  if ( (*(_WORD *)(a1 + 12) & 0x10C) != 0 )
    return 0;
  v2 = (int *)(4 * v1 + 4391456);
  if ( dword_430220[v1] || (v3 = malloc(0x1000u), (*v2 = (int)v3) != 0) )
  {
    v4 = *v2;
    *(_DWORD *)(a1 + 8) = v4;
    *(_DWORD *)a1 = v4;
    *(_DWORD *)(a1 + 24) = 4096;
    *(_DWORD *)(a1 + 4) = 4096;
  }
  else
  {
    *(_DWORD *)(a1 + 8) = a1 + 20;
    *(_DWORD *)a1 = a1 + 20;
    *(_DWORD *)(a1 + 24) = 2;
    *(_DWORD *)(a1 + 4) = 2;
  }
  *(_WORD *)(a1 + 12) |= 0x1102u;
  return 1;
}


/* ==== 41012C  __ftbuf  ()  size=42 ==== */
int __cdecl _ftbuf(int a1, int a2)
{
  int result; // eax

  if ( a1 )
  {
    if ( (*(_BYTE *)(a2 + 13) & 0x10) != 0 )
    {
      result = _flush((_DWORD *)a2);
      *(_BYTE *)(a2 + 13) &= 0xEEu;
      *(_DWORD *)(a2 + 24) = 0;
      *(_DWORD *)a2 = 0;
      *(_DWORD *)(a2 + 8) = 0;
    }
  }
  return result;
}


/* ==== 410156  __mtinitlocks  ()  size=73 ==== */
int _mtinitlocks()
{
  int v0; // esi
  struct _RTL_CRITICAL_SECTION *v1; // edi

  v0 = 0;
  v1 = (struct _RTL_CRITICAL_SECTION *)&unk_430228;
  while ( 1 )
  {
    if ( dword_42D434[2 * v0] == 1 )
    {
      *(&lpCriticalSection + 2 * v0) = v1++;
      if ( !__crtInitCritSecAndSpinCount(*(&lpCriticalSection + 2 * v0), 4000) )
        break;
    }
    if ( ++v0 >= 36 )
      return 1;
  }
  *(&lpCriticalSection + 2 * v0) = 0;
  return 0;
}


/* ==== 41019F  __mtdeletelocks  ()  size=85 ==== */
void _mtdeletelocks()
{
  LPCRITICAL_SECTION *v0; // esi
  LPCRITICAL_SECTION v1; // edi
  LPCRITICAL_SECTION *v2; // esi

  v0 = &lpCriticalSection;
  do
  {
    v1 = *v0;
    if ( *v0 && v0[1] != (LPCRITICAL_SECTION)1 )
    {
      DeleteCriticalSection(*v0);
      free(v1);
      *v0 = 0;
    }
    v0 += 2;
  }
  while ( (int)v0 < (int)&dword_42D550 );
  v2 = &lpCriticalSection;
  do
  {
    if ( *v2 )
    {
      if ( v2[1] == (LPCRITICAL_SECTION)1 )
        DeleteCriticalSection(*v2);
    }
    v2 += 2;
  }
  while ( (int)v2 < (int)&dword_42D550 );
}


/* ==== 4101F4  __unlock  ()  size=21 ==== */
void __cdecl _unlock(int a1)
{
  LeaveCriticalSection(*(&lpCriticalSection + 2 * a1));
}


/* ==== 410209  __mtinitlocknum  ()  size=160 ==== */
int __cdecl _mtinitlocknum(int a1)
{
  struct _RTL_CRITICAL_SECTION *v1; // edi
  CPPEH_RECORD ms_exc; // [esp+Ch] [ebp-18h] BYREF

  if ( !*(&lpCriticalSection + 2 * a1) )
  {
    v1 = (struct _RTL_CRITICAL_SECTION *)malloc(0x18u);
    if ( !v1 )
    {
      *_errno() = 12;
      return 0;
    }
    _lock(10);
    ms_exc.registration.TryLevel = 0;
    if ( *(&lpCriticalSection + 2 * a1) )
    {
      free(v1);
    }
    else
    {
      if ( !__crtInitCritSecAndSpinCount(v1, 4000) )
      {
        free(v1);
        *_errno() = 12;
        _local_unwind2((int)&ms_exc.registration, -1);
        return 0;
      }
      *(&lpCriticalSection + 2 * a1) = v1;
    }
    ms_exc.registration.TryLevel = -1;
    _unlock(10);
  }
  return 1;
}


/* ==== 4102A9  __lock  ()  size=49 ==== */
void __cdecl _lock(int a1)
{
  if ( !*(&lpCriticalSection + 2 * a1) && !_mtinitlocknum(a1) )
    _amsg_exit(17);
  EnterCriticalSection(*(&lpCriticalSection + 2 * a1));
}


/* ==== 4102DA  sub_4102DA  ()  size=68 ==== */
void sub_4102DA()
{
  void (**i)(void); // [esp+Ch] [ebp-1Ch]

  for ( i = dword_4290F4; i < dword_4290F4; ++i )
  {
    if ( *i )
      (*i)();
  }
}


/* ==== 41031E  sub_41031E  ()  size=68 ==== */
void __cdecl sub_41031E()
{
  void (**i)(void); // [esp+Ch] [ebp-1Ch]

  for ( i = &dword_4290FC; i < &dword_4290FC; ++i )
  {
    if ( *i )
      (*i)();
  }
}


/* ==== 410362  __openfile  ()  size=360 ==== */
_DWORD *__cdecl _openfile(char *FileName, _BYTE *a2, int ShareFlag, _DWORD *a4)
{
  _BYTE *v4; // edi
  char v5; // al
  unsigned int v6; // ecx
  unsigned int v7; // esi
  int v8; // edx
  int v9; // eax
  int v10; // eax
  int v11; // eax
  int v12; // eax
  int v13; // eax
  int v14; // eax
  char v15; // al
  int v16; // ecx
  _DWORD *result; // eax
  int v18; // [esp+Ch] [ebp-8h]
  int v19; // [esp+10h] [ebp-4h]

  v4 = a2;
  v5 = *a2;
  v18 = 0;
  v19 = 0;
  if ( *a2 == 97 )
  {
    v6 = 265;
LABEL_7:
    v7 = dword_4304E4 | 2;
    goto LABEL_8;
  }
  if ( v5 != 114 )
  {
    if ( v5 != 119 )
      return 0;
    v6 = 769;
    goto LABEL_7;
  }
  v6 = 0;
  v7 = dword_4304E4 | 1;
LABEL_8:
  v8 = 1;
  while ( 1 )
  {
    v15 = *++v4;
    if ( !*v4 || !v8 )
      break;
    if ( v15 > 84 )
    {
      v12 = v15 - 98;
      if ( v12 )
      {
        v13 = v12 - 1;
        if ( v13 )
        {
          v14 = v13 - 11;
          if ( v14 )
          {
            if ( v14 != 6 || (v6 & 0xC000) != 0 )
LABEL_35:
              v8 = 0;
            else
              v6 |= 0x4000u;
          }
          else
          {
            if ( v18 )
              goto LABEL_35;
            v18 = 1;
            v7 &= ~0x4000u;
          }
        }
        else
        {
          if ( v18 )
            goto LABEL_35;
          v18 = 1;
          v7 |= 0x4000u;
        }
      }
      else
      {
        if ( (v6 & 0xC000) != 0 )
          goto LABEL_35;
        v6 |= 0x8000u;
      }
    }
    else if ( v15 == 84 )
    {
      if ( (v6 & 0x1000) != 0 )
        goto LABEL_35;
      v6 |= 0x1000u;
    }
    else
    {
      v9 = v15 - 43;
      if ( v9 )
      {
        v10 = v9 - 25;
        if ( v10 )
        {
          v11 = v10 - 14;
          if ( v11 )
          {
            if ( v11 != 1 || v19 )
              goto LABEL_35;
            v19 = 1;
            v6 |= 0x20u;
          }
          else
          {
            if ( v19 )
              goto LABEL_35;
            v19 = 1;
            v6 |= 0x10u;
          }
        }
        else
        {
          if ( (v6 & 0x40) != 0 )
            goto LABEL_35;
          v6 |= 0x40u;
        }
      }
      else
      {
        if ( (v6 & 2) != 0 )
          goto LABEL_35;
        v6 = v6 & 0xFFFFFFFC | 2;
        v7 = v7 & 0xFFFFFF7C | 0x80;
      }
    }
  }
  v16 = _sopen(FileName, v6, ShareFlag, 420);
  if ( v16 < 0 )
    return 0;
  result = a4;
  ++dword_43021C;
  a4[3] = v7;
  a4[1] = 0;
  *a4 = 0;
  a4[2] = 0;
  a4[7] = 0;
  a4[4] = v16;
  return result;
}


/* ==== 4104CA  __getstream  ()  size=290 ==== */
_DWORD *_getstream()
{
  _DWORD *v0; // edi
  int i; // esi
  int v2; // eax
  int v3; // esi
  int v4; // eax

  v0 = 0;
  _lock(1);
  for ( i = 0; i < dword_431760; ++i )
  {
    v2 = *(_DWORD *)(dword_430744 + 4 * i);
    if ( !v2 )
    {
      v3 = 4 * i;
      *(_DWORD *)(v3 + dword_430744) = malloc(0x38u);
      v4 = *(_DWORD *)(v3 + dword_430744);
      if ( v4 )
      {
        if ( __crtInitCritSecAndSpinCount(v4 + 32, 4000) )
        {
          EnterCriticalSection((LPCRITICAL_SECTION)(*(_DWORD *)(v3 + dword_430744) + 32));
          v0 = *(_DWORD **)(v3 + dword_430744);
        }
        else
        {
          free(*(void **)(v3 + dword_430744));
          *(_DWORD *)(v3 + dword_430744) = 0;
        }
      }
      break;
    }
    if ( (*(_BYTE *)(v2 + 12) & 0x83) == 0 )
    {
      if ( i > 2 && i < 20 && !_mtinitlocknum(i + 16) )
        break;
      _lock_file2(i, *(_DWORD *)(dword_430744 + 4 * i));
      if ( (*(_BYTE *)(*(_DWORD *)(dword_430744 + 4 * i) + 12) & 0x83) == 0 )
      {
        v0 = *(_DWORD **)(dword_430744 + 4 * i);
        break;
      }
      _unlock_file2(i, *(_DWORD *)(dword_430744 + 4 * i));
    }
  }
  if ( v0 )
  {
    v0[1] = 0;
    v0[3] = 0;
    v0[2] = 0;
    *v0 = 0;
    v0[7] = 0;
    v0[4] = -1;
  }
  _unlock(1);
  return v0;
}


/* ==== 4105EC  ___heap_select  ()  size=26 ==== */
int __heap_select()
{
  if ( dword_4300E8 == 2 && (unsigned int)dword_4300F4 >= 5 )
    return 1;
  else
    return 3;
}


/* ==== 410606  __heap_init  ()  size=81 ==== */
int __cdecl _heap_init(int a1)
{
  hHeap = HeapCreate(a1 == 0, 0x1000u, 0);
  if ( !hHeap )
    return 0;
  dword_430740 = __heap_select();
  if ( dword_430740 == 3 && !__sbh_heap_init(1016) )
  {
    HeapDestroy(hHeap);
    return 0;
  }
  return 1;
}


/* ==== 410657  ___sbh_heap_init  ()  size=72 ==== */
int __cdecl __sbh_heap_init(int a1)
{
  int result; // eax

  result = (int)HeapAlloc(hHeap, 0, 0x140u);
  lpMem = (LPVOID)result;
  if ( result )
  {
    dword_430720 = 0;
    dword_430724 = 0;
    dword_430730 = result;
    dword_43072C = a1;
    dword_430734 = 16;
    return 1;
  }
  return result;
}


/* ==== 41069F  ___sbh_find_block  ()  size=43 ==== */
char *__cdecl __sbh_find_block(int a1)
{
  char *result; // eax

  for ( result = (char *)lpMem; result < (char *)lpMem + 20 * dword_430724; result += 20 )
  {
    if ( (unsigned int)(a1 - *((_DWORD *)result + 3)) < 0x100000 )
      return result;
  }
  return 0;
}


/* ==== 4106CA  ___sbh_free_block  ()  size=792 ==== */
_DWORD *__cdecl __sbh_free_block(_DWORD *a1, int a2)
{
  _DWORD *result; // eax
  int *v3; // esi
  unsigned int v4; // edi
  int v5; // ecx
  char *v6; // ebx
  unsigned int v7; // edx
  _BYTE *v8; // ecx
  unsigned int v9; // ebx
  bool v10; // zf
  _BYTE *v11; // ecx
  unsigned int v12; // ebx
  unsigned int v13; // edx
  unsigned int v14; // ebx
  int v15; // ecx
  unsigned int v16; // esi
  unsigned int v17; // esi
  _DWORD *v18; // ecx
  int v19; // ebx
  LPVOID *v20; // eax
  _DWORD *v21; // [esp+8h] [ebp-10h]
  int v22; // [esp+Ch] [ebp-Ch]
  int v23; // [esp+10h] [ebp-8h]
  int v24; // [esp+14h] [ebp-4h]
  char *v25; // [esp+24h] [ebp+Ch]
  int *v26; // [esp+24h] [ebp+Ch]
  char v27; // [esp+27h] [ebp+Fh]

  result = (_DWORD *)a1[4];
  v3 = (int *)(a2 - 4);
  v4 = (unsigned int)(a2 - a1[3]) >> 15;
  v21 = &result[129 * v4 + 81];
  v5 = *(_DWORD *)(a2 - 4) - 1;
  v24 = v5;
  if ( (v5 & 1) == 0 )
  {
    v6 = (char *)v3 + v5;
    v22 = *(int *)((char *)v3 + v5);
    v23 = *(_DWORD *)(a2 - 8);
    v25 = (char *)v3 + v5;
    if ( (v22 & 1) == 0 )
    {
      v7 = (v22 >> 4) - 1;
      if ( v7 > 0x3F )
        v7 = 63;
      if ( *((_DWORD *)v6 + 1) == *((_DWORD *)v6 + 2) )
      {
        if ( v7 >= 0x20 )
        {
          v11 = (char *)result + v7 + 4;
          v12 = ~(0x80000000 >> (v7 - 32));
          result[v4 + 49] &= v12;
          v10 = (*v11)-- == 1;
          if ( v10 )
            a1[1] &= v12;
        }
        else
        {
          v8 = (char *)result + v7 + 4;
          v9 = ~(0x80000000 >> v7);
          result[v4 + 17] &= v9;
          v10 = (*v8)-- == 1;
          if ( v10 )
            *a1 &= v9;
        }
        v6 = v25;
      }
      v5 = v22 + v24;
      *(_DWORD *)(*((_DWORD *)v6 + 2) + 4) = *((_DWORD *)v6 + 1);
      *(_DWORD *)(*((_DWORD *)v25 + 1) + 8) = *((_DWORD *)v25 + 2);
      v24 += v22;
    }
    v13 = (v5 >> 4) - 1;
    if ( v13 > 0x3F )
      v13 = 63;
    if ( (v23 & 1) != 0 )
    {
      v14 = (unsigned int)a1;
    }
    else
    {
      v26 = (int *)((char *)v3 - v23);
      v14 = (v23 >> 4) - 1;
      if ( v14 > 0x3F )
        v14 = 63;
      v15 = v23 + v5;
      v13 = (v15 >> 4) - 1;
      v24 = v15;
      if ( v13 > 0x3F )
        v13 = 63;
      if ( v14 != v13 )
      {
        if ( v26[1] == v26[2] )
        {
          if ( v14 >= 0x20 )
          {
            v17 = ~(0x80000000 >> (v14 - 32));
            result[v4 + 49] &= v17;
            v10 = (*((_BYTE *)result + v14 + 4))-- == 1;
            if ( v10 )
              a1[1] &= v17;
          }
          else
          {
            v16 = ~(0x80000000 >> v14);
            result[v4 + 17] &= v16;
            v10 = (*((_BYTE *)result + v14 + 4))-- == 1;
            if ( v10 )
              *a1 &= v16;
          }
        }
        *(_DWORD *)(v26[2] + 4) = v26[1];
        *(_DWORD *)(v26[1] + 8) = v26[2];
      }
      v3 = v26;
    }
    if ( (v23 & 1) != 0 || v14 != v13 )
    {
      v18 = &v21[2 * v13];
      v19 = v18[1];
      v3[2] = (int)v18;
      v3[1] = v19;
      v18[1] = v3;
      *(_DWORD *)(v3[1] + 8) = v3;
      if ( v3[1] == v3[2] )
      {
        v27 = *((_BYTE *)result + v13 + 4);
        *((_BYTE *)result + v13 + 4) = v27 + 1;
        if ( v13 >= 0x20 )
        {
          if ( !v27 )
            a1[1] |= 0x80000000 >> (v13 - 32);
          result[v4 + 49] |= 0x80000000 >> (v13 - 32);
        }
        else
        {
          if ( !v27 )
            *a1 |= 0x80000000 >> v13;
          result[v4 + 17] |= 0x80000000 >> v13;
        }
      }
    }
    *v3 = v24;
    *(int *)((char *)v3 + v24 - 4) = v24;
    result += 129 * v4 + 81;
    v10 = (*v21)-- == 1;
    if ( v10 )
    {
      if ( dword_430720 )
      {
        VirtualFree((LPVOID)(*((_DWORD *)dword_430720 + 3) + (dword_430738 << 15)), 0x8000u, 0x4000u);
        *((_DWORD *)dword_430720 + 2) |= 0x80000000 >> dword_430738;
        *(_DWORD *)(*((_DWORD *)dword_430720 + 4) + 4 * dword_430738 + 196) = 0;
        --*(_BYTE *)(*((_DWORD *)dword_430720 + 4) + 67);
        v20 = (LPVOID *)dword_430720;
        if ( !*(_BYTE *)(*((_DWORD *)dword_430720 + 4) + 67) )
        {
          *((_DWORD *)dword_430720 + 1) &= ~1u;
          v20 = (LPVOID *)dword_430720;
        }
        if ( v20[2] == (LPVOID)-1 )
        {
          VirtualFree(v20[3], 0, 0x8000u);
          HeapFree(hHeap, 0, *((LPVOID *)dword_430720 + 4));
          memcpy(dword_430720, (char *)dword_430720 + 20, (size_t)lpMem + 20 * dword_430724 - (_DWORD)dword_430720 - 20);
          --dword_430724;
          if ( a1 > dword_430720 )
            a1 -= 5;
          dword_430730 = (int)lpMem;
        }
      }
      result = a1;
      dword_430720 = a1;
      dword_430738 = v4;
    }
  }
  return result;
}


/* ==== 4109E2  ___sbh_alloc_new_region  ()  size=183 ==== */
char *__sbh_alloc_new_region()
{
  int v0; // eax
  void *v1; // eax
  char *v3; // esi
  LPVOID v4; // eax
  LPVOID v5; // eax

  v0 = dword_430724;
  if ( dword_430724 == dword_430734 )
  {
    v1 = HeapReAlloc(hHeap, 0, lpMem, 4 * (5 * dword_430734 + 80));
    if ( !v1 )
      return 0;
    dword_430734 += 16;
    lpMem = v1;
    v0 = dword_430724;
  }
  v3 = (char *)lpMem + 20 * v0;
  v4 = HeapAlloc(hHeap, 8u, 0x41C4u);
  *((_DWORD *)v3 + 4) = v4;
  if ( !v4 )
    return 0;
  v5 = VirtualAlloc(0, 0x100000u, 0x2000u, 4u);
  *((_DWORD *)v3 + 3) = v5;
  if ( !v5 )
  {
    HeapFree(hHeap, 0, *((LPVOID *)v3 + 4));
    return 0;
  }
  *((_DWORD *)v3 + 2) = -1;
  *(_DWORD *)v3 = 0;
  *((_DWORD *)v3 + 1) = 0;
  ++dword_430724;
  **((_DWORD **)v3 + 4) = -1;
  return v3;
}


/* ==== 410A99  ___sbh_alloc_new_group  ()  size=262 ==== */
int __cdecl __sbh_alloc_new_group(_DWORD *a1)
{
  int v1; // eax
  int v2; // esi
  int v3; // ebx
  int v4; // eax
  int v5; // edx
  _DWORD *v6; // edi
  _DWORD *v8; // edx
  _DWORD *v9; // eax
  int v10; // ecx

  v1 = a1[2];
  v2 = a1[4];
  v3 = 0;
  while ( v1 >= 0 )
  {
    v1 *= 2;
    ++v3;
  }
  v4 = 516 * v3 + v2 + 324;
  v5 = 63;
  do
  {
    *(_DWORD *)(v4 + 8) = v4;
    *(_DWORD *)(v4 + 4) = v4;
    v4 += 8;
    --v5;
  }
  while ( v5 );
  v6 = (_DWORD *)(a1[3] + (v3 << 15));
  if ( !VirtualAlloc(v6, 0x8000u, 0x1000u, 4u) )
    return -1;
  v8 = v6 + 7168;
  if ( v6 < v6 + 7168 )
  {
    v9 = v6 + 4;
    v10 = 8;
    do
    {
      *(v9 - 2) = -1;
      v9[1019] = -1;
      *v9 = v9 + 1023;
      *(v9 - 1) = 4080;
      v9[1] = v9 - 1025;
      v9[1018] = 4080;
      v9 += 1024;
      --v10;
    }
    while ( v10 );
    v8 = v6 + 7168;
  }
  *(_DWORD *)(516 * v3 + v2 + 832) = v6 + 3;
  v6[5] = 516 * v3 + v2 + 828;
  *(_DWORD *)(516 * v3 + v2 + 836) = v8 + 3;
  v8[4] = 516 * v3 + v2 + 828;
  *(_DWORD *)(v2 + 4 * v3 + 68) = 0;
  *(_DWORD *)(v2 + 4 * v3 + 196) = 1;
  if ( (*(_BYTE *)(v2 + 67))++ == 0 )
    a1[1] |= 1u;
  a1[2] &= ~(0x80000000 >> v3);
  return v3;
}


/* ==== 410B9F  ___sbh_resize_block  ()  size=735 ==== */
int __cdecl __sbh_resize_block(_DWORD *a1, int a2, int a3)
{
  int v3; // eax
  unsigned int v4; // edx
  signed int v5; // esi
  int v6; // ecx
  int *v7; // edi
  int v8; // ebx
  unsigned int v9; // ecx
  unsigned int v10; // ebx
  _BYTE *v11; // ecx
  int v12; // ebx
  bool v13; // zf
  unsigned int v14; // ebx
  _BYTE *v15; // ecx
  int v16; // ebx
  unsigned int v17; // edi
  int v18; // ecx
  _DWORD *v19; // eax
  char v20; // cl
  int v21; // edx
  int *v22; // eax
  int v24; // ecx
  int *v25; // ebx
  unsigned int v26; // esi
  unsigned int v27; // esi
  unsigned int v28; // ebx
  _BYTE *v29; // esi
  int v30; // ebx
  _BYTE *v31; // ecx
  unsigned int v32; // ebx
  unsigned int v33; // ecx
  int v34; // edi
  _DWORD *v35; // eax
  char v36; // cl
  int v37; // [esp+Ch] [ebp-Ch]
  int v38; // [esp+10h] [ebp-8h]
  int v39; // [esp+14h] [ebp-4h]
  int v40; // [esp+14h] [ebp-4h]
  int *v41; // [esp+24h] [ebp+Ch]
  char v42; // [esp+27h] [ebp+Fh]
  int v43; // [esp+28h] [ebp+10h]
  unsigned int v44; // [esp+28h] [ebp+10h]
  int v45; // [esp+28h] [ebp+10h]
  char v46; // [esp+2Bh] [ebp+13h]

  v3 = a1[4];
  v4 = (unsigned int)(a2 - a1[3]) >> 15;
  v37 = 516 * v4 + v3 + 324;
  v5 = (a3 + 23) & 0xFFFFFFF0;
  v6 = *(_DWORD *)(a2 - 4) - 1;
  v7 = (int *)(v6 + a2 - 4);
  v8 = *v7;
  v43 = v6;
  v39 = *v7;
  if ( v5 <= v6 )
  {
    if ( v5 < v6 )
    {
      v45 = v6 - v5;
      v24 = v5 + 1;
      *(_DWORD *)(a2 - 4) = v5 + 1;
      v25 = (int *)(a2 + v5 - 4);
      v26 = (v45 >> 4) - 1;
      v41 = v25;
      *(v25 - 1) = v24;
      if ( v26 > 0x3F )
        v26 = 63;
      if ( (v39 & 1) == 0 )
      {
        v27 = (v39 >> 4) - 1;
        if ( v27 > 0x3F )
          v27 = 63;
        if ( v7[1] == v7[2] )
        {
          if ( v27 >= 0x20 )
          {
            v31 = (_BYTE *)(v27 + v3 + 4);
            v32 = ~(0x80000000 >> (v27 - 32));
            *(_DWORD *)(v3 + 4 * v4 + 196) &= v32;
            v13 = (*v31)-- == 1;
            if ( v13 )
              a1[1] &= v32;
          }
          else
          {
            v28 = 0x80000000 >> v27;
            v29 = (_BYTE *)(v27 + v3 + 4);
            v30 = ~v28;
            *(_DWORD *)(v3 + 4 * v4 + 68) &= v30;
            v13 = (*v29)-- == 1;
            if ( v13 )
              *a1 &= v30;
          }
          v25 = v41;
        }
        *(_DWORD *)(v7[2] + 4) = v7[1];
        *(_DWORD *)(v7[1] + 8) = v7[2];
        v45 += v39;
        v26 = (v45 >> 4) - 1;
        if ( v26 > 0x3F )
          v26 = 63;
      }
      v33 = v37 + 8 * v26;
      v34 = *(_DWORD *)(v33 + 4);
      v25[2] = v33;
      v25[1] = v34;
      *(_DWORD *)(v33 + 4) = v25;
      *(_DWORD *)(v25[1] + 8) = v25;
      if ( v25[1] == v25[2] )
      {
        v42 = *(_BYTE *)(v26 + v3 + 4);
        *(_BYTE *)(v26 + v3 + 4) = v42 + 1;
        if ( v26 >= 0x20 )
        {
          if ( !v42 )
            a1[1] |= 0x80000000 >> (v26 - 32);
          v35 = (_DWORD *)(v3 + 4 * v4 + 196);
          v36 = v26 - 32;
        }
        else
        {
          if ( !v42 )
            *a1 |= 0x80000000 >> v26;
          v35 = (_DWORD *)(v3 + 4 * v4 + 68);
          v36 = v26;
        }
        *v35 |= 0x80000000 >> v36;
      }
      *v25 = v45;
      *(int *)((char *)v25 + v45 - 4) = v45;
    }
  }
  else
  {
    if ( (v8 & 1) != 0 || v5 > v6 + v8 )
      return 0;
    v9 = (v39 >> 4) - 1;
    v38 = v9;
    if ( v9 > 0x3F )
    {
      v9 = 63;
      v38 = 63;
    }
    if ( v7[1] == v7[2] )
    {
      if ( v9 >= 0x20 )
      {
        v14 = 0x80000000 >> (v9 - 32);
        v15 = (_BYTE *)(v38 + v3 + 4);
        v16 = ~v14;
        *(_DWORD *)(v3 + 4 * v4 + 196) &= v16;
        v13 = (*v15)-- == 1;
        if ( v13 )
          a1[1] &= v16;
      }
      else
      {
        v10 = 0x80000000 >> v9;
        v11 = (_BYTE *)(v38 + v3 + 4);
        v12 = ~v10;
        *(_DWORD *)(v3 + 4 * v4 + 68) &= v12;
        v13 = (*v11)-- == 1;
        if ( v13 )
          *a1 &= v12;
      }
    }
    *(_DWORD *)(v7[2] + 4) = v7[1];
    *(_DWORD *)(v7[1] + 8) = v7[2];
    v40 = v43 - v5 + v39;
    if ( v40 <= 0 )
    {
      v21 = a2;
    }
    else
    {
      v17 = (v40 >> 4) - 1;
      v18 = a2 + v5 - 4;
      if ( v17 > 0x3F )
        v17 = 63;
      v44 = v37 + 8 * v17;
      *(_DWORD *)(a2 + v5) = *(_DWORD *)(v44 + 4);
      *(_DWORD *)(v18 + 8) = v44;
      *(_DWORD *)(v44 + 4) = v18;
      *(_DWORD *)(*(_DWORD *)(a2 + v5) + 8) = a2 + v5 - 4;
      if ( *(_DWORD *)(a2 + v5) == *(_DWORD *)(a2 + v5 - 4 + 8) )
      {
        v46 = *(_BYTE *)(v17 + v3 + 4);
        *(_BYTE *)(v17 + v3 + 4) = v46 + 1;
        if ( v17 >= 0x20 )
        {
          if ( !v46 )
            a1[1] |= 0x80000000 >> (v17 - 32);
          v19 = (_DWORD *)(v3 + 4 * v4 + 196);
          v20 = v17 - 32;
        }
        else
        {
          if ( !v46 )
            *a1 |= 0x80000000 >> v17;
          v19 = (_DWORD *)(v3 + 4 * v4 + 68);
          v20 = v17;
        }
        *v19 |= 0x80000000 >> v20;
      }
      v21 = a2;
      v22 = (int *)(a2 + v5 - 4);
      *v22 = v40;
      *(int *)((char *)v22 + v40 - 4) = v40;
    }
    *(_DWORD *)(v21 - 4) = v5 + 1;
    *(_DWORD *)(v21 + v5 - 8) = v5 + 1;
  }
  return 1;
}


/* ==== 410E7E  ___sbh_alloc_block  ()  size=764 ==== */
_DWORD *__cdecl __sbh_alloc_block(int a1)
{
  int v1; // ecx
  unsigned int v2; // esi
  char *j; // ebx
  bool i; // cf
  _DWORD *v5; // eax
  int v6; // edx
  _DWORD *v7; // ecx
  int v8; // edx
  int v9; // edi
  int v10; // ecx
  int *v12; // edx
  int v13; // ecx
  int v14; // esi
  unsigned int v15; // ebx
  _BYTE *v16; // edi
  bool v17; // zf
  unsigned int v18; // ebx
  _BYTE *v19; // edi
  int v20; // ebx
  _DWORD *v21; // ecx
  int v22; // edi
  _DWORD *v23; // edx
  int v24; // [esp+Ch] [ebp-14h]
  int v25; // [esp+Ch] [ebp-14h]
  signed int v26; // [esp+10h] [ebp-10h]
  _DWORD *v27; // [esp+14h] [ebp-Ch]
  unsigned int v28; // [esp+18h] [ebp-8h]
  int v29; // [esp+18h] [ebp-8h]
  char *v30; // [esp+1Ch] [ebp-4h]
  int v31; // [esp+1Ch] [ebp-4h]
  char *v32; // [esp+28h] [ebp+8h]
  char v33; // [esp+2Bh] [ebp+Bh]

  v26 = (a1 + 23) & 0xFFFFFFF0;
  v1 = (v26 >> 4) - 1;
  v30 = (char *)lpMem + 20 * dword_430724;
  if ( v1 >= 32 )
  {
    v2 = 0;
    v28 = 0xFFFFFFFF >> ((v26 >> 4) - 33);
  }
  else
  {
    v2 = 0xFFFFFFFF >> v1;
    v28 = -1;
  }
  j = (char *)dword_430730;
  for ( i = dword_430730 < (unsigned int)lpMem + 20 * dword_430724; ; i = j < v30 )
  {
    v32 = j;
    if ( !i || v2 & *(_DWORD *)j | v28 & *((_DWORD *)j + 1) )
      break;
    j += 20;
  }
  if ( j == v30 )
  {
    for ( j = (char *)lpMem; ; j += 20 )
    {
      v32 = j;
      if ( (unsigned int)j >= dword_430730 || v2 & *(_DWORD *)j | v28 & *((_DWORD *)j + 1) )
        break;
    }
    if ( j == (char *)dword_430730 )
    {
      while ( j < v30 && !*((_DWORD *)j + 2) )
      {
        j += 20;
        v32 = j;
      }
      if ( j == v30 )
      {
        for ( j = (char *)lpMem; ; j += 20 )
        {
          v32 = j;
          if ( (unsigned int)j >= dword_430730 || *((_DWORD *)j + 2) )
            break;
        }
        if ( j == (char *)dword_430730 )
        {
          j = __sbh_alloc_new_region();
          v32 = j;
          if ( !j )
            return 0;
        }
      }
      **((_DWORD **)j + 4) = __sbh_alloc_new_group(j);
      if ( **((_DWORD **)j + 4) == -1 )
        return 0;
    }
  }
  dword_430730 = (int)j;
  v5 = (_DWORD *)*((_DWORD *)j + 4);
  v6 = *v5;
  v31 = *v5;
  if ( *v5 == -1 || !(v2 & v5[v6 + 17] | v28 & v5[v6 + 49]) )
  {
    v31 = 0;
    v7 = v5 + 17;
    if ( !(v2 & v5[17] | v28 & v5[49]) )
    {
      do
      {
        v8 = v28 & v7[33];
        ++v31;
        ++v7;
      }
      while ( !(v2 & *v7 | v8) );
    }
    v6 = v31;
  }
  v27 = &v5[129 * v6 + 81];
  v9 = 0;
  v10 = v2 & v5[v6 + 17];
  if ( !v10 )
  {
    v10 = v28 & v5[v6 + 49];
    v9 = 32;
  }
  while ( v10 >= 0 )
  {
    v10 *= 2;
    ++v9;
  }
  v12 = (int *)v27[2 * v9 + 1];
  v13 = *v12 - v26;
  v14 = (v13 >> 4) - 1;
  v29 = v13;
  if ( v14 > 63 )
    v14 = 63;
  if ( v14 == v9 )
    goto LABEL_55;
  if ( v12[1] != v12[2] )
    goto LABEL_45;
  if ( v9 >= 32 )
  {
    v18 = 0x80000000 >> (v9 - 32);
    v19 = (char *)v5 + v9 + 4;
    v20 = ~v18;
    v5[v31 + 49] &= v20;
    v17 = (*v19)-- == 1;
    v25 = v20;
    if ( v17 )
    {
      j = v32;
      *((_DWORD *)v32 + 1) &= v25;
      goto LABEL_45;
    }
  }
  else
  {
    v15 = 0x80000000 >> v9;
    v16 = (char *)v5 + v9 + 4;
    v24 = ~v15;
    v5[v31 + 17] &= ~v15;
    v17 = (*v16)-- == 1;
    if ( v17 )
    {
      j = v32;
      *(_DWORD *)v32 &= v24;
      goto LABEL_45;
    }
  }
  j = v32;
LABEL_45:
  *(_DWORD *)(v12[2] + 4) = v12[1];
  *(_DWORD *)(v12[1] + 8) = v12[2];
  if ( v13 )
  {
    v21 = &v27[2 * v14];
    v22 = v21[1];
    v12[2] = (int)v21;
    v12[1] = v22;
    v21[1] = v12;
    *(_DWORD *)(v12[1] + 8) = v12;
    if ( v12[1] == v12[2] )
    {
      v33 = *((_BYTE *)v5 + v14 + 4);
      *((_BYTE *)v5 + v14 + 4) = v33 + 1;
      if ( v14 >= 32 )
      {
        if ( !v33 )
          *((_DWORD *)j + 1) |= 0x80000000 >> (v14 - 32);
        v5[v31 + 49] |= 0x80000000 >> (v14 - 32);
      }
      else
      {
        if ( !v33 )
          *(_DWORD *)j |= 0x80000000 >> v14;
        v5[v31 + 17] |= 0x80000000 >> v14;
      }
    }
    v13 = v29;
LABEL_55:
    if ( v13 )
    {
      *v12 = v13;
      *(int *)((char *)v12 + v13 - 4) = v13;
    }
    goto LABEL_58;
  }
  v13 = 0;
LABEL_58:
  v23 = (int *)((char *)v12 + v13);
  *v23 = v26 + 1;
  *(_DWORD *)((char *)v23 + v26 - 4) = v26 + 1;
  v17 = (*v27)++ == 0;
  if ( v17 && j == dword_430720 && v31 == dword_430738 )
    dword_430720 = 0;
  *v5 = v31;
  return v23 + 1;
}


/* ==== 41117A  __callnewh  ()  size=27 ==== */
int __cdecl _callnewh(size_t Size)
{
  return dword_430378 && dword_430378(Size);
}


/* ==== 411195  __ValidateEH3RN  ()  size=553 ==== */
int __cdecl _ValidateEH3RN(unsigned int a1)
{
  unsigned int v2; // ebx
  struct _TEB *v3; // eax
  unsigned int v5; // edi
  unsigned int v6; // edx
  unsigned int *v7; // eax
  unsigned int v8; // eax
  unsigned int v9; // edi
  int v10; // esi
  char *v11; // eax
  unsigned int v12; // ebx
  int v13; // ecx
  unsigned int v14; // eax
  int v15; // ecx
  int v16; // edx
  _DWORD *v17; // eax
  int v18; // ebx
  int j; // edx
  unsigned int *v20; // eax
  int v21; // esi
  int v22; // eax
  int i; // ecx
  unsigned int *v24; // eax
  int v25; // edx
  struct _MEMORY_BASIC_INFORMATION Buffer; // [esp+8h] [ebp-20h] BYREF
  PVOID StackLimit; // [esp+24h] [ebp-4h]
  int v28; // [esp+30h] [ebp+8h]

  v2 = *(_DWORD *)(a1 + 8);
  if ( (v2 & 3) != 0 )
    return 0;
  v3 = NtCurrentTeb();
  StackLimit = v3->NtTib.StackLimit;
  if ( v2 >= (unsigned int)StackLimit && (PVOID)v2 < v3->NtTib.StackBase )
    return 0;
  v5 = *(_DWORD *)(a1 + 12);
  if ( v5 == -1 )
    return 1;
  v6 = 0;
  v28 = 0;
  v7 = (unsigned int *)v2;
  do
  {
    if ( *v7 != -1 && *v7 >= v6 )
      return 0;
    if ( v7[1] )
      ++v28;
    ++v6;
    v7 += 3;
  }
  while ( v6 <= v5 );
  if ( v28 )
  {
    v8 = *(_DWORD *)(a1 - 8);
    if ( v8 < (unsigned int)StackLimit || v8 >= a1 )
      return 0;
  }
  v9 = v2 & 0xFFFFF000;
  v10 = 0;
  if ( dword_430380 > 0 )
  {
    while ( dword_430388[v10] != v9 )
    {
      if ( ++v10 >= dword_430380 )
        goto LABEL_19;
    }
    if ( v10 <= 0 || InterlockedExchange(&dword_4303C8, 1) )
      return 1;
    if ( dword_430388[v10] != v9 )
    {
      v22 = dword_430380;
      v10 = dword_430380 - 1;
      if ( dword_430380 - 1 < 0 )
        goto LABEL_50;
      do
      {
        if ( dword_430388[v10] == v9 )
          break;
        --v10;
      }
      while ( v10 >= 0 );
      if ( v10 >= 0 )
      {
        if ( !v10 )
        {
LABEL_56:
          InterlockedExchange(&dword_4303C8, 0);
          return 1;
        }
      }
      else
      {
LABEL_50:
        if ( dword_430380 < 16 )
          v22 = ++dword_430380;
        v10 = v22 - 1;
      }
    }
    for ( i = 0; i <= v10; v9 = v25 )
    {
      v24 = (unsigned int *)(4 * i + 4391816);
      v25 = dword_430388[i++];
      *v24 = v9;
    }
    goto LABEL_56;
  }
LABEL_19:
  if ( VirtualQuery((LPCVOID)v2, &Buffer, 0x1Cu) && Buffer.Type == 0x1000000 )
  {
    if ( (Buffer.Protect & 0xCC) == 0 )
      goto LABEL_29;
    if ( *(_WORD *)Buffer.AllocationBase == 23117 )
    {
      v11 = (char *)Buffer.AllocationBase + *((_DWORD *)Buffer.AllocationBase + 15);
      if ( *(_DWORD *)v11 == 17744 && *((_WORD *)v11 + 12) == 267 )
      {
        v12 = v2 - (unsigned int)Buffer.AllocationBase;
        v13 = (int)&v11[*((unsigned __int16 *)v11 + 10) + 24];
        if ( *((_WORD *)v11 + 3) )
        {
          v14 = *(_DWORD *)&v11[*((unsigned __int16 *)v11 + 10) + 36];
          if ( v12 < v14 || v12 >= v14 + *(_DWORD *)(v13 + 8) || *(char *)(v13 + 39) >= 0 )
          {
LABEL_29:
            if ( !InterlockedExchange(&dword_4303C8, 1) )
            {
              v15 = dword_430380;
              v16 = dword_430380;
              if ( dword_430380 > 0 )
              {
                v17 = (_DWORD *)(4 * dword_430380 + 4391812);
                do
                {
                  if ( *v17 == v9 )
                    break;
                  --v16;
                  --v17;
                }
                while ( v16 > 0 );
              }
              if ( !v16 )
              {
                v18 = 15;
                if ( dword_430380 <= 15 )
                  v18 = dword_430380;
                for ( j = 0; j <= v18; v9 = v21 )
                {
                  v20 = (unsigned int *)(4 * j + 4391816);
                  v21 = dword_430388[j++];
                  *v20 = v9;
                }
                if ( v15 < 16 )
                  dword_430380 = v15 + 1;
              }
              InterlockedExchange(&dword_4303C8, 0);
            }
            return 1;
          }
          return 0;
        }
      }
    }
  }
  return -1;
}


/* ==== 4113BE  __forcdecpt  ()  size=60 ==== */
char __cdecl _forcdecpt(char *a1)
{
  char *v1; // esi
  bool i; // zf
  char result; // al
  char *v4; // esi
  char v5; // cl

  v1 = a1;
  for ( i = tolower(*a1) == 101; !i; i = isdigit(*v1) == 0 )
    ++v1;
  result = *v1;
  *v1 = byte_42D694;
  v4 = v1 + 1;
  do
  {
    v5 = *v4;
    *v4 = result;
    result = v5;
  }
  while ( *v4++ );
  return result;
}


/* ==== 41145F  __fassign  ()  size=62 ==== */
_DWORD *__cdecl _fassign(int a1, _DWORD *a2, int a3)
{
  _DWORD *result; // eax
  _DWORD v4[2]; // [esp+0h] [ebp-8h] BYREF

  if ( a1 )
  {
    sub_4150AE(v4, a3);
    result = a2;
    *a2 = v4[0];
    result[1] = v4[1];
  }
  else
  {
    sub_4150F3(&a1, a3);
    result = a2;
    *a2 = a1;
  }
  return result;
}


/* ==== 41149D  __shift  ()  size=29 ==== */
const char *__usercall _shift@<eax>(const char *result@<eax>, int a2@<edi>)
{
  const char *v2; // esi
  size_t v3; // eax

  v2 = result;
  if ( a2 )
  {
    v3 = strlen(result);
    return (const char *)memcpy((void *)&v2[a2], v2, v3 + 1);
  }
  return result;
}


/* ==== 4114BA  __cftoe2  ()  size=174 ==== */
_BYTE *__usercall _cftoe2@<eax>(int a1@<eax>, _BYTE *a2@<ebx>, int a3, int a4, char a5)
{
  _BYTE *v6; // eax
  char *v7; // eax
  _BYTE *v8; // ecx
  int v9; // eax
  _BYTE *v10; // ecx
  _BYTE *v11; // ecx

  if ( a5 )
    _shift(&a2[*(_DWORD *)a1 == 45], a3 > 0);
  v6 = a2;
  if ( *(_DWORD *)a1 == 45 )
  {
    *a2 = 45;
    v6 = a2 + 1;
  }
  if ( a3 > 0 )
  {
    *v6 = v6[1];
    *++v6 = byte_42D694;
  }
  v7 = strcpy(&v6[(a5 == 0) + a3], "e+000");
  if ( a4 )
    *v7 = 69;
  v8 = v7 + 1;
  if ( **(_BYTE **)(a1 + 12) != 48 )
  {
    v9 = *(_DWORD *)(a1 + 4) - 1;
    if ( v9 < 0 )
    {
      v9 = 1 - *(_DWORD *)(a1 + 4);
      *v8 = 45;
    }
    v10 = v8 + 1;
    if ( v9 >= 100 )
    {
      *v10 += v9 / 100;
      v9 %= 100;
    }
    v11 = v10 + 1;
    if ( v9 >= 10 )
    {
      *v11 += v9 / 10;
      LOBYTE(v9) = v9 % 10;
    }
    v11[1] += v9;
  }
  return a2;
}


/* ==== 411568  sub_411568  ()  size=112 ==== */
_BYTE *__cdecl sub_411568(_DWORD *a1, _BYTE *a2, int a3, int a4)
{
  int v5[4]; // [esp+8h] [ebp-2Ch] BYREF
  _BYTE v6[24]; // [esp+18h] [ebp-1Ch] BYREF

  _fltout2(*a1, a1[1], v5, v6);
  _fptostr(&a2[(v5[0] == 45) + (a3 > 0)], a3 + 1, (int)v5);
  _cftoe2((int)v5, a2, a3, a4, 0);
  return a2;
}


/* ==== 4115D8  __cftof2  ()  size=156 ==== */
char *__usercall _cftof2@<eax>(_DWORD *a1@<eax>, char *a2, int Size, char a4)
{
  int v5; // eax
  char *v6; // eax
  char *v7; // ebx
  int v8; // eax
  char *v9; // ebx
  int v10; // esi
  char *v11; // ebx
  int v12; // esi

  v5 = a1[1] - 1;
  if ( a4 && v5 == Size )
  {
    v6 = &a2[v5 + (*a1 == 45)];
    *v6 = 48;
    v6[1] = 0;
  }
  v7 = a2;
  if ( *a1 == 45 )
  {
    *a2 = 45;
    v7 = a2 + 1;
  }
  v8 = a1[1];
  if ( v8 > 0 )
  {
    v9 = &v7[v8];
  }
  else
  {
    _shift(v7, 1);
    *v7 = 48;
    v9 = v7 + 1;
  }
  if ( Size > 0 )
  {
    _shift(v9, 1);
    *v9 = byte_42D694;
    v10 = a1[1];
    v11 = v9 + 1;
    if ( v10 < 0 )
    {
      v12 = -v10;
      if ( a4 || Size >= v12 )
        Size = v12;
      _shift(v11, Size);
      memset(v11, 48, Size);
    }
  }
  return a2;
}


/* ==== 411674  sub_411674  ()  size=103 ==== */
char *__cdecl sub_411674(_DWORD *a1, char *a2, size_t Size)
{
  int v4[4]; // [esp+8h] [ebp-2Ch] BYREF
  _BYTE v5[24]; // [esp+18h] [ebp-1Ch] BYREF

  _fltout2(*a1, a1[1], v4, v5);
  _fptostr(&a2[v4[0] == 45], Size + v4[1], (int)v4);
  _cftof2(v4, a2, Size, 0);
  return a2;
}


/* ==== 4116DB  sub_4116DB  ()  size=159 ==== */
char *__cdecl sub_4116DB(_DWORD *a1, char *a2, signed int Size, int a4)
{
  int v4; // esi
  char *v5; // edi
  int v7; // [esp+Ch] [ebp-2Ch] BYREF
  int v8; // [esp+10h] [ebp-28h]
  char v9[24]; // [esp+1Ch] [ebp-1Ch] BYREF

  _fltout2(*a1, a1[1], &v7, v9);
  v4 = v8 - 1;
  v5 = &a2[v7 == 45];
  _fptostr(v5, Size, (int)&v7);
  if ( v8 - 1 < -4 || v8 - 1 >= Size )
    return _cftoe2((int)&v7, a2, Size, a4, 1);
  if ( v4 < v8 - 1 )
    v5[strlen(v5) - 1] = 0;
  return _cftof2(&v7, a2, Size, 1);
}


/* ==== 41177A  __cfltcvt  ()  size=81 ==== */
char *__cdecl _cfltcvt(_DWORD *a1, char *a2, int a3, size_t Size, int a5)
{
  if ( a3 == 101 || a3 == 69 )
    return sub_411568(a1, a2, Size, a5);
  if ( a3 == 102 )
    return sub_411674(a1, a2, Size);
  return sub_4116DB(a1, a2, Size, a5);
}


/* ==== 4117CB  __setdefaultprecision  ()  size=18 ==== */
unsigned int _setdefaultprecision()
{
  return _controlfp(0x10000u, 0x30000u);
}


/* ==== 4117DD  __ms_p5_test_fdiv  ()  size=64 ==== */
BOOL _ms_p5_test_fdiv()
{
  return 4195835.0 - 4195835.0 / 3145727.0 * 3145727.0 > 1.0;
}


/* ==== 41181D  __ms_p5_mp_test_fdiv  ()  size=41 ==== */
int _ms_p5_mp_test_fdiv()
{
  HMODULE ModuleHandleA; // eax
  BOOL (__stdcall *IsProcessorFeaturePresent)(DWORD); // eax

  ModuleHandleA = GetModuleHandleA("KERNEL32");
  if ( ModuleHandleA
    && (IsProcessorFeaturePresent = (BOOL (__stdcall *)(DWORD))GetProcAddress(
                                                                 ModuleHandleA,
                                                                 "IsProcessorFeaturePresent")) != 0 )
  {
    return IsProcessorFeaturePresent(0);
  }
  else
  {
    return _ms_p5_test_fdiv();
  }
}


/* ==== 411850  _strcmp  ()  size=136 ==== */
int __cdecl strcmp(const char *Str1, const char *Str2)
{
  const char *v2; // edx
  const char *v3; // ecx
  unsigned int v4; // eax
  bool v5; // cf
  unsigned int v6; // eax
  __int16 v8; // ax

  v2 = Str1;
  v3 = Str2;
  if ( ((unsigned __int8)Str1 & 3) == 0 )
  {
dodwords:
    while ( 1 )
    {
      v4 = *(_DWORD *)v2;
      v5 = (unsigned __int8)*(_DWORD *)v2 < (unsigned int)*v3;
      if ( (unsigned __int8)*(_DWORD *)v2 != *v3 )
        break;
      if ( !(_BYTE)v4 )
        return 0;
      v5 = BYTE1(v4) < (unsigned int)v3[1];
      if ( BYTE1(v4) != v3[1] )
        break;
      if ( !BYTE1(v4) )
        return 0;
      v6 = HIWORD(v4);
      v5 = (unsigned __int8)v6 < (unsigned int)v3[2];
      if ( (_BYTE)v6 != v3[2] )
        break;
      if ( !(_BYTE)v6 )
        return 0;
      v5 = BYTE1(v6) < (unsigned int)v3[3];
      if ( BYTE1(v6) != v3[3] )
        break;
      v3 += 4;
      v2 += 4;
      if ( !BYTE1(v6) )
        return 0;
    }
    return -2 * v5 + 1;
  }
  if ( ((unsigned __int8)Str1 & 1) != 0 )
  {
    v2 = Str1 + 1;
    v5 = *Str1 < (unsigned int)*Str2;
    if ( *Str1 != *Str2 )
      return -2 * v5 + 1;
    v3 = Str2 + 1;
    if ( !*Str1 )
      return 0;
    if ( ((unsigned __int8)v2 & 2) == 0 )
      goto dodwords;
  }
  v8 = *(_WORD *)v2;
  v2 += 2;
  v5 = (unsigned __int8)v8 < (unsigned int)*v3;
  if ( (_BYTE)v8 != *v3 )
    return -2 * v5 + 1;
  if ( !(_BYTE)v8 )
    return 0;
  v5 = HIBYTE(v8) < (unsigned int)v3[1];
  if ( HIBYTE(v8) == v3[1] )
  {
    if ( HIBYTE(v8) )
    {
      v3 += 2;
      goto dodwords;
    }
    return 0;
  }
  return -2 * v5 + 1;
}


/* ==== 4118D8  ___isctype_mt  ()  size=119 ==== */
int __cdecl __isctype_mt(UINT *a1, int CharType, int a3)
{
  int v3; // ecx
  int v4; // eax
  int v5; // eax
  int result; // eax
  int MultiByteStr; // [esp+0h] [ebp-4h] BYREF

  MultiByteStr = v3;
  if ( (unsigned int)(CharType + 1) <= 0x100 )
  {
    v4 = *(unsigned __int16 *)(a1[18] + 2 * CharType);
    return a3 & v4;
  }
  if ( *(char *)(a1[18] + 2 * BYTE1(CharType) + 1) >= 0 )
  {
    LOWORD(MultiByteStr) = (unsigned __int8)CharType;
    v5 = 1;
  }
  else
  {
    *(_WORD *)((char *)&MultiByteStr + 1) = (unsigned __int8)CharType;
    LOBYTE(MultiByteStr) = BYTE1(CharType);
    v5 = 2;
  }
  result = __crtGetStringTypeA(1u, (LPCCH)&MultiByteStr, v5, (LPWORD)&CharType + 1, a1[1], a1[5], 1);
  if ( result )
  {
    v4 = HIWORD(CharType);
    return a3 & v4;
  }
  return result;
}


/* ==== 411960  _strchr  ()  size=190 ==== */
char *__cdecl strchr(const char *Str, int Val)
{
  const char *v2; // edx
  char v3; // cl
  int v4; // ecx
  int v5; // esi
  int v6; // eax
  unsigned int v7; // eax
  unsigned int v9; // eax
  unsigned int v10; // eax

  v2 = Str;
  if ( ((unsigned __int8)Str & 3) != 0 )
  {
    while ( 1 )
    {
      v3 = *v2++;
      if ( v3 == (_BYTE)Val )
        return (char *)(v2 - 1);
      if ( !v3 )
        return 0;
      if ( ((unsigned __int8)v2 & 3) == 0 )
        goto main_loop_2;
    }
  }
  else
  {
    while ( 1 )
    {
main_loop_2:
      while ( 1 )
      {
        v4 = (((unsigned __int8)Val << 8)
            | (unsigned __int8)Val
            | ((((unsigned __int8)Val << 8) | (unsigned __int8)Val) << 16))
           ^ *(_DWORD *)v2;
        v5 = *(_DWORD *)v2 + 2130640639;
        v6 = v5 ^ ~*(_DWORD *)v2;
        v2 += 4;
        if ( (((v4 + 2130640639) ^ ~v4) & 0x81010100) != 0 )
          break;
        v7 = v6 & 0x81010100;
        if ( v7 && ((v7 & 0x1010100) != 0 || (v5 & 0x80000000) == 0) )
          return 0;
      }
      v9 = *((_DWORD *)v2 - 1);
      if ( (_BYTE)v9 == (_BYTE)Val )
        break;
      if ( !(_BYTE)v9 )
        return 0;
      if ( BYTE1(v9) == (_BYTE)Val )
        return (char *)(v2 - 3);
      if ( !BYTE1(v9) )
        return 0;
      v10 = HIWORD(v9);
      if ( (_BYTE)v10 == (_BYTE)Val )
        return (char *)(v2 - 2);
      if ( !(_BYTE)v10 )
        return 0;
      if ( BYTE1(v10) == (_BYTE)Val )
        return (char *)(v2 - 1);
      if ( !BYTE1(v10) )
        return 0;
    }
    return (char *)(v2 - 4);
  }
}


/* ==== 411A1E  sub_411A1E  ()  size=376 ==== */
unsigned int __cdecl sub_411A1E(int a1)
{
  unsigned int result; // eax
  int v2; // esi
  char *v3; // edi
  size_t v4; // ebx
  void *v5; // esp
  const char **v6; // esi
  HANDLE StdHandle; // eax
  _BYTE v8[27]; // [esp-2Bh] [ebp-B7h] BYREF
  const char *v9; // [esp-10h] [ebp-9Ch]
  DWORD v10; // [esp-Ch] [ebp-98h]
  DWORD *v11; // [esp-8h] [ebp-94h]
  int v12; // [esp-4h] [ebp-90h]
  DWORD v13[69]; // [esp+0h] [ebp-8Ch] BYREF
  char v14; // [esp+114h] [ebp+88h]

  for ( result = 0; result < 0x13; ++result )
  {
    if ( a1 == dword_42D570[2 * result] )
      break;
  }
  v2 = 2 * result;
  if ( a1 == dword_42D570[2 * result] )
  {
    result = dword_43013C;
    if ( dword_43013C == 1 || !dword_43013C && dword_42CBD4 == 1 )
    {
      v12 = 0;
      v11 = &v13[3];
      v6 = (const char **)&(&off_42D574)[v2];
      v10 = strlen(*v6);
      v9 = *v6;
      StdHandle = GetStdHandle(0xFFFFFFF4);
      return WriteFile(StdHandle, v9, v10, &v13[3], 0);
    }
    else if ( a1 != 252 )
    {
      v14 = 0;
      if ( !GetModuleFileNameA(0, (LPSTR)&v13[4], 0x104u) )
        strcpy((char *)&v13[4], "<program name unknown>");
      v3 = (char *)&v13[4];
      if ( strlen((const char *)&v13[4]) + 1 > 0x3C )
      {
        v3 = &v8[strlen((const char *)&v13[4])];
        strncpy(v3, "...", 3u);
      }
      v4 = strlen(v3);
      v5 = alloca(v4 + strlen((&off_42D574)[v2]) + 28);
      strcpy((char *)v13, "Runtime Error!\n\nProgram: ");
      strcat((char *)v13, v3);
      strcat((char *)v13, "\n\n");
      strcat((char *)v13, (&off_42D574)[v2]);
      return __crtMessageBoxA(v13, "Microsoft Visual C++ Runtime Library", 8208);
    }
  }
  return result;
}


/* ==== 411B96  __FF_MSGBANNER  ()  size=57 ==== */
unsigned int _FF_MSGBANNER()
{
  unsigned int result; // eax

  result = dword_43013C;
  if ( dword_43013C == 1 || !dword_43013C && dword_42CBD4 == 1 )
  {
    sub_411A1E(252);
    if ( dword_4303CC )
      dword_4303CC();
    return sub_411A1E(255);
  }
  return result;
}


/* ==== 411BCF  __wincmdln  ()  size=93 ==== */
const CHAR *_wincmdln()
{
  BOOL v0; // edi
  const CHAR *v1; // esi
  unsigned __int8 v2; // al

  v0 = 0;
  if ( !dword_4319B0 )
    __initmbctable();
  v1 = (const CHAR *)dword_4319A0;
  if ( !dword_4319A0 )
    v1 = ValueName;
  while ( 1 )
  {
    v2 = *v1;
    if ( *v1 <= 0x20u )
    {
      if ( !v2 )
        return v1;
      if ( !v0 )
        break;
    }
    if ( v2 == 34 )
      v0 = !v0;
    if ( _ismbblead(v2) )
      ++v1;
    ++v1;
  }
  while ( *v1 && *v1 <= 0x20u )
    ++v1;
  return v1;
}


/* ==== 411C2C  __setenvp  ()  size=199 ==== */
int _setenvp()
{
  char *v0; // esi
  int v1; // edi
  _DWORD *v2; // edi
  char *i; // esi
  size_t v5; // eax
  size_t v6; // ebp
  char *v7; // eax

  if ( !dword_4319B0 )
    __initmbctable();
  v0 = dword_430134;
  v1 = 0;
  if ( !dword_430134 )
    return -1;
  while ( *v0 )
  {
    if ( *v0 != 61 )
      ++v1;
    v0 += strlen(v0) + 1;
  }
  v2 = malloc(4 * v1 + 4);
  dword_430108 = v2;
  if ( !v2 )
    return -1;
  for ( i = dword_430134; ; i += v6 )
  {
    if ( !*i )
    {
      free(dword_430134);
      dword_430134 = 0;
      *v2 = 0;
      dword_4319A4 = 1;
      return 0;
    }
    v5 = strlen(i);
    v6 = v5 + 1;
    if ( *i != 61 )
      break;
LABEL_15:
    ;
  }
  v7 = (char *)malloc(v5 + 1);
  *v2 = v7;
  if ( v7 )
  {
    strcpy(v7, i);
    ++v2;
    goto LABEL_15;
  }
  free(dword_430108);
  dword_430108 = 0;
  return -1;
}


/* ==== 411CF3  _parse_cmdline  ()  size=364 ==== */
char **__usercall parse_cmdline@<eax>(char *a1@<eax>, char *a2@<ecx>, _DWORD *a3@<esi>, char **a4, _DWORD *a5)
{
  _DWORD *v5; // ebx
  BOOL v6; // edx
  char **v8; // ecx
  char v9; // cl
  int v10; // ebx
  char **v11; // ecx
  int v12; // ebx
  unsigned int v13; // edx
  unsigned __int8 v14; // cl
  char **result; // eax
  BOOL v16; // [esp+8h] [ebp-4h]

  v5 = a5;
  v6 = 0;
  *a3 = 0;
  *a5 = 1;
  if ( a4 )
  {
    v8 = a4++;
    *v8 = a2;
  }
  do
  {
    if ( *a1 == 34 )
    {
      ++a1;
      v6 = !v6;
      v9 = 34;
    }
    else
    {
      ++*a3;
      if ( a2 )
        *a2++ = *a1;
      v9 = *a1;
      v10 = (unsigned __int8)*a1++;
      if ( (byte_431781[v10] & 4) != 0 )
      {
        ++*a3;
        if ( a2 )
          *a2++ = *a1;
        ++a1;
      }
      v5 = a5;
      if ( !v9 )
      {
        --a1;
        goto LABEL_17;
      }
    }
  }
  while ( v6 || v9 != 32 && v9 != 9 );
  if ( a2 )
    *(a2 - 1) = 0;
LABEL_17:
  v16 = 0;
  while ( *a1 )
  {
    while ( *a1 == 32 || *a1 == 9 )
      ++a1;
    if ( !*a1 )
      break;
    if ( a4 )
    {
      v11 = a4++;
      *v11 = a2;
    }
    ++*v5;
    while ( 1 )
    {
      v12 = 1;
      v13 = 0;
      while ( *a1 == 92 )
      {
        ++a1;
        ++v13;
      }
      if ( *a1 == 34 )
      {
        if ( (v13 & 1) == 0 )
        {
          if ( v16 && a1[1] == 34 )
            ++a1;
          else
            v12 = 0;
          v16 = !v16;
        }
        v13 >>= 1;
      }
      for ( ; v13; --v13 )
      {
        if ( a2 )
          *a2++ = 92;
        ++*a3;
      }
      v14 = *a1;
      if ( !*a1 || !v16 && (v14 == 32 || v14 == 9) )
        break;
      if ( v12 )
      {
        if ( a2 )
        {
          if ( (byte_431781[v14] & 4) != 0 )
          {
            *a2++ = v14;
            ++a1;
            ++*a3;
          }
          *a2++ = *a1;
        }
        else if ( (byte_431781[v14] & 4) != 0 )
        {
          ++a1;
          ++*a3;
        }
        ++*a3;
      }
      ++a1;
    }
    if ( a2 )
      *a2++ = 0;
    ++*a3;
    v5 = a5;
  }
  result = a4;
  if ( a4 )
    *a4 = 0;
  ++*v5;
  return result;
}


/* ==== 411E5F  __setargv  ()  size=162 ==== */
int _setargv()
{
  char *v0; // ebx
  int v1; // esi
  char **v2; // eax
  int v3; // edi
  int v5; // [esp+Ch] [ebp-8h] BYREF
  int v6; // [esp+10h] [ebp-4h] BYREF

  if ( !dword_4319B0 )
    __initmbctable();
  byte_4304D4 = 0;
  GetModuleFileNameA(0, Filename, 0x104u);
  dword_430118 = (int)Filename;
  if ( !dword_4319A0 || (v0 = (char *)dword_4319A0, !*(_BYTE *)dword_4319A0) )
    v0 = Filename;
  parse_cmdline(v0, 0, &v5, 0, &v6);
  v1 = v6;
  v2 = (char **)malloc(4 * v6 + v5);
  v3 = (int)v2;
  if ( !v2 )
    return -1;
  parse_cmdline(v0, (char *)&v2[v1], &v5, v2, &v6);
  dword_4300FC = v6 - 1;
  dword_430100 = v3;
  return 0;
}


/* ==== 411F01  ___crtGetEnvironmentStringsA  ()  size=290 ==== */
CHAR *__crtGetEnvironmentStringsA()
{
  int v0; // eax
  CHAR *v1; // ebx
  WCHAR *EnvironmentStringsW; // esi
  WCHAR *i; // eax
  size_t v4; // eax
  int v5; // ebp
  CHAR *v6; // eax
  LPCH EnvironmentStrings; // eax
  LPCH v9; // esi
  size_t v10; // ebp
  void *v11; // eax
  void *v12; // edi
  CHAR *Block; // [esp+10h] [ebp-8h]
  int cchWideChar; // [esp+14h] [ebp-4h]

  v0 = dword_4304D8;
  v1 = 0;
  EnvironmentStringsW = 0;
  if ( !dword_4304D8 )
  {
    EnvironmentStringsW = GetEnvironmentStringsW();
    if ( EnvironmentStringsW )
    {
      dword_4304D8 = 1;
LABEL_8:
      if ( EnvironmentStringsW || (EnvironmentStringsW = GetEnvironmentStringsW()) != 0 )
      {
        for ( i = EnvironmentStringsW; *i; ++i )
        {
          do
            ++i;
          while ( *i );
        }
        cchWideChar = i - EnvironmentStringsW + 1;
        v4 = WideCharToMultiByte(0, 0, EnvironmentStringsW, cchWideChar, 0, 0, 0, 0);
        v5 = v4;
        if ( v4 )
        {
          v6 = (CHAR *)malloc(v4);
          Block = v6;
          if ( v6 )
          {
            if ( !WideCharToMultiByte(0, 0, EnvironmentStringsW, cchWideChar, v6, v5, 0, 0) )
            {
              free(Block);
              Block = 0;
            }
            v1 = Block;
          }
        }
        FreeEnvironmentStringsW(EnvironmentStringsW);
        return v1;
      }
      return 0;
    }
    if ( GetLastError() == 120 )
    {
      v0 = 2;
      dword_4304D8 = 2;
    }
    else
    {
      v0 = dword_4304D8;
    }
  }
  if ( v0 == 1 )
    goto LABEL_8;
  if ( v0 != 2 && v0 )
    return 0;
  EnvironmentStrings = GetEnvironmentStrings();
  v9 = EnvironmentStrings;
  if ( !EnvironmentStrings )
    return 0;
  for ( ; *EnvironmentStrings; ++EnvironmentStrings )
  {
    do
      ++EnvironmentStrings;
    while ( *EnvironmentStrings );
  }
  v10 = EnvironmentStrings - v9 + 1;
  v11 = malloc(v10);
  v12 = v11;
  if ( v11 )
    memcpy_0(v11, v9, v10);
  else
    v12 = 0;
  FreeEnvironmentStringsA(v9);
  return (CHAR *)v12;
}


/* ==== 412023  __ioinit  ()  size=510 ==== */
int _ioinit()
{
  _DWORD *v0; // eax
  unsigned int i; // ecx
  signed int v3; // edi
  LPBYTE v4; // ebp
  _DWORD *v5; // esi
  _DWORD *v6; // eax
  unsigned int j; // ecx
  int k; // ebx
  int v9; // esi
  int m; // ebx
  int v11; // esi
  DWORD v12; // eax
  HANDLE StdHandle; // eax
  HANDLE v14; // edi
  DWORD FileType; // eax
  HANDLE *v16; // [esp+4h] [ebp-48h]
  struct _STARTUPINFOA StartupInfo; // [esp+8h] [ebp-44h] BYREF

  v0 = malloc(0x480u);
  if ( !v0 )
    return -1;
  dword_430620[0] = (int)v0;
  uNumber = 32;
  for ( i = (unsigned int)(v0 + 288); (unsigned int)v0 < i; i = dword_430620[0] + 1152 )
  {
    *v0 = -1;
    v0[2] = 0;
    *((_BYTE *)v0 + 4) = 0;
    *((_BYTE *)v0 + 5) = 10;
    v0 += 9;
  }
  GetStartupInfoA(&StartupInfo);
  if ( StartupInfo.cbReserved2 && StartupInfo.lpReserved2 )
  {
    v3 = *(_DWORD *)StartupInfo.lpReserved2;
    v4 = StartupInfo.lpReserved2 + 4;
    v16 = (HANDLE *)&StartupInfo.lpReserved2[*(_DWORD *)StartupInfo.lpReserved2 + 4];
    if ( *(int *)StartupInfo.lpReserved2 >= 2048 )
      v3 = 2048;
    if ( (int)uNumber < v3 )
    {
      v5 = &unk_430624;
      while ( 1 )
      {
        v6 = malloc(0x480u);
        if ( !v6 )
          break;
        uNumber += 32;
        *v5 = v6;
        for ( j = (unsigned int)(v6 + 288); (unsigned int)v6 < j; j = *v5 + 1152 )
        {
          *v6 = -1;
          v6[2] = 0;
          *((_BYTE *)v6 + 4) = 0;
          *((_BYTE *)v6 + 5) = 10;
          v6 += 9;
        }
        ++v5;
        if ( (int)uNumber >= v3 )
          goto LABEL_19;
      }
      v3 = uNumber;
    }
LABEL_19:
    for ( k = 0; k < v3; ++v4 )
    {
      if ( *v16 != (HANDLE)-1 && (*v4 & 1) != 0 && ((*v4 & 8) != 0 || GetFileType(*v16)) )
      {
        v9 = dword_430620[k >> 5] + 36 * (k & 0x1F);
        *(_DWORD *)v9 = *v16;
        *(_BYTE *)(v9 + 4) = *v4;
        if ( !__crtInitCritSecAndSpinCount(v9 + 12, 4000) )
          return -1;
        ++*(_DWORD *)(v9 + 8);
      }
      ++v16;
      ++k;
    }
  }
  for ( m = 0; m < 3; ++m )
  {
    v11 = dword_430620[0] + 36 * m;
    if ( *(_DWORD *)v11 == -1 )
    {
      *(_BYTE *)(v11 + 4) = -127;
      if ( m )
        v12 = -(m != 1) - 11;
      else
        v12 = -10;
      StdHandle = GetStdHandle(v12);
      v14 = StdHandle;
      if ( StdHandle == (HANDLE)-1 || (FileType = GetFileType(StdHandle)) == 0 )
      {
        *(_BYTE *)(v11 + 4) |= 0x40u;
      }
      else
      {
        *(_DWORD *)v11 = v14;
        if ( (unsigned __int8)FileType == 2 )
        {
          *(_BYTE *)(v11 + 4) |= 0x40u;
        }
        else if ( (unsigned __int8)FileType == 3 )
        {
          *(_BYTE *)(v11 + 4) |= 8u;
        }
        if ( !__crtInitCritSecAndSpinCount(v11 + 12, 4000) )
          return -1;
        ++*(_DWORD *)(v11 + 8);
      }
    }
    else
    {
      *(_BYTE *)(v11 + 4) |= 0x80u;
    }
  }
  SetHandleCount(uNumber);
  return 0;
}


/* ==== 412221  ?__CxxUnhandledExceptionFilter@@YGJPAU_EXCEPTION_POINTERS@@@Z  (__CxxUnhandledExceptionFilter(_EXCEPTION_POINTERS *))  size=78 ==== */
int __stdcall __CxxUnhandledExceptionFilter(struct _EXCEPTION_POINTERS *a1)
{
  PEXCEPTION_RECORD ExceptionRecord; // eax
  ULONG_PTR v2; // eax

  ExceptionRecord = a1->ExceptionRecord;
  if ( a1->ExceptionRecord->ExceptionCode == -529697949 && ExceptionRecord->NumberParameters == 3 )
  {
    v2 = ExceptionRecord->ExceptionInformation[0];
    if ( v2 == 429065504 || v2 == 429065505 )
      terminate();
  }
  if ( lpfn && _ValidateExecute(lpfn) )
    return lpfn();
  else
    return 0;
}


/* ==== 412290  __allrem  ()  size=178 ==== */
unsigned __int64 __stdcall _allrem(unsigned __int64 a1, __int64 a2)
{
  int v2; // edi
  int v3; // eax
  unsigned __int64 v4; // rtt
  unsigned __int64 result; // rax
  unsigned __int64 v6; // rcx
  unsigned __int64 v7; // rax
  unsigned int v8; // eax
  int v9; // ecx
  bool v10; // cf
  unsigned __int64 v11; // rax

  v2 = 0;
  if ( (a1 & 0x8000000000000000uLL) != 0LL )
  {
    v2 = 1;
    HIDWORD(a1) = -HIDWORD(a1) - ((_DWORD)a1 != 0);
    LODWORD(a1) = -(int)a1;
  }
  v3 = HIDWORD(a2);
  if ( a2 < 0 )
  {
    v3 = -HIDWORD(a2) - ((_DWORD)a2 != 0);
    HIDWORD(a2) = v3;
    LODWORD(a2) = -(int)a2;
  }
  if ( !v3 )
  {
    LODWORD(v4) = a1;
    HIDWORD(v4) = HIDWORD(a1) % (unsigned int)a2;
    result = v4 % (unsigned int)a2;
    if ( v2 - 1 < 0 )
      return result;
    return -(__int64)result;
  }
  v6 = __PAIR64__(v3, a2);
  v7 = a1;
  do
  {
    v6 >>= 1;
    v7 >>= 1;
  }
  while ( HIDWORD(v6) );
  v8 = v7 / (unsigned int)v6;
  v9 = HIDWORD(a2) * v8;
  v11 = (unsigned int)a2 * (unsigned __int64)v8;
  v10 = __CFADD__(v9, HIDWORD(v11));
  HIDWORD(v11) += v9;
  if ( v10 || v11 > a1 )
    v11 -= a2;
  result = v11 - a1;
  if ( v2 - 1 < 0 )
    return -(__int64)result;
  return result;
}


/* ==== 412342  __inc  ()  size=22 ==== */
int __fastcall _inc(int a1, FILE *a2)
{
  if ( --a2->_cnt < 0 )
    return _filbuf(a2);
  return *(unsigned __int8 *)a2->_ptr++;
}


/* ==== 412358  sub_412358  ()  size=3627 ==== */
int __cdecl sub_412358(FILE *a1, _BYTE *a2, int a3)
{
  _BYTE *v3; // edi
  int v4; // eax
  int v5; // ecx
  int v6; // esi
  int v7; // eax
  unsigned __int8 *v8; // edi
  int v9; // esi
  int v10; // ebx
  int v11; // eax
  int v12; // ecx
  wchar_t *v13; // ebx
  char v14; // al
  int v15; // esi
  int v16; // esi
  int v17; // eax
  int v18; // ecx
  int v19; // eax
  signed int v20; // ebx
  char *v21; // esi
  int v22; // ebx
  FILE *v23; // edi
  int v25; // eax
  int v26; // ecx
  int v29; // eax
  int v31; // eax
  int v32; // ecx
  int v35; // eax
  wchar_t *v36; // edi
  int v38; // eax
  bool v39; // zf
  _BYTE *v40; // edi
  _BYTE *v41; // ebx
  void *v42; // esp
  unsigned __int8 v43; // dl
  unsigned __int8 v44; // al
  unsigned int v45; // esi
  unsigned __int8 v46; // al
  int v47; // eax
  int v48; // ecx
  int v49; // eax
  int v50; // ecx
  int v51; // eax
  int v52; // eax
  int v53; // eax
  int v54; // ecx
  int v55; // eax
  int v56; // eax
  int v57; // ebx
  int v58; // eax
  int v59; // eax
  int v60; // ecx
  int result; // eax
  _BYTE v62[16]; // [esp-20h] [ebp-214h] BYREF
  unsigned __int64 v63; // [esp-10h] [ebp-204h]
  unsigned __int64 v64; // [esp-8h] [ebp-1FCh]
  int v65; // [esp+Ch] [ebp-1E8h]
  int v66; // [esp+10h] [ebp-1E4h]
  _BYTE *v67; // [esp+14h] [ebp-1E0h]
  int v68; // [esp+18h] [ebp-1DCh]
  wchar_t DstCh; // [esp+1Ch] [ebp-1D8h] BYREF
  int v70; // [esp+20h] [ebp-1D4h]
  int v71; // [esp+24h] [ebp-1D0h]
  char SrcCh[4]; // [esp+28h] [ebp-1CCh] BYREF
  void *Block; // [esp+2Ch] [ebp-1C8h]
  int v74; // [esp+30h] [ebp-1C4h]
  int v75; // [esp+34h] [ebp-1C0h]
  int v76; // [esp+38h] [ebp-1BCh]
  wchar_t *v77; // [esp+3Ch] [ebp-1B8h]
  char v78; // [esp+43h] [ebp-1B1h]
  unsigned __int64 v79; // [esp+44h] [ebp-1B0h]
  int v80; // [esp+4Ch] [ebp-1A8h]
  unsigned __int8 v81; // [esp+53h] [ebp-1A1h]
  int v82; // [esp+54h] [ebp-1A0h]
  _BYTE *v83; // [esp+58h] [ebp-19Ch]
  char v84; // [esp+5Dh] [ebp-197h]
  char v85; // [esp+5Eh] [ebp-196h]
  char v86; // [esp+5Fh] [ebp-195h]
  FILE *Stream; // [esp+60h] [ebp-194h]
  int C; // [esp+64h] [ebp-190h]
  char v89; // [esp+69h] [ebp-18Bh]
  char v90; // [esp+6Ah] [ebp-18Ah]
  char v91; // [esp+6Bh] [ebp-189h]
  int v92; // [esp+6Ch] [ebp-188h]
  int v93; // [esp+70h] [ebp-184h]
  char v94; // [esp+77h] [ebp-17Dh]
  char v95; // [esp+78h] [ebp-17Ch] BYREF
  char v96; // [esp+79h] [ebp-17Bh] BYREF
  CPPEH_RECORD ms_exc; // [esp+1DCh] [ebp-18h]

  Stream = a1;
  v3 = a2;
  v83 = a2;
  v70 = a3;
  Block = 0;
  v66 = 0;
  v77 = 0;
  C = 0;
  v86 = 0;
  v93 = 0;
  v75 = 0;
  while ( 1 )
  {
LABEL_3:
    if ( !*v3 )
      goto LABEL_272;
    v4 = isspace((unsigned __int8)*v3);
    v5 = HIDWORD(v64);
    if ( !v4 )
      break;
    --v93;
    do
    {
      ++v93;
      v6 = _inc(v5, Stream);
      v7 = isspace(v6);
      v5 = HIDWORD(v64);
    }
    while ( v7 );
    if ( v6 != -1 )
      ungetc(v6, Stream);
    v3 = v83;
    do
      ++v3;
    while ( isspace((unsigned __int8)*v3) );
    v83 = v3;
  }
  v8 = v83;
  if ( *v83 != 37 )
  {
    ++v93;
    v57 = _inc(SHIDWORD(v64), Stream);
    C = v57;
    v58 = *v8;
    v3 = v8 + 1;
    v83 = v3;
    if ( v58 == v57 )
    {
      if ( (off_42D640[(unsigned __int8)v57] & 0x8000u) == 0 )
        goto LABEL_269;
      ++v93;
      v59 = _inc((int)off_42D640, Stream);
      v60 = (unsigned __int8)*v3++;
      v83 = v3;
      if ( v60 == v59 )
      {
        --v93;
        goto LABEL_269;
      }
      if ( v59 != -1 )
        ungetc(v59, Stream);
    }
    v39 = v57 == -1;
    goto LABEL_266;
  }
  v9 = 0;
  v80 = 0;
  v81 = 0;
  v82 = 0;
  v76 = 0;
  v92 = 0;
  v78 = 0;
  v84 = 0;
  v90 = 0;
  v94 = 0;
  v85 = 0;
  v91 = 0;
  v89 = 1;
  v71 = 0;
  do
  {
    v10 = *++v8;
    v11 = isdigit((unsigned __int8)v10);
    v12 = HIDWORD(v64);
    if ( v11 )
    {
      ++v76;
      v9 = v10 + 10 * v9 - 48;
      continue;
    }
    if ( v10 > 78 )
    {
      if ( v10 == 104 )
      {
        --v89;
        --v91;
      }
      else
      {
        if ( v10 == 108 )
        {
          ++v89;
        }
        else if ( v10 != 119 )
        {
          goto LABEL_39;
        }
        ++v91;
      }
    }
    else
    {
      switch ( v10 )
      {
        case 'N':
          continue;
        case '*':
          ++v90;
          continue;
        case 'F':
          continue;
      }
      if ( v10 != 73 )
      {
        if ( v10 == 76 )
        {
          ++v89;
          continue;
        }
LABEL_39:
        ++v94;
        continue;
      }
      LOBYTE(v12) = v8[1];
      if ( (_BYTE)v12 == 54 && v8[2] == 52 )
      {
        v8 += 2;
        ++v71;
        v79 = 0;
        continue;
      }
      if ( (_BYTE)v12 == 51 && v8[2] == 50 )
      {
        v8 += 2;
        continue;
      }
      if ( (_BYTE)v12 != 100 && (_BYTE)v12 != 105 && (_BYTE)v12 != 111 && (_BYTE)v12 != 120 && (_BYTE)v12 != 88 )
        goto LABEL_39;
    }
  }
  while ( !v94 );
  v92 = v9;
  v83 = v8;
  if ( v90 )
  {
    v13 = v77;
  }
  else
  {
    v65 = v70;
    v70 += 4;
    v13 = *(wchar_t **)(v70 - 4);
    v77 = v13;
  }
  v94 = 0;
  if ( !v91 )
  {
    v14 = *v8;
    if ( *v8 == 83 || (v91 = -1, v14 == 67) )
      v91 = 1;
  }
  v15 = *v8 | 0x20;
  v74 = v15;
  if ( v15 != 110 )
  {
    if ( v15 == 99 || v15 == 123 )
    {
      ++v93;
      C = _inc(v12, Stream);
    }
    else
    {
      do
      {
        ++v93;
        v16 = _inc(v12, Stream);
        v17 = isspace(v16);
        v12 = HIDWORD(v64);
      }
      while ( v17 );
      C = v16;
      v15 = v74;
    }
  }
  v18 = v76;
  if ( v76 && !v92 )
    goto LABEL_137;
  if ( v15 > 111 )
  {
    switch ( v15 )
    {
      case 'p':
        v89 = 1;
        break;
      case 's':
LABEL_111:
        if ( v91 > 0 )
          v85 = 1;
LABEL_113:
        v36 = v13;
        --v93;
        if ( C != -1 )
        {
          ungetc(C, Stream);
          v18 = HIDWORD(v64);
        }
        while ( 1 )
        {
          if ( v76 )
          {
            if ( !v92-- )
              break;
          }
          ++v93;
          v38 = _inc(v18, Stream);
          C = v38;
          if ( v38 == -1 )
            goto LABEL_188;
          if ( v15 != 99 && (v15 != 115 || v38 >= 9 && v38 <= 13 || v38 == 32) )
          {
            if ( v15 != 123 || (v18 = v78 ^ *((char *)Block + (v38 >> 3)), ((1 << (v38 & 7)) & v18) == 0) )
            {
LABEL_188:
              --v93;
              if ( v38 != -1 )
                ungetc(v38, Stream);
              break;
            }
            v15 = v74;
          }
          if ( v90 )
          {
            v36 = (wchar_t *)((char *)v36 + 1);
          }
          else
          {
            if ( v85 )
            {
              SrcCh[0] = v38;
              if ( (off_42D640[(unsigned __int8)v38] & 0x8000u) != 0 )
              {
                ++v93;
                SrcCh[1] = _inc((int)off_42D640, Stream);
              }
              mbtowc(&DstCh, SrcCh, SrcSizeInBytes);
              *v13++ = DstCh;
            }
            else
            {
              *(_BYTE *)v13 = v38;
              v13 = (wchar_t *)((char *)v13 + 1);
            }
            v77 = v13;
          }
        }
        if ( v36 == v13 )
          goto LABEL_272;
        if ( !v90 )
        {
          ++v75;
          if ( v74 != 99 )
          {
            v8 = v83;
            if ( v85 )
              *v77 = 0;
            else
              *(_BYTE *)v77 = 0;
            goto LABEL_108;
          }
        }
LABEL_107:
        v8 = v83;
        goto LABEL_108;
      case 'u':
        break;
      case 'x':
LABEL_70:
        v20 = C;
        if ( C == 45 )
        {
          v84 = 1;
        }
        else if ( C != 43 )
        {
LABEL_169:
          if ( v20 != 48 )
          {
LABEL_205:
            if ( v71 )
            {
              if ( !v94 )
              {
                while ( v15 != 120 && v15 != 112 )
                {
                  v49 = isdigit(v20);
                  v50 = HIDWORD(v64);
                  if ( !v49 )
                    goto LABEL_217;
                  if ( v15 == 111 )
                  {
                    if ( v20 >= 56 )
                      goto LABEL_217;
                    v50 = v79 >> 29;
                    v79 *= 8LL;
                  }
                  else
                  {
                    v64 = 10;
                    v63 = v79;
                    v79 *= 10LL;
                  }
LABEL_218:
                  if ( v94 )
                  {
                    --v93;
                    if ( v20 != -1 )
                      ungetc(v20, Stream);
                  }
                  else
                  {
                    ++v82;
                    v79 += v20 - 48;
                    if ( !v76 || (--v92, v92) )
                    {
                      ++v93;
                      v20 = _inc(v50, Stream);
                    }
                    else
                    {
                      v94 = 1;
                    }
                  }
                  if ( v94 )
                  {
                    C = v20;
                    goto LABEL_227;
                  }
                }
                v51 = isxdigit(v20);
                v50 = HIDWORD(v64);
                if ( v51 )
                {
                  v79 *= 16LL;
                  v52 = isdigit(v20);
                  v50 = HIDWORD(v64);
                  if ( !v52 )
                    v20 = (v20 & 0xFFFFFFDF) - 7;
                  goto LABEL_218;
                }
LABEL_217:
                ++v94;
                goto LABEL_218;
              }
LABEL_227:
              if ( v84 )
                v79 = -(__int64)v79;
              goto LABEL_252;
            }
            if ( v94 )
            {
LABEL_250:
              if ( v84 )
                v80 = -v80;
LABEL_252:
              if ( !v82 )
                goto LABEL_272;
              if ( !v90 )
              {
                ++v75;
                v13 = v77;
                v8 = v83;
                v19 = v80;
                goto LABEL_255;
              }
              goto LABEL_107;
            }
            while ( v15 != 120 && v15 != 112 )
            {
              v53 = isdigit(v20);
              v54 = HIDWORD(v64);
              if ( !v53 )
                goto LABEL_240;
              if ( v15 == 111 )
              {
                if ( v20 >= 56 )
                  goto LABEL_240;
                v80 *= 8;
              }
              else
              {
                v80 *= 10;
              }
LABEL_241:
              if ( v94 )
              {
                --v93;
                if ( v20 != -1 )
                  ungetc(v20, Stream);
              }
              else
              {
                ++v82;
                v80 = v80 + v20 - 48;
                if ( !v76 || (--v92, v92) )
                {
                  ++v93;
                  v20 = _inc(v54, Stream);
                }
                else
                {
                  v94 = 1;
                }
              }
              if ( v94 )
              {
                C = v20;
                goto LABEL_250;
              }
            }
            v55 = isxdigit(v20);
            v54 = HIDWORD(v64);
            if ( v55 )
            {
              v80 *= 16;
              v56 = isdigit(v20);
              v54 = HIDWORD(v64);
              if ( !v56 )
                v20 = (v20 & 0xFFFFFFDF) - 7;
              goto LABEL_241;
            }
LABEL_240:
            ++v94;
            goto LABEL_241;
          }
          ++v93;
          v47 = _inc(v18, Stream);
          v20 = v47;
          C = v47;
          if ( (_BYTE)v47 == 120 || (_BYTE)v47 == 88 )
          {
            ++v93;
            v20 = _inc(v48, Stream);
            C = v20;
            if ( v76 )
            {
              v92 -= 2;
              if ( v92 < 1 )
                ++v94;
            }
            HIDWORD(v64) = 120;
            goto LABEL_177;
          }
          v82 = 1;
          if ( v15 != 120 )
          {
            if ( v76 )
            {
              if ( !--v92 )
                ++v94;
            }
            HIDWORD(v64) = 111;
LABEL_177:
            v15 = HIDWORD(v64);
            goto LABEL_205;
          }
          --v93;
          if ( v47 != -1 )
            ungetc(v47, Stream);
          v20 = 48;
LABEL_204:
          C = v20;
          goto LABEL_205;
        }
        if ( --v92 || !v76 )
        {
          ++v93;
          v20 = _inc(v76, Stream);
          C = v20;
        }
        else
        {
          v94 = 1;
        }
        goto LABEL_169;
      case '{':
        if ( v91 > 0 )
          v85 = 1;
        v40 = v83 + 1;
        v83 = v40;
        v67 = v40;
        if ( *v40 == 94 )
        {
          v67 = ++v40;
          v78 = -1;
        }
        v41 = Block;
        if ( !Block )
        {
          v42 = alloca(32);
          ms_exc.old_esp = (DWORD)v62;
          v41 = v62;
          Block = v62;
          ms_exc.registration.TryLevel = -1;
        }
        memset(v41, 0, 0x20u);
        if ( v74 == 123 && *v40 == 93 )
        {
          v43 = 93;
          ++v40;
          v41[11] = 32;
          goto LABEL_161;
        }
LABEL_160:
        v43 = v81;
LABEL_161:
        while ( 1 )
        {
          v46 = *v40;
          if ( *v40 == 93 )
            break;
          ++v40;
          if ( v46 != 45 || !v43 || (LOBYTE(v18) = *v40, *v40 == 93) )
          {
            v81 = v46;
            v18 = v46 & 7;
            v41[v46 >> 3] |= 1 << v18;
            goto LABEL_160;
          }
          ++v40;
          if ( v43 >= (unsigned __int8)v18 )
          {
            v44 = v43;
            v43 = v18;
          }
          else
          {
            v44 = v18;
          }
          if ( v43 <= v44 )
          {
            v45 = v43;
            v68 = (unsigned __int8)(v44 - v43 + 1);
            do
            {
              v18 = v45 & 7;
              v41[v45++ >> 3] |= 1 << v18;
              --v68;
            }
            while ( v68 );
          }
          v43 = 0;
        }
        v15 = v74;
        v13 = v77;
        if ( v74 == 123 )
          v83 = v40;
        goto LABEL_113;
      default:
LABEL_136:
        if ( *v8 == C )
        {
          --v86;
          if ( !v90 )
            v70 = v65;
          goto LABEL_108;
        }
LABEL_137:
        v39 = C == -1;
LABEL_266:
        if ( !v39 )
          ungetc(C, Stream);
        goto LABEL_272;
    }
LABEL_197:
    v20 = C;
    if ( C == 45 )
    {
      v84 = 1;
    }
    else if ( C != 43 )
    {
      goto LABEL_205;
    }
    if ( !--v92 && v76 )
    {
      v94 = 1;
      goto LABEL_205;
    }
    ++v93;
    v20 = _inc(v76, Stream);
    goto LABEL_204;
  }
  switch ( v15 )
  {
    case 'o':
      goto LABEL_197;
    case 'c':
      if ( !v76 )
      {
        v76 = 1;
        ++v92;
      }
      goto LABEL_111;
    case 'd':
      goto LABEL_197;
  }
  if ( v15 <= 100 )
    goto LABEL_136;
  if ( v15 > 103 )
  {
    if ( v15 == 105 )
    {
      v15 = 100;
      goto LABEL_70;
    }
    if ( v15 != 110 )
      goto LABEL_136;
    v19 = v93;
    if ( v90 )
      goto LABEL_108;
LABEL_255:
    if ( v71 )
    {
      *(_QWORD *)v13 = v79;
    }
    else if ( v89 )
    {
      *(_DWORD *)v13 = v19;
    }
    else
    {
      *v13 = v19;
    }
LABEL_108:
    ++v86;
    v3 = v8 + 1;
    v83 = v3;
LABEL_269:
    if ( C == -1 )
    {
      if ( *v3 != 37 || v83[1] != 110 )
        goto LABEL_272;
      v3 = v83;
    }
    goto LABEL_3;
  }
  v21 = &v95;
  v22 = C;
  if ( C == 45 )
  {
    v95 = 45;
    v21 = &v96;
    goto LABEL_75;
  }
  if ( C == 43 )
  {
LABEL_75:
    --v92;
    ++v93;
    v23 = Stream;
    v22 = _inc(v76, Stream);
    C = v22;
  }
  else
  {
    v23 = Stream;
  }
  if ( !v76 || v92 > 349 )
    v92 = 349;
  while ( 1 )
  {
    v25 = isdigit(v22);
    v26 = HIDWORD(v64);
    if ( !v25 )
      break;
    if ( !v92-- )
      break;
    ++v82;
    *v21++ = v22;
    ++v93;
    v22 = _inc(v26, v23);
    C = v22;
  }
  if ( byte_42D694 == (_BYTE)v22 )
  {
    if ( v92-- )
    {
      ++v93;
      v22 = _inc(SHIDWORD(v64), v23);
      *v21++ = byte_42D694;
      while ( 1 )
      {
        C = v22;
        v29 = isdigit(v22);
        v26 = HIDWORD(v64);
        if ( !v29 )
          break;
        if ( !v92-- )
          break;
        ++v82;
        *v21++ = v22;
        ++v93;
        v22 = _inc(v26, v23);
      }
    }
  }
  if ( v82 && (v22 == 101 || v22 == 69) )
  {
    if ( v92-- )
    {
      *v21++ = 101;
      ++v93;
      v31 = _inc(v26, v23);
      v22 = v31;
      C = v31;
      if ( v31 == 45 )
      {
        *v21++ = 45;
        goto LABEL_96;
      }
      if ( v31 == 43 )
      {
LABEL_96:
        if ( !v92-- )
        {
          v92 = 0;
          goto LABEL_101;
        }
        goto LABEL_100;
      }
LABEL_101:
      while ( 1 )
      {
        v35 = isdigit(v22);
        v32 = HIDWORD(v64);
        if ( !v35 )
          break;
        if ( !v92-- )
          break;
        ++v82;
        *v21++ = v22;
LABEL_100:
        ++v93;
        v22 = _inc(v32, v23);
        C = v22;
      }
    }
  }
  --v93;
  if ( v22 != -1 )
    ungetc(v22, v23);
  if ( v82 )
  {
    if ( !v90 )
    {
      ++v75;
      *v21 = 0;
      v64 = __PAIR64__(&v95, (unsigned int)v77);
      HIDWORD(v63) = v89 - 1;
      off_42D55C[0]();
    }
    goto LABEL_107;
  }
LABEL_272:
  if ( v66 == 1 )
    free(Block);
  result = v75;
  if ( C == -1 && !v75 && !v86 )
    return -1;
  return result;
}


/* ==== 413183  ___crtInitCritSecNoSpinCount@8  (__crtInitCritSecNoSpinCount(x,x))  size=16 ==== */
int __stdcall __crtInitCritSecNoSpinCount(LPCRITICAL_SECTION lpCriticalSection, int a2)
{
  InitializeCriticalSection(lpCriticalSection);
  return 1;
}


/* ==== 413193  ___crtInitCritSecAndSpinCount  ()  size=139 ==== */
BOOL __cdecl __crtInitCritSecAndSpinCount(struct _RTL_CRITICAL_SECTION *a1, DWORD a2)
{
  BOOL (__stdcall *InitializeCriticalSectionAndSpinCount)(LPCRITICAL_SECTION, DWORD); // eax
  HMODULE ModuleHandleA; // eax

  InitializeCriticalSectionAndSpinCount = (BOOL (__stdcall *)(LPCRITICAL_SECTION, DWORD))dword_4304E0;
  if ( !dword_4304E0 )
  {
    if ( dword_4300E8 == 1
      || (ModuleHandleA = GetModuleHandleA("kernel32.dll")) == 0
      || (InitializeCriticalSectionAndSpinCount = (BOOL (__stdcall *)(LPCRITICAL_SECTION, DWORD))GetProcAddress(
                                                                                                   ModuleHandleA,
                                                                                                   "InitializeCriticalSec"
                                                                                                   "tionAndSpinCount"),
          (dword_4304E0 = (int)InitializeCriticalSectionAndSpinCount) == 0) )
    {
      InitializeCriticalSectionAndSpinCount = (BOOL (__stdcall *)(LPCRITICAL_SECTION, DWORD))__crtInitCritSecNoSpinCount;
      dword_4304E0 = (int)__crtInitCritSecNoSpinCount;
    }
  }
  return InitializeCriticalSectionAndSpinCount(a1, a2);
}


/* ==== 41321E  __filbuf  ()  size=225 ==== */
int __cdecl _filbuf(FILE *File)
{
  int flag; // eax
  int v2; // eax
  int v3; // eax
  int v4; // edx
  _BYTE *v5; // edi
  int v6; // ecx
  char *ptr; // ecx
  int result; // eax

  flag = File->_flag;
  if ( (flag & 0x83) == 0 || (flag & 0x40) != 0 )
    return -1;
  if ( (flag & 2) != 0 )
  {
    File->_flag = flag | 0x20;
    return -1;
  }
  v2 = flag | 1;
  File->_flag = v2;
  if ( (v2 & 0x10C) != 0 )
    File->_ptr = File->_base;
  else
    _getbuf(File);
  v3 = sub_4134DC(File->_file, File->_base, File->_bufsiz);
  File->_cnt = v3;
  if ( !v3 || v3 == -1 )
  {
    File->_flag |= v3 != 0 ? 32 : 16;
    File->_cnt = 0;
    return -1;
  }
  v4 = File->_flag;
  if ( (v4 & 0x82) == 0 )
  {
    v5 = File->_file == -1 ? &unk_42D608 : (_BYTE *)(dword_430620[File->_file >> 5] + 36 * (File->_file & 0x1F));
    if ( (v5[4] & 0x82) == 0x82 )
      File->_flag = v4 | 0x2000;
  }
  if ( File->_bufsiz == 512 )
  {
    v6 = File->_flag;
    if ( (v6 & 8) != 0 && (v6 & 0x400) == 0 )
      File->_bufsiz = 4096;
  }
  ptr = File->_ptr;
  File->_cnt = v3 - 1;
  result = (unsigned __int8)*ptr;
  File->_ptr = ptr + 1;
  return result;
}


/* ==== 4132FF  sub_4132FF  ()  size=477 ==== */
unsigned int __cdecl sub_4132FF(int FileHandle, char *lpBuffer, DWORD nNumberOfBytesToRead)
{
  char *v3; // ebx
  char *v4; // edx
  int v5; // esi
  int v6; // eax
  char v7; // cl
  int v8; // eax
  DWORD LastError; // eax
  int v11; // ecx
  char *v12; // ecx
  bool v13; // cf
  char v14; // al
  char v15; // al
  DWORD NumberOfBytesRead; // [esp+Ch] [ebp-Ch] BYREF
  unsigned int v17; // [esp+10h] [ebp-8h]
  char Buffer; // [esp+17h] [ebp-1h] BYREF
  char *nNumberOfBytesToReada; // [esp+28h] [ebp+10h]

  v17 = 0;
  v3 = lpBuffer;
  v4 = lpBuffer;
  if ( nNumberOfBytesToRead )
  {
    v5 = 36 * (FileHandle & 0x1F);
    v6 = v5 + dword_430620[FileHandle >> 5];
    v7 = *(_BYTE *)(v6 + 4);
    if ( (v7 & 2) == 0 )
    {
      if ( (v7 & 0x48) != 0 && *(_BYTE *)(v6 + 5) != 10 )
      {
        --nNumberOfBytesToRead;
        *lpBuffer = *(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 5);
        v8 = dword_430620[FileHandle >> 5];
        v4 = lpBuffer + 1;
        v17 = 1;
        *(_BYTE *)(v8 + v5 + 5) = 10;
      }
      if ( !ReadFile(
              *(HANDLE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F)),
              v4,
              nNumberOfBytesToRead,
              &NumberOfBytesRead,
              0) )
      {
        LastError = GetLastError();
        if ( LastError == 5 )
        {
          *_errno() = 9;
          *__doserrno() = 5;
          return -1;
        }
        if ( LastError != 109 )
        {
          _dosmaperr(LastError);
          return -1;
        }
        return 0;
      }
      v11 = dword_430620[FileHandle >> 5];
      v17 += NumberOfBytesRead;
      if ( *(char *)(v11 + v5 + 4) < 0 )
      {
        if ( NumberOfBytesRead && *lpBuffer == 10 )
          *(_BYTE *)(v11 + v5 + 4) |= 4u;
        else
          *(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 4) &= ~4u;
        v12 = &lpBuffer[v17];
        v13 = lpBuffer < &lpBuffer[v17];
        nNumberOfBytesToReada = lpBuffer;
        v17 += (unsigned int)lpBuffer;
        if ( v13 )
        {
          do
          {
            v14 = *nNumberOfBytesToReada;
            if ( *nNumberOfBytesToReada == 26 )
            {
              if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 4) & 0x40) == 0 )
                *(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 4) |= 2u;
              return v3 - lpBuffer;
            }
            if ( v14 == 13 )
            {
              if ( nNumberOfBytesToReada < v12 - 1 )
              {
                if ( nNumberOfBytesToReada[1] != 10 )
                {
                  ++nNumberOfBytesToReada;
LABEL_35:
                  *v3 = 13;
LABEL_36:
                  ++v3;
                  goto LABEL_37;
                }
                nNumberOfBytesToReada += 2;
                goto LABEL_33;
              }
              ++nNumberOfBytesToReada;
              if ( !ReadFile(
                      *(HANDLE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F)),
                      &Buffer,
                      1u,
                      &NumberOfBytesRead,
                      0)
                && GetLastError()
                || !NumberOfBytesRead )
              {
                goto LABEL_35;
              }
              if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 4) & 0x48) != 0 )
              {
                v15 = Buffer;
                if ( Buffer != 10 )
                {
                  *v3 = 13;
                  *(_BYTE *)(dword_430620[FileHandle >> 5] + v5 + 5) = v15;
                  goto LABEL_36;
                }
LABEL_33:
                *v3 = 10;
                goto LABEL_36;
              }
              if ( v3 == lpBuffer && Buffer == 10 )
                goto LABEL_33;
              _lseeki64_lk(FileHandle, -1, -1, 1u);
              if ( Buffer != 10 )
                goto LABEL_35;
            }
            else
            {
              *v3++ = v14;
              ++nNumberOfBytesToReada;
            }
LABEL_37:
            v12 = (char *)v17;
          }
          while ( (unsigned int)nNumberOfBytesToReada < v17 );
        }
        return v3 - lpBuffer;
      }
      return v17;
    }
  }
  return 0;
}


/* ==== 4134DC  sub_4134DC  ()  size=171 ==== */
unsigned int __cdecl sub_4134DC(int a1, char *lpBuffer, DWORD nNumberOfBytesToRead)
{
  int v3; // esi
  unsigned int v5; // [esp+Ch] [ebp-1Ch]

  if ( a1 < uNumber && (v3 = 36 * (a1 & 0x1F), (*(_BYTE *)(dword_430620[a1 >> 5] + v3 + 4) & 1) != 0) )
  {
    _lock_fhandle(a1);
    if ( (*(_BYTE *)(dword_430620[a1 >> 5] + v3 + 4) & 1) != 0 )
    {
      v5 = sub_4132FF(a1, lpBuffer, nNumberOfBytesToRead);
    }
    else
    {
      *_errno() = 9;
      *__doserrno() = 0;
      v5 = -1;
    }
    _unlock_fhandle(a1);
    return v5;
  }
  else
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
}


/* ==== 413587  sub_413587  ()  size=444 ==== */
int __cdecl sub_413587(int FileHandle, _BYTE *lpBuffer, DWORD nNumberOfBytesToWrite)
{
  int v4; // esi
  int v5; // eax
  DWORD v6; // ecx
  char *v7; // eax
  char *v8; // edx
  char v9; // dl
  signed int v10; // edi
  DWORD NumberOfBytesWritten; // [esp+4h] [ebp-80h] BYREF
  _BYTE *v12; // [esp+8h] [ebp-7Ch]
  int v13; // [esp+Ch] [ebp-78h]
  DWORD v14; // [esp+10h] [ebp-74h]
  char *v15; // [esp+14h] [ebp-70h]
  int v16; // [esp+18h] [ebp-6Ch]
  DWORD LastError; // [esp+1Ch] [ebp-68h]
  _BYTE Buffer[1028]; // [esp+20h] [ebp-64h] BYREF

  v12 = lpBuffer;
  v14 = 0;
  v13 = 0;
  if ( !nNumberOfBytesToWrite )
    return 0;
  v4 = 36 * (FileHandle & 0x1F);
  if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v4 + 4) & 0x20) != 0 )
    _lseeki64_lk(FileHandle, 0, 0, 2u);
  v5 = v4 + dword_430620[FileHandle >> 5];
  if ( *(char *)(v5 + 4) >= 0 )
  {
    if ( WriteFile(*(HANDLE *)v5, lpBuffer, nNumberOfBytesToWrite, &NumberOfBytesWritten, 0) )
    {
      LastError = 0;
      v14 = NumberOfBytesWritten;
      goto LABEL_19;
    }
  }
  else
  {
    v15 = lpBuffer;
    LastError = 0;
    while ( 1 )
    {
      v16 = 0;
      v6 = v15 - v12;
      v7 = Buffer;
      do
      {
        if ( v6 >= nNumberOfBytesToWrite )
          break;
        v8 = v15++;
        v9 = *v8;
        ++v6;
        if ( v9 == 10 )
        {
          ++v13;
          *v7++ = 13;
          ++v16;
        }
        *v7++ = v9;
        ++v16;
      }
      while ( v16 < 1024 );
      v10 = v7 - Buffer;
      if ( !WriteFile(
              *(HANDLE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F)),
              Buffer,
              v7 - Buffer,
              &NumberOfBytesWritten,
              0) )
        break;
      v14 += NumberOfBytesWritten;
      if ( (int)NumberOfBytesWritten < v10 || v15 - v12 >= nNumberOfBytesToWrite )
        goto LABEL_19;
    }
  }
  LastError = GetLastError();
LABEL_19:
  if ( v14 )
    return v14 - v13;
  if ( LastError )
  {
    if ( LastError == 5 )
    {
      *_errno() = 9;
      *__doserrno() = 5;
    }
    else
    {
      _dosmaperr(LastError);
    }
  }
  else
  {
    if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v4 + 4) & 0x40) != 0 && *v12 == 26 )
      return 0;
    *_errno() = 28;
    *__doserrno() = 0;
  }
  return -1;
}


/* ==== 413743  sub_413743  ()  size=171 ==== */
int __cdecl sub_413743(int a1, _BYTE *lpBuffer, DWORD nNumberOfBytesToWrite)
{
  int v3; // esi
  int v5; // [esp+Ch] [ebp-1Ch]

  if ( a1 < uNumber && (v3 = 36 * (a1 & 0x1F), (*(_BYTE *)(dword_430620[a1 >> 5] + v3 + 4) & 1) != 0) )
  {
    _lock_fhandle(a1);
    if ( (*(_BYTE *)(dword_430620[a1 >> 5] + v3 + 4) & 1) != 0 )
    {
      v5 = sub_413587(a1, lpBuffer, nNumberOfBytesToWrite);
    }
    else
    {
      *_errno() = 9;
      *__doserrno() = 0;
      v5 = -1;
    }
    _unlock_fhandle(a1);
    return v5;
  }
  else
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
}


/* ==== 4137EE  __lseek_lk  ()  size=116 ==== */
DWORD __cdecl _lseek_lk(int FileHandle, LONG lDistanceToMove, DWORD dwMoveMethod)
{
  void *osfhandle; // eax
  DWORD v5; // edi
  DWORD LastError; // eax
  _BYTE *v7; // eax

  osfhandle = (void *)_get_osfhandle(FileHandle);
  if ( osfhandle == (void *)-1 )
  {
    *_errno() = 9;
    return -1;
  }
  else
  {
    v5 = SetFilePointer(osfhandle, lDistanceToMove, 0, dwMoveMethod);
    if ( v5 == -1 )
      LastError = GetLastError();
    else
      LastError = 0;
    if ( LastError )
    {
      _dosmaperr(LastError);
      return -1;
    }
    else
    {
      v7 = (_BYTE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F) + 4);
      *v7 &= ~2u;
      return v5;
    }
  }
}


/* ==== 413862  __lseek  ()  size=171 ==== */
int __cdecl _lseek(int FileHandle, int Offset, int Origin)
{
  int v3; // esi
  DWORD v5; // [esp+Ch] [ebp-1Ch]

  if ( FileHandle < uNumber
    && (v3 = 36 * (FileHandle & 0x1F), (*(_BYTE *)(dword_430620[FileHandle >> 5] + v3 + 4) & 1) != 0) )
  {
    _lock_fhandle(FileHandle);
    if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v3 + 4) & 1) != 0 )
    {
      v5 = _lseek_lk(FileHandle, Offset, Origin);
    }
    else
    {
      *_errno() = 9;
      *__doserrno() = 0;
      v5 = -1;
    }
    _unlock_fhandle(FileHandle);
    return v5;
  }
  else
  {
    *_errno() = 9;
    *__doserrno() = 0;
    return -1;
  }
}


/* ==== 41390D  __commit  ()  size=188 ==== */
int __cdecl _commit(int FileHandle)
{
  int v1; // esi
  void *osfhandle; // eax
  DWORD LastError; // [esp+Ch] [ebp-1Ch]

  if ( FileHandle < uNumber )
  {
    v1 = 36 * (FileHandle & 0x1F);
    if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v1 + 4) & 1) != 0 )
    {
      _lock_fhandle(FileHandle);
      if ( (*(_BYTE *)(dword_430620[FileHandle >> 5] + v1 + 4) & 1) != 0 )
      {
        osfhandle = (void *)_get_osfhandle(FileHandle);
        if ( FlushFileBuffers(osfhandle) )
          LastError = 0;
        else
          LastError = GetLastError();
        if ( !LastError )
          goto LABEL_10;
        *__doserrno() = LastError;
      }
      *_errno() = 9;
      LastError = -1;
LABEL_10:
      _unlock_fhandle(FileHandle);
      return LastError;
    }
  }
  *_errno() = 9;
  return -1;
}


/* ==== 4139C9  sub_4139C9  ()  size=982 ==== */
int __cdecl sub_4139C9(
        int Locale,
        DWORD dwMapFlags,
        CHAR *lpMultiByteStr,
        int cbMultiByte,
        LPWSTR lpDestStr,
        int cchDest,
        UINT CodePage,
        int a8)
{
  int v8; // ecx
  CHAR *v9; // eax
  int v10; // edi
  int v11; // esi
  void *v12; // esp
  int v13; // eax
  void *v14; // esp
  int v15; // eax
  CHAR *v17; // edi
  UINT v18; // eax
  const CHAR *v19; // eax
  int v20; // eax
  void *v21; // esp
  CHAR *v22; // eax
  int v23; // esi
  _DWORD v24[5]; // [esp+0h] [ebp-58h] BYREF
  UINT v25; // [esp+14h] [ebp-44h]
  int v26; // [esp+18h] [ebp-40h]
  int v27; // [esp+1Ch] [ebp-3Ch]
  int v28; // [esp+20h] [ebp-38h]
  int v29; // [esp+24h] [ebp-34h]
  void *Block; // [esp+28h] [ebp-30h]
  int v31; // [esp+2Ch] [ebp-2Ch]
  LPCSTR lpSrcStr; // [esp+30h] [ebp-28h]
  size_t Size; // [esp+34h] [ebp-24h] BYREF
  LPWSTR v34; // [esp+38h] [ebp-20h]
  LPWSTR lpWideCharStr; // [esp+3Ch] [ebp-1Ch]
  CPPEH_RECORD ms_exc; // [esp+40h] [ebp-18h]

  if ( !dword_430508 )
  {
    if ( LCMapStringW(0, 0x100u, &String1, 1, 0, 0) )
    {
      dword_430508 = 1;
    }
    else if ( GetLastError() == 120 )
    {
      dword_430508 = 2;
    }
  }
  if ( cbMultiByte > 0 )
  {
    v8 = cbMultiByte;
    v9 = lpMultiByteStr;
    while ( 1 )
    {
      --v8;
      if ( !*v9 )
        break;
      ++v9;
      if ( !v8 )
      {
        v8 = -1;
        break;
      }
    }
    cbMultiByte += -1 - v8;
  }
  if ( dword_430508 != 2 && dword_430508 )
  {
    if ( dword_430508 == 1 )
    {
      v10 = 0;
      v31 = 0;
      v27 = 0;
      v28 = 0;
      if ( !CodePage )
        CodePage = dword_430500;
      v11 = MultiByteToWideChar(CodePage, 8 * (a8 != 0) + 1, lpMultiByteStr, cbMultiByte, 0, 0);
      v29 = v11;
      if ( v11 )
      {
        v12 = alloca(2 * v11);
        ms_exc.old_esp = (DWORD)v24;
        lpWideCharStr = (LPWSTR)v24;
        ms_exc.registration.TryLevel = -1;
        if ( v24 )
        {
LABEL_21:
          if ( MultiByteToWideChar(CodePage, 1u, lpMultiByteStr, cbMultiByte, lpWideCharStr, v11) )
          {
            v13 = LCMapStringW(Locale, dwMapFlags, lpWideCharStr, v11, 0, 0);
            v10 = v13;
            v31 = v13;
            if ( v13 )
            {
              if ( (dwMapFlags & 0x400) != 0 )
              {
                if ( cchDest && v13 <= cchDest )
                  LCMapStringW(Locale, dwMapFlags, lpWideCharStr, v11, lpDestStr, cchDest);
                goto LABEL_35;
              }
              v14 = alloca(2 * v13);
              ms_exc.old_esp = (DWORD)v24;
              v34 = (LPWSTR)v24;
              ms_exc.registration.TryLevel = -1;
              if ( v24 )
              {
LABEL_30:
                if ( LCMapStringW(Locale, dwMapFlags, lpWideCharStr, v11, v34, v10) )
                {
                  if ( cchDest )
                    v15 = WideCharToMultiByte(CodePage, 0, v34, v10, (LPSTR)lpDestStr, cchDest, 0, 0);
                  else
                    v15 = WideCharToMultiByte(CodePage, 0, v34, v10, 0, 0, 0, 0);
                  v10 = v15;
                }
                goto LABEL_35;
              }
              v34 = (LPWSTR)malloc(2 * v13);
              if ( v34 )
              {
                v28 = 1;
                goto LABEL_30;
              }
            }
          }
LABEL_35:
          if ( v28 )
            free(v34);
          if ( v27 )
            free(lpWideCharStr);
          return v10;
        }
        lpWideCharStr = (LPWSTR)malloc(2 * v11);
        if ( lpWideCharStr )
        {
          v27 = 1;
          goto LABEL_21;
        }
      }
    }
    return 0;
  }
  lpSrcStr = 0;
  v17 = 0;
  Block = 0;
  v26 = 0;
  if ( !Locale )
    Locale = dword_4304F0;
  if ( !CodePage )
    CodePage = dword_430500;
  v18 = sub_415670(Locale);
  v25 = v18;
  if ( v18 == -1 )
    return 0;
  if ( v18 != CodePage )
  {
    v19 = (const CHAR *)sub_4156B7(CodePage, v18, lpMultiByteStr, (int)&cbMultiByte, 0, 0);
    lpSrcStr = v19;
    if ( !v19 )
      return 0;
    v20 = LCMapStringA(Locale, dwMapFlags, v19, cbMultiByte, 0, 0);
    Size = v20;
    if ( v20 )
    {
      v21 = alloca(v20);
      ms_exc.old_esp = (DWORD)v24;
      v17 = (CHAR *)v24;
      v24[4] = v24;
      memset(v24, 0, v20);
      ms_exc.registration.TryLevel = -1;
      if ( !v24 )
      {
        v22 = (CHAR *)malloc(Size);
        v17 = v22;
        if ( !v22 )
        {
LABEL_53:
          v23 = 0;
          goto LABEL_56;
        }
        memset(v22, 0, Size);
        v26 = 1;
      }
      Size = LCMapStringA(Locale, dwMapFlags, lpSrcStr, cbMultiByte, v17, Size);
      if ( !Size )
        goto LABEL_53;
      Block = (void *)sub_4156B7(v25, CodePage, v17, (int)&Size, (int)lpDestStr, cchDest);
      v23 = Block != 0 ? Size : 0;
    }
    else
    {
      v23 = v24[3];
    }
LABEL_56:
    if ( v26 )
      free(v17);
    goto LABEL_59;
  }
  v23 = LCMapStringA(Locale, dwMapFlags, lpMultiByteStr, cbMultiByte, (LPSTR)lpDestStr, cchDest);
LABEL_59:
  if ( lpSrcStr )
    free((void *)lpSrcStr);
  if ( Block && lpDestStr != Block )
    free(Block);
  return v23;
}


/* ==== 413D9F  ___crtGetStringTypeA  ()  size=442 ==== */
BOOL __cdecl __crtGetStringTypeA(
        DWORD dwInfoType,
        CHAR *lpMultiByteStr,
        int cbMultiByte,
        LPWORD lpCharType,
        UINT CodePage,
        LCID Locale,
        int a7)
{
  CHAR *v7; // esi
  int v8; // edi
  void *v9; // esp
  WCHAR *v10; // esi
  int v11; // eax
  LCID v13; // ebx
  UINT v14; // edi
  UINT v15; // eax
  const CHAR *v16; // eax
  BOOL StringTypeA; // edi
  _DWORD v18[5]; // [esp+0h] [ebp-38h] BYREF
  BOOL StringTypeW; // [esp+14h] [ebp-24h]
  int v20; // [esp+18h] [ebp-20h]
  WORD CharType; // [esp+1Ch] [ebp-1Ch] BYREF
  CPPEH_RECORD ms_exc; // [esp+20h] [ebp-18h]

  v7 = 0;
  if ( !dword_43050C )
  {
    if ( GetStringTypeW(1u, &String1, 1, &CharType) )
    {
      dword_43050C = 1;
    }
    else if ( GetLastError() == 120 )
    {
      dword_43050C = 2;
    }
  }
  if ( dword_43050C != 2 && dword_43050C )
  {
    if ( dword_43050C == 1 )
    {
      StringTypeW = 0;
      v20 = 0;
      if ( !CodePage )
        CodePage = dword_430500;
      v8 = MultiByteToWideChar(CodePage, 8 * (a7 != 0) + 1, lpMultiByteStr, cbMultiByte, 0, 0);
      v18[4] = v8;
      if ( v8 )
      {
        v9 = alloca(2 * v8);
        ms_exc.old_esp = (DWORD)v18;
        v10 = (WCHAR *)v18;
        v18[3] = v18;
        memset(v18, 0, 2 * v8);
        ms_exc.registration.TryLevel = -1;
        if ( v18 )
        {
LABEL_15:
          v11 = MultiByteToWideChar(CodePage, 1u, lpMultiByteStr, cbMultiByte, v10, v8);
          if ( v11 )
            StringTypeW = GetStringTypeW(dwInfoType, v10, v11, lpCharType);
          if ( v20 )
            free(v10);
          return StringTypeW;
        }
        v10 = (WCHAR *)sub_40DAAE(2u, v8);
        if ( v10 )
        {
          v20 = 1;
          goto LABEL_15;
        }
      }
    }
    return 0;
  }
  v13 = Locale;
  if ( !Locale )
    v13 = dword_4304F0;
  v14 = CodePage;
  if ( !CodePage )
    v14 = dword_430500;
  v15 = sub_415670(v13);
  if ( v15 == -1 )
    return 0;
  if ( v15 != v14 )
  {
    v16 = (const CHAR *)sub_4156B7(v14, v15, lpMultiByteStr, (int)&cbMultiByte, 0, 0);
    v7 = (CHAR *)v16;
    if ( !v16 )
      return 0;
    lpMultiByteStr = (CHAR *)v16;
  }
  StringTypeA = GetStringTypeA(v13, dwInfoType, lpMultiByteStr, cbMultiByte, lpCharType);
  if ( v7 )
    free(v7);
  return StringTypeA;
}


/* ==== 413F60  _strrchr  ()  size=45 ==== */
char *__cdecl strrchr(const char *Str, int Ch)
{
  unsigned int v2; // ecx
  const char *v3; // edi
  bool v4; // zf
  char *v5; // edi

  v2 = strlen(Str) + 1;
  v3 = &Str[v2 - 1];
  do
  {
    if ( !v2 )
      break;
    v4 = *v3-- == (unsigned __int8)Ch;
    --v2;
  }
  while ( !v4 );
  v5 = (char *)(v3 + 1);
  if ( *v5 == (_BYTE)Ch )
    return v5;
  else
    return 0;
}


/* ==== 413F90  _strspn  ()  size=70 ==== */
size_t __cdecl strspn(const char *Str, const char *Control)
{
  unsigned int v2; // eax
  size_t v5; // ecx
  signed __int32 v7[9]; // [esp+0h] [ebp-24h] BYREF

  v2 = 0;
  memset(v7, 0, 32);
  while ( 1 )
  {
    LOBYTE(v2) = *Control;
    if ( !*Control )
      break;
    ++Control;
    _bittestandset(v7, v2);
  }
  v5 = -1;
  do
  {
    ++v5;
    LOBYTE(v2) = *Str;
    if ( !*Str )
      break;
    ++Str;
  }
  while ( _bittest(v7, v2) );
  return v5;
}


/* ==== 413FE0  _strcspn  ()  size=70 ==== */
size_t __cdecl strcspn(const char *Str, const char *Control)
{
  unsigned int v2; // eax
  size_t v5; // ecx
  signed __int32 v7[9]; // [esp+0h] [ebp-24h] BYREF

  v2 = 0;
  memset(v7, 0, 32);
  while ( 1 )
  {
    LOBYTE(v2) = *Control;
    if ( !*Control )
      break;
    ++Control;
    _bittestandset(v7, v2);
  }
  v5 = -1;
  do
  {
    ++v5;
    LOBYTE(v2) = *Str;
    if ( !*Str )
      break;
    ++Str;
  }
  while ( !_bittest(v7, v2) );
  return v5;
}


/* ==== 414026  _isdigit  ()  size=58 ==== */
int __cdecl isdigit(int C)
{
  DWORD v1; // eax

  v1 = _getptd()[25];
  if ( (_UNKNOWN *)v1 != off_42D00C )
    v1 = __updatetlocinfo();
  if ( *(int *)(v1 + 40) <= 1 )
    return *(_BYTE *)(*(_DWORD *)(v1 + 72) + 2 * C) & 4;
  else
    return __isctype_mt((UINT *)v1, C, 4);
}


/* ==== 414060  _isxdigit  ()  size=63 ==== */
int __cdecl isxdigit(int C)
{
  DWORD v1; // eax

  v1 = _getptd()[25];
  if ( (_UNKNOWN *)v1 != off_42D00C )
    v1 = __updatetlocinfo();
  if ( *(int *)(v1 + 40) <= 1 )
    return *(_BYTE *)(*(_DWORD *)(v1 + 72) + 2 * C) & 0x80;
  else
    return __isctype_mt((UINT *)v1, C, 128);
}


/* ==== 41409F  _isspace  ()  size=58 ==== */
int __cdecl isspace(int C)
{
  DWORD v1; // eax

  v1 = _getptd()[25];
  if ( (_UNKNOWN *)v1 != off_42D00C )
    v1 = __updatetlocinfo();
  if ( *(int *)(v1 + 40) <= 1 )
    return *(_BYTE *)(*(_DWORD *)(v1 + 72) + 2 * C) & 8;
  else
    return __isctype_mt((UINT *)v1, C, 8);
}


/* ==== 4140E0  _strpbrk  ()  size=64 ==== */
char *__cdecl strpbrk(const char *Str, const char *Control)
{
  char *result; // eax
  signed __int32 v5[9]; // [esp+0h] [ebp-24h] BYREF

  result = 0;
  memset(v5, 0, 32);
  while ( 1 )
  {
    LOBYTE(result) = *Control;
    if ( !*Control )
      break;
    ++Control;
    _bittestandset(v5, (unsigned int)result);
  }
  while ( 1 )
  {
    LOBYTE(result) = *Str;
    if ( !*Str )
      break;
    ++Str;
    if ( _bittest(v5, (unsigned int)result) )
      return (char *)(Str - 1);
  }
  return result;
}


/* ==== 414120  ?_ValidateRead@@YAHPBXI@Z  (_ValidateRead(void const *,uint))  size=28 ==== */
BOOL __cdecl _ValidateRead(void *lp, UINT_PTR ucb)
{
  return !IsBadReadPtr(lp, ucb);
}


/* ==== 41413C  ?_ValidateWrite@@YAHPAXI@Z  (_ValidateWrite(void *,uint))  size=28 ==== */
BOOL __cdecl _ValidateWrite(void *lp, UINT_PTR ucb)
{
  return !IsBadWritePtr(lp, ucb);
}


/* ==== 414158  ?_ValidateExecute@@YAHP6GHXZ@Z  (_ValidateExecute(int (*)(void)))  size=24 ==== */
BOOL __cdecl _ValidateExecute(FARPROC lpfn)
{
  return !IsBadCodePtr(lpfn);
}


/* ==== 414170  _abort  ()  size=23 ==== */
void __cdecl __noreturn abort()
{
  sub_411A1E(10);
  raise(22);
  _exit(3);
}


/* ==== 414188  ___crtMessageBoxA  ()  size=249 ==== */
int __cdecl __crtMessageBoxA(const CHAR *a1, const CHAR *a2, UINT a3)
{
  HWND ActiveWindow_0; // ebx
  HMODULE LibraryA; // eax
  HMODULE v5; // edi
  HWINSTA ProcessWindowStation; // eax
  _BYTE v8[12]; // [esp+Ch] [ebp-10h] BYREF
  DWORD v9; // [esp+18h] [ebp-4h] BYREF

  ActiveWindow_0 = 0;
  if ( !MessageBoxA_0 )
  {
    LibraryA = LoadLibraryA("user32.dll");
    v5 = LibraryA;
    if ( !LibraryA )
      return 0;
    MessageBoxA_0 = (int (__stdcall *)(HWND, LPCSTR, LPCSTR, UINT))GetProcAddress(LibraryA, "MessageBoxA");
    if ( !MessageBoxA_0 )
      return 0;
    GetActiveWindow_0 = (HWND (__stdcall *)())GetProcAddress(v5, "GetActiveWindow");
    GetLastActivePopup_0 = (HWND (__stdcall *)(HWND))GetProcAddress(v5, "GetLastActivePopup");
    if ( dword_4300E8 == 2 )
    {
      GetUserObjectInformationA = (BOOL (__stdcall *)(HANDLE, int, PVOID, DWORD, LPDWORD))GetProcAddress(
                                                                                            v5,
                                                                                            "GetUserObjectInformationA");
      if ( GetUserObjectInformationA )
        GetProcessWindowStation = (HWINSTA (__stdcall *)())GetProcAddress(v5, "GetProcessWindowStation");
    }
  }
  if ( !GetProcessWindowStation
    || (ProcessWindowStation = GetProcessWindowStation()) != 0
    && GetUserObjectInformationA(ProcessWindowStation, 1, v8, 12, &v9)
    && (v8[8] & 1) != 0 )
  {
    if ( GetActiveWindow_0 )
    {
      ActiveWindow_0 = GetActiveWindow_0();
      if ( ActiveWindow_0 )
      {
        if ( GetLastActivePopup_0 )
          ActiveWindow_0 = GetLastActivePopup_0(ActiveWindow_0);
      }
    }
  }
  else if ( (unsigned int)dword_4300F4 < 4 )
  {
    BYTE2(a3) |= 4u;
  }
  else
  {
    BYTE2(a3) |= 0x20u;
  }
  return MessageBoxA_0(ActiveWindow_0, a1, a2, a3);
}


/* ==== 414290  _strncpy  ()  size=292 ==== */
char *__cdecl strncpy(char *Destination, const char *Source, size_t Count)
{
  size_t v3; // ecx
  size_t v4; // ebx
  const char *v5; // esi
  char *v6; // edi
  size_t v7; // ecx
  char v8; // al
  size_t v10; // ecx
  int v11; // eax
  int v12; // edx

  v3 = Count;
  if ( !Count )
    return Destination;
  v4 = Count;
  v5 = Source;
  v6 = Destination;
  if ( ((unsigned __int8)Source & 3) == 0 )
  {
    v7 = Count >> 2;
    if ( Count >> 2 )
      goto main_loop_entrance_0;
copy_tail_loop:
    while ( 1 )
    {
      v8 = *v5++;
      *v6++ = v8;
      if ( !v8 )
        break;
      if ( !--v4 )
        return Destination;
    }
    while ( --v4 )
finish_loop:
      *v6++ = v8;
    return Destination;
  }
  do
  {
    v8 = *v5++;
    *v6++ = v8;
    if ( !--v3 )
      return Destination;
    if ( !v8 )
    {
      while ( ((unsigned __int8)v6 & 3) != 0 )
      {
        *v6++ = 0;
        if ( !--v3 )
          return Destination;
      }
      v4 = v3;
      v10 = v3 >> 2;
      if ( !v10 )
        goto finish_loop;
      goto fill_dwords_with_EOS;
    }
  }
  while ( ((unsigned __int8)v5 & 3) != 0 );
  LOBYTE(v4) = v3;
  v7 = v3 >> 2;
  if ( !v7 )
  {
tail_loop_start_0:
    v4 &= 3u;
    if ( v4 )
      goto copy_tail_loop;
    return Destination;
  }
  while ( 1 )
  {
main_loop_entrance_0:
    v11 = (*(_DWORD *)v5 + 2130640639) ^ ~*(_DWORD *)v5;
    v12 = *(_DWORD *)v5;
    v5 += 4;
    if ( (v11 & 0x81010100) == 0 )
      goto main_loop_3;
    if ( !(_BYTE)v12 )
      break;
    if ( !BYTE1(v12) )
    {
      *(_DWORD *)v6 = (unsigned __int8)v12;
      goto fill_with_EOS_dwords;
    }
    if ( (v12 & 0xFF0000) == 0 )
    {
      *(_DWORD *)v6 = (unsigned __int16)v12;
      goto fill_with_EOS_dwords;
    }
    if ( (v12 & 0xFF000000) == 0 )
    {
      *(_DWORD *)v6 = v12;
      goto fill_with_EOS_dwords;
    }
main_loop_3:
    *(_DWORD *)v6 = v12;
    v6 += 4;
    if ( !--v7 )
      goto tail_loop_start_0;
  }
  *(_DWORD *)v6 = 0;
fill_with_EOS_dwords:
  v6 += 4;
  v8 = 0;
  v10 = v7 - 1;
  if ( v10 )
  {
fill_dwords_with_EOS:
    v8 = 0;
    do
    {
      *(_DWORD *)v6 = 0;
      v6 += 4;
      --v10;
    }
    while ( v10 );
  }
  v4 &= 3u;
  if ( v4 )
    goto finish_loop;
  return Destination;
}


/* ==== 4143B4  __getbuf  ()  size=68 ==== */
int __cdecl _getbuf(_DWORD *a1)
{
  void *v1; // eax
  int result; // eax

  ++dword_43021C;
  v1 = malloc(0x1000u);
  a1[2] = v1;
  if ( v1 )
  {
    a1[3] |= 8u;
    a1[6] = 4096;
  }
  else
  {
    a1[3] |= 4u;
    a1[2] = a1 + 5;
    a1[6] = 2;
  }
  result = a1[2];
  a1[1] = 0;
  *a1 = result;
  return result;
}


/* ==== 4143F8  __isatty  ()  size=42 ==== */
int __cdecl _isatty(int FileHandle)
{
  if ( FileHandle < uNumber )
    return *(_BYTE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F) + 4) & 0x40;
  else
    return 0;
}


/* ==== 414422  ___wctomb_mt  ()  size=96 ==== */
int __cdecl __wctomb_mt(UINT *a1, LPSTR lpMultiByteStr, WCHAR WideCharStr)
{
  CHAR *v3; // ecx
  int result; // eax
  int v5; // [esp-Ch] [ebp-10h]

  v3 = lpMultiByteStr;
  if ( !lpMultiByteStr )
    return 0;
  if ( !a1[5] )
  {
    if ( WideCharStr <= 0xFFu )
    {
      *lpMultiByteStr = WideCharStr;
      return 1;
    }
    goto LABEL_8;
  }
  v5 = a1[10];
  lpMultiByteStr = 0;
  result = WideCharToMultiByte(a1[1], 0, &WideCharStr, 1, v3, v5, 0, (LPBOOL)&lpMultiByteStr);
  if ( !result || lpMultiByteStr )
  {
LABEL_8:
    *_errno() = 42;
    return -1;
  }
  return result;
}


/* ==== 414482  _wctomb  ()  size=39 ==== */
int __cdecl wctomb(char *MbCh, wchar_t WCh)
{
  UINT *v2; // eax

  v2 = (UINT *)_getptd()[25];
  if ( v2 != (UINT *)off_42D00C )
    v2 = (UINT *)__updatetlocinfo();
  return __wctomb_mt(v2, MbCh, WCh);
}


/* ==== 4144B0  __aulldvrm  ()  size=149 ==== */
unsigned int __stdcall _aulldvrm(unsigned __int64 a1, __int64 a2)
{
  unsigned __int64 v2; // rtt
  unsigned int v3; // esi
  unsigned int v4; // ecx
  unsigned int v5; // ebx
  unsigned __int64 v6; // rax
  char v7; // cf
  unsigned __int64 v8; // rax

  if ( HIDWORD(a2) )
  {
    v4 = HIDWORD(a2);
    v5 = a2;
    v6 = a1;
    do
    {
      v7 = v4 & 1;
      v4 >>= 1;
      v5 = (v5 >> 1) | (v7 << 31);
      v6 >>= 1;
    }
    while ( v4 );
    v3 = v6 / v5;
    v8 = v3 * (unsigned __int64)(unsigned int)a2;
    if ( __CFADD__(HIDWORD(a2) * v3, HIDWORD(v8)) || (HIDWORD(v8) = (a2 * (unsigned __int64)v3) >> 32, v8 > a1) )
      --v3;
  }
  else
  {
    LODWORD(v2) = a1;
    HIDWORD(v2) = HIDWORD(a1) % (unsigned int)a2;
    return v2 / (unsigned int)a2;
  }
  return v3;
}


/* ==== 414545  _getenv  ()  size=129 ==== */
char *__cdecl getenv(const char *VarName)
{
  const char **v1; // esi
  size_t v3; // edi

  v1 = (const char **)dword_430108;
  if ( !dword_4319A4 )
    return 0;
  if ( dword_430108 || dword_430110 && !__wtomb_environ() && (v1 = (const char **)dword_430108) != 0 )
  {
    if ( VarName )
    {
      v3 = strlen(VarName);
      while ( *v1 )
      {
        if ( strlen(*v1) > v3
          && (*v1)[v3] == 61
          && !_mbsnbicoll((const unsigned __int8 *)*v1, (const unsigned __int8 *)VarName, v3) )
        {
          return (char *)&(*v1)[v3 + 1];
        }
        ++v1;
      }
    }
  }
  return 0;
}


/* ==== 4145C6  __free_lc_time  ()  size=400 ==== */
void __cdecl _free_lc_time(void **a1)
{
  if ( a1 )
  {
    free(a1[1]);
    free(a1[2]);
    free(a1[3]);
    free(a1[4]);
    free(a1[5]);
    free(a1[6]);
    free(*a1);
    free(a1[8]);
    free(a1[9]);
    free(a1[10]);
    free(a1[11]);
    free(a1[12]);
    free(a1[13]);
    free(a1[7]);
    free(a1[14]);
    free(a1[15]);
    free(a1[16]);
    free(a1[17]);
    free(a1[18]);
    free(a1[19]);
    free(a1[20]);
    free(a1[21]);
    free(a1[22]);
    free(a1[23]);
    free(a1[24]);
    free(a1[25]);
    free(a1[26]);
    free(a1[27]);
    free(a1[28]);
    free(a1[29]);
    free(a1[30]);
    free(a1[31]);
    free(a1[32]);
    free(a1[33]);
    free(a1[34]);
    free(a1[35]);
    free(a1[36]);
    free(a1[37]);
    free(a1[38]);
    free(a1[39]);
    free(a1[40]);
    free(a1[41]);
    free(a1[42]);
  }
}


/* ==== 414756  ___free_lconv_num  ()  size=95 ==== */
void __cdecl __free_lconv_num(int a1)
{
  void *v1; // eax
  void *v2; // esi

  if ( a1 )
  {
    if ( *(_UNKNOWN **)a1 != *off_42D684 && *(_UNKNOWN **)a1 != off_42D654 )
      free(*(void **)a1);
    v1 = *(void **)(a1 + 4);
    if ( v1 != off_42D684[1] && v1 != off_42D658 )
      free(*(void **)(a1 + 4));
    v2 = *(void **)(a1 + 8);
    if ( v2 != off_42D684[2] && v2 != off_42D65C )
      free(v2);
  }
}


/* ==== 4147B5  ___free_lconv_mon  ()  size=217 ==== */
void __cdecl __free_lconv_mon(int a1)
{
  void *v1; // eax
  void *v2; // eax
  void *v3; // eax
  void *v4; // eax
  void *v5; // eax
  void *v6; // eax
  void *v7; // esi

  if ( a1 )
  {
    v1 = *(void **)(a1 + 12);
    if ( v1 != off_42D684[3] && v1 != off_42D660 )
      free(*(void **)(a1 + 12));
    v2 = *(void **)(a1 + 16);
    if ( v2 != off_42D684[4] && v2 != off_42D664 )
      free(*(void **)(a1 + 16));
    v3 = *(void **)(a1 + 20);
    if ( v3 != off_42D684[5] && v3 != off_42D668 )
      free(*(void **)(a1 + 20));
    v4 = *(void **)(a1 + 24);
    if ( v4 != off_42D684[6] && v4 != off_42D66C )
      free(*(void **)(a1 + 24));
    v5 = *(void **)(a1 + 28);
    if ( v5 != off_42D684[7] && v5 != off_42D670 )
      free(*(void **)(a1 + 28));
    v6 = *(void **)(a1 + 32);
    if ( v6 != off_42D684[8] && v6 != off_42D674 )
      free(*(void **)(a1 + 32));
    v7 = *(void **)(a1 + 36);
    if ( v7 != off_42D684[9] && v7 != off_42D678 )
      free(v7);
  }
}


/* ==== 414890  _strncmp  ()  size=57 ==== */
int __cdecl strncmp(const char *Str1, const char *Str2, size_t MaxCount)
{
  size_t v3; // ecx
  const char *v4; // edi
  bool v5; // zf
  size_t v6; // ecx
  const char *v7; // edi
  unsigned __int8 v9; // al

  v3 = MaxCount;
  if ( MaxCount )
  {
    v4 = Str1;
    do
    {
      if ( !v3 )
        break;
      v5 = *v4++ == 0;
      --v3;
    }
    while ( !v5 );
    v6 = MaxCount - v3;
    v7 = Str1;
    do
    {
      if ( !v6 )
        break;
      v5 = *Str2++ == *v7++;
      --v6;
    }
    while ( v5 );
    v9 = *(Str2 - 1);
    v3 = 0;
    if ( v9 > (unsigned int)*(v7 - 1) )
      return ~v3;
    if ( v9 != *(v7 - 1) )
    {
      v3 = -2;
      return ~v3;
    }
  }
  return v3;
}


/* ==== 4148C9  __fcloseall  ()  size=155 ==== */
int __cdecl _fcloseall()
{
  int i; // edi
  int v1; // esi
  int v2; // eax
  int v4; // [esp+10h] [ebp-1Ch]

  v4 = 0;
  _lock(1);
  for ( i = 3; i < dword_431760; ++i )
  {
    v1 = 4 * i;
    v2 = *(_DWORD *)(4 * i + dword_430744);
    if ( v2 )
    {
      if ( (*(_BYTE *)(v2 + 12) & 0x83) != 0 && fclose(*(FILE **)(4 * i + dword_430744)) != -1 )
        ++v4;
      if ( i >= 20 )
      {
        DeleteCriticalSection((LPCRITICAL_SECTION)(*(_DWORD *)(v1 + dword_430744) + 32));
        free(*(void **)(v1 + dword_430744));
        *(_DWORD *)(v1 + dword_430744) = 0;
      }
    }
  }
  _unlock(1);
  return v4;
}


/* ==== 414964  __tsopen_lk  ()  size=743 ==== */
int __cdecl _tsopen_lk(_DWORD *a1, int *a2, LPCSTR lpFileName, __int16 a4, char a5)
{
  int v5; // ecx
  unsigned int v7; // eax
  DWORD v8; // esi
  int v9; // eax
  int v10; // edi
  HANDLE v11; // eax
  void *v12; // esi
  DWORD FileType; // eax
  DWORD LastError; // eax
  char v15; // al
  int v16; // ecx
  int v17; // esi
  bool v18; // zf
  _BYTE *v19; // eax
  DWORD v20; // [esp-10h] [ebp-34h]
  _SECURITY_ATTRIBUTES SecurityAttributes; // [esp+8h] [ebp-1Ch] BYREF
  DWORD dwDesiredAccess; // [esp+14h] [ebp-10h]
  DWORD dwCreationDisposition; // [esp+18h] [ebp-Ch]
  DWORD dwShareMode; // [esp+1Ch] [ebp-8h]
  char Buffer; // [esp+22h] [ebp-2h] BYREF
  char v26; // [esp+23h] [ebp-1h]

  SecurityAttributes.nLength = 12;
  SecurityAttributes.lpSecurityDescriptor = 0;
  if ( (a4 & 0x80u) == 0 )
  {
    SecurityAttributes.bInheritHandle = 1;
    v26 = 0;
  }
  else
  {
    SecurityAttributes.bInheritHandle = 0;
    v26 = 16;
  }
  if ( (a4 & 0x8000) == 0 && ((a4 & 0x4000) != 0 || dword_430594 != 0x8000) )
    v26 |= 0x80u;
  if ( (a4 & 3) != 0 )
  {
    if ( (a4 & 3) == 1 )
    {
      dwDesiredAccess = 0x40000000;
    }
    else
    {
      if ( (a4 & 3) != 2 )
      {
LABEL_18:
        *_errno() = 22;
        *__doserrno() = 0;
        return -1;
      }
      dwDesiredAccess = -1073741824;
    }
  }
  else
  {
    dwDesiredAccess = 0x80000000;
  }
  switch ( v5 )
  {
    case 16:
      dwShareMode = 0;
      break;
    case 32:
      dwShareMode = 1;
      break;
    case 48:
      dwShareMode = 2;
      break;
    case 64:
      dwShareMode = 3;
      break;
    default:
      goto LABEL_18;
  }
  v7 = a4 & 0x700;
  if ( v7 > 0x400 )
  {
    if ( v7 != 1280 )
    {
      if ( v7 == 1536 )
        goto LABEL_37;
      if ( v7 != 1792 )
        goto LABEL_35;
    }
    dwCreationDisposition = 1;
    goto LABEL_39;
  }
  if ( v7 == 1024 || (a4 & 0x700) == 0 )
  {
    dwCreationDisposition = 3;
    goto LABEL_39;
  }
  if ( v7 == 256 )
  {
    dwCreationDisposition = 4;
    goto LABEL_39;
  }
  if ( v7 == 512 )
  {
LABEL_37:
    dwCreationDisposition = 5;
    goto LABEL_39;
  }
  if ( v7 != 768 )
  {
LABEL_35:
    *_errno() = 22;
    *__doserrno() = 0;
    return -1;
  }
  dwCreationDisposition = 2;
LABEL_39:
  v8 = 128;
  if ( (a4 & 0x100) != 0 && (a5 & ~(_BYTE)dword_4300E4 & 0x80u) == 0 )
    v8 = 1;
  if ( (a4 & 0x40) != 0 )
  {
    BYTE2(dwDesiredAccess) |= 1u;
    v8 |= 0x4000000u;
    if ( dword_4300E8 == 2 )
      dwShareMode |= 4u;
  }
  if ( (a4 & 0x1000) != 0 )
    v8 |= 0x100u;
  if ( (a4 & 0x20) != 0 )
  {
    v8 |= 0x8000000u;
  }
  else if ( (a4 & 0x10) != 0 )
  {
    v8 |= 0x10000000u;
  }
  v9 = _alloc_osfhnd();
  v10 = v9;
  if ( v9 == -1 )
  {
    *_errno() = 24;
    *__doserrno() = 0;
    return -1;
  }
  v20 = dwCreationDisposition;
  *a1 = 1;
  *a2 = v9;
  v11 = CreateFileA(lpFileName, dwDesiredAccess, dwShareMode, &SecurityAttributes, v20, v8, 0);
  v12 = v11;
  if ( v11 == (HANDLE)-1 )
  {
LABEL_57:
    LastError = GetLastError();
    _dosmaperr(LastError);
    return -1;
  }
  FileType = GetFileType(v11);
  switch ( FileType )
  {
    case 0u:
      CloseHandle(v12);
      goto LABEL_57;
    case 2u:
      v26 |= 0x40u;
      break;
    case 3u:
      v26 |= 8u;
      break;
  }
  _set_osfhnd(v10, v12);
  v26 |= 1u;
  v15 = v26;
  v16 = dword_430620[v10 >> 5];
  v17 = 36 * (v10 & 0x1F);
  v18 = (v26 & 0x48) == 0;
  v26 &= 0x48u;
  *(_BYTE *)(v17 + v16 + 4) = v15;
  if ( v18 && v15 < 0 && (a4 & 2) != 0 )
  {
    dwDesiredAccess = _lseek_lk(v10, -1, 2u);
    if ( dwDesiredAccess == -1 )
    {
      if ( *__doserrno() == 131 )
        goto LABEL_67;
      goto LABEL_76;
    }
    Buffer = 0;
    if ( !sub_4132FF(v10, &Buffer, 1u) && Buffer == 26 && sub_415B16(v10, dwDesiredAccess) == -1
      || _lseek_lk(v10, 0, 0) == -1 )
    {
LABEL_76:
      _close_lk(v10);
      return -1;
    }
  }
LABEL_67:
  if ( !v26 && (a4 & 8) != 0 )
  {
    v19 = (_BYTE *)(v17 + dword_430620[v10 >> 5] + 4);
    *v19 |= 0x20u;
  }
  return v10;
}


/* ==== 414C4B  __sopen  ()  size=85 ==== */
int _sopen(const char *FileName, int OpenFlag, int ShareFlag, ...)
{
  int v4; // [esp+Ch] [ebp-24h]
  int v5; // [esp+10h] [ebp-20h] BYREF
  int v6; // [esp+14h] [ebp-1Ch] BYREF
  CPPEH_RECORD ms_exc; // [esp+18h] [ebp-18h]
  int v8; // [esp+44h] [ebp+14h]
  va_list va; // [esp+48h] [ebp+18h] BYREF

  va_start(va, ShareFlag);
  v8 = va_arg(va, _DWORD);
  v6 = 0;
  ms_exc.registration.TryLevel = 0;
  v4 = _tsopen_lk(&v6, &v5, FileName, OpenFlag, v8);
  ms_exc.registration.TryLevel = -1;
  if ( v6 )
    _unlock_fhandle(v5);
  return v4;
}


/* ==== 414CA0  ___tolower_mt  ()  size=200 ==== */
int __cdecl __tolower_mt(UINT *MultiByteStr, unsigned int a2)
{
  unsigned int v2; // ebx
  UINT *v3; // esi
  int v4; // eax
  int v5; // eax
  int v6; // eax
  int result; // eax
  unsigned __int16 v8; // ax
  WCHAR DestStr; // [esp+Ch] [ebp-4h] BYREF

  v2 = a2;
  v3 = MultiByteStr;
  if ( MultiByteStr[5] && (!MultiByteStr[9] || a2 > 0x7F) )
  {
    if ( a2 >= 0x100
      || ((int)MultiByteStr[10] <= 1
        ? (v4 = *(_BYTE *)(MultiByteStr[18] + 2 * a2) & 1)
        : (v4 = __isctype_mt(MultiByteStr, a2, 1)),
          v4) )
    {
      if ( *(char *)(v3[18] + 2 * BYTE1(v2) + 1) >= 0 )
      {
        LOWORD(MultiByteStr) = (unsigned __int8)v2;
        v5 = 1;
      }
      else
      {
        LOBYTE(MultiByteStr) = BYTE1(v2);
        *(_WORD *)((char *)&MultiByteStr + 1) = (unsigned __int8)v2;
        v5 = 2;
      }
      v6 = sub_4139C9(v3[5], 0x100u, (CHAR *)&MultiByteStr, v5, &DestStr, 3, v3[1], 1);
      if ( v6 )
      {
        if ( v6 == 1 )
          return (unsigned __int8)DestStr;
        LOBYTE(v8) = 0;
        HIBYTE(v8) = DestStr;
        return HIBYTE(DestStr) | v8;
      }
    }
    return v2;
  }
  if ( (int)a2 < 65 )
    return v2;
  result = a2 + 32;
  if ( (int)a2 > 90 )
    return v2;
  return result;
}


/* ==== 414D68  _tolower  ()  size=34 ==== */
int __cdecl tolower(int C)
{
  UINT *v1; // eax

  v1 = (UINT *)_getptd()[25];
  if ( v1 != (UINT *)off_42D00C )
    v1 = (UINT *)__updatetlocinfo();
  return __tolower_mt(v1, C);
}


/* ==== 414D8A  __ZeroTail  ()  size=50 ==== */
int __cdecl _ZeroTail(int a1, int a2)
{
  int v2; // eax

  v2 = a2 / 32;
  if ( (~(-1 << (31 - a2 % 32)) & *(_DWORD *)(a1 + 4 * (a2 / 32))) != 0 )
    return 0;
  while ( ++v2 < 3 )
  {
    if ( *(_DWORD *)(a1 + 4 * v2) )
      return 0;
  }
  return 1;
}


/* ==== 414DBC  __IncMan  ()  size=77 ==== */
int __cdecl _IncMan(int a1, int a2)
{
  int result; // eax
  int v3; // esi
  _DWORD *v4; // edi

  result = __addl(*(_DWORD *)(a1 + 4 * (a2 / 32)), 1 << (31 - a2 % 32), a1 + 4 * (a2 / 32));
  v3 = a2 / 32 - 1;
  if ( v3 >= 0 )
  {
    v4 = (_DWORD *)(a1 + 4 * v3);
    do
    {
      if ( !result )
        break;
      result = __addl(*v4, 1, v4);
      --v3;
      --v4;
    }
    while ( v3 >= 0 );
  }
  return result;
}


/* ==== 414E09  __RoundMan  ()  size=114 ==== */
int __cdecl _RoundMan(int a1, int a2)
{
  int v2; // ebx
  int v3; // eax
  int v4; // ebx
  int v6; // [esp+Ch] [ebp-4h]

  v6 = 0;
  v2 = a2 / 32;
  v3 = a1;
  if ( ((1 << (31 - a2 % 32)) & *(_DWORD *)(a1 + 4 * (a2 / 32))) != 0 )
  {
    if ( !_ZeroTail(a1, a2) )
      v6 = _IncMan(a1, a2 - 1);
    v3 = a1;
  }
  *(_DWORD *)(v3 + 4 * v2) &= -1 << (31 - a2 % 32);
  v4 = v2 + 1;
  if ( v4 < 3 )
    memset((void *)(v3 + 4 * v4), 0, 4 * (3 - v4));
  return v6;
}


/* ==== 414E7B  __CopyMan  ()  size=27 ==== */
_DWORD *__cdecl _CopyMan(int a1, _DWORD *a2)
{
  _DWORD *result; // eax
  int v3; // edx

  result = a2;
  v3 = 3;
  do
  {
    *(_DWORD *)((char *)result + a1 - (_DWORD)a2) = *result;
    ++result;
    --v3;
  }
  while ( v3 );
  return result;
}


/* ==== 414E96  __IsZeroMan  ()  size=25 ==== */
int __cdecl _IsZeroMan(int a1)
{
  int v1; // eax

  v1 = 0;
  while ( !*(_DWORD *)(a1 + 4 * v1) )
  {
    if ( ++v1 >= 3 )
      return 1;
  }
  return 0;
}


/* ==== 414EAF  __ShrMan  ()  size=123 ==== */
int __cdecl _ShrMan(int a1, int a2)
{
  int v2; // edx
  int v3; // eax
  int result; // eax
  _DWORD *v5; // ecx
  int v6; // [esp+Ch] [ebp-Ch]
  int v7; // [esp+10h] [ebp-8h]
  int v8; // [esp+14h] [ebp-4h]
  int v9; // [esp+24h] [ebp+Ch]

  v2 = a2 % 32;
  v7 = a2 / 32;
  v3 = 0;
  v9 = 32 - a2 % 32;
  v8 = 0;
  do
  {
    v6 = ~(-1 << v2) & *(_DWORD *)(a1 + 4 * v3);
    *(_DWORD *)(a1 + 4 * v3) = v8 | (*(_DWORD *)(a1 + 4 * v3) >> v2);
    ++v3;
    v8 = v6 << v9;
  }
  while ( v3 < 3 );
  result = 2;
  v5 = (_DWORD *)(a1 + 4 * (2 - v7));
  do
  {
    if ( result < v7 )
      *(_DWORD *)(a1 + 4 * result) = 0;
    else
      *(_DWORD *)(a1 + 4 * result) = *v5;
    --result;
    --v5;
  }
  while ( result >= 0 );
  return result;
}


/* ==== 414F2A  __ld12cvt  ()  size=344 ==== */
int __cdecl _ld12cvt(unsigned __int16 *a1, _DWORD *a2, int *a3)
{
  unsigned __int16 v4; // di
  int v5; // ecx
  int v6; // edi
  int v7; // ebx
  int result; // eax
  int v9; // eax
  int v10; // edi
  int v11; // ebx
  int v12; // esi
  int v13; // ebx
  int v14; // edx
  int v15; // [esp-4h] [ebp-28h]
  _DWORD v16[3]; // [esp+Ch] [ebp-18h] BYREF
  __int64 v17; // [esp+18h] [ebp-Ch] BYREF
  int v18; // [esp+20h] [ebp-4h]
  int v19; // [esp+2Ch] [ebp+8h]

  v4 = a1[5];
  v19 = v4 & 0x8000;
  LODWORD(v17) = *(_DWORD *)(a1 + 3);
  v5 = *(_DWORD *)(a1 + 1);
  v6 = (v4 & 0x7FFF) - 0x3FFF;
  v18 = *a1 << 16;
  HIDWORD(v17) = v5;
  if ( v6 == -16383 )
  {
    v7 = 0;
    if ( !_IsZeroMan((int)&v17) )
    {
      v17 = 0;
      v18 = 0;
LABEL_4:
      result = 2;
      goto LABEL_16;
    }
    goto LABEL_15;
  }
  _CopyMan((int)v16, &v17);
  if ( _RoundMan((int)&v17, a3[2]) )
    ++v6;
  v9 = a3[1];
  if ( v6 < v9 - a3[2] )
  {
    v17 = 0;
    v18 = 0;
LABEL_11:
    v7 = 0;
    goto LABEL_4;
  }
  if ( v6 <= v9 )
  {
    v10 = v9 - v6;
    _CopyMan((int)&v17, v16);
    _ShrMan((int)&v17, v10);
    _RoundMan((int)&v17, a3[2]);
    _ShrMan((int)&v17, a3[3] + 1);
    goto LABEL_11;
  }
  v15 = a3[3];
  if ( v6 >= *a3 )
  {
    LODWORD(v17) = 0;
    HIBYTE(v17) = 0;
    v18 = 0;
    *(_DWORD *)((char *)&v17 + 3) = 128;
    _ShrMan((int)&v17, v15);
    v7 = *a3 + a3[5];
    result = 1;
    goto LABEL_16;
  }
  v11 = a3[5];
  BYTE3(v17) &= ~0x80u;
  v7 = v6 + v11;
  _ShrMan((int)&v17, v15);
LABEL_15:
  result = 0;
LABEL_16:
  v12 = a3[4];
  v13 = v17 | (v19 != 0 ? 0x80000000 : 0) | (v7 << (31 - *((_BYTE *)a3 + 12)));
  if ( v12 == 64 )
  {
    v14 = HIDWORD(v17);
    a2[1] = v13;
    *a2 = v14;
  }
  else if ( v12 == 32 )
  {
    *a2 = v13;
  }
  return result;
}


/* ==== 415082  sub_415082  ()  size=22 ==== */
int __cdecl sub_415082(unsigned __int16 *a1, _DWORD *a2)
{
  return _ld12cvt(a1, a2, dword_42D69C);
}


/* ==== 415098  sub_415098  ()  size=22 ==== */
int __cdecl sub_415098(unsigned __int16 *a1, _DWORD *a2)
{
  return _ld12cvt(a1, a2, dword_42D6B4);
}


/* ==== 4150AE  sub_4150AE  ()  size=69 ==== */
int __cdecl sub_4150AE(_DWORD *a1, int a2)
{
  _BYTE v3[4]; // [esp+4h] [ebp-14h] BYREF
  unsigned __int16 v4[6]; // [esp+8h] [ebp-10h] BYREF

  sub_415E1D(v4, v3, a2, 0, 0, 0, 0);
  return sub_415082(v4, a1);
}


/* ==== 4150F3  sub_4150F3  ()  size=69 ==== */
int __cdecl sub_4150F3(_DWORD *a1, int a2)
{
  _BYTE v3[4]; // [esp+4h] [ebp-14h] BYREF
  unsigned __int16 v4[6]; // [esp+8h] [ebp-10h] BYREF

  sub_415E1D(v4, v3, a2, 0, 0, 0, 0);
  return sub_415098(v4, a1);
}


/* ==== 415138  __fptostr  ()  size=119 ==== */
char *__cdecl _fptostr(char *a1, char *a2, int a3)
{
  int v3; // edx
  char *v4; // ecx
  int v5; // ebx
  const char *v7; // edi
  char *result; // eax
  char v9; // dl
  size_t v10; // eax
  char *v11; // [esp+14h] [ebp+8h]

  v3 = a3;
  v4 = *(char **)(a3 + 12);
  v5 = (int)a2;
  v7 = a1 + 1;
  *a1 = 48;
  result = a1 + 1;
  if ( (int)a2 > 0 )
  {
    v11 = a2;
    v5 = 0;
    do
    {
      v9 = *v4;
      if ( *v4 )
        ++v4;
      else
        v9 = 48;
      *result++ = v9;
      --v11;
    }
    while ( v11 );
    v3 = a3;
  }
  *result = 0;
  if ( v5 >= 0 && *v4 >= 53 )
  {
    while ( *--result == 57 )
      *result = 48;
    ++*result;
  }
  if ( *a1 == 49 )
  {
    ++*(_DWORD *)(v3 + 4);
  }
  else
  {
    v10 = strlen(v7);
    return (char *)memcpy(a1, v7, v10 + 1);
  }
  return result;
}


/* ==== 4151AF  ___dtold  ()  size=186 ==== */
int __cdecl __dtold(int a1, int *a2)
{
  unsigned __int16 v3; // ax
  int v4; // ecx
  int v5; // eax
  unsigned int v6; // edx
  int v7; // eax
  __int16 v8; // di
  int result; // eax
  int v10; // ecx
  int v11; // edx
  int v12; // ecx
  unsigned int v13; // [esp+Ch] [ebp-4h]
  __int16 v14; // [esp+1Ch] [ebp+Ch]

  v3 = *((_WORD *)a2 + 3);
  v13 = 0x80000000;
  v4 = (v3 >> 4) & 0x7FF;
  v14 = v3 & 0x8000;
  v5 = a2[1];
  v6 = *a2;
  v7 = v5 & 0xFFFFF;
  if ( (_WORD)v4 )
  {
    if ( (unsigned __int16)v4 == 2047 )
      v8 = 0x7FFF;
    else
      v8 = v4 + 15360;
  }
  else
  {
    if ( !v7 && !v6 )
    {
      result = a1;
      *(_DWORD *)(a1 + 4) = 0;
      *(_DWORD *)a1 = 0;
      *(_WORD *)(a1 + 8) = 0;
      return result;
    }
    v8 = v4 + 15361;
    v13 = 0;
  }
  v10 = v13 | (v7 << 11) | (v6 >> 21);
  result = a1;
  *(_DWORD *)(a1 + 4) = v10;
  *(_DWORD *)a1 = v6 << 11;
  if ( (v10 & 0x80000000) == 0 )
  {
    do
    {
      v11 = *(__int64 *)a1 >> 31;
      v12 = 2 * *(_DWORD *)a1;
      --v8;
      *(_DWORD *)(a1 + 4) = v11;
      *(_DWORD *)a1 = v12;
    }
    while ( (v11 & 0x80000000) == 0 );
  }
  *(_WORD *)(a1 + 8) = v8 | v14;
  return result;
}


/* ==== 415269  __fltout2  ()  size=120 ==== */
_DWORD *__cdecl _fltout2(int a1, int a2, _DWORD *a3, char *a4)
{
  _DWORD *v4; // ebx
  __int16 v6; // [esp-10h] [ebp-4Ch]
  char *Destination; // [esp+Ch] [ebp-30h]
  __int16 v8; // [esp+10h] [ebp-2Ch] BYREF
  char v9; // [esp+12h] [ebp-2Ah]
  char Source[24]; // [esp+14h] [ebp-28h] BYREF
  char v11[4]; // [esp+2Ch] [ebp-10h] BYREF
  int v12; // [esp+30h] [ebp-Ch]
  __int16 v13; // [esp+34h] [ebp-8h]

  v4 = a3;
  Destination = a4;
  __dtold((int)v11, &a1);
  v6 = v13;
  v4[2] = sub_41625D(v11[0], v12, v6, 17, 0, &v8);
  *v4 = v9;
  v4[1] = v8;
  strcpy(Destination, Source);
  v4[3] = Destination;
  return v4;
}


/* ==== 4152E1  sub_4152E1  ()  size=7 ==== */
void __noreturn sub_4152E1()
{
  _amsg_exit(2);
}


/* ==== 4152EA  sub_4152EA  ()  size=146 ==== */
int __usercall sub_4152EA@<eax>(__int16 a1@<bx>)
{
  int result; // eax
  int v2; // ecx

  result = 0;
  if ( (a1 & 1) != 0 )
    result = 16;
  if ( (a1 & 4) != 0 )
    result |= 8u;
  if ( (a1 & 8) != 0 )
    result |= 4u;
  if ( (a1 & 0x10) != 0 )
    result |= 2u;
  if ( (a1 & 0x20) != 0 )
    result |= 1u;
  if ( (a1 & 2) != 0 )
    result |= 0x80000u;
  v2 = a1 & 0xC00;
  if ( v2 )
  {
    switch ( v2 )
    {
      case 1024:
        result |= 0x100u;
        break;
      case 2048:
        result |= 0x200u;
        break;
      case 3072:
        result |= 0x300u;
        break;
    }
  }
  if ( (a1 & 0x300) != 0 )
  {
    if ( (a1 & 0x300) == 0x200 )
      result |= 0x10000u;
  }
  else
  {
    result |= 0x20000u;
  }
  if ( (a1 & 0x1000) != 0 )
    return result | 0x40000;
  return result;
}


/* ==== 41537C  __hw_cw  ()  size=142 ==== */
int __usercall _hw_cw@<eax>(int a1@<ebx>)
{
  int result; // eax
  int v2; // ecx

  result = (a1 & 0x10) != 0;
  if ( (a1 & 8) != 0 )
    result |= 4u;
  if ( (a1 & 4) != 0 )
    result |= 8u;
  if ( (a1 & 2) != 0 )
    result |= 0x10u;
  if ( (a1 & 1) != 0 )
    result |= 0x20u;
  if ( (a1 & 0x80000) != 0 )
    result |= 2u;
  v2 = a1 & 0x300;
  if ( (a1 & 0x300) != 0 )
  {
    switch ( v2 )
    {
      case 256:
        result |= 0x400u;
        break;
      case 512:
        result |= 0x800u;
        break;
      case 768:
        result |= 0xC00u;
        break;
    }
  }
  if ( (a1 & 0x30000) != 0 )
  {
    if ( (a1 & 0x30000) == 0x10000 )
      result |= 0x200u;
  }
  else
  {
    result |= 0x300u;
  }
  if ( (a1 & 0x40000) != 0 )
    return result | 0x1000;
  return result;
}


/* ==== 41540A  __control87  ()  size=50 ==== */
unsigned int __cdecl _control87(unsigned int NewValue, unsigned int Mask)
{
  unsigned int v2; // ebx
  __int16 v4; // [esp+4h] [ebp-4h]

  v2 = Mask & NewValue | ~Mask & sub_4152EA(v4);
  _hw_cw(v2);
  return v2;
}


/* ==== 41543C  __controlfp  ()  size=22 ==== */
unsigned int __cdecl _controlfp(unsigned int NewValue, unsigned int Mask)
{
  return _control87(NewValue, Mask & 0xFFF7FFFF);
}


/* ==== 415452  _x_ismbbtype  ()  size=51 ==== */
int __cdecl x_ismbbtype(unsigned __int8 a1, int a2, unsigned __int8 a3)
{
  int result; // eax

  if ( (a3 & (unsigned __int8)byte_431781[a1]) != 0 )
    return 1;
  result = a2 ? (unsigned __int16)(a2 & off_42D640[a1]) : 0;
  if ( result )
    return 1;
  return result;
}


/* ==== 415485  __ismbblead  ()  size=17 ==== */
int __cdecl _ismbblead(unsigned int Ch)
{
  return x_ismbbtype(Ch, 0, 4u);
}


/* ==== 415496  ___mbtowc_mt  ()  size=192 ==== */
UINT __cdecl __mbtowc_mt(UINT *a1, LPWSTR lpWideCharStr, unsigned __int8 *lpMultiByteStr, UINT a4)
{
  unsigned __int8 v4; // al
  int v6; // eax

  if ( !lpMultiByteStr || !a4 )
    return 0;
  v4 = *lpMultiByteStr;
  if ( !*lpMultiByteStr )
  {
    if ( lpWideCharStr )
      *lpWideCharStr = 0;
    return 0;
  }
  if ( !a1[5] )
  {
    if ( lpWideCharStr )
      *lpWideCharStr = v4;
    return 1;
  }
  if ( *(char *)(a1[18] + 2 * v4 + 1) >= 0 )
  {
    if ( MultiByteToWideChar(a1[1], 9u, (LPCCH)lpMultiByteStr, 1, lpWideCharStr, lpWideCharStr != 0) )
      return 1;
  }
  else
  {
    v6 = a1[10];
    if ( v6 > 1
      && (int)a4 >= v6
      && MultiByteToWideChar(a1[1], 9u, (LPCCH)lpMultiByteStr, v6, lpWideCharStr, lpWideCharStr != 0)
      || a4 >= a1[10] && lpMultiByteStr[1] )
    {
      return a1[10];
    }
  }
  *_errno() = 42;
  return -1;
}


/* ==== 415556  _mbtowc  ()  size=43 ==== */
int __cdecl mbtowc(wchar_t *DstCh, const char *SrcCh, size_t SrcSizeInBytes)
{
  UINT *v3; // eax

  v3 = (UINT *)_getptd()[25];
  if ( v3 != (UINT *)off_42D00C )
    v3 = (UINT *)__updatetlocinfo();
  return __mbtowc_mt(v3, DstCh, (unsigned __int8 *)SrcCh, SrcSizeInBytes);
}


/* ==== 415581  _ungetc  ()  size=108 ==== */
int __cdecl ungetc(int Character, FILE *Stream)
{
  int flag; // eax
  char *v3; // eax
  int v5; // eax

  if ( Character == -1 )
    return -1;
  flag = Stream->_flag;
  if ( (flag & 1) == 0 && ((flag & 0x80u) == 0 || (flag & 2) != 0) )
    return -1;
  if ( !Stream->_base )
    _getbuf(Stream);
  if ( Stream->_ptr == Stream->_base )
  {
    if ( Stream->_cnt )
      return -1;
    ++Stream->_ptr;
  }
  v3 = --Stream->_ptr;
  if ( (Stream->_flag & 0x40) != 0 )
  {
    if ( *v3 != (_BYTE)Character )
    {
      Stream->_ptr = v3 + 1;
      return -1;
    }
  }
  else
  {
    *v3 = Character;
  }
  v5 = Stream->_flag;
  ++Stream->_cnt;
  Stream->_flag = v5 & 0xFFFFFFEE | 1;
  return (unsigned __int8)Character;
}


/* ==== 4155ED  __lseeki64_lk  ()  size=131 ==== */
__int64 __cdecl _lseeki64_lk(int FileHandle, LONG a2, int a3, DWORD dwMoveMethod)
{
  void *osfhandle; // eax
  DWORD LastError; // eax
  _BYTE *v7; // eax
  __int64 lDistanceToMove; // [esp+8h] [ebp-8h] BYREF

  HIDWORD(lDistanceToMove) = a3;
  osfhandle = (void *)_get_osfhandle(FileHandle);
  if ( osfhandle == (void *)-1 )
  {
    *_errno() = 9;
    return -1;
  }
  LODWORD(lDistanceToMove) = SetFilePointer(osfhandle, a2, (PLONG)&lDistanceToMove + 1, dwMoveMethod);
  if ( (_DWORD)lDistanceToMove == -1 )
  {
    LastError = GetLastError();
    if ( LastError )
    {
      _dosmaperr(LastError);
      return -1;
    }
  }
  v7 = (_BYTE *)(dword_430620[FileHandle >> 5] + 36 * (FileHandle & 0x1F) + 4);
  *v7 &= ~2u;
  return lDistanceToMove;
}


/* ==== 415670  sub_415670  ()  size=71 ==== */
int __cdecl sub_415670(LCID Locale)
{
  CHAR LCData[8]; // [esp+0h] [ebp-Ch] BYREF

  LCData[6] = 0;
  if ( GetLocaleInfoA(Locale, 0x1004u, LCData, 6) )
    return atol(LCData);
  else
    return -1;
}


/* ==== 4156B7  sub_4156B7  ()  size=474 ==== */
void *__cdecl sub_4156B7(UINT CodePage, UINT a2, char *Str, int *a4, CHAR *a5, int a6)
{
  int v6; // ebx
  int v7; // esi
  void *v8; // esp
  WCHAR *v9; // ebx
  void *v11; // eax
  int v12; // eax
  _BYTE v13[12]; // [esp+0h] [ebp-60h] BYREF
  WCHAR *v14; // [esp+Ch] [ebp-54h]
  int *v15; // [esp+10h] [ebp-50h]
  int v16; // [esp+14h] [ebp-4Ch]
  int cbMultiByte; // [esp+18h] [ebp-48h]
  LPCCH lpMultiByteStr; // [esp+1Ch] [ebp-44h]
  LPSTR v19; // [esp+20h] [ebp-40h]
  int v20; // [esp+24h] [ebp-3Ch]
  BOOL v21; // [esp+28h] [ebp-38h]
  void *Block; // [esp+2Ch] [ebp-34h]
  struct _cpinfo CPInfo; // [esp+30h] [ebp-30h] BYREF
  CPPEH_RECORD ms_exc; // [esp+48h] [ebp-18h]

  lpMultiByteStr = Str;
  v15 = a4;
  v19 = a5;
  Block = 0;
  v16 = 0;
  v6 = *a4;
  cbMultiByte = *a4;
  v21 = 0;
  if ( CodePage == a2 )
  {
    v9 = v14;
  }
  else
  {
    if ( GetCPInfo(CodePage, &CPInfo) && CPInfo.MaxCharSize == 1 && GetCPInfo(a2, &CPInfo) )
      v21 = CPInfo.MaxCharSize == 1;
    if ( v21 )
    {
      if ( v6 == -1 )
        v7 = strlen(Str) + 1;
      else
        v7 = v6;
      v20 = v7;
    }
    else
    {
      v7 = v20;
    }
    if ( !v21 )
    {
      v7 = MultiByteToWideChar(CodePage, 1u, lpMultiByteStr, v6, 0, 0);
      v20 = v7;
      if ( !v7 )
        return 0;
    }
    v8 = alloca(2 * v7);
    ms_exc.old_esp = (DWORD)v13;
    v9 = (WCHAR *)v13;
    v14 = (WCHAR *)v13;
    memset(v13, 0, 2 * v7);
    ms_exc.registration.TryLevel = -1;
    if ( !v13 )
    {
      v9 = (WCHAR *)sub_40DAAE(2u, v7);
      if ( !v9 )
        return 0;
      v16 = 1;
    }
    if ( MultiByteToWideChar(CodePage, 1u, lpMultiByteStr, cbMultiByte, v9, v7) )
    {
      if ( v19 )
      {
        if ( WideCharToMultiByte(a2, 0, v9, v7, v19, a6, 0, 0) )
          Block = v19;
      }
      else if ( v21 || (v7 = WideCharToMultiByte(a2, 0, v9, v7, 0, 0, 0, 0)) != 0 )
      {
        v11 = sub_40DAAE(1u, v7);
        Block = v11;
        if ( v11 )
        {
          v12 = WideCharToMultiByte(a2, 0, v9, v7, (LPSTR)v11, v7, 0, 0);
          if ( v12 )
          {
            if ( cbMultiByte != -1 )
              *v15 = v12;
          }
          else
          {
            free(Block);
            Block = 0;
          }
        }
      }
    }
  }
  if ( v16 )
    free(v9);
  return Block;
}


/* ==== 415891  _siglookup  ()  size=46 ==== */
unsigned int __usercall siglookup@<eax>(unsigned int a1@<edx>, int a2@<esi>)
{
  unsigned int result; // eax

  result = a1;
  do
  {
    if ( *(_DWORD *)(result + 4) == a2 )
      break;
    result += 12;
  }
  while ( result < a1 + 12 * dword_42CEF4 );
  if ( result >= a1 + 12 * dword_42CEF4 || *(_DWORD *)(result + 4) != a2 )
    return 0;
  return result;
}


/* ==== 4158BF  _raise  ()  size=377 ==== */
int __cdecl raise(int Signal)
{
  int *v2; // esi
  void (__cdecl *v3)(int, DWORD); // edi
  DWORD *v4; // ebx
  int i; // eax
  DWORD v6; // [esp+Ch] [ebp-30h]
  DWORD v7; // [esp+10h] [ebp-2Ch]
  DWORD *v8; // [esp+18h] [ebp-24h]
  int v9; // [esp+20h] [ebp-1Ch]

  v9 = 0;
  switch ( Signal )
  {
    case 2:
      v2 = &dword_430578;
      v3 = (void (__cdecl *)(int, DWORD))dword_430578;
      break;
    case 4:
    case 8:
    case 11:
      v4 = _getptd();
      v2 = (int *)(siglookup(v4[21], Signal) + 8);
      v3 = (void (__cdecl *)(int, DWORD))*v2;
      goto LABEL_15;
    case 15:
      v2 = &dword_430584;
      v3 = (void (__cdecl *)(int, DWORD))dword_430584;
      break;
    case 21:
      v2 = &dword_43057C;
      v3 = (void (__cdecl *)(int, DWORD))dword_43057C;
      break;
    case 22:
      v2 = &dword_430580;
      v3 = (void (__cdecl *)(int, DWORD))dword_430580;
      break;
    default:
      return -1;
  }
  v9 = 1;
  v4 = v8;
LABEL_15:
  if ( v3 != (void (__cdecl *)(int, DWORD))1 )
  {
    if ( !v3 )
      _exit(3);
    if ( v9 )
      _lock(0);
    if ( Signal == 8 || Signal == 11 || Signal == 4 )
    {
      v7 = v4[22];
      v4[22] = 0;
      if ( Signal != 8 )
        goto LABEL_29;
      v6 = v4[23];
      v4[23] = 140;
    }
    if ( Signal == 8 )
    {
      for ( i = dword_42CEE8; i < dword_42CEE8 + dword_42CEEC; ++i )
        *(_DWORD *)(v4[21] + 12 * i + 8) = 0;
      goto LABEL_33;
    }
LABEL_29:
    *v2 = 0;
LABEL_33:
    if ( v9 )
      _unlock(0);
    if ( Signal == 8 )
      v3(8, v4[23]);
    else
      ((void (__cdecl *)(int))v3)(Signal);
    if ( Signal == 8 || Signal == 11 || Signal == 4 )
    {
      v4[22] = v7;
      if ( Signal == 8 )
        v4[23] = v6;
    }
  }
  return 0;
}


/* ==== 415A38  __mbsnbicoll  ()  size=78 ==== */
int __cdecl _mbsnbicoll(const unsigned __int8 *Str1, const unsigned __int8 *Str2, size_t MaxCount)
{
  UINT *v3; // eax
  int v5; // eax

  v3 = (UINT *)_getptd()[24];
  if ( v3 != Block )
    v3 = __updatetmbcinfo();
  if ( !MaxCount )
    return 0;
  v5 = sub_416515(v3[3], 1u, (LPCCH)Str1, MaxCount, (int)Str2, MaxCount, v3[1]);
  if ( v5 )
    return v5 - 2;
  else
    return 0x7FFFFFFF;
}


/* ==== 415A86  ___wtomb_environ  ()  size=144 ==== */
int __wtomb_environ()
{
  LPCWCH *v0; // edi
  const WCHAR *v1; // eax
  size_t v2; // eax
  void *v3; // eax
  int cbMultiByte; // [esp+Ch] [ebp-8h]
  void *Block; // [esp+10h] [ebp-4h] BYREF

  v0 = (LPCWCH *)dword_430110;
  Block = 0;
  v1 = *(const WCHAR **)dword_430110;
  if ( !*(_DWORD *)dword_430110 )
    return 0;
  while ( 1 )
  {
    v2 = WideCharToMultiByte(0, 0, v1, -1, 0, 0, 0, 0);
    cbMultiByte = v2;
    if ( !v2 )
      break;
    v3 = malloc(v2);
    Block = v3;
    if ( !v3 )
      break;
    if ( !WideCharToMultiByte(0, 0, *v0, -1, (LPSTR)v3, cbMultiByte, 0, 0) )
    {
      free(Block);
      return -1;
    }
    if ( (int)sub_41694D(&Block, 0) < 0 )
    {
      if ( Block )
      {
        free(Block);
        Block = 0;
      }
    }
    v1 = *++v0;
    if ( !*v0 )
      return 0;
  }
  return -1;
}


/* ==== 415B16  sub_415B16  ()  size=325 ==== */
int __cdecl sub_415B16(int FileHandle, LONG lDistanceToMove)
{
  int v2; // esi
  DWORD v3; // eax
  int v4; // edi
  DWORD v5; // eax
  int v6; // eax
  void *osfhandle; // eax
  BOOL v8; // eax
  unsigned int *v9; // edi
  int v11; // [esp+8h] [ebp-100Ch]
  DWORD v12; // [esp+Ch] [ebp-1008h]
  _BYTE Buffer[4096]; // [esp+10h] [ebp-1004h] BYREF

  v2 = 0;
  v12 = _lseek_lk(FileHandle, 0, 1u);
  if ( v12 == -1 )
    return -1;
  v3 = _lseek_lk(FileHandle, 0, 2u);
  if ( v3 == -1 )
    return -1;
  v4 = lDistanceToMove - v3;
  if ( (int)(lDistanceToMove - v3) <= 0 )
  {
    if ( (int)(lDistanceToMove - v3) < 0 )
    {
      _lseek_lk(FileHandle, lDistanceToMove, 0);
      osfhandle = (void *)_get_osfhandle(FileHandle);
      v8 = SetEndOfFile(osfhandle);
      v2 = v8 - 1;
      if ( !v8 )
      {
        *_errno() = 13;
        v9 = __doserrno();
        *v9 = GetLastError();
      }
    }
  }
  else
  {
    memset(Buffer, 0, sizeof(Buffer));
    v11 = _setmode_lk(FileHandle, 0x8000);
    while ( 1 )
    {
      v5 = 4096;
      if ( v4 < 4096 )
        v5 = v4;
      v6 = sub_413587(FileHandle, Buffer, v5);
      if ( v6 == -1 )
        break;
      v4 -= v6;
      if ( v4 <= 0 )
        goto LABEL_13;
    }
    if ( *__doserrno() == 5 )
      *_errno() = 13;
    v2 = -1;
LABEL_13:
    _setmode_lk(FileHandle, v11);
  }
  _lseek_lk(FileHandle, v12, 0);
  return v2;
}


/* ==== 415C5B  ___addl  ()  size=33 ==== */
int __cdecl __addl(unsigned int a1, unsigned int a2, unsigned int *a3)
{
  unsigned int v3; // ecx
  int result; // eax

  v3 = a1 + a2;
  result = 0;
  if ( a1 + a2 < a1 || v3 < a2 )
    result = 1;
  *a3 = v3;
  return result;
}


/* ==== 415C7C  ___add_12  ()  size=94 ==== */
int __cdecl __add_12(unsigned int *a1, unsigned int *a2)
{
  if ( __addl(*a1, *a2, a1) && __addl(a1[1], 1u, a1 + 1) )
    ++a1[2];
  if ( __addl(a1[1], a2[1], a1 + 1) )
    ++a1[2];
  return __addl(a1[2], a2[2], a1 + 2);
}


/* ==== 415CDA  ___shl_12  ()  size=46 ==== */
_DWORD *__cdecl __shl_12(_DWORD *a1)
{
  _DWORD *result; // eax
  unsigned int v2; // edi
  int v3; // ecx
  int v4; // esi
  int v5; // ecx

  result = a1;
  v2 = a1[1];
  v3 = *a1 >> 31;
  *a1 *= 2;
  v4 = v3 | (2 * v2);
  v5 = (v2 >> 31) | (2 * a1[2]);
  a1[1] = v4;
  a1[2] = v5;
  return result;
}


/* ==== 415D08  ___shr_12  ()  size=45 ==== */
int *__cdecl __shr_12(int *a1)
{
  int *result; // eax
  unsigned int v2; // edx
  int v3; // edi
  int v4; // ecx

  result = a1;
  v2 = a1[2];
  v3 = a1[1];
  a1[1] = *(__int64 *)(a1 + 1) >> 1;
  v4 = (v3 << 31) | ((unsigned int)*a1 >> 1);
  a1[2] = v2 >> 1;
  *a1 = v4;
  return result;
}


/* ==== 415D35  sub_415D35  ()  size=232 ==== */
__int16 __cdecl sub_415D35(char *a1, int a2, int a3)
{
  unsigned int v3; // eax
  unsigned int v4; // kr00_4
  __int16 result; // ax
  int v6; // [esp+Ch] [ebp-1Ch]
  __int16 v8; // [esp+14h] [ebp-14h]
  unsigned int v9; // [esp+18h] [ebp-10h] BYREF
  int v10; // [esp+1Ch] [ebp-Ch]
  int v11; // [esp+20h] [ebp-8h]

  v8 = 16462;
  *(_DWORD *)a3 = 0;
  *(_DWORD *)(a3 + 4) = 0;
  *(_DWORD *)(a3 + 8) = 0;
  if ( a2 )
  {
    v6 = a2;
    do
    {
      v9 = *(_DWORD *)a3;
      v10 = *(_DWORD *)(a3 + 4);
      v11 = *(_DWORD *)(a3 + 8);
      __shl_12((_DWORD *)a3);
      __shl_12((_DWORD *)a3);
      __add_12((unsigned int *)a3, &v9);
      __shl_12((_DWORD *)a3);
      v3 = *a1;
      v10 = 0;
      v11 = 0;
      v9 = v3;
      __add_12((unsigned int *)a3, &v9);
      ++a1;
      --v6;
    }
    while ( v6 );
  }
  if ( !*(_DWORD *)(a3 + 8) )
  {
    do
    {
      v8 -= 16;
      v4 = *(_DWORD *)(a3 + 4);
      *(_QWORD *)a3 <<= 16;
    }
    while ( is_mul_ok(0x10000u, v4) );
    *(_DWORD *)(a3 + 8) = (unsigned __int64)v4 >> 16;
  }
  while ( (*(_DWORD *)(a3 + 8) & 0x8000) == 0 )
  {
    __shl_12((_DWORD *)a3);
    --v8;
  }
  result = v8;
  *(_WORD *)(a3 + 10) = v8;
  return result;
}


/* ==== 415E1D  sub_415E1D  ()  size=1039 ==== */
int __cdecl sub_415E1D(int a1, char **a2, char *a3, int a4, int a5, int a6, int a7)
{
  int v7; // ecx
  char *v8; // esi
  char *v9; // edi
  char v10; // al
  char v11; // bl
  char *v12; // ecx
  int v13; // esi
  int i; // eax
  int v15; // eax
  int v16; // eax
  __int16 v17; // cx
  int v18; // esi
  unsigned int v19; // edx
  __int16 v20; // ax
  int result; // eax
  int v22; // [esp-8h] [ebp-74h]
  int v23; // [esp-8h] [ebp-74h]
  int v24; // [esp+10h] [ebp-5Ch]
  int v25; // [esp+14h] [ebp-58h]
  int v26; // [esp+18h] [ebp-54h]
  __int16 v27; // [esp+1Ch] [ebp-50h]
  int v28; // [esp+20h] [ebp-4Ch]
  int v29; // [esp+24h] [ebp-48h]
  int v30; // [esp+28h] [ebp-44h]
  char *v31; // [esp+2Ch] [ebp-40h]
  int v32; // [esp+30h] [ebp-3Ch]
  unsigned int v33; // [esp+34h] [ebp-38h]
  char *v34; // [esp+38h] [ebp-34h]
  _WORD v35[3]; // [esp+3Ch] [ebp-30h] BYREF
  unsigned int v36; // [esp+42h] [ebp-2Ah]
  int v37; // [esp+46h] [ebp-26h]
  char v38[23]; // [esp+4Ch] [ebp-20h] BYREF
  char v39; // [esp+63h] [ebp-9h]

  v7 = 0;
  v8 = v38;
  v27 = 0;
  v24 = 1;
  v33 = 0;
  v30 = 0;
  v26 = 0;
  v25 = 0;
  v28 = 0;
  v32 = 0;
  v29 = 0;
  v9 = a3;
  v31 = a3;
  while ( 1 )
  {
    v10 = *v9;
    if ( *v9 != 32 && v10 != 9 && v10 != 10 && v10 != 13 )
      break;
    ++v9;
  }
  while ( 2 )
  {
    v11 = *v9++;
    switch ( v7 )
    {
      case 0:
        if ( v11 >= 49 && v11 <= 57 )
          goto LABEL_10;
        if ( v11 == byte_42D694 )
          goto LABEL_12;
        v7 = 2;
        switch ( v11 )
        {
          case '+':
            v27 = 0;
            continue;
          case '-':
            v27 = 0x8000;
            continue;
          case '0':
            goto LABEL_36;
        }
        --v9;
        goto LABEL_71;
      case 1:
        v7 = 1;
        v30 = 1;
        if ( v11 >= 49 && v11 <= 57 )
          goto LABEL_10;
        if ( v11 == byte_42D694 )
          goto LABEL_22;
        if ( v11 == 43 || v11 == 45 )
          goto LABEL_31;
        if ( v11 == 48 )
          continue;
        goto LABEL_26;
      case 2:
        if ( v11 >= 49 && v11 <= 57 )
        {
LABEL_10:
          v22 = 3;
LABEL_81:
          v7 = v22;
          --v9;
        }
        else
        {
          if ( v11 == byte_42D694 )
          {
LABEL_12:
            v23 = 5;
            goto LABEL_89;
          }
          if ( v11 != 48 )
          {
LABEL_83:
            v9 = v31;
            goto LABEL_71;
          }
LABEL_36:
          v7 = 1;
        }
        continue;
      case 3:
        v30 = 1;
        while ( isdigit((unsigned __int8)v11) )
        {
          if ( v33 >= 0x19 )
          {
            ++v32;
          }
          else
          {
            ++v33;
            *v8++ = v11 - 48;
          }
          v11 = *v9++;
        }
        if ( v11 != byte_42D694 )
          goto LABEL_54;
LABEL_22:
        v23 = 4;
        goto LABEL_89;
      case 4:
        v30 = 1;
        v26 = 1;
        if ( !v33 )
        {
          while ( v11 == 48 )
          {
            --v32;
            v11 = *v9++;
          }
        }
        while ( isdigit((unsigned __int8)v11) )
        {
          if ( v33 < 0x19 )
          {
            ++v33;
            *v8++ = v11 - 48;
            --v32;
          }
          v11 = *v9++;
        }
LABEL_54:
        if ( v11 == 43 || v11 == 45 )
        {
LABEL_31:
          --v9;
          v23 = 11;
        }
        else
        {
LABEL_26:
          if ( v11 <= 67 || v11 > 69 && (v11 <= 99 || v11 > 101) )
          {
LABEL_70:
            --v9;
            goto LABEL_71;
          }
          v23 = 6;
        }
        goto LABEL_89;
      case 5:
        v26 = 1;
        if ( !isdigit((unsigned __int8)v11) )
          goto LABEL_83;
        v22 = 4;
        goto LABEL_81;
      case 6:
        v12 = v9 - 2;
        v31 = v9 - 2;
        if ( v11 >= 49 && v11 <= 57 )
          goto LABEL_80;
        if ( v11 == 43 )
          goto LABEL_88;
        if ( v11 == 45 )
          goto LABEL_87;
        if ( v11 != 48 )
          goto LABEL_93;
LABEL_64:
        v23 = 8;
        goto LABEL_89;
      case 7:
        if ( v11 >= 49 && v11 <= 57 )
          goto LABEL_80;
        if ( v11 != 48 )
          goto LABEL_83;
        goto LABEL_64;
      case 8:
        v25 = 1;
        while ( v11 == 48 )
          v11 = *v9++;
        if ( v11 < 49 || v11 > 57 )
          goto LABEL_70;
LABEL_80:
        v22 = 9;
        goto LABEL_81;
      case 9:
        v34 = v8;
        v25 = 1;
        v13 = 0;
        while ( 2 )
        {
          if ( isdigit((unsigned __int8)v11) )
          {
            v13 = v11 + 10 * v13 - 48;
            if ( v13 <= 5200 )
            {
              v11 = *v9++;
              continue;
            }
            v13 = 5201;
          }
          break;
        }
        v28 = v13;
        for ( i = (unsigned __int8)v11; isdigit(i); i = (unsigned __int8)i )
          LOBYTE(i) = *v9++;
        v8 = v34;
        --v9;
        goto LABEL_71;
      case 11:
        if ( !a7 )
        {
          v7 = 10;
          --v9;
LABEL_91:
          if ( v7 == 10 )
            goto LABEL_71;
          continue;
        }
        v12 = v9 - 1;
        v31 = v9 - 1;
        if ( v11 == 43 )
        {
LABEL_88:
          v23 = 7;
LABEL_89:
          v7 = v23;
          continue;
        }
        if ( v11 == 45 )
        {
LABEL_87:
          v24 = -1;
          v7 = 7;
          continue;
        }
LABEL_93:
        v9 = v12;
LABEL_71:
        *a2 = v9;
        if ( !v30 )
        {
          v29 = 4;
LABEL_118:
          v17 = 0;
          v20 = 0;
          v19 = 0;
          v18 = 0;
          goto LABEL_119;
        }
        if ( v33 > 0x18 )
        {
          if ( v39 >= 5 )
            ++v39;
          --v8;
          ++v32;
          v33 = 24;
        }
        if ( !v33 )
          goto LABEL_118;
        while ( !*--v8 )
        {
          --v33;
          ++v32;
        }
        sub_415D35(v38, v33, (int)v35);
        v15 = v28;
        if ( v24 < 0 )
          v15 = -v28;
        v16 = v32 + v15;
        if ( !v25 )
          v16 += a5;
        if ( !v26 )
          v16 -= a6;
        if ( v16 > 5200 )
        {
          v18 = 0;
          v20 = 0x7FFF;
          v19 = 0x80000000;
          v17 = 0;
          v29 = 2;
          goto LABEL_119;
        }
        if ( v16 < -5200 )
        {
          v29 = 1;
          goto LABEL_118;
        }
        sub_416E33(v35, v16, a4);
        v17 = v35[0];
        v18 = *(_DWORD *)&v35[1];
        v19 = v36;
        v20 = v37;
LABEL_119:
        *(_WORD *)a1 = v17;
        *(_DWORD *)(a1 + 2) = v18;
        *(_WORD *)(a1 + 10) = v27 | v20;
        result = v29;
        *(_DWORD *)(a1 + 6) = v19;
        return result;
      default:
        goto LABEL_91;
    }
  }
}


/* ==== 41625D  sub_41625D  ()  size=668 ==== */
int __cdecl sub_41625D(__int64 a1, __int16 a2, int a3, char a4, int a5)
{
  unsigned __int16 v5; // dx
  int v6; // edi
  int v7; // esi
  int v8; // edi
  int v9; // esi
  int i; // esi
  _BYTE *v11; // eax
  _BYTE *v12; // ecx
  bool v13; // zf
  char *v14; // eax
  char v15; // cl
  char *v16; // eax
  bool v17; // cc
  char *v18; // ecx
  char v19; // al
  int v21; // [esp+Ch] [ebp-34h]
  int v22; // [esp+10h] [ebp-30h]
  int v23; // [esp+14h] [ebp-2Ch]
  _BYTE *v24; // [esp+14h] [ebp-2Ch]
  __int64 v25; // [esp+18h] [ebp-28h] BYREF
  int v26; // [esp+20h] [ebp-20h]
  _BYTE v27[12]; // [esp+24h] [ebp-1Ch] BYREF
  _BYTE v28[12]; // [esp+30h] [ebp-10h] BYREF

  v25 = a1;
  LOWORD(v26) = a2;
  memset(v27, 204, 10);
  v27[10] = -5;
  v27[11] = 63;
  v22 = 1;
  v5 = a2 & 0x7FFF;
  if ( a2 >= 0 )
    *(_BYTE *)(a5 + 2) = 32;
  else
    *(_BYTE *)(a5 + 2) = 45;
  v6 = HIDWORD(v25);
  if ( v5 || v25 )
  {
    if ( v5 == 0x7FFF )
    {
      *(_WORD *)a5 = 1;
      if ( (v6 != 0x80000000 || (_DWORD)v25) && (v6 & 0x40000000) == 0 )
      {
        strcpy((char *)(a5 + 4), "1#SNAN");
LABEL_21:
        *(_BYTE *)(a5 + 3) = 6;
        return 0;
      }
      if ( a2 < 0 && v6 == -1073741824 )
      {
        if ( !(_DWORD)v25 )
        {
          strcpy((char *)(a5 + 4), "1#IND");
LABEL_18:
          *(_BYTE *)(a5 + 3) = 5;
          return 0;
        }
      }
      else if ( v6 == 0x80000000 && !(_DWORD)v25 )
      {
        strcpy((char *)(a5 + 4), "1#INF");
        goto LABEL_18;
      }
      strcpy((char *)(a5 + 4), "1#QNAN");
      goto LABEL_21;
    }
    *(_WORD *)v28 = 0;
    *(_QWORD *)&v28[2] = v25;
    v7 = (77 * (HIBYTE(v5) + 2 * HIBYTE(HIDWORD(v25))) + 19728 * v5 - 323162868) >> 16;
    *(_WORD *)&v28[10] = a2 & 0x7FFF;
    sub_416E33(v28, -(__int16)v7, 1);
    if ( *(_WORD *)&v28[10] >= 0x3FFFu )
    {
      LOWORD(v7) = v7 + 1;
      sub_416BFD(v28, v27);
    }
    v8 = a3;
    *(_WORD *)a5 = v7;
    if ( (a4 & 1) == 0 || (v8 = (__int16)v7 + a3, v8 > 0) )
    {
      if ( v8 > 21 )
        v8 = 21;
      v9 = *(unsigned __int16 *)&v28[10] - 16382;
      *(_WORD *)&v28[10] = 0;
      v23 = 8;
      do
      {
        __shl_12(v28);
        --v23;
      }
      while ( v23 );
      if ( v9 < 0 )
      {
        for ( i = (unsigned __int8)-(char)v9; i; --i )
          __shr_12((int *)v28);
      }
      v11 = (_BYTE *)(a5 + 4);
      v24 = (_BYTE *)(a5 + 4);
      if ( v8 + 1 > 0 )
      {
        v21 = v8 + 1;
        do
        {
          v25 = *(_QWORD *)v28;
          v26 = *(_DWORD *)&v28[8];
          __shl_12(v28);
          __shl_12(v28);
          __add_12((unsigned int *)v28, (unsigned int *)&v25);
          __shl_12(v28);
          v12 = v24++;
          v13 = v21-- == 1;
          *v12 = v28[11] + 48;
          v28[11] = 0;
        }
        while ( !v13 );
        v11 = v24;
      }
      v14 = v11 - 1;
      v15 = *v14;
      v16 = v14 - 1;
      v17 = v15 < 53;
      v18 = (char *)(a5 + 4);
      if ( v17 )
      {
        while ( v16 >= v18 && *v16 == 48 )
          --v16;
        if ( v16 < v18 )
        {
          *v18 = 48;
          goto LABEL_53;
        }
      }
      else
      {
        while ( v16 >= v18 && *v16 == 57 )
          *v16-- = 48;
        if ( v16 < v18 )
        {
          ++v16;
          ++*(_WORD *)a5;
        }
        ++*v16;
      }
      v19 = (_BYTE)v16 - a5 - 3;
      *(_BYTE *)(a5 + 3) = v19;
      *(_BYTE *)(v19 + a5 + 4) = 0;
      return v22;
    }
  }
  *(_BYTE *)(a5 + 4) = 48;
LABEL_53:
  *(_WORD *)a5 = 0;
  *(_BYTE *)(a5 + 2) = 32;
  *(_BYTE *)(a5 + 3) = 1;
  *(_BYTE *)(a5 + 5) = 0;
  return 1;
}


/* ==== 4164F9  _strncnt  ()  size=28 ==== */
int __usercall strncnt@<eax>(_BYTE *a1@<eax>, int a2)
{
  int v2; // ecx

  v2 = a2;
  if ( a2 )
  {
    while ( 1 )
    {
      --v2;
      if ( !*a1 )
        break;
      ++a1;
      if ( !v2 )
        goto LABEL_4;
    }
  }
  else
  {
LABEL_4:
    --v2;
  }
  return a2 - v2 - 1;
}


/* ==== 416515  sub_416515  ()  size=906 ==== */
int __cdecl sub_416515(
        int Locale,
        DWORD dwCmpFlags,
        CHAR *lpMultiByteStr,
        int cbMultiByte,
        const CHAR *a5,
        int cchCount2,
        UINT CodePage)
{
  CHAR *v7; // ebx
  void *v8; // edi
  int v9; // eax
  BYTE *LeadByte; // eax
  unsigned __int8 v12; // dl
  BYTE *i; // eax
  unsigned __int8 v14; // dl
  int v15; // ebx
  void *v16; // esp
  WCHAR *v17; // eax
  int v18; // esi
  void *v19; // esp
  WCHAR *v20; // edi
  UINT v21; // ebx
  UINT v22; // eax
  UINT v23; // esi
  int v24; // esi
  _DWORD v26[5]; // [esp+0h] [ebp-64h] BYREF
  int v27; // [esp+14h] [ebp-50h]
  int v28; // [esp+18h] [ebp-4Ch]
  int v29; // [esp+1Ch] [ebp-48h]
  int v30; // [esp+20h] [ebp-44h]
  void *Block; // [esp+24h] [ebp-40h]
  PCNZCH lpString1; // [esp+28h] [ebp-3Ch]
  LPWSTR lpWideCharStr; // [esp+2Ch] [ebp-38h]
  LPCCH lpString2; // [esp+30h] [ebp-34h]
  struct _cpinfo CPInfo; // [esp+34h] [ebp-30h] BYREF
  CPPEH_RECORD ms_exc; // [esp+4Ch] [ebp-18h]

  lpString1 = lpMultiByteStr;
  v7 = (CHAR *)a5;
  lpString2 = a5;
  v8 = 0;
  if ( !dword_430598 )
  {
    if ( CompareStringW(0, 0, &String1, 1, &String1, 1) )
    {
      dword_430598 = 1;
    }
    else if ( GetLastError() == 120 )
    {
      dword_430598 = 2;
    }
  }
  if ( cbMultiByte > 0 )
    cbMultiByte = strncnt(lpMultiByteStr, cbMultiByte);
  v9 = cchCount2;
  if ( cchCount2 > 0 )
  {
    v9 = strncnt(v7, cchCount2);
    cchCount2 = v9;
  }
  if ( dword_430598 == 2 || !dword_430598 )
  {
    Block = 0;
    if ( !Locale )
      Locale = dword_4304F0;
    v21 = CodePage;
    if ( !CodePage )
      v21 = dword_430500;
    v22 = sub_415670(Locale);
    v23 = v22;
    if ( v22 == -1 )
      return 0;
    if ( v22 != v21 )
    {
      v8 = sub_4156B7(v21, v22, (char *)lpString1, &cbMultiByte, 0, 0);
      if ( !v8 )
        return 0;
      Block = sub_4156B7(v21, v23, (char *)lpString2, &cchCount2, 0, 0);
      if ( !Block )
      {
        free(v8);
        return 0;
      }
      lpString1 = (PCNZCH)v8;
      lpString2 = (LPCCH)Block;
    }
    v24 = CompareStringA(Locale, dwCmpFlags, lpString1, cbMultiByte, lpString2, cchCount2);
    if ( v8 )
    {
      free(v8);
      free(Block);
    }
    return v24;
  }
  if ( dword_430598 != 1 )
    return 0;
  v27 = 0;
  v30 = 0;
  v29 = 0;
  if ( !CodePage )
    CodePage = dword_430500;
  if ( cbMultiByte && v9 )
    goto LABEL_41;
  if ( cbMultiByte == v9 )
    return 2;
  if ( v9 > 1 )
    return 1;
  if ( cbMultiByte > 1 )
    return 3;
  if ( !GetCPInfo(CodePage, &CPInfo) )
    return 0;
  if ( cbMultiByte > 0 )
  {
    if ( CPInfo.MaxCharSize >= 2 )
    {
      LeadByte = CPInfo.LeadByte;
      if ( CPInfo.LeadByte[0] )
      {
        while ( 1 )
        {
          v12 = LeadByte[1];
          if ( !v12 )
            break;
          if ( (unsigned __int8)*lpMultiByteStr >= *LeadByte && (unsigned __int8)*lpMultiByteStr <= v12 )
            return 2;
          LeadByte += 2;
          if ( !*LeadByte )
            return 3;
        }
      }
    }
    return 3;
  }
  if ( cchCount2 <= 0 )
  {
LABEL_41:
    v15 = MultiByteToWideChar(CodePage, 9u, lpMultiByteStr, cbMultiByte, 0, 0);
    v28 = v15;
    if ( v15 )
    {
      v16 = alloca(2 * v15);
      ms_exc.old_esp = (DWORD)v26;
      lpWideCharStr = (LPWSTR)v26;
      ms_exc.registration.TryLevel = -1;
      v17 = (WCHAR *)v26;
      if ( v26 )
      {
LABEL_45:
        if ( MultiByteToWideChar(CodePage, 1u, lpMultiByteStr, cbMultiByte, v17, v15) )
        {
          v18 = MultiByteToWideChar(CodePage, 9u, lpString2, cchCount2, 0, 0);
          v26[4] = v18;
          if ( v18 )
          {
            v19 = alloca(2 * v18);
            ms_exc.old_esp = (DWORD)v26;
            v20 = (WCHAR *)v26;
            v26[3] = v26;
            ms_exc.registration.TryLevel = -1;
            if ( v26 )
            {
LABEL_50:
              if ( MultiByteToWideChar(CodePage, 1u, lpString2, cchCount2, v20, v18) )
                v29 = CompareStringW(Locale, dwCmpFlags, lpWideCharStr, v15, v20, v18);
              if ( v30 )
                free(v20);
              goto LABEL_54;
            }
            v20 = (WCHAR *)malloc(2 * v18);
            if ( v20 )
            {
              v30 = 1;
              goto LABEL_50;
            }
          }
        }
LABEL_54:
        if ( v27 )
          free(lpWideCharStr);
        return v29;
      }
      v17 = (WCHAR *)malloc(2 * v15);
      lpWideCharStr = v17;
      if ( v17 )
      {
        v27 = 1;
        goto LABEL_45;
      }
    }
    return 0;
  }
  if ( CPInfo.MaxCharSize >= 2 )
  {
    for ( i = CPInfo.LeadByte; *i; i += 2 )
    {
      v14 = i[1];
      if ( !v14 )
        break;
      if ( (unsigned __int8)*v7 >= *i && (unsigned __int8)*v7 <= v14 )
        return 2;
    }
  }
  return 1;
}


/* ==== 41689F  _findenv  ()  size=77 ==== */
int __usercall findenv@<eax>(size_t a1@<edi>, unsigned __int8 *Str1)
{
  const unsigned __int8 **i; // esi
  unsigned __int8 v3; // al

  for ( i = (const unsigned __int8 **)dword_430108; ; ++i )
  {
    if ( !*i )
      return -(((char *)i - (_BYTE *)dword_430108) >> 2);
    if ( !_mbsnbicoll(Str1, *i, a1) )
    {
      v3 = (*i)[a1];
      if ( v3 == 61 || !v3 )
        break;
    }
  }
  return ((char *)i - (_BYTE *)dword_430108) >> 2;
}


/* ==== 4168EC  _copy_environ  ()  size=97 ==== */
char **__usercall copy_environ@<eax>(char **a1@<edi>)
{
  int v1; // ecx
  char **result; // eax
  char **v3; // esi
  const char *v4; // eax
  const char **v5; // ebx
  char **v6; // [esp+0h] [ebp-4h]

  v1 = 0;
  result = a1;
  if ( a1 )
  {
    if ( *a1 )
    {
      do
      {
        ++result;
        ++v1;
      }
      while ( *result );
    }
    v3 = (char **)malloc(4 * v1 + 4);
    v6 = v3;
    if ( !v3 )
      _amsg_exit(9);
    v4 = *a1;
    v5 = (const char **)a1;
    while ( v4 )
    {
      *v3++ = _strdup(v4);
      v4 = *++v5;
    }
    *v3 = 0;
    return v6;
  }
  return result;
}


/* ==== 41694D  sub_41694D  ()  size=470 ==== */
int __cdecl sub_41694D(unsigned __int8 **a1, int a2)
{
  unsigned __int8 *v3; // esi
  unsigned __int8 *v4; // eax
  bool v5; // zf
  char **v6; // eax
  _DWORD *v7; // eax
  _DWORD *v8; // eax
  _DWORD *v9; // ebx
  int v10; // eax
  int v11; // edi
  unsigned __int8 **v12; // esi
  char *v13; // eax
  unsigned __int8 **v14; // ecx
  size_t v15; // eax
  char *v16; // eax
  CHAR *v17; // edi
  unsigned __int8 *v18; // eax
  int v19; // [esp+8h] [ebp-10h]
  unsigned __int8 *v20; // [esp+Ch] [ebp-Ch]
  unsigned __int8 *Block; // [esp+10h] [ebp-8h]
  BOOL v22; // [esp+14h] [ebp-4h]

  v19 = 0;
  if ( !a1 )
    return -1;
  v3 = *a1;
  Block = *a1;
  if ( !*a1 )
    return -1;
  v4 = _mbschr(v3, 0x3Du);
  v20 = v4;
  if ( !v4 || v3 == v4 )
    return -1;
  v5 = v4[1] == 0;
  v6 = (char **)dword_430108;
  v22 = v5;
  if ( dword_430108 == (void *)dword_43010C )
  {
    v6 = copy_environ((char **)dword_430108);
    dword_430108 = v6;
  }
  if ( !v6 )
  {
    if ( a2 && dword_430110 )
    {
      if ( __wtomb_environ() )
        return -1;
    }
    else
    {
      if ( v22 )
        return 0;
      v7 = malloc(4u);
      dword_430108 = v7;
      if ( !v7 )
        return -1;
      *v7 = 0;
      if ( !dword_430110 )
      {
        v8 = malloc(4u);
        dword_430110 = (int)v8;
        if ( !v8 )
          return -1;
        *v8 = 0;
      }
    }
  }
  v9 = dword_430108;
  v10 = findenv(v20 - v3, v3);
  v11 = v10;
  if ( v10 < 0 || !*v9 )
  {
    if ( !v22 )
    {
      if ( v10 < 0 )
        v11 = -v10;
      v13 = (char *)sub_40C034(dword_430108, 4 * v11 + 8);
      if ( !v13 )
        return -1;
      v14 = (unsigned __int8 **)&v13[4 * v11];
      v14[1] = 0;
      *v14 = v3;
      *a1 = 0;
      goto LABEL_33;
    }
    free(v3);
    *a1 = 0;
    return 0;
  }
  v12 = (unsigned __int8 **)&v9[v10];
  free(*v12);
  if ( !v22 )
  {
    *v12 = Block;
    v3 = Block;
    *a1 = 0;
    goto LABEL_34;
  }
  while ( *v12 )
  {
    ++v11;
    *v12 = v12[1];
    v12 = (unsigned __int8 **)&v9[v11];
  }
  v13 = (char *)sub_40C034(dword_430108, 4 * v11);
  v3 = Block;
  if ( !v13 )
    goto LABEL_34;
LABEL_33:
  dword_430108 = v13;
LABEL_34:
  if ( a2 )
  {
    v15 = strlen((const char *)v3);
    v16 = (char *)malloc(v15 + 2);
    v17 = v16;
    if ( v16 )
    {
      strcpy(v16, (const char *)v3);
      v18 = &v20[v17 - (CHAR *)v3];
      *v18 = 0;
      if ( !SetEnvironmentVariableA(v17, !v22 ? (LPCSTR)v18 + 1 : 0) )
        v19 = -1;
      free(v17);
    }
  }
  if ( v22 )
    free(v3);
  return v19;
}


/* ==== 416B30  ___ascii_strnicmp  ()  size=97 ==== */
int __cdecl __ascii_strnicmp(unsigned __int8 *a1, unsigned __int8 *a2, int a3)
{
  int v3; // ecx
  unsigned __int8 v6; // ah
  unsigned __int8 v7; // al
  bool v8; // cf

  v3 = a3;
  if ( a3 )
  {
    do
    {
      v6 = *a1;
      v7 = *a2;
      if ( !*a1 || !v7 )
        break;
      ++a1;
      ++a2;
      if ( v6 >= 0x41u && v6 <= 0x5Au )
        v6 += 32;
      if ( v7 >= 0x41u && v7 <= 0x5Au )
        v7 += 32;
      v8 = v6 < v7;
      if ( v6 != v7 )
        goto differ;
      --v3;
    }
    while ( v3 );
    v3 = 0;
    v8 = v6 < v7;
    if ( v6 == v7 )
      return v3;
differ:
    v3 = -1;
    if ( !v8 )
      return 1;
  }
  return v3;
}


/* ==== 416B91  __setmode_lk  ()  size=108 ==== */
int __cdecl _setmode_lk(int a1, int a2)
{
  int v2; // ecx
  int v3; // eax

  v2 = 36 * (a1 & 0x1F);
  v3 = *(_BYTE *)(dword_430620[a1 >> 5] + v2 + 4) & 0x80;
  if ( a2 == 0x8000 )
  {
    *(_BYTE *)(dword_430620[a1 >> 5] + v2 + 4) &= ~0x80u;
    return v3 != 0 ? 0x4000 : 0x8000;
  }
  if ( a2 == 0x4000 )
  {
    *(_BYTE *)(dword_430620[a1 >> 5] + v2 + 4) |= 0x80u;
    return v3 != 0 ? 0x4000 : 0x8000;
  }
  *_errno() = 22;
  return -1;
}


/* ==== 416BFD  sub_416BFD  ()  size=566 ==== */
int __cdecl sub_416BFD(int a1, int a2)
{
  __int16 v2; // cx
  __int16 v3; // ax
  __int16 v4; // di
  int v5; // ecx
  __int16 v6; // di
  int result; // eax
  int v8; // edi
  unsigned __int16 v9; // dx
  int v10; // ebx
  int v11; // [esp+Ch] [ebp-30h]
  int v12; // [esp+10h] [ebp-2Ch]
  unsigned __int16 *v13; // [esp+14h] [ebp-28h]
  int v14; // [esp+18h] [ebp-24h]
  unsigned __int16 *v15; // [esp+1Ch] [ebp-20h]
  int *v16; // [esp+20h] [ebp-1Ch]
  int i; // [esp+24h] [ebp-18h]
  int v18; // [esp+28h] [ebp-14h]
  int v19; // [esp+28h] [ebp-14h]
  int v20[3]; // [esp+2Ch] [ebp-10h] BYREF

  v2 = *(_WORD *)(a2 + 10);
  v14 = 0;
  memset(v20, 0, sizeof(v20));
  v3 = *(_WORD *)(a1 + 10);
  v4 = v2;
  v5 = v2 & 0x7FFF;
  v6 = v3 ^ v4;
  result = v3 & 0x7FFF;
  v8 = v6 & 0x8000;
  v9 = v5 + result;
  v18 = v5 + result;
  if ( (unsigned __int16)result < 0x7FFFu && (unsigned __int16)v5 < 0x7FFFu && v9 <= 0xBFFDu )
  {
    if ( v9 <= 0x3FBFu )
    {
      result = 0;
LABEL_16:
      *(_DWORD *)(a1 + 8) = 0;
      *(_DWORD *)(a1 + 4) = 0;
      *(_DWORD *)a1 = 0;
      return result;
    }
    if ( (_WORD)result )
    {
      result = 0;
    }
    else
    {
      ++v18;
      result = 0;
      if ( (*(_DWORD *)(a1 + 8) & 0x7FFFFFFF) == 0 && !*(_DWORD *)(a1 + 4) && !*(_DWORD *)a1 )
        goto LABEL_45;
    }
    if ( !(_WORD)v5 )
    {
      ++v18;
      if ( (*(_DWORD *)(a2 + 8) & 0x7FFFFFFF) == 0 && !*(_DWORD *)(a2 + 4) && !*(_DWORD *)a2 )
        goto LABEL_16;
    }
    v12 = 0;
    v16 = &v20[1];
    for ( i = 5; i > 0; --i )
    {
      v13 = (unsigned __int16 *)(a1 + 2 * v12);
      v15 = (unsigned __int16 *)(a2 + 8);
      v11 = i;
      do
      {
        if ( __addl(*(v16 - 1), *v13 * *v15, (unsigned int *)v16 - 1) )
          ++*(_WORD *)v16;
        ++v13;
        --v15;
        --v11;
      }
      while ( v11 );
      v16 = (int *)((char *)v16 + 2);
      ++v12;
    }
    v19 = v18 + 49154;
    if ( (__int16)v19 <= 0 )
      goto LABEL_49;
    do
    {
      if ( v20[2] < 0 )
        break;
      __shl_12(v20);
      v19 += 0xFFFF;
    }
    while ( (__int16)v19 > 0 );
    if ( (__int16)v19 <= 0 )
    {
LABEL_49:
      v19 += 0xFFFF;
      if ( (v19 & 0x8000u) != 0 )
      {
        v10 = (unsigned __int16)-(__int16)v19;
        v19 += v10;
        do
        {
          if ( (v20[0] & 1) != 0 )
            ++v14;
          __shr_12(v20);
          --v10;
        }
        while ( v10 );
        if ( v14 )
          LOBYTE(v20[0]) |= 1u;
      }
    }
    if ( LOWORD(v20[0]) > 0x8000u || (v20[0] & 0x1FFFF) == 0x18000 )
    {
      if ( *(int *)((char *)v20 + 2) == -1 )
      {
        *(int *)((char *)v20 + 2) = 0;
        if ( *(int *)((char *)&v20[1] + 2) == -1 )
        {
          *(int *)((char *)&v20[1] + 2) = 0;
          if ( HIWORD(v20[2]) == 0xFFFF )
          {
            ++v19;
            HIWORD(v20[2]) = 0x8000;
          }
          else
          {
            ++HIWORD(v20[2]);
          }
        }
        else
        {
          ++*(int *)((char *)&v20[1] + 2);
        }
      }
      else
      {
        ++*(int *)((char *)v20 + 2);
      }
    }
    result = v19;
    if ( (unsigned __int16)v19 < 0x7FFFu )
    {
      *(_WORD *)a1 = HIWORD(v20[0]);
      *(_DWORD *)(a1 + 2) = v20[1];
      *(_DWORD *)(a1 + 6) = v20[2];
      result = v8 | v19;
LABEL_45:
      *(_WORD *)(a1 + 10) = result;
      return result;
    }
  }
  *(_DWORD *)(a1 + 4) = 0;
  *(_DWORD *)a1 = 0;
  *(_DWORD *)(a1 + 8) = (_WORD)v8 != 0 ? -32768 : 2147450880;
  return result;
}


/* ==== 416E33  sub_416E33  ()  size=142 ==== */
uintptr_t __cdecl sub_416E33(_WORD *a1, int a2, int a3)
{
  uintptr_t result; // eax
  int v4; // ecx
  char *v5; // ebx
  char v6; // al
  char *v7; // esi
  _DWORD *v8; // esi
  __int64 v9; // [esp+8h] [ebp-10h] BYREF
  int v10; // [esp+10h] [ebp-8h]

  result = __security_cookie;
  v4 = (int)a1;
  v5 = (char *)&unk_42D6D0 - 96;
  if ( a2 )
  {
    if ( a2 < 0 )
    {
      a2 = -a2;
      v5 = (char *)&unk_42D830 - 96;
    }
    if ( !a3 )
      *a1 = 0;
    while ( a2 )
    {
      v6 = a2;
      a2 >>= 3;
      result = v6 & 7;
      v5 += 84;
      if ( result )
      {
        v7 = &v5[12 * result];
        if ( *(_WORD *)v7 >= 0x8000u )
        {
          LODWORD(v9) = *(_DWORD *)v7;
          v8 = v7 + 4;
          HIDWORD(v9) = *v8;
          v10 = v8[1];
          --*(_DWORD *)((char *)&v9 + 2);
          v7 = (char *)&v9;
        }
        result = sub_416BFD(v4, (int)v7);
        v4 = (int)a1;
      }
    }
  }
  return result;
}


/* ==== 416EC2  RtlUnwind  ()  size=6 ==== */
// attributes: thunk
void __stdcall RtlUnwind(PVOID TargetFrame, PVOID TargetIp, PEXCEPTION_RECORD ExceptionRecord, PVOID ReturnValue)
{
  __imp_RtlUnwind(TargetFrame, TargetIp, ExceptionRecord, ReturnValue);
}


/* ==== 416EC8  ClosePrinter  ()  size=6 ==== */
// attributes: thunk
BOOL __stdcall ClosePrinter(HANDLE hPrinter)
{
  return __imp_ClosePrinter(hPrinter);
}


/* ==== 416ECE  DocumentPropertiesA  ()  size=6 ==== */
// attributes: thunk
LONG __stdcall DocumentPropertiesA(
        HWND hWnd,
        HANDLE hPrinter,
        LPSTR pDeviceName,
        PDEVMODEA pDevModeOutput,
        PDEVMODEA pDevModeInput,
        DWORD fMode)
{
  return __imp_DocumentPropertiesA(hWnd, hPrinter, pDeviceName, pDevModeOutput, pDevModeInput, fMode);
}


/* ==== 416ED4  OpenPrinterA  ()  size=6 ==== */
// attributes: thunk
BOOL __stdcall OpenPrinterA(LPSTR pPrinterName, LPHANDLE phPrinter, LPPRINTER_DEFAULTSA pDefault)
{
  return __imp_OpenPrinterA(pPrinterName, phPrinter, pDefault);
}


/* ==== 416EF7  sub_416EF7  ()  size=26 ==== */
_DWORD *__thiscall sub_416EF7(_DWORD *this)
{
  ATL::CComCriticalSection::CComCriticalSection((ATL::CComCriticalSection *)(this + 6));
  this[12] = 0;
  this[13] = 0;
  this[14] = 0;
  return this;
}


/* ==== 416F27  sub_416F27  ()  size=175 ==== */
int __thiscall sub_416F27(int this)
{
  struct _OSVERSIONINFOA VersionInformation; // [esp+4h] [ebp-20h] BYREF

  sub_416EF7((_DWORD *)this);
  *(_DWORD *)(this + 8) = &_ImageBase;
  *(_DWORD *)(this + 4) = &_ImageBase;
  *(_DWORD *)this = 60;
  *(_BYTE *)(this + 12) = 0;
  memset(&VersionInformation, 0, sizeof(VersionInformation));
  VersionInformation.dwOSVersionInfoSize = 148;
  GetVersionExA(&VersionInformation);
  if ( VersionInformation.dwPlatformId == 2 )
  {
    if ( VersionInformation.dwMajorVersion < 5 )
      goto LABEL_9;
    goto LABEL_8;
  }
  if ( VersionInformation.dwPlatformId == 1
    && (VersionInformation.dwMajorVersion > 4
     || VersionInformation.dwMajorVersion == 4 && VersionInformation.dwMinorVersion) )
  {
LABEL_8:
    *(_BYTE *)(this + 12) = 1;
  }
LABEL_9:
  *(_DWORD *)(this + 16) = 1808;
  *(_DWORD *)(this + 20) = &unk_4282A8;
  if ( ATL::CComCriticalSection::Init((struct _RTL_CRITICAL_SECTION *)(this + 24)) < 0 )
    byte_42DA28 = 1;
  return this;
}


/* ==== 416FF1  CreateStdAccessibleObject  ()  size=6 ==== */
// attributes: thunk
HRESULT __stdcall CreateStdAccessibleObject(HWND hwnd, LONG idObject, const IID *const riid, void **ppvObject)
{
  return __imp_CreateStdAccessibleObject(hwnd, idObject, riid, ppvObject);
}


/* ==== 417001  LresultFromObject  ()  size=6 ==== */
// attributes: thunk
LONG_PTR __stdcall LresultFromObject(const IID *const riid, WPARAM wParam, LPUNKNOWN punk)
{
  return __imp_LresultFromObject(riid, wParam, punk);
}


/* ==== 417007  sub_417007  ()  size=579 ==== */
FARPROC __stdcall sub_417007(ULONG_PTR a1, char *Arguments)
{
  _DWORD *v2; // esi
  int v3; // ebx
  char *v4; // edi
  const CHAR *v5; // ecx
  char *v6; // ebx
  char *v7; // edx
  bool v8; // zf
  HMODULE LibraryA; // edi
  int v11; // edx
  FARPROC ProcAddress; // ebx
  _DWORD *v13; // eax
  _DWORD *v14; // eax
  _DWORD v15[3]; // [esp+Ch] [ebp-44h] BYREF
  LPCSTR lpLibFileName; // [esp+18h] [ebp-38h]
  BOOL v17; // [esp+1Ch] [ebp-34h]
  LPCSTR lpProcName; // [esp+20h] [ebp-30h]
  HMODULE v19; // [esp+24h] [ebp-2Ch]
  int (__stdcall *v20)(); // [esp+28h] [ebp-28h]
  DWORD LastError; // [esp+2Ch] [ebp-24h]
  volatile LONG *Target; // [esp+38h] [ebp-18h]
  char *v23; // [esp+44h] [ebp-Ch]
  int v24; // [esp+4Ch] [ebp-4h]

  v2 = (_DWORD *)a1;
  v3 = *(_DWORD *)(a1 + 12);
  v4 = (char *)&_ImageBase + *(_DWORD *)(a1 + 20);
  v5 = (char *)&_ImageBase + *(_DWORD *)(a1 + 4);
  Target = (volatile LONG *)((char *)&_ImageBase + *(_DWORD *)(a1 + 8));
  v6 = (char *)&_ImageBase + v3;
  v7 = (char *)&_ImageBase + *(_DWORD *)(a1 + 16);
  v24 = *(_DWORD *)(a1 + 28);
  lpLibFileName = v5;
  v23 = v4;
  v15[2] = Arguments;
  v8 = (*(_DWORD *)a1 & 1) == 0;
  v15[0] = 36;
  v15[1] = a1;
  v17 = 0;
  lpProcName = 0;
  v19 = 0;
  v20 = 0;
  LastError = 0;
  if ( v8 )
  {
    Arguments = (char *)v15;
    RaiseException(0xC06D0057, 0, 1u, (const ULONG_PTR *)&Arguments);
    return 0;
  }
  LibraryA = (HMODULE)*Target;
  v11 = *(_DWORD *)&v7[4 * ((Arguments - v6) >> 2)];
  a1 = 4 * ((Arguments - v6) >> 2);
  v17 = v11 >= 0;
  if ( v11 < 0 )
    lpProcName = (LPCSTR)(unsigned __int16)v11;
  else
    lpProcName = (char *)&word_400002 + v11;
  ProcAddress = 0;
  if ( !dword_4305EC || (ProcAddress = (FARPROC)dword_4305EC(0, v15)) == 0 )
  {
    if ( !LibraryA )
    {
      if ( !dword_4305EC || (LibraryA = (HMODULE)dword_4305EC(1, v15)) == 0 )
      {
        LibraryA = LoadLibraryA(lpLibFileName);
        if ( !LibraryA )
        {
          LastError = GetLastError();
          if ( !dword_4305E8 || (LibraryA = (HMODULE)dword_4305E8(3, v15)) == 0 )
          {
            Arguments = (char *)v15;
            RaiseException(0xC06D007E, 0, 1u, (const ULONG_PTR *)&Arguments);
            return v20;
          }
        }
      }
      if ( (HMODULE)InterlockedExchange(Target, (LONG)LibraryA) == LibraryA )
      {
        FreeLibrary(LibraryA);
      }
      else if ( v2[6] )
      {
        v13 = LocalAlloc(0x40u, 8u);
        if ( v13 )
        {
          v13[1] = v2;
          *v13 = dword_4305E4;
          dword_4305E4 = (int)v13;
        }
      }
    }
    v19 = LibraryA;
    if ( dword_4305EC )
      ProcAddress = (FARPROC)dword_4305EC(2, v15);
    if ( !ProcAddress )
    {
      if ( !v2[5]
        || !v2[7]
        || (v14 = (_DWORD *)((char *)LibraryA + *((_DWORD *)LibraryA + 15)), *v14 != 17744)
        || v14[2] != v24
        || LibraryA != (HMODULE)v14[13]
        || (ProcAddress = *(FARPROC *)&v23[a1]) == 0 )
      {
        ProcAddress = GetProcAddress(LibraryA, lpProcName);
        if ( !ProcAddress )
        {
          LastError = GetLastError();
          if ( dword_4305E8 )
            ProcAddress = (FARPROC)dword_4305E8(4, v15);
          if ( !ProcAddress )
          {
            a1 = (ULONG_PTR)v15;
            RaiseException(0xC06D007F, 0, 1u, &a1);
            ProcAddress = v20;
          }
        }
      }
    }
    *(_DWORD *)Arguments = ProcAddress;
  }
  if ( dword_4305EC )
  {
    LastError = 0;
    v19 = LibraryA;
    v20 = ProcAddress;
    dword_4305EC(5, v15);
  }
  return ProcAddress;
}


/* ==== 41724A  _WinMain@16  (WinMain(x,x,x,x))  size=5 ==== */
// attributes: thunk
int __stdcall WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
{
  return _WinMain@16_0(hInstance, hPrevInstance, lpCmdLine, nShowCmd);
}


/* ==== 41724F  ?AfxInitialize@@YGHHK@Z  (AfxInitialize(int,ulong))  size=30 ==== */
int __stdcall AfxInitialize(int a1, unsigned int a2)
{
  *((_BYTE *)AfxGetModuleState() + 20) = a1;
  if ( !a1 )
    _setmbcp(-3);
  return 1;
}


/* ==== 41726D  sub_41726D  ()  size=19 ==== */
void sub_41726D()
{
  AfxTermLocalData(0, 1);
  AfxCriticalTerm();
  AfxTlsRelease();
}


/* ==== 417280  ?InitString@CSimpleException@@QAEXXZ  (CSimpleException::InitString(void))  size=41 ==== */
void __thiscall CSimpleException::InitString(CSimpleException *this)
{
  unsigned int v1; // [esp-Ch] [ebp-10h]

  v1 = *((_DWORD *)this + 37);
  *((_DWORD *)this + 3) = 1;
  *((_DWORD *)this + 4) = AfxLoadString(v1, (LPSTR)this + 20, 0x80u) != 0;
}


/* ==== 4172A9  ?GetErrorMessage@CSimpleException@@UAEHPADIPAI@Z  (CSimpleException::GetErrorMessage(char *,uint,uint *))  size=80 ==== */
int __thiscall CSimpleException::GetErrorMessage(
        CHAR *this,
        LPSTR lpString1,
        unsigned int iMaxLength,
        unsigned int *a4)
{
  if ( !lpString1 || !iMaxLength )
    return 0;
  if ( a4 )
    *a4 = 0;
  if ( !*((_DWORD *)this + 3) )
    CSimpleException::InitString((CSimpleException *)this);
  if ( *((_DWORD *)this + 4) )
    lstrcpynA(lpString1, this + 20, iMaxLength);
  else
    *lpString1 = 0;
  return *((_DWORD *)this + 4);
}


/* ==== 4172F9  unknown_libname_11  ()  size=25 ==== */
// MFC 3.1-14.0 32bit
void __noreturn unknown_libname_11()
{
  void *pExceptionObject; // [esp+0h] [ebp-4h] BYREF

  pExceptionObject = &unk_42E178;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI5PAVCMemoryException__);
}


/* ==== 417313  unknown_libname_12  ()  size=25 ==== */
// MFC 3.1-14.0 32bit
void __noreturn unknown_libname_12()
{
  void *pExceptionObject; // [esp+0h] [ebp-4h] BYREF

  pExceptionObject = &unk_42E210;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI5PAVCNotSupportedException__);
}


/* ==== 41732D  unknown_libname_13  ()  size=25 ==== */
// MFC 3.1-14.0 32bit
void __noreturn unknown_libname_13()
{
  void *pExceptionObject; // [esp+0h] [ebp-4h] BYREF

  pExceptionObject = &unk_42E2A8;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI5PAVCInvalidArgException__);
}


/* ==== 417347  ?Create@CProgressCtrl@@UAEHKABUtagRECT@@PAVCWnd@@I@Z  (CProgressCtrl::Create(ulong,tagRECT const &,CWnd *,uint))  size=49 ==== */
int __thiscall CProgressCtrl::Create(
        CProgressCtrl *this,
        unsigned int a2,
        const struct tagRECT *a3,
        struct CWnd *a4,
        unsigned int a5)
{
  AfxEndDeferRegisterClass(512);
  return (*(int (__thiscall **)(CProgressCtrl *, const char *, _DWORD, unsigned int, const struct tagRECT *, struct CWnd *, unsigned int, _DWORD))(*(_DWORD *)this + 84))(
           this,
           "msctls_progress32",
           0,
           a2,
           a3,
           a4,
           a5,
           0);
}


/* ==== 417378  unknown_libname_14  ()  size=55 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_14(CWnd *this, unsigned int a2, int a3, int a4, int a5, int a6)
{
  int v7; // edi

  v7 = (*(int (__thiscall **)(CWnd *, int, int, int, int))(*(_DWORD *)this + 304))(this, a3, a4, a5, a6);
  if ( v7 )
    CWnd::ModifyStyleEx(this, 0, a2, 0);
  return v7;
}


/* ==== 4173AF  sub_4173AF  ()  size=56 ==== */
void __thiscall sub_4173AF(CWnd *this)
{
  *(_DWORD *)this = &CProgressCtrl::`vftable';
  CWnd::DestroyWindow(this);
  CWnd::~CWnd(this);
}


/* ==== 4173E7  ?GetRange@CProgressCtrl@@QAEXAAH0@Z  (CProgressCtrl::GetRange(int &,int &))  size=45 ==== */
void __thiscall CProgressCtrl::GetRange(HWND *this, int *a2, int *a3)
{
  LPARAM lParam[2]; // [esp+0h] [ebp-8h] BYREF

  SendMessageA(this[7], 0x407u, 0, (LPARAM)lParam);
  *a2 = lParam[0];
  *a3 = lParam[1];
}


/* ==== 417414  unknown_libname_15  ()  size=32 ==== */
// MFC 3.1-14.0 32bit
void __thiscall unknown_libname_15(_DWORD *this)
{
  CPlex *v2; // ecx

  v2 = (CPlex *)this[5];
  this[3] = 0;
  this[4] = 0;
  this[2] = 0;
  this[1] = 0;
  CPlex::FreeDataChain(v2);
  this[5] = 0;
}


/* ==== 417434  unknown_libname_16  ()  size=34 ==== */
// MFC 3.1-14.0 32bit
void __thiscall unknown_libname_16(_DWORD *this, _DWORD *a2)
{
  bool v2; // zf

  if ( !a2 )
    unknown_libname_13();
  *a2 = this[4];
  v2 = this[3]-- == 1;
  this[4] = a2;
  if ( v2 )
    unknown_libname_15(this);
}


/* ==== 417456  sub_417456  ()  size=36 ==== */
int __thiscall sub_417456(_DWORD *this)
{
  int *v1; // eax
  int v2; // edx
  bool v3; // zf
  int v4; // esi

  v1 = (int *)this[1];
  v2 = *v1;
  v3 = *v1 == 0;
  v4 = v1[2];
  this[1] = *v1;
  if ( v3 )
    this[2] = 0;
  else
    *(_DWORD *)(v2 + 4) = 0;
  unknown_libname_16(this, v1);
  return v4;
}


/* ==== 41747A  ?SetSize@CByteArray@@QAEXHH@Z  (CByteArray::SetSize(int,int))  size=261 ==== */
void __thiscall CByteArray::SetSize(CByteArray *this, int Size, int a3)
{
  char *v4; // ebx
  int v6; // ecx
  void *v7; // eax
  signed int v8; // ebx
  signed int v9; // eax
  int v10; // eax
  signed int Sizea; // [esp+14h] [ebp+8h]

  v4 = 0;
  if ( Size < 0 )
    goto LABEL_21;
  if ( a3 >= 0 )
    *((_DWORD *)this + 4) = a3;
  if ( Size )
  {
    v6 = *((_DWORD *)this + 1);
    if ( !v6 )
    {
      v7 = operator new(Size);
      *((_DWORD *)this + 1) = v7;
      memset(v7, 0, Size);
      *((_DWORD *)this + 3) = Size;
LABEL_8:
      *((_DWORD *)this + 2) = Size;
      return;
    }
    v8 = *((_DWORD *)this + 3);
    if ( Size <= v8 )
    {
      v9 = *((_DWORD *)this + 2);
      if ( Size > v9 )
        memset((void *)(v6 + v9), 0, Size - v9);
      goto LABEL_8;
    }
    v10 = *((_DWORD *)this + 4);
    if ( !v10 )
    {
      v10 = *((_DWORD *)this + 2) / 8;
      if ( v10 < 4 )
      {
        v10 = 4;
      }
      else if ( v10 > 1024 )
      {
        v10 = 1024;
      }
    }
    Sizea = v8 + v10;
    if ( Size >= v8 + v10 )
      Sizea = Size;
    if ( Sizea >= v8 )
    {
      v4 = (char *)operator new(Sizea);
      memcpy_0(v4, *((const void **)this + 1), *((_DWORD *)this + 2));
      memset(&v4[*((_DWORD *)this + 2)], 0, Size - *((_DWORD *)this + 2));
      j__free(*((void **)this + 1));
      *((_DWORD *)this + 2) = Size;
      *((_DWORD *)this + 3) = Sizea;
      goto LABEL_23;
    }
LABEL_21:
    unknown_libname_13();
  }
  j__free(*((void **)this + 1));
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 2) = 0;
LABEL_23:
  *((_DWORD *)this + 1) = v4;
}


/* ==== 417596  sub_417596  ()  size=16 ==== */
void __thiscall sub_417596(_DWORD *this)
{
  void *v1; // [esp-4h] [ebp-4h]

  v1 = (void *)this[1];
  *this = &CByteArray::`vftable';
  j__free(v1);
}


/* ==== 4175A6  ?Serialize@CByteArray@@UAEXAAVCArchive@@@Z  (CByteArray::Serialize(CArchive &))  size=125 ==== */
void __thiscall CByteArray::Serialize(CByteArray *this, struct CArchive *a2)
{
  unsigned int v3; // edi
  char *j; // esi
  unsigned int v5; // ebx
  int Count; // eax
  unsigned int v7; // edi
  char *i; // esi
  unsigned int v9; // ebx

  if ( (*((_BYTE *)a2 + 24) & 1) != 0 )
  {
    Count = CArchive::ReadCount(a2);
    CByteArray::SetSize(this, Count, -1);
    v7 = *((_DWORD *)this + 2);
    for ( i = (char *)*((_DWORD *)this + 1); v7; v7 -= v9 )
    {
      v9 = 0x7FFFFFFF;
      if ( v7 < 0x7FFFFFFF )
        v9 = v7;
      CArchive::Read(a2, i, v9);
      i += v9;
    }
  }
  else
  {
    CArchive::WriteCount(a2, *((_DWORD *)this + 2));
    v3 = *((_DWORD *)this + 2);
    for ( j = (char *)*((_DWORD *)this + 1); v3; v3 -= v5 )
    {
      v5 = 0x7FFFFFFF;
      if ( v3 < 0x7FFFFFFF )
        v5 = v3;
      CArchive::Write(a2, j, v5);
      j += v5;
    }
  }
}


/* ==== 417623  sub_417623  ()  size=28 ==== */
_DWORD *__thiscall sub_417623(_DWORD *Block, char a2)
{
  sub_417596(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41763F  unknown_libname_17  ()  size=48 ==== */
// MFC 3.1-14.0 32bit
_DWORD *__stdcall unknown_libname_17(_DWORD *a1, int a2, int a3)
{
  _DWORD *result; // eax

  if ( !a2 || !a3 )
    unknown_libname_13();
  result = operator new(a3 * a2 + 4);
  *result = *a1;
  *a1 = result;
  return result;
}


/* ==== 417670  ?FreeDataChain@CPlex@@QAEXXZ  (CPlex::FreeDataChain(void))  size=22 ==== */
void __thiscall CPlex::FreeDataChain(CPlex **this)
{
  CPlex *v1; // esi

  if ( this )
  {
    do
    {
      v1 = *this;
      j__free(this);
      this = (CPlex **)v1;
    }
    while ( v1 );
  }
}


/* ==== 417686  unknown_libname_18  ()  size=76 ==== */
// MFC 3.1-14.0 32bit
void __thiscall unknown_libname_18(int this, int a2, int a3)
{
  int v3; // ebx
  void *v5; // eax

  v3 = a2;
  if ( !a2 )
    v3 = 17;
  if ( *(_DWORD *)(this + 4) )
  {
    j__free(*(void **)(this + 4));
    *(_DWORD *)(this + 4) = 0;
  }
  if ( a3 )
  {
    v5 = operator new(4 * v3);
    *(_DWORD *)(this + 4) = v5;
    memset(v5, 0, 4 * v3);
  }
  *(_DWORD *)(this + 8) = v3;
}


/* ==== 4176D2  sub_4176D2  ()  size=43 ==== */
// ?RemoveAll@CMapPtrToPtr@@QAEXXZ
// doubtful name
void __thiscall sub_4176D2(int this)
{
  CPlex **v2; // ecx

  if ( *(_DWORD *)(this + 4) )
  {
    j__free(*(void **)(this + 4));
    *(_DWORD *)(this + 4) = 0;
  }
  v2 = *(CPlex ***)(this + 20);
  *(_DWORD *)(this + 12) = 0;
  *(_DWORD *)(this + 16) = 0;
  CPlex::FreeDataChain(v2);
  *(_DWORD *)(this + 20) = 0;
}


/* ==== 4176FD  sub_4176FD  ()  size=25 ==== */
void __thiscall sub_4176FD(_DWORD *this, _DWORD *a2)
{
  bool v2; // zf

  *a2 = this[4];
  v2 = this[3]-- == 1;
  this[4] = a2;
  if ( v2 )
    sub_4176D2((int)this);
}


/* ==== 417716  unknown_libname_19  ()  size=56 ==== */
// MFC 3.1-14.0 32bit
_DWORD *__thiscall unknown_libname_19(_DWORD *this, unsigned int a2, int *a3, unsigned int *a4)
{
  int v4; // edx
  int v5; // ecx
  _DWORD *result; // eax

  *a4 = a2 >> 4;
  v4 = (a2 >> 4) % this[2];
  *a3 = v4;
  v5 = this[1];
  if ( v5 )
  {
    for ( result = *(_DWORD **)(v5 + 4 * v4); result; result = (_DWORD *)*result )
    {
      if ( result[1] == a2 )
        return result;
    }
  }
  return 0;
}


/* ==== 41774E  ?GetValueAt@CMapPtrToPtr@@QBEPAXPAX@Z  (CMapPtrToPtr::GetValueAt(void *))  size=55 ==== */
void *__thiscall CMapPtrToPtr::GetValueAt(CMapPtrToPtr *this, unsigned int a2)
{
  int v2; // esi
  _DWORD *i; // edx

  v2 = *((_DWORD *)this + 1);
  if ( !v2 )
    return 0;
  for ( i = *(_DWORD **)(v2 + 4 * ((a2 >> 4) % *((_DWORD *)this + 2))); ; i = (_DWORD *)*i )
  {
    if ( !i )
      return 0;
    if ( i[1] == a2 )
      break;
  }
  return (void *)i[2];
}


/* ==== 417785  sub_417785  ()  size=67 ==== */
int __thiscall sub_417785(_DWORD *this, unsigned int a2)
{
  int v2; // esi
  int result; // eax
  int *v4; // edx

  v2 = this[1];
  if ( !v2 )
    return 0;
  v4 = (int *)(v2 + 4 * ((a2 >> 4) % this[2]));
  for ( result = *v4; result; result = *(_DWORD *)result )
  {
    if ( *(_DWORD *)(result + 4) == a2 )
    {
      *v4 = *(_DWORD *)result;
      sub_4176FD(this, (_DWORD *)result);
      return 1;
    }
    v4 = (int *)result;
  }
  return result;
}


/* ==== 4177C8  ?GetNextAssoc@CMapPtrToPtr@@QBEXAAPAU__POSITION@@AAPAX1@Z  (CMapPtrToPtr::GetNextAssoc(__POSITION * &,void * &,void * &))  size=122 ==== */
void __thiscall CMapPtrToPtr::GetNextAssoc(CMapPtrToPtr *this, struct __POSITION **a2, void **a3, void **a4)
{
  struct __POSITION **v4; // ebx
  struct __POSITION *v5; // esi
  unsigned int v6; // edx
  int v7; // edi
  struct __POSITION **i; // eax
  struct __POSITION *v9; // edi
  unsigned int v10; // ebx
  unsigned int v11; // edx
  struct __POSITION **v12; // eax

  v4 = a2;
  v5 = *a2;
  if ( *a2 )
  {
    if ( v5 == (struct __POSITION *)-1 )
    {
      v6 = *((_DWORD *)this + 2);
      v7 = 0;
      if ( v6 )
      {
        for ( i = (struct __POSITION **)*((_DWORD *)this + 1); ; ++i )
        {
          v5 = *i;
          if ( *i )
            break;
          if ( ++v7 >= v6 )
          {
            *a2 = 0;
            return;
          }
        }
      }
    }
    v9 = *(struct __POSITION **)v5;
    if ( !*(_DWORD *)v5 )
    {
      v10 = *((_DWORD *)this + 2);
      v11 = (*((_DWORD *)v5 + 1) >> 4) % v10 + 1;
      if ( v11 < v10 )
      {
        v12 = (struct __POSITION **)(*((_DWORD *)this + 1) + 4 * v11);
        do
        {
          v9 = *v12;
          if ( *v12 )
            break;
          ++v11;
          ++v12;
        }
        while ( v11 < v10 );
      }
      v4 = a2;
    }
    *v4 = v9;
    *a3 = (void *)*((_DWORD *)v5 + 1);
    *a4 = (void *)*((_DWORD *)v5 + 2);
  }
}


/* ==== 417842  sub_417842  ()  size=46 ==== */
_DWORD *__thiscall sub_417842(_DWORD *this, int a2)
{
  _DWORD *result; // eax
  int v3; // ecx

  result = this;
  v3 = a2;
  *result = &CMapPtrToPtr::`vftable';
  if ( a2 <= 0 )
    v3 = 10;
  result[1] = 0;
  result[2] = 17;
  result[3] = 0;
  result[4] = 0;
  result[5] = 0;
  result[6] = v3;
  return result;
}


/* ==== 417870  sub_417870  ()  size=11 ==== */
void __thiscall sub_417870(int this)
{
  *(_DWORD *)this = &CMapPtrToPtr::`vftable';
  sub_4176D2(this);
}


/* ==== 41787B  ?NewAssoc@CMapPtrToPtr@@IAEPAUCAssoc@1@XZ  (CMapPtrToPtr::NewAssoc(void))  size=75 ==== */
struct CMapPtrToPtr::CAssoc *__thiscall CMapPtrToPtr::NewAssoc(CMapPtrToPtr *this)
{
  _DWORD *v2; // eax
  int v3; // ecx
  int v4; // edx
  int v5; // ecx
  _DWORD *v6; // eax
  int v7; // ecx
  struct CMapPtrToPtr::CAssoc *result; // eax
  int v9; // ecx

  if ( !*((_DWORD *)this + 4) )
  {
    v2 = unknown_libname_17((_DWORD *)this + 5, *((_DWORD *)this + 6), 12);
    v3 = *((_DWORD *)this + 6);
    v4 = 3 * v3;
    v5 = v3 - 1;
    v6 = &v2[v4 - 2];
    if ( v5 >= 0 )
    {
      v7 = v5 + 1;
      do
      {
        *v6 = *((_DWORD *)this + 4);
        *((_DWORD *)this + 4) = v6;
        v6 -= 3;
        --v7;
      }
      while ( v7 );
    }
  }
  result = (struct CMapPtrToPtr::CAssoc *)*((_DWORD *)this + 4);
  v9 = *(_DWORD *)result;
  ++*((_DWORD *)this + 3);
  *((_DWORD *)this + 4) = v9;
  *((_DWORD *)result + 1) = 0;
  *((_DWORD *)result + 2) = 0;
  return result;
}


/* ==== 4178C6  sub_4178C6  ()  size=85 ==== */
int __thiscall sub_4178C6(CMapPtrToPtr *this, unsigned int a2)
{
  unsigned int v2; // edi
  struct CMapPtrToPtr::CAssoc *v4; // eax
  unsigned int v5; // ecx
  unsigned int v7; // [esp+8h] [ebp-4h] BYREF

  v2 = a2;
  v4 = (struct CMapPtrToPtr::CAssoc *)unknown_libname_19(this, a2, (int *)&a2, &v7);
  if ( !v4 )
  {
    if ( !*((_DWORD *)this + 1) )
      unknown_libname_18((int)this, *((_DWORD *)this + 2), 1);
    v4 = CMapPtrToPtr::NewAssoc(this);
    v5 = a2;
    *((_DWORD *)v4 + 1) = v2;
    v5 *= 4;
    *(_DWORD *)v4 = *(_DWORD *)(v5 + *((_DWORD *)this + 1));
    *(_DWORD *)(v5 + *((_DWORD *)this + 1)) = v4;
  }
  return (int)v4 + 8;
}


/* ==== 41791B  sub_41791B  ()  size=28 ==== */
void *__thiscall sub_41791B(void *Block, char a2)
{
  sub_417870((int)Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 417937  sub_417937  ()  size=6 ==== */
void *sub_417937()
{
  return &unk_42E15C;
}


/* ==== 41793D  ?Allocate@CAfxStringMgr@@UAEPAUCStringData@ATL@@HH@Z  (CAfxStringMgr::Allocate(int,int))  size=59 ==== */
struct ATL::CStringData *__thiscall CAfxStringMgr::Allocate(CAfxStringMgr *this, int a2, int a3)
{
  struct ATL::CStringData *result; // eax

  if ( a2 < 0 )
    return 0;
  result = (struct ATL::CStringData *)malloc(a3 * (a2 + 1) + 16);
  if ( !result )
    return 0;
  *((_DWORD *)result + 1) = 0;
  *(_DWORD *)result = this;
  *((_DWORD *)result + 3) = 1;
  *((_DWORD *)result + 2) = a2;
  return result;
}


/* ==== 417978  ?allocate@?$allocator@D@std@@QAEPADI@Z  (std::allocator<char>::allocate(uint))  size=13 ==== */
void __stdcall std::allocator<char>::allocate(void *Block)
{
  free(Block);
}


/* ==== 417985  ?Reallocate@CAfxStringMgr@@UAEPAUCStringData@ATL@@PAU23@HH@Z  (CAfxStringMgr::Reallocate(ATL::CStringData *,int,int))  size=47 ==== */
struct ATL::CStringData *__thiscall CAfxStringMgr::Reallocate(
        CAfxStringMgr *this,
        struct ATL::CStringData *lpMem,
        int a3,
        int a4)
{
  struct ATL::CStringData *result; // eax

  if ( a3 < 0 )
    return 0;
  result = (struct ATL::CStringData *)sub_40C034(lpMem, a4 * (a3 + 1) + 16);
  if ( !result )
    return 0;
  *((_DWORD *)result + 2) = a3;
  return result;
}


/* ==== 4179B4  sub_4179B4  ()  size=3 ==== */
void *__thiscall sub_4179B4(void *this)
{
  return this;
}


/* ==== 4179B7  ??0CAfxStringMgr@@QAE@XZ  (CAfxStringMgr::CAfxStringMgr(void))  size=38 ==== */
CAfxStringMgr *__thiscall CAfxStringMgr::CAfxStringMgr(CAfxStringMgr *this)
{
  CAfxStringMgr *result; // eax

  result = this;
  *(_DWORD *)this = &CAfxStringMgr::`vftable';
  *((_DWORD *)this + 1) = 0;
  *((_DWORD *)this + 4) = 2;
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 3) = 0;
  *((_WORD *)this + 10) = 0;
  *((_WORD *)this + 11) = 0;
  *((_DWORD *)this + 1) = this;
  return result;
}


/* ==== 4179DD  ?GetNilString@CAfxStringMgr@@UAEPAUCStringData@ATL@@XZ  (CAfxStringMgr::GetNilString(void))  size=14 ==== */
struct ATL::CStringData *__thiscall CAfxStringMgr::GetNilString(CAfxStringMgr *this)
{
  _InterlockedExchangeAdd((volatile signed __int32 *)this + 4, 1u);
  return (CAfxStringMgr *)((char *)this + 4);
}


/* ==== 4179EB  sub_4179EB  ()  size=10 ==== */
CAfxStringMgr *sub_4179EB()
{
  return CAfxStringMgr::CAfxStringMgr((CAfxStringMgr *)&unk_42E15C);
}


/* ==== 4179F5  j_unknown_libname_11  ()  size=5 ==== */
// attributes: thunk
void __noreturn j_unknown_libname_11()
{
  unknown_libname_11();
}


/* ==== 4179FA  ?AfxSetNewHandler@@YGP6AHI@ZP6AHI@Z@Z  (AfxSetNewHandler(int (*)(uint)))  size=18 ==== */
void (__noreturn *__stdcall AfxSetNewHandler(void (__noreturn *a1)()))()
{
  void (__noreturn *result)(); // eax

  result = off_42C230[0];
  off_42C230[0] = a1;
  return result;
}


/* ==== 417A0C  ??2@YAPAXI@Z  (operator new(uint))  size=43 ==== */
void *__cdecl operator new(size_t Size)
{
  void *result; // eax

  result = malloc(Size);
  if ( !result )
  {
    if ( off_42C230[0] )
      off_42C230[0]();
  }
  return result;
}


/* ==== 417A37  j__free  ()  size=5 ==== */
// attributes: thunk
void __cdecl j__free(void *Block)
{
  free(Block);
}


/* ==== 417A3C  ?Delete@CException@@QAEXXZ  (CException::Delete(void))  size=14 ==== */
void __thiscall CException::Delete(CException *this)
{
  if ( *((int *)this + 1) > 0 )
    (*(void (__thiscall **)(CException *, int))(*(_DWORD *)this + 4))(this, 1);
}


/* ==== 417A4A  sub_417A4A  ()  size=114 ==== */
int __thiscall sub_417A4A(void *this, unsigned int a2, unsigned int a3)
{
  unsigned int v4; // [esp+0h] [ebp-208h] BYREF
  _BYTE v5[512]; // [esp+4h] [ebp-204h] BYREF

  if ( (*(int (__thiscall **)(void *, _BYTE *, int, unsigned int *))(*(_DWORD *)this + 12))(this, v5, 512, &v4) )
    return sub_41E4CD(v5, a2, v4);
  if ( !a3 )
    a3 = 61472;
  return AfxMessageBox(a3, a2, v4);
}


/* ==== 417ABC  ??0CException@@QAE@XZ  (CException::CException(void))  size=10 ==== */
CException *__thiscall CException::CException(CException *this)
{
  CException *result; // eax

  result = this;
  *((_DWORD *)this + 1) = 1;
  return result;
}


/* ==== 417AC6  ??0CException@@QAE@H@Z  (CException::CException(int))  size=12 ==== */
CException *__thiscall CException::CException(CException *this, int a2)
{
  CException *result; // eax

  result = this;
  *((_DWORD *)this + 1) = a2;
  return result;
}


/* ==== 417AD2  ?AfxDlgProc@@YGHPAUHWND__@@IIJ@Z  (AfxDlgProc(HWND__ *,uint,uint,long))  size=58 ==== */
INT_PTR __stdcall AfxDlgProc(HWND a1, UINT a2, WPARAM a3, LPARAM a4)
{
  struct CObject *v4; // eax
  struct CObject *v5; // eax

  if ( a2 != 272 )
    return 0;
  v4 = CWnd::FromHandlePermanent(a1);
  v5 = AfxDynamicDownCast((struct CRuntimeClass *)&off_425860, v4);
  if ( v5 )
    return (*(int (__thiscall **)(struct CObject *))(*(_DWORD *)v5 + 324))(v5);
  else
    return 1;
}


/* ==== 417B0C  sub_417B0C  ()  size=6 ==== */
_UNKNOWN ***sub_417B0C()
{
  return &off_425884;
}


/* ==== 417B12  sub_417B12  ()  size=62 ==== */
void __thiscall sub_417B12(CWnd *this)
{
  *(_DWORD *)this = &off_425954;
  if ( *((_DWORD *)this + 7) )
    CWnd::DestroyWindow(this);
  CWnd::~CWnd(this);
}


/* ==== 417B50  sub_417B50  ()  size=96 ==== */
void __thiscall sub_417B50(struct CWnd *this)
{
  _BYTE v2[84]; // [esp+4h] [ebp-64h] BYREF
  int v3; // [esp+64h] [ebp-4h]

  CPaintDC::CPaintDC((CPaintDC *)v2, this);
  v3 = 0;
  if ( !CWnd::PaintWindowlessControls(this, (struct CDC *)v2) )
    CWnd::Default(this);
  v3 = -1;
  CPaintDC::~CPaintDC((CPaintDC *)v2);
}


/* ==== 417BB0  ?SetOccDialogInfo@CDialog@@MAEHPAU_AFX_OCC_DIALOG_INFO@@@Z  (CDialog::SetOccDialogInfo(_AFX_OCC_DIALOG_INFO *))  size=13 ==== */
int __thiscall CDialog::SetOccDialogInfo(CDialog *this, struct _AFX_OCC_DIALOG_INFO *a2)
{
  *((_DWORD *)this + 27) = a2;
  return 1;
}


/* ==== 417BBD  ??0CDialog@@QAE@IPAVCWnd@@@Z  (CDialog::CDialog(uint,CWnd *))  size=57 ==== */
CDialog *__thiscall CDialog::CDialog(CDialog *this, unsigned int a2, struct CWnd *a3)
{
  CWnd::CWnd(this);
  *(_DWORD *)this = &off_425954;
  memset((char *)this + 80, 0, 0x20u);
  *((_DWORD *)this + 25) = a3;
  *((_DWORD *)this + 20) = a2;
  *((_DWORD *)this + 21) = (unsigned __int16)a2;
  return this;
}


/* ==== 417BF6  ?EndDialog@CDialog@@QAEXH@Z  (CDialog::EndDialog(int))  size=38 ==== */
void __thiscall CDialog::EndDialog(CDialog *this, INT_PTR nResult)
{
  if ( (*((_BYTE *)this + 56) & 0x18) != 0 )
    (*(void (__thiscall **)(CDialog *, INT_PTR))(*(_DWORD *)this + 132))(this, nResult);
  EndDialog(*((HWND *)this + 7), nResult);
}


/* ==== 417C1C  ?OnOK@CDialog@@MAEXXZ  (CDialog::OnOK(void))  size=25 ==== */
void __thiscall CDialog::OnOK(CDialog *this)
{
  if ( CWnd::UpdateData(this, 1) )
    CDialog::EndDialog(this, 1);
}


/* ==== 417C35  sub_417C35  ()  size=8 ==== */
void __thiscall sub_417C35(CDialog *this)
{
  CDialog::EndDialog(this, 2);
}


/* ==== 417C3D  ?OnHelpHitTest@CDialog@@IAEJIJ@Z  (CDialog::OnHelpHitTest(uint,long))  size=19 ==== */
int __thiscall CDialog::OnHelpHitTest(CDialog *this, unsigned int a2, int a3)
{
  int v3; // eax

  v3 = *((_DWORD *)this + 20);
  if ( v3 )
    return v3 + 0x20000;
  else
    return 0;
}


/* ==== 417C50  ?PreTranslateMessage@CDialog@@UAEHPAUtagMSG@@@Z  (CDialog::PreTranslateMessage(tagMSG *))  size=153 ==== */
int __thiscall CDialog::PreTranslateMessage(HWND *this, struct tagMSG *a2)
{
  struct CFrameWnd *TopLevelFrame; // eax
  WPARAM wParam; // eax
  HWND DlgItem; // eax

  if ( CWnd::PreTranslateMessage((CWnd *)this, a2) )
    return 1;
  TopLevelFrame = CWnd::GetTopLevelFrame((CWnd *)this);
  if ( TopLevelFrame && *((_DWORD *)TopLevelFrame + 25) )
    return 0;
  if ( a2->message == 256 )
  {
    wParam = a2->wParam;
    if ( (wParam == 27 || wParam == 3) && (GetWindowLongA(a2->hwnd, -16) & 4) != 0 )
    {
      if ( sub_41E03A(a2->hwnd, "Edit") )
      {
        DlgItem = GetDlgItem(this[7], 2);
        if ( !DlgItem || IsWindowEnabled(DlgItem) )
        {
          SendMessageA(this[7], 0x111u, 2u, 0);
          return 1;
        }
      }
    }
  }
  return CWnd::PreTranslateInput((CWnd *)this, a2);
}


/* ==== 417CE9  unknown_libname_20  ()  size=132 ==== */
// MFC 3.1-14.0 32bit
BOOL __thiscall unknown_libname_20(HWND *this, unsigned int a2, int a3, void *Buf1, struct AFX_CMDHANDLERINFO *a5)
{
  HWND Parent; // eax
  struct CWnd *v7; // eax
  struct CWinThread *Thread; // eax
  BOOL result; // eax

  result = 1;
  if ( !CCmdTarget::OnCmdMsg((CCmdTarget *)this, a2, a3, Buf1, a5) )
  {
    if ( a3 && a3 != -1 )
      return 0;
    if ( (a2 & 0x8000) == 0 || a2 >= 0xF000 )
      return 0;
    Parent = GetParent(this[7]);
    v7 = CWnd::FromHandle(Parent);
    if ( !v7
      || !(*(int (__thiscall **)(struct CWnd *, unsigned int, int, void *, struct AFX_CMDHANDLERINFO *))(*(_DWORD *)v7 + 12))(
            v7,
            a2,
            a3,
            Buf1,
            a5) )
    {
      Thread = AfxGetThread();
      if ( !Thread
        || !(*(int (__thiscall **)(struct CWinThread *, unsigned int, int, void *, struct AFX_CMDHANDLERINFO *))(*(_DWORD *)Thread + 12))(
              Thread,
              a2,
              a3,
              Buf1,
              a5) )
      {
        return 0;
      }
    }
  }
  return result;
}


/* ==== 417D6D  sub_417D6D  ()  size=28 ==== */
CWnd *__thiscall sub_417D6D(CWnd *Block, char a2)
{
  sub_417B12(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 417D89  ?PreModal@CDialog@@IAEPAUHWND__@@XZ  (CDialog::PreModal(void))  size=58 ==== */
HWND __thiscall CDialog::PreModal(CDialog *this)
{
  CWinApp *v2; // eax
  HWND v3; // eax
  HWND SafeOwner; // edi

  v2 = (CWinApp *)*((_DWORD *)AfxGetModuleState() + 1);
  if ( v2 )
    CWinApp::EnableModeless(v2, 0);
  v3 = (HWND)*((_DWORD *)this + 25);
  if ( v3 )
    v3 = (HWND)*((_DWORD *)v3 + 7);
  SafeOwner = CWnd::GetSafeOwner_(v3, (HWND *)this + 26);
  AfxHookWindowCreate(this);
  return SafeOwner;
}


/* ==== 417DC3  ?PostModal@CDialog@@IAEXXZ  (CDialog::PostModal(void))  size=66 ==== */
void __thiscall CDialog::PostModal(HWND *this)
{
  CWinApp *v2; // eax

  AfxUnhookWindowCreate();
  CWnd::Detach((CWnd *)this);
  if ( IsWindow(this[26]) )
    EnableWindow(this[26], 1);
  this[26] = 0;
  v2 = (CWinApp *)*((_DWORD *)AfxGetModuleState() + 1);
  if ( v2 )
    CWinApp::EnableModeless(v2, 1);
}


/* ==== 417E27  ?HandleInitDialog@CDialog@@IAEJIJ@Z  (CDialog::HandleInitDialog(uint,long))  size=135 ==== */
int __thiscall CDialog::HandleInitDialog(HWND *this, unsigned int a2, int a3)
{
  int v4; // ecx
  HWND v5; // edx
  int v6; // eax
  int v8; // edi
  HWND NextDlgTabItem; // eax
  CWnd *v10; // eax
  HWND v11; // [esp-4h] [ebp-Ch]

  (*((void (__thiscall **)(HWND *))*this + 85))(this);
  v4 = *((_DWORD *)AfxGetModuleState() + 1038);
  if ( v4
    && this[27]
    && ((v5 = this[24], v11 = this[27], !v5)
      ? (v6 = (*(int (__thiscall **)(int, HWND *, HWND, HWND))(*(_DWORD *)v4 + 32))(v4, this, this[21], v11))
      : (v6 = (*(int (__thiscall **)(int, HWND *, HWND, HWND))(*(_DWORD *)v4 + 28))(v4, this, v5, v11)),
        !v6) )
  {
    CDialog::EndDialog((CDialog *)this, -1);
    return 0;
  }
  else
  {
    v8 = CWnd::Default((CWnd *)this);
    if ( v8 && (*((_BYTE *)this + 57) & 1) != 0 )
    {
      NextDlgTabItem = GetNextDlgTabItem(this[7], 0, 0);
      v10 = CWnd::FromHandle(NextDlgTabItem);
      if ( v10 )
      {
        CWnd::SetFocus(v10);
        return 0;
      }
    }
    return v8;
  }
}


/* ==== 417EAE  ?AfxHelpEnabled@@YGHXZ  (AfxHelpEnabled(void))  size=86 ==== */
int __stdcall AfxHelpEnabled()
{
  struct CWnd *MainWnd; // eax
  struct AFX_MODULE_STATE *ModuleState; // eax
  _BYTE v3[8]; // [esp+4h] [ebp-8h] BYREF

  if ( !*((_DWORD *)AfxGetModuleState() + 1) )
    return 0;
  MainWnd = AfxGetMainWnd();
  if ( MainWnd
    && (*(int (__thiscall **)(struct CWnd *, int, _DWORD, _DWORD, _BYTE *))(*(_DWORD *)MainWnd + 12))(
         MainWnd,
         57670,
         0,
         0,
         v3) )
  {
    return 1;
  }
  ModuleState = AfxGetModuleState();
  return (*(int (__thiscall **)(_DWORD, int, _DWORD, _DWORD, _BYTE *))(**((_DWORD **)ModuleState + 1) + 12))(
           *((_DWORD *)ModuleState + 1),
           57670,
           0,
           0,
           v3);
}


/* ==== 417F04  ?OnInitDialog@CDialog@@UAEHXZ  (CDialog::OnInitDialog(void))  size=97 ==== */
int __thiscall CDialog::OnInitDialog(CDialog *this)
{
  int v2; // eax
  CDialog *v3; // ecx
  int updated; // eax
  CWnd *DlgItem; // esi
  int v7; // eax

  if ( *((_DWORD *)this + 24) )
    v2 = CWnd::ExecuteDlgInit(this, *((void **)this + 24));
  else
    v2 = CWnd::ExecuteDlgInit(this, *((LPCSTR *)this + 21));
  v3 = this;
  if ( v2 && (updated = CWnd::UpdateData(this, 0), v3 = this, updated) )
  {
    DlgItem = CWnd::GetDlgItem(this, 57670);
    if ( DlgItem )
    {
      v7 = AfxHelpEnabled();
      CWnd::ShowWindow(DlgItem, v7 != 0 ? 5 : 0);
    }
    return 1;
  }
  else
  {
    CDialog::EndDialog(v3, -1);
    return 0;
  }
}


/* ==== 417F65  ?CheckAutoCenter@CDialog@@UAEHXZ  (CDialog::CheckAutoCenter(void))  size=151 ==== */
int __thiscall CDialog::CheckAutoCenter(CDialog *this)
{
  _DWORD *v2; // esi
  HMODULE v3; // ebx
  HRSRC ResourceA; // eax
  int v5; // ebx
  int v6; // ecx
  __int16 v7; // ax
  __int16 v8; // si
  HGLOBAL hResData; // [esp+Ch] [ebp-4h]

  v2 = (_DWORD *)*((_DWORD *)this + 23);
  hResData = (HGLOBAL)*((_DWORD *)this + 22);
  if ( *((_DWORD *)this + 21) )
  {
    v3 = (HMODULE)*((_DWORD *)AfxGetModuleState() + 3);
    ResourceA = FindResourceA(v3, *((LPCSTR *)this + 21), (LPCSTR)5);
    hResData = LoadResource(v3, ResourceA);
  }
  if ( hResData )
    v2 = LockResource(hResData);
  v5 = 1;
  if ( v2 )
  {
    v6 = *v2;
    if ( HIWORD(*v2) == 0xFFFF )
    {
      v6 = v2[3];
      v7 = *((_WORD *)v2 + 9);
      v8 = *((_WORD *)v2 + 10);
    }
    else
    {
      v7 = *((_WORD *)v2 + 5);
      v8 = *((_WORD *)v2 + 6);
    }
    if ( (v6 & 0x1801) != 0 || v7 || v8 )
      v5 = 0;
  }
  if ( *((_DWORD *)this + 21) )
    FreeResource(hResData);
  return v5;
}


/* ==== 417FFC  ?OnCommandHelp@CDialog@@IAEJIJ@Z  (CDialog::OnCommandHelp(uint,long))  size=62 ==== */
int __thiscall CDialog::OnCommandHelp(CDialog *this, unsigned int a2, int a3)
{
  int v3; // esi
  int v4; // eax
  int v5; // eax

  v3 = a3;
  if ( !a3 )
  {
    v4 = *((_DWORD *)this + 20);
    if ( !v4 )
      return 0;
    v3 = v4 + 0x20000;
    if ( v4 == -131072 )
      return 0;
  }
  v5 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( v5 )
    (*(void (__thiscall **)(int, int, int))(*(_DWORD *)v5 + 172))(v5, v3, 1);
  return 1;
}


/* ==== 41803A  ?CreateDlgIndirect@CWnd@@IAEHPBUDLGTEMPLATE@@PAV1@PAUHINSTANCE__@@@Z  (CWnd::CreateDlgIndirect(DLGTEMPLATE const *,CWnd *,HINSTANCE__ *))  size=525 ==== */
BOOL __thiscall CWnd::CreateDlgIndirect(CWnd *this, struct DLGTEMPLATE *a2, struct CWnd *a3, HINSTANCE hInstance)
{
  int v5; // esi
  struct DLGTEMPLATE *v7; // esi
  void *v8; // eax
  BOOL v9; // eax
  HWND v10; // eax
  HWND DialogIndirectParamA; // esi
  int v12; // [esp+0h] [ebp-54h] BYREF
  _BYTE v13[16]; // [esp+Ch] [ebp-48h] BYREF
  _BYTE v14[12]; // [esp+1Ch] [ebp-38h] BYREF
  int v15; // [esp+2Ch] [ebp-28h]
  int v16; // [esp+30h] [ebp-24h]
  CWnd *v17; // [esp+34h] [ebp-20h]
  unsigned __int8 *Str1; // [esp+38h] [ebp-1Ch] BYREF
  int v19; // [esp+3Ch] [ebp-18h] BYREF
  HGLOBAL hMem; // [esp+40h] [ebp-14h]
  int *v21; // [esp+44h] [ebp-10h]
  int v22; // [esp+50h] [ebp-4h]

  v21 = &v12;
  v17 = this;
  if ( !hInstance )
    hInstance = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 3);
  v5 = *((_DWORD *)AfxGetModuleState() + 1038);
  v15 = v5;
  hMem = 0;
  v16 = 0;
  v22 = 0;
  AfxEndDeferRegisterClass(16);
  AfxEndDeferRegisterClass(507904);
  if ( v5 )
  {
    if ( !(*(int (__thiscall **)(CWnd *, _BYTE *))(*(_DWORD *)this + 300))(this, v13) )
      return 0;
    v7 = (struct DLGTEMPLATE *)(*(int (__thiscall **)(int, _BYTE *, struct DLGTEMPLATE *))(*(_DWORD *)v5 + 16))(
                                 v5,
                                 v13,
                                 a2);
  }
  else
  {
    v7 = a2;
  }
  if ( !v7 )
    return 0;
  v8 = sub_417937();
  Str1 = (unsigned __int8 *)((*(int (__thiscall **)(void *))(*(_DWORD *)v8 + 12))(v8) + 16);
  LOBYTE(v22) = 1;
  v19 = 0;
  v9 = CDialogTemplate::GetFont(v7, (int)&Str1, (int)&v19) == 0;
  if ( !dword_42FE54 )
  {
LABEL_15:
    if ( v9 )
    {
LABEL_16:
      CDialogTemplate::CDialogTemplate((CDialogTemplate *)v14, v7);
      LOBYTE(v22) = 2;
      sub_41CF5F(v19);
      hMem = (HGLOBAL)ATL::CComPtrBase<ICustomDestinationList>::Detach(v14);
      LOBYTE(v22) = 1;
      Concurrency::details::UMSFreeVirtualProcessorRoot::InitialThreadParam::~InitialThreadParam((Concurrency::details::UMSFreeVirtualProcessorRoot::InitialThreadParam *)v14);
      if ( hMem )
        v7 = (struct DLGTEMPLATE *)GlobalLock(hMem);
      goto LABEL_18;
    }
    goto LABEL_18;
  }
  if ( v9 )
    goto LABEL_16;
  if ( GetSystemMetrics(42) )
  {
    v9 = _mbscmp(Str1, "MS Shell Dlg") == 0;
    if ( v9 )
    {
      if ( (_WORD)v19 == 8 )
        v19 = 0;
      goto LABEL_15;
    }
  }
LABEL_18:
  *((_DWORD *)this + 16) = -1;
  *((_DWORD *)this + 14) |= 0x10u;
  AfxHookWindowCreate(this);
  if ( a3 )
    v10 = (HWND)*((_DWORD *)a3 + 7);
  else
    v10 = 0;
  DialogIndirectParamA = CreateDialogIndirectParamA(hInstance, v7, v10, AfxDlgProc, 0);
  ATL::CStringData::Release((ATL::CStringData *)(Str1 - 16));
  v22 = -1;
  if ( v15 )
  {
    (*(void (__thiscall **)(int, _BYTE *))(*(_DWORD *)v15 + 20))(v15, v13);
    if ( DialogIndirectParamA )
      (*(void (__thiscall **)(CWnd *, _DWORD))(*(_DWORD *)this + 300))(this, 0);
  }
  if ( !AfxUnhookWindowCreate() )
    (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 276))(this);
  if ( DialogIndirectParamA && (*((_BYTE *)this + 56) & 0x10) == 0 )
  {
    DestroyWindow(DialogIndirectParamA);
    DialogIndirectParamA = 0;
  }
  if ( hMem )
  {
    GlobalUnlock(hMem);
    GlobalFree(hMem);
  }
  return DialogIndirectParamA != 0;
}


/* ==== 418247  ?DoModal@CDialog@@UAEHXZ  (CDialog::DoModal(void))  size=381 ==== */
int __thiscall CDialog::DoModal(CDialog *this)
{
  void *v2; // eax
  struct DLGTEMPLATE *v3; // ebx
  HINSTANCE v4; // edi
  HRSRC ResourceA; // eax
  struct CWnd *v7; // eax
  char v8; // di
  int v9; // [esp+0h] [ebp-30h] BYREF
  int v10; // [esp+10h] [ebp-20h]
  CDialog *v11; // [esp+14h] [ebp-1Ch]
  HGLOBAL hResData; // [esp+18h] [ebp-18h]
  HWND hWnd; // [esp+1Ch] [ebp-14h]
  int *v14; // [esp+20h] [ebp-10h]
  int v15; // [esp+2Ch] [ebp-4h]

  v2 = (void *)*((_DWORD *)this + 22);
  v3 = (struct DLGTEMPLATE *)*((_DWORD *)this + 23);
  v14 = &v9;
  v11 = this;
  hResData = v2;
  v4 = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 3);
  if ( *((_DWORD *)this + 21) )
  {
    v4 = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 3);
    ResourceA = FindResourceA(v4, *((LPCSTR *)this + 21), (LPCSTR)5);
    hResData = LoadResource(v4, ResourceA);
  }
  if ( hResData )
    v3 = (struct DLGTEMPLATE *)LockResource(hResData);
  if ( !v3 )
    return -1;
  hWnd = CDialog::PreModal(this);
  AfxUnhookWindowCreate();
  v10 = 0;
  if ( hWnd && hWnd != GetDesktopWindow() && IsWindowEnabled(hWnd) )
  {
    EnableWindow(hWnd, 0);
    v10 = 1;
  }
  v15 = 0;
  AfxHookWindowCreate(this);
  v7 = CWnd::FromHandle(hWnd);
  if ( CWnd::CreateDlgIndirect(this, v3, v7, v4) )
  {
    if ( (*((_BYTE *)this + 56) & 0x10) != 0 )
    {
      v8 = 4;
      if ( (CWnd::GetStyle(this) & 0x100) != 0 )
        v8 = 5;
      CWnd::RunModalLoop(this, v8);
    }
    if ( *((_DWORD *)this + 7) )
      CWnd::SetWindowPos(this, 0, 0, 0, 0, 0, 0x97u);
  }
  v15 = -1;
  if ( v10 )
    EnableWindow(hWnd, 1);
  if ( hWnd && GetActiveWindow() == *((HWND *)this + 7) )
    SetActiveWindow(hWnd);
  (*(void (__thiscall **)(CDialog *))(*(_DWORD *)this + 96))(this);
  CDialog::PostModal((HWND *)this);
  if ( *((_DWORD *)this + 21) )
    FreeResource(hResData);
  return *((_DWORD *)this + 16);
}


/* ==== 4183C4  ?CreateIndirect@CDialog@@IAEHPBUDLGTEMPLATE@@PAVCWnd@@PAXPAUHINSTANCE__@@@Z  (CDialog::CreateIndirect(DLGTEMPLATE const *,CWnd *,void *,HINSTANCE__ *))  size=43 ==== */
BOOL __thiscall CDialog::CreateIndirect(CDialog *this, struct DLGTEMPLATE *a2, struct CWnd *a3, void *a4, HINSTANCE a5)
{
  struct CWnd *MainWnd; // eax

  MainWnd = a3;
  if ( !a3 )
    MainWnd = AfxGetMainWnd();
  *((_DWORD *)this + 24) = a4;
  return CWnd::CreateDlgIndirect(this, a2, MainWnd, a5);
}


/* ==== 4183EF  ?CreateIndirect@CDialog@@IAEHPAXPAVCWnd@@PAUHINSTANCE__@@@Z  (CDialog::CreateIndirect(void *,CWnd *,HINSTANCE__ *))  size=35 ==== */
BOOL __thiscall CDialog::CreateIndirect(CDialog *this, HGLOBAL hResData, struct CWnd *a3, HINSTANCE a4)
{
  struct DLGTEMPLATE *v5; // eax

  v5 = (struct DLGTEMPLATE *)LockResource(hResData);
  return CDialog::CreateIndirect(this, v5, a3, 0, a4);
}


/* ==== 418412  sub_418412  ()  size=22 ==== */
BOOL __thiscall sub_418412(CDialog *this, struct DLGTEMPLATE *a2, struct CWnd *a3, void *a4)
{
  return CDialog::CreateIndirect(this, a2, a3, a4, 0);
}


/* ==== 418428  sub_418428  ()  size=90 ==== */
BOOL __thiscall sub_418428(CDialog *this, LPCSTR lpName, struct CWnd *a3)
{
  HINSTANCE v4; // esi
  HRSRC ResourceA; // eax
  HGLOBAL Resource; // ebx
  BOOL Indirect; // esi

  *((_DWORD *)this + 21) = lpName;
  if ( ((unsigned int)lpName & 0xFFFF0000) == 0 && !*((_DWORD *)this + 20) )
    *((_DWORD *)this + 20) = (unsigned __int16)lpName;
  v4 = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 3);
  ResourceA = FindResourceA(v4, lpName, (LPCSTR)5);
  Resource = LoadResource(v4, ResourceA);
  Indirect = CDialog::CreateIndirect(this, Resource, a3, v4);
  FreeResource(Resource);
  return Indirect;
}


/* ==== 418482  sub_418482  ()  size=18 ==== */
BOOL __thiscall sub_418482(CDialog *this, HGLOBAL hResData, struct CWnd *a3)
{
  return CDialog::CreateIndirect(this, hResData, a3, 0);
}


/* ==== 418494  j_??1CProcessLocalObject@@QAE@XZ  (CProcessLocalObject::~CProcessLocalObject(void))  size=5 ==== */
// attributes: thunk
void __thiscall CProcessLocalObject::~CProcessLocalObject(CProcessLocalObject *this)
{
  ??1CProcessLocalObject@@QAE@XZ(this);
}


/* ==== 418499  ??0CWnd@@AAE@PAUHWND__@@@Z  (CWnd::CWnd(HWND__ *))  size=70 ==== */
CWnd *__thiscall CWnd::CWnd(CWnd *this, HWND a2)
{
  CCmdTarget::CCmdTarget(this);
  *(_DWORD *)this = &CWnd::`vftable';
  *((_DWORD *)this + 11) = &CWnd::XAccessible::`vftable';
  *((_DWORD *)this + 12) = &CWnd::XAccessibleServer::`vftable';
  *((_DWORD *)this + 7) = a2;
  *((_BYTE *)this + 32) = 0;
  *((_DWORD *)this + 10) = 0;
  *((_DWORD *)this + 13) = 0;
  *((_DWORD *)this + 14) = 0;
  *((_DWORD *)this + 15) = 0;
  *((_DWORD *)this + 16) = 0;
  *((_DWORD *)this + 17) = 0;
  *((_DWORD *)this + 18) = 0;
  *((_DWORD *)this + 19) = 0;
  return this;
}


/* ==== 4184DF  ?_AfxModifyStyle@@YGHPAUHWND__@@HKKI@Z  (_AfxModifyStyle(HWND__ *,int,ulong,ulong,uint))  size=80 ==== */
int __stdcall _AfxModifyStyle(HWND hWnd, int nIndex, unsigned int a3, unsigned int a4, unsigned int a5)
{
  LONG WindowLongA; // eax

  WindowLongA = GetWindowLongA(hWnd, nIndex);
  if ( WindowLongA == (a4 | WindowLongA & ~a3) )
    return 0;
  SetWindowLongA(hWnd, nIndex, a4 | WindowLongA & ~a3);
  if ( a5 )
    SetWindowPos(hWnd, 0, 0, 0, 0, 0, a5 | 0x17);
  return 1;
}


/* ==== 41852F  ?ModifyStyleEx@CWnd@@SGHPAUHWND__@@KKI@Z  (CWnd::ModifyStyleEx(HWND__ *,ulong,ulong,uint))  size=26 ==== */
int __stdcall CWnd::ModifyStyleEx(HWND hWnd, unsigned int a2, unsigned int a3, unsigned int a4)
{
  return _AfxModifyStyle(hWnd, -20, a2, a3, a4);
}


/* ==== 418549  nullsub_5  ()  size=1 ==== */
void nullsub_5()
{
  ;
}


/* ==== 41854A  ?OnFinalRelease@CWnd@@UAEXXZ  (CWnd::OnFinalRelease(void))  size=17 ==== */
void __thiscall CWnd::OnFinalRelease(CWnd *this)
{
  int v1; // eax

  v1 = *(_DWORD *)this;
  if ( *((_DWORD *)this + 7) )
    (*(void (**)(void))(v1 + 96))();
  else
    (*(void (**)(void))(v1 + 276))();
}


/* ==== 41855B  ?DefWindowProcA@CWnd@@MAEJIIJ@Z  (CWnd::DefWindowProcA(uint,uint,long))  size=71 ==== */
LRESULT __thiscall CWnd::DefWindowProcA(CWnd *this, UINT Msg, WPARAM wParam, LPARAM lParam)
{
  LRESULT (__stdcall *v5)(HWND, UINT, WPARAM, LPARAM); // eax

  v5 = (LRESULT (__stdcall *)(HWND, UINT, WPARAM, LPARAM))*((_DWORD *)this + 15);
  if ( v5 )
    return CallWindowProcA(v5, *((HWND *)this + 7), Msg, wParam, lParam);
  v5 = *(LRESULT (__stdcall **)(HWND, UINT, WPARAM, LPARAM))(*(int (__thiscall **)(CWnd *))(*(_DWORD *)this + 240))(this);
  if ( v5 )
    return CallWindowProcA(v5, *((HWND *)this + 7), Msg, wParam, lParam);
  else
    return DefWindowProcA(*((HWND *)this + 7), Msg, wParam, lParam);
}


/* ==== 4185A2  sub_4185A2  ()  size=4 ==== */
char *__thiscall sub_4185A2(char *this)
{
  return this + 60;
}


/* ==== 4185A6  ?PreTranslateMessage@CWnd@@UAEHPAUtagMSG@@@Z  (CWnd::PreTranslateMessage(tagMSG *))  size=31 ==== */
int __thiscall CWnd::PreTranslateMessage(CWnd *this, struct tagMSG *a2)
{
  void (__stdcall *v3)(struct tagMSG *, CWnd *); // eax

  v3 = (void (__stdcall *)(struct tagMSG *, CWnd *))*((_DWORD *)AfxGetModuleState() + 1037);
  if ( v3 )
    v3(a2, this);
  return 0;
}


/* ==== 4185C5  ?OnToolHitTest@CWnd@@UBEHVCPoint@@PAUtagTOOLINFOA@@@Z  (CWnd::OnToolHitTest(CPoint,tagTOOLINFOA *))  size=113 ==== */
int __thiscall CWnd::OnToolHitTest(HWND *this, struct tagPOINT Point, _DWORD *a3)
{
  HWND v4; // eax
  HWND v5; // edi
  HWND v6; // eax
  int Point_4; // [esp+14h] [ebp+Ch]

  v4 = _AfxChildWindowFromPoint(this[7], Point);
  v5 = v4;
  if ( !v4 )
    return -1;
  Point_4 = (unsigned __int16)GetDlgCtrlID(v4);
  if ( a3 && *a3 >= 0x28u )
  {
    v6 = this[7];
    a3[1] |= 1u;
    a3[9] = -1;
    a3[2] = v6;
    a3[3] = v5;
    if ( (SendMessageA(v5, 0x87u, 0, 0) & 0x2000) == 0 )
      a3[1] |= 0x80000002;
  }
  return Point_4;
}


/* ==== 418636  ?AfxRegisterClass@@YGHPAUtagWNDCLASSA@@@Z  (AfxRegisterClass(tagWNDCLASSA *))  size=258 ==== */
int __stdcall AfxRegisterClass(WNDCLASSA *lpWndClass)
{
  WNDCLASSA *v1; // edi
  int v3; // ebx
  WNDCLASSA *v4; // eax
  int v5; // eax
  const CHAR *lpszClassName; // [esp-4h] [ebp-54h]
  HINSTANCE hInstance; // [esp-4h] [ebp-54h]
  int v8; // [esp+0h] [ebp-50h] BYREF
  tagWNDCLASSA WndClass; // [esp+10h] [ebp-40h] BYREF
  int v10; // [esp+38h] [ebp-18h]
  LPCSTR lpString; // [esp+3Ch] [ebp-14h]
  int *v12; // [esp+40h] [ebp-10h]
  int v13; // [esp+4Ch] [ebp-4h]

  v1 = lpWndClass;
  v12 = &v8;
  if ( GetClassInfoA(lpWndClass->hInstance, lpWndClass->lpszClassName, &WndClass) )
    return 1;
  if ( !RegisterClassA(v1) )
    return 0;
  v10 = 1;
  if ( *((_BYTE *)AfxGetModuleState() + 20) )
  {
    AfxLockGlobals(1);
    v13 = 0;
    lpString = (char *)AfxGetModuleState() + 52;
    v3 = lstrlenA(lpString);
    if ( (unsigned int)(v3 + lstrlenA(v1->lpszClassName) + 2) >= 0x1000 )
      return 0;
    v4 = (WNDCLASSA *)lstrlenA(lpString);
    lpszClassName = v1->lpszClassName;
    lpWndClass = v4;
    v5 = lstrlenA(lpszClassName);
    if ( (unsigned int)&lpWndClass->style + v5 + 2 >= 0x1000 )
    {
      hInstance = v1->hInstance;
      v10 = 0;
      UnregisterClassA(v1->lpszClassName, hInstance);
    }
    else
    {
      lstrcatA((LPSTR)lpString, v1->lpszClassName);
      HIWORD(lpWndClass) = 10;
      lstrcatA((LPSTR)lpString, (LPCSTR)&lpWndClass + 2);
    }
    v13 = -1;
    AfxUnlockGlobals(1);
  }
  return v10;
}


/* ==== 418738  sub_418738  ()  size=21 ==== */
BOOL __thiscall sub_418738(_DWORD *this)
{
  HMODULE v1; // ecx
  BOOL result; // eax

  *this = &_AFX_HTMLHELP_STATE::`vftable';
  v1 = (HMODULE)this[1];
  if ( v1 )
    return FreeLibrary(v1);
  return result;
}


/* ==== 41874D  sub_41874D  ()  size=27 ==== */
_DWORD *__thiscall sub_41874D(_DWORD *this, char a2)
{
  sub_418738(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 418768  sub_418768  ()  size=6 ==== */
_UNKNOWN **sub_418768()
{
  return &off_425D48;
}


/* ==== 41876E  unknown_libname_21  ()  size=64 ==== */
// MFC 3.1-14.0 32bit
_DWORD *__stdcall unknown_libname_21(_DWORD *a1, int a2, int a3, unsigned int a4)
{
  while ( a1[4] )
  {
    if ( a2 == *a1 && a3 == a1[1] && a4 >= a1[2] && a4 <= a1[3] )
      return a1;
    a1 += 6;
  }
  return 0;
}


/* ==== 4187AE  ?WindowProc@CWnd@@MAEJIIJ@Z  (CWnd::WindowProc(uint,uint,long))  size=68 ==== */
int __thiscall CWnd::WindowProc(CWnd *this, unsigned int a2, unsigned int a3, int a4)
{
  int v6; // [esp+4h] [ebp-4h] BYREF

  v6 = 0;
  if ( !(*(int (__thiscall **)(CWnd *, unsigned int, unsigned int, int, int *))(*(_DWORD *)this + 268))(
          this,
          a2,
          a3,
          a4,
          &v6) )
    return (*(int (__thiscall **)(CWnd *, unsigned int, unsigned int, int))(*(_DWORD *)this + 272))(this, a2, a3, a4);
  return v6;
}


/* ==== 4187F2  sub_4187F2  ()  size=25 ==== */
CCmdUI *__thiscall sub_4187F2(CCmdUI *this)
{
  CCmdUI::CCmdUI(this);
  *(_DWORD *)this = &CTestCmdUI::`vftable';
  *((_DWORD *)this + 10) = 1;
  return this;
}


/* ==== 41880B  ?Enable@CTestCmdUI@@UAEXH@Z  (CTestCmdUI::Enable(int))  size=17 ==== */
void __thiscall CTestCmdUI::Enable(CTestCmdUI *this, int a2)
{
  *((_DWORD *)this + 10) = a2;
  *((_DWORD *)this + 6) = 1;
}


/* ==== 41881C  nullsub_6  ()  size=3 ==== */
void __stdcall nullsub_6(int a1)
{
  ;
}


/* ==== 41881F  ?CalcWindowRect@CWnd@@UAEXPAUtagRECT@@I@Z  (CWnd::CalcWindowRect(tagRECT *,uint))  size=45 ==== */
void __thiscall CWnd::CalcWindowRect(CWnd *this, LPRECT lpRect, unsigned int a3)
{
  unsigned int v4; // eax
  DWORD Style; // eax
  DWORD v6; // [esp-4h] [ebp-8h]

  v4 = CWnd::GetExStyle(this);
  if ( !a3 )
    v4 &= ~0x200u;
  v6 = v4;
  Style = CWnd::GetStyle(this);
  AdjustWindowRectEx(lpRect, Style, 0, v6);
}


/* ==== 41884C  sub_41884C  ()  size=6 ==== */
_UNKNOWN **sub_41884C()
{
  return &off_425D38;
}


/* ==== 418852  unknown_libname_27  ()  size=15 ==== */
// MFC 3.1-14.0 32bit
unsigned int __stdcall unknown_libname_27(int a1)
{
  return CCmdTarget::ExternalAddRef((CCmdTarget *)(a1 - 44));
}


/* ==== 418861  unknown_libname_28  ()  size=15 ==== */
// MFC 3.1-14.0 32bit
unsigned int __stdcall unknown_libname_28(int a1)
{
  return CCmdTarget::ExternalRelease((CCmdTarget *)(a1 - 44));
}


/* ==== 418870  unknown_libname_29  ()  size=23 ==== */
// MFC 3.1-14.0 32bit
unsigned int __stdcall unknown_libname_29(int a1, void *a2, void **a3)
{
  return CCmdTarget::ExternalQueryInterface((CCmdTarget *)(a1 - 44), a2, a3);
}


/* ==== 418887  sub_418887  ()  size=9 ==== */
HRESULT __stdcall sub_418887(
        struct IAccessible *a1,
        int a2,
        const struct _GUID *a3,
        unsigned int a4,
        int lVal,
        DISPID *a6,
        struct tagVARIANT *a7,
        struct tagEXCEPINFO *a8,
        unsigned int *a9)
{
  return ATL::AtlIAccessibleInvokeHelper(a1, a2, a3, a4, lVal, a6, a7, a8, a9);
}


/* ==== 418890  ?GetIDsOfNames@XAccessible@CWnd@@UAGJABU_GUID@@PAPA_WIKPAJ@Z  (CWnd::XAccessible::GetIDsOfNames(_GUID const &,wchar_t * *,uint,ulong,long *))  size=27 ==== */
int __stdcall CWnd::XAccessible::GetIDsOfNames(
        CWnd::XAccessible *this,
        const struct _GUID *a2,
        wchar_t **a3,
        unsigned int a4,
        unsigned int a5,
        int *a6)
{
  return ATL::AtlIAccessibleGetIDsOfNamesHelper(a2, a3, a4, a5, a6);
}


/* ==== 4188AB  ?GetTypeInfoCount@XAccessible@CWnd@@UAGJPAI@Z  (CWnd::XAccessible::GetTypeInfoCount(uint *))  size=26 ==== */
int __stdcall CWnd::XAccessible::GetTypeInfoCount(CWnd::XAccessible *this, unsigned int *a2)
{
  if ( !a2 )
    return -2147467261;
  *a2 = 1;
  return 0;
}


/* ==== 4188C5  sub_4188C5  ()  size=8 ==== */
int __stdcall sub_4188C5(int a1, int a2, int a3, int a4)
{
  return -2147467263;
}


/* ==== 4188CD  ?get_accParent@XAccessible@CWnd@@UAGJPAPAUIDispatch@@@Z  (CWnd::XAccessible::get_accParent(IDispatch * *))  size=22 ==== */
int __stdcall CWnd::XAccessible::get_accParent(CWnd::XAccessible *this, struct IDispatch **a2)
{
  return (*(int (__thiscall **)(char *, struct IDispatch **))(*((_DWORD *)this - 11) + 140))((char *)this - 44, a2);
}


/* ==== 4188E3  ?get_accChildCount@XAccessible@CWnd@@UAGJPAJ@Z  (CWnd::XAccessible::get_accChildCount(long *))  size=22 ==== */
int __stdcall CWnd::XAccessible::get_accChildCount(CWnd::XAccessible *this, int *a2)
{
  return (*(int (__thiscall **)(char *, int *))(*((_DWORD *)this - 11) + 144))((char *)this - 44, a2);
}


/* ==== 4188F9  ?get_accChild@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPAUIDispatch@@@Z  (CWnd::XAccessible::get_accChild(tagVARIANT,IDispatch * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accChild(CWnd::XAccessible *this, struct tagVARIANT a2, struct IDispatch **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, struct IDispatch **))(*((_DWORD *)this - 11) + 148))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418920  ?get_accName@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accName(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accName(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 152))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418947  ?get_accValue@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accValue(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accValue(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 156))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 41896E  ?get_accDescription@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accDescription(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accDescription(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 160))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418995  ?get_accRole@XAccessible@CWnd@@UAGJUtagVARIANT@@PAU3@@Z  (CWnd::XAccessible::get_accRole(tagVARIANT,tagVARIANT *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accRole(CWnd::XAccessible *this, struct tagVARIANT a2, struct tagVARIANT *a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(*((_DWORD *)this - 11) + 164))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 4189BC  ?get_accState@XAccessible@CWnd@@UAGJUtagVARIANT@@PAU3@@Z  (CWnd::XAccessible::get_accState(tagVARIANT,tagVARIANT *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accState(CWnd::XAccessible *this, struct tagVARIANT a2, struct tagVARIANT *a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(*((_DWORD *)this - 11) + 168))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 4189E3  ?get_accHelp@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accHelp(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accHelp(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 172))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418A0A  ?get_accHelpTopic@XAccessible@CWnd@@UAGJPAPA_WUtagVARIANT@@PAJ@Z  (CWnd::XAccessible::get_accHelpTopic(wchar_t * *,tagVARIANT,long *))  size=43 ==== */
int __stdcall CWnd::XAccessible::get_accHelpTopic(CWnd::XAccessible *this, wchar_t **a2, struct tagVARIANT a3, int *a4)
{
  return (*(int (__thiscall **)(char *, wchar_t **, _DWORD, ULONG, LONG, LONG, int *))(*((_DWORD *)this - 11) + 176))(
           (char *)this - 44,
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi,
           a4);
}


/* ==== 418A35  ?get_accKeyboardShortcut@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accKeyboardShortcut(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accKeyboardShortcut(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 180))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418A5C  ?get_accFocus@XAccessible@CWnd@@UAGJPAUtagVARIANT@@@Z  (CWnd::XAccessible::get_accFocus(tagVARIANT *))  size=22 ==== */
int __stdcall CWnd::XAccessible::get_accFocus(CWnd::XAccessible *this, struct tagVARIANT *a2)
{
  return (*(int (__thiscall **)(char *, struct tagVARIANT *))(*((_DWORD *)this - 11) + 184))((char *)this - 44, a2);
}


/* ==== 418A72  ?get_accSelection@XAccessible@CWnd@@UAGJPAUtagVARIANT@@@Z  (CWnd::XAccessible::get_accSelection(tagVARIANT *))  size=22 ==== */
int __stdcall CWnd::XAccessible::get_accSelection(CWnd::XAccessible *this, struct tagVARIANT *a2)
{
  return (*(int (__thiscall **)(char *, struct tagVARIANT *))(*((_DWORD *)this - 11) + 188))((char *)this - 44, a2);
}


/* ==== 418A88  ?get_accDefaultAction@XAccessible@CWnd@@UAGJUtagVARIANT@@PAPA_W@Z  (CWnd::XAccessible::get_accDefaultAction(tagVARIANT,wchar_t * *))  size=39 ==== */
int __stdcall CWnd::XAccessible::get_accDefaultAction(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t **))(*((_DWORD *)this - 11) + 192))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418AAF  ?accSelect@XAccessible@CWnd@@UAGJJUtagVARIANT@@@Z  (CWnd::XAccessible::accSelect(long,tagVARIANT))  size=39 ==== */
int __stdcall CWnd::XAccessible::accSelect(CWnd::XAccessible *this, int a2, struct tagVARIANT a3)
{
  return (*(int (__thiscall **)(char *, int, _DWORD, ULONG, LONG, LONG))(*((_DWORD *)this - 11) + 196))(
           (char *)this - 44,
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi);
}


/* ==== 418AD6  ?accLocation@XAccessible@CWnd@@UAGJPAJ000UtagVARIANT@@@Z  (CWnd::XAccessible::accLocation(long *,long *,long *,long *,tagVARIANT))  size=49 ==== */
int __stdcall CWnd::XAccessible::accLocation(
        CWnd::XAccessible *this,
        int *a2,
        int *a3,
        int *a4,
        int *a5,
        struct tagVARIANT a6)
{
  return (*(int (__thiscall **)(char *, int *, int *, int *, int *, _DWORD, ULONG, LONG, LONG))(*((_DWORD *)this - 11)
                                                                                              + 200))(
           (char *)this - 44,
           a2,
           a3,
           a4,
           a5,
           *(_DWORD *)&a6.vt,
           a6.decVal.Hi32,
           a6.lVal,
           a6.cyVal.Hi);
}


/* ==== 418B07  ?accNavigate@XAccessible@CWnd@@UAGJJUtagVARIANT@@PAU3@@Z  (CWnd::XAccessible::accNavigate(long,tagVARIANT,tagVARIANT *))  size=43 ==== */
int __stdcall CWnd::XAccessible::accNavigate(
        CWnd::XAccessible *this,
        int a2,
        struct tagVARIANT a3,
        struct tagVARIANT *a4)
{
  return (*(int (__thiscall **)(char *, int, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(*((_DWORD *)this - 11)
                                                                                            + 204))(
           (char *)this - 44,
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi,
           a4);
}


/* ==== 418B32  ?accHitTest@XAccessible@CWnd@@UAGJJJPAUtagVARIANT@@@Z  (CWnd::XAccessible::accHitTest(long,long,tagVARIANT *))  size=30 ==== */
int __stdcall CWnd::XAccessible::accHitTest(CWnd::XAccessible *this, int a2, int a3, struct tagVARIANT *a4)
{
  return (*(int (__thiscall **)(char *, int, int, struct tagVARIANT *))(*((_DWORD *)this - 11) + 208))(
           (char *)this - 44,
           a2,
           a3,
           a4);
}


/* ==== 418B50  ?accDoDefaultAction@XAccessible@CWnd@@UAGJUtagVARIANT@@@Z  (CWnd::XAccessible::accDoDefaultAction(tagVARIANT))  size=35 ==== */
int __stdcall CWnd::XAccessible::accDoDefaultAction(CWnd::XAccessible *this, struct tagVARIANT a2)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG))(*((_DWORD *)this - 11) + 212))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi);
}


/* ==== 418B73  ?put_accName@XAccessible@CWnd@@UAGJUtagVARIANT@@PA_W@Z  (CWnd::XAccessible::put_accName(tagVARIANT,wchar_t *))  size=39 ==== */
int __stdcall CWnd::XAccessible::put_accName(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t *a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t *))(*((_DWORD *)this - 11) + 216))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418B9A  ?put_accValue@XAccessible@CWnd@@UAGJUtagVARIANT@@PA_W@Z  (CWnd::XAccessible::put_accValue(tagVARIANT,wchar_t *))  size=39 ==== */
int __stdcall CWnd::XAccessible::put_accValue(CWnd::XAccessible *this, struct tagVARIANT a2, wchar_t *a3)
{
  return (*(int (__thiscall **)(char *, _DWORD, ULONG, LONG, LONG, wchar_t *))(*((_DWORD *)this - 11) + 220))(
           (char *)this - 44,
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418BC1  ?AddRef@XDataObject@COleDataSource@@UAGKXZ  (COleDataSource::XDataObject::AddRef(void))  size=15 ==== */
unsigned int __stdcall COleDataSource::XDataObject::AddRef(COleDataSource::XDataObject *this)
{
  return CCmdTarget::ExternalAddRef((COleDataSource::XDataObject *)((char *)this - 48));
}


/* ==== 418BD0  sub_418BD0  ()  size=15 ==== */
unsigned int __stdcall sub_418BD0(int a1)
{
  return CCmdTarget::ExternalRelease((CCmdTarget *)(a1 - 48));
}


/* ==== 418BDF  ?QueryInterface@XDataObject@COleDataSource@@UAGJABU_GUID@@PAPAX@Z  (COleDataSource::XDataObject::QueryInterface(_GUID const &,void * *))  size=23 ==== */
unsigned int __stdcall COleDataSource::XDataObject::QueryInterface(
        COleDataSource::XDataObject *this,
        const struct _GUID *a2,
        void **a3)
{
  return CCmdTarget::ExternalQueryInterface((COleDataSource::XDataObject *)((char *)this - 48), a2, a3);
}


/* ==== 418BF6  ?SetProxy@XAccessibleServer@CWnd@@UAGJPAUIAccessibleProxy@@@Z  (CWnd::XAccessibleServer::SetProxy(IAccessibleProxy *))  size=22 ==== */
int __stdcall CWnd::XAccessibleServer::SetProxy(CWnd::XAccessibleServer *this, struct IAccessibleProxy *a2)
{
  return (*(int (__thiscall **)(char *, struct IAccessibleProxy *))(*((_DWORD *)this - 12) + 224))(
           (char *)this - 48,
           a2);
}


/* ==== 418C0C  ?GetHWND@XAccessibleServer@CWnd@@UAGJPAPAUHWND__@@@Z  (CWnd::XAccessibleServer::GetHWND(HWND__ * *))  size=29 ==== */
int __stdcall CWnd::XAccessibleServer::GetHWND(CWnd::XAccessibleServer *this, HWND *a2)
{
  if ( !a2 )
    return -2147467261;
  *a2 = (HWND)*((_DWORD *)this - 5);
  return 0;
}


/* ==== 418C29  ?GetEnumVariant@XAccessibleServer@CWnd@@UAGJPAPAUIEnumVARIANT@@@Z  (CWnd::XAccessibleServer::GetEnumVariant(IEnumVARIANT * *))  size=26 ==== */
int __stdcall CWnd::XAccessibleServer::GetEnumVariant(CWnd::XAccessibleServer *this, struct IEnumVARIANT **a2)
{
  if ( !a2 )
    return -2147467261;
  *a2 = 0;
  return -2147467263;
}


/* ==== 418C43  ?EnsureStdObj@CWnd@@UAEJXZ  (CWnd::EnsureStdObj(void))  size=31 ==== */
HRESULT __thiscall CWnd::EnsureStdObj(CWnd *this)
{
  HRESULT result; // eax

  if ( *((_DWORD *)this + 9) )
    return 0;
  result = CreateStdAccessibleObject(*((HWND *)this + 7), -4, &riid, (void **)this + 9);
  if ( result >= 0 )
    return 0;
  return result;
}


/* ==== 418C62  ?get_accParent@CWnd@@UAEJPAPAUIDispatch@@@Z  (CWnd::get_accParent(IDispatch * *))  size=16 ==== */
int __thiscall CWnd::get_accParent(CWnd *this, struct IDispatch **a2)
{
  return (*(int (__stdcall **)(_DWORD, struct IDispatch **))(**((_DWORD **)this + 9) + 28))(*((_DWORD *)this + 9), a2);
}


/* ==== 418C72  ?get_accChildCount@CWnd@@UAEJPAJ@Z  (CWnd::get_accChildCount(long *))  size=16 ==== */
int __thiscall CWnd::get_accChildCount(CWnd *this, int *a2)
{
  return (*(int (__stdcall **)(_DWORD, int *))(**((_DWORD **)this + 9) + 32))(*((_DWORD *)this + 9), a2);
}


/* ==== 418C82  ?get_accChild@CWnd@@UAEJUtagVARIANT@@PAPAUIDispatch@@@Z  (CWnd::get_accChild(tagVARIANT,IDispatch * *))  size=33 ==== */
int __thiscall CWnd::get_accChild(CWnd *this, struct tagVARIANT a2, struct IDispatch **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, struct IDispatch **))(**((_DWORD **)this + 9) + 36))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418CA3  ?get_accName@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accName(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accName(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 40))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418CC4  ?get_accValue@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accValue(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accValue(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 44))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418CE5  ?get_accDescription@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accDescription(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accDescription(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 48))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418D06  ?get_accRole@CWnd@@UAEJUtagVARIANT@@PAU2@@Z  (CWnd::get_accRole(tagVARIANT,tagVARIANT *))  size=33 ==== */
int __thiscall CWnd::get_accRole(CWnd *this, struct tagVARIANT a2, struct tagVARIANT *a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(**((_DWORD **)this + 9) + 52))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418D27  ?get_accState@CWnd@@UAEJUtagVARIANT@@PAU2@@Z  (CWnd::get_accState(tagVARIANT,tagVARIANT *))  size=33 ==== */
int __thiscall CWnd::get_accState(CWnd *this, struct tagVARIANT a2, struct tagVARIANT *a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(**((_DWORD **)this + 9) + 56))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418D48  ?get_accHelp@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accHelp(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accHelp(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 60))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418D69  ?get_accHelpTopic@CWnd@@UAEJPAPA_WUtagVARIANT@@PAJ@Z  (CWnd::get_accHelpTopic(wchar_t * *,tagVARIANT,long *))  size=37 ==== */
int __thiscall CWnd::get_accHelpTopic(CWnd *this, wchar_t **a2, struct tagVARIANT a3, int *a4)
{
  return (*(int (__stdcall **)(_DWORD, wchar_t **, _DWORD, ULONG, LONG, LONG, int *))(**((_DWORD **)this + 9) + 64))(
           *((_DWORD *)this + 9),
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi,
           a4);
}


/* ==== 418D8E  ?get_accKeyboardShortcut@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accKeyboardShortcut(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accKeyboardShortcut(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 68))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418DAF  ?get_accFocus@CWnd@@UAEJPAUtagVARIANT@@@Z  (CWnd::get_accFocus(tagVARIANT *))  size=16 ==== */
int __thiscall CWnd::get_accFocus(CWnd *this, struct tagVARIANT *a2)
{
  return (*(int (__stdcall **)(_DWORD, struct tagVARIANT *))(**((_DWORD **)this + 9) + 72))(*((_DWORD *)this + 9), a2);
}


/* ==== 418DBF  ?get_accSelection@CWnd@@UAEJPAUtagVARIANT@@@Z  (CWnd::get_accSelection(tagVARIANT *))  size=16 ==== */
int __thiscall CWnd::get_accSelection(CWnd *this, struct tagVARIANT *a2)
{
  return (*(int (__stdcall **)(_DWORD, struct tagVARIANT *))(**((_DWORD **)this + 9) + 76))(*((_DWORD *)this + 9), a2);
}


/* ==== 418DCF  ?get_accDefaultAction@CWnd@@UAEJUtagVARIANT@@PAPA_W@Z  (CWnd::get_accDefaultAction(tagVARIANT,wchar_t * *))  size=33 ==== */
int __thiscall CWnd::get_accDefaultAction(CWnd *this, struct tagVARIANT a2, wchar_t **a3)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG, wchar_t **))(**((_DWORD **)this + 9) + 80))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi,
           a3);
}


/* ==== 418DF0  ?accSelect@CWnd@@UAEJJUtagVARIANT@@@Z  (CWnd::accSelect(long,tagVARIANT))  size=33 ==== */
int __thiscall CWnd::accSelect(CWnd *this, int a2, struct tagVARIANT a3)
{
  return (*(int (__stdcall **)(_DWORD, int, _DWORD, ULONG, LONG, LONG))(**((_DWORD **)this + 9) + 84))(
           *((_DWORD *)this + 9),
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi);
}


/* ==== 418E11  ?accLocation@CWnd@@UAEJPAJ000UtagVARIANT@@@Z  (CWnd::accLocation(long *,long *,long *,long *,tagVARIANT))  size=44 ==== */
int __thiscall CWnd::accLocation(CWnd *this, int *a2, int *a3, int *a4, int *a5, struct tagVARIANT a6)
{
  return (*(int (__stdcall **)(_DWORD, int *, int *, int *, int *, _DWORD, ULONG, LONG, LONG))(**((_DWORD **)this + 9)
                                                                                             + 88))(
           *((_DWORD *)this + 9),
           a2,
           a3,
           a4,
           a5,
           *(_DWORD *)&a6.vt,
           a6.decVal.Hi32,
           a6.lVal,
           a6.cyVal.Hi);
}


/* ==== 418E3D  ?accNavigate@CWnd@@UAEJJUtagVARIANT@@PAU2@@Z  (CWnd::accNavigate(long,tagVARIANT,tagVARIANT *))  size=37 ==== */
int __thiscall CWnd::accNavigate(CWnd *this, int a2, struct tagVARIANT a3, struct tagVARIANT *a4)
{
  return (*(int (__stdcall **)(_DWORD, int, _DWORD, ULONG, LONG, LONG, struct tagVARIANT *))(**((_DWORD **)this + 9) + 92))(
           *((_DWORD *)this + 9),
           a2,
           *(_DWORD *)&a3.vt,
           a3.decVal.Hi32,
           a3.lVal,
           a3.cyVal.Hi,
           a4);
}


/* ==== 418E62  ?accHitTest@CWnd@@UAEJJJPAUtagVARIANT@@@Z  (CWnd::accHitTest(long,long,tagVARIANT *))  size=24 ==== */
int __thiscall CWnd::accHitTest(CWnd *this, int a2, int a3, struct tagVARIANT *a4)
{
  return (*(int (__stdcall **)(_DWORD, int, int, struct tagVARIANT *))(**((_DWORD **)this + 9) + 96))(
           *((_DWORD *)this + 9),
           a2,
           a3,
           a4);
}


/* ==== 418E7A  ?accDoDefaultAction@CWnd@@UAEJUtagVARIANT@@@Z  (CWnd::accDoDefaultAction(tagVARIANT))  size=29 ==== */
int __thiscall CWnd::accDoDefaultAction(CWnd *this, struct tagVARIANT a2)
{
  return (*(int (__stdcall **)(_DWORD, _DWORD, ULONG, LONG, LONG))(**((_DWORD **)this + 9) + 100))(
           *((_DWORD *)this + 9),
           *(_DWORD *)&a2.vt,
           a2.decVal.Hi32,
           a2.lVal,
           a2.cyVal.Hi);
}


/* ==== 418E97  unknown_libname_30  ()  size=33 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_30(_DWORD **this, int a2, int a3, int a4, int a5, int a6)
{
  return (*(int (__stdcall **)(_DWORD *, int, int, int, int, int))(*this[9] + 104))(this[9], a2, a3, a4, a5, a6);
}


/* ==== 418EB8  ?SetProxy@CWnd@@UAEJPAUIAccessibleProxy@@@Z  (CWnd::SetProxy(IAccessibleProxy *))  size=12 ==== */
int __thiscall CWnd::SetProxy(CWnd *this, struct IAccessibleProxy *a2)
{
  *((_DWORD *)this + 10) = a2;
  return 0;
}


/* ==== 418EC4  sub_418EC4  ()  size=4 ==== */
int sub_418EC4()
{
  return 1;
}


/* ==== 418EC8  ?PreTranslateInput@CWnd@@QAEHPAUtagMSG@@@Z  (CWnd::PreTranslateInput(tagMSG *))  size=48 ==== */
int __thiscall CWnd::PreTranslateInput(CWnd *this, struct tagMSG *a2)
{
  UINT message; // eax

  message = a2->message;
  if ( (message < 0x100 || message > 0x109) && (message < 0x200 || message > 0x209) )
    return 0;
  else
    return CWnd::IsDialogMessageA(this, a2);
}


/* ==== 418EF8  ?ContinueModal@CWnd@@UAEHXZ  (CWnd::ContinueModal(void))  size=7 ==== */
int __thiscall CWnd::ContinueModal(CWnd *this)
{
  return *((_DWORD *)this + 14) & 0x10;
}


/* ==== 418EFF  ?_AfxInitCommonControls@@YGJPAUtagINITCOMMONCONTROLSEX@@J@Z  (_AfxInitCommonControls(tagINITCOMMONCONTROLSEX *,long))  size=120 ==== */
HMODULE __stdcall _AfxInitCommonControls(struct tagINITCOMMONCONTROLSEX *a1, int a2)
{
  HMODULE ModuleHandleA; // edi
  HMODULE result; // eax
  HMODULE v4; // ebx
  int v5; // esi
  BOOL (__stdcall *InitCommonControlsEx)(const INITCOMMONCONTROLSEX *); // eax

  ModuleHandleA = GetModuleHandleA("COMCTL32.DLL");
  result = LoadLibraryA("COMCTL32.DLL");
  v4 = result;
  if ( result )
  {
    v5 = 0;
    InitCommonControlsEx = (BOOL (__stdcall *)(const INITCOMMONCONTROLSEX *))GetProcAddress(
                                                                               result,
                                                                               "InitCommonControlsEx");
    if ( InitCommonControlsEx )
    {
      if ( InitCommonControlsEx(a1) )
      {
        v5 = a2;
        if ( !ModuleHandleA )
        {
          InitCommonControls();
          v5 = a2 | 0x3FC0;
        }
      }
    }
    else if ( (a2 & 0x3FC0) == a2 )
    {
      InitCommonControls();
      v5 = 16320;
    }
    FreeLibrary(v4);
    return (HMODULE)v5;
  }
  return result;
}


/* ==== 418F77  ?IsTracking@CFrameWnd@@QBEHXZ  (CFrameWnd::IsTracking(void))  size=31 ==== */
BOOL __thiscall CFrameWnd::IsTracking(CFrameWnd *this)
{
  int v1; // eax

  v1 = *((_DWORD *)this + 41);
  return v1 && v1 != 57346 && v1 != 57345;
}


/* ==== 418F96  ?CreateControlContainer@CWnd@@MAEHPAPAVCOleControlContainer@@@Z  (CWnd::CreateControlContainer(COleControlContainer * *))  size=13 ==== */
int __thiscall CWnd::CreateControlContainer(CWnd *this, struct COleControlContainer **a2)
{
  *a2 = 0;
  return 1;
}


/* ==== 418FA3  ?CreateControlSite@CWnd@@MAEHPAVCOleControlContainer@@PAPAVCOleControlSite@@IABU_GUID@@@Z  (CWnd::CreateControlSite(COleControlContainer *,COleControlSite * *,uint,_GUID const &))  size=13 ==== */
int __thiscall CWnd::CreateControlSite(
        CWnd *this,
        struct COleControlContainer *a2,
        struct COleControlSite **a3,
        unsigned int a4,
        const struct _GUID *a5)
{
  *a3 = 0;
  return 1;
}


/* ==== 418FB0  ??0CWnd@@QAE@XZ  (CWnd::CWnd(void))  size=67 ==== */
CWnd *__thiscall CWnd::CWnd(CWnd *this)
{
  CCmdTarget::CCmdTarget(this);
  *(_DWORD *)this = &CWnd::`vftable';
  *((_DWORD *)this + 11) = &CWnd::XAccessible::`vftable';
  *((_DWORD *)this + 12) = &CWnd::XAccessibleServer::`vftable';
  *((_DWORD *)this + 7) = 0;
  *((_BYTE *)this + 32) = 0;
  *((_DWORD *)this + 10) = 0;
  *((_DWORD *)this + 9) = 0;
  *((_DWORD *)this + 13) = 0;
  *((_DWORD *)this + 14) = 0;
  *((_DWORD *)this + 15) = 0;
  *((_DWORD *)this + 16) = 0;
  *((_DWORD *)this + 17) = 0;
  *((_DWORD *)this + 18) = 0;
  *((_DWORD *)this + 19) = 0;
  return this;
}


/* ==== 418FF3  ?_AfxPreInitDialog@@YGXPAVCWnd@@PAUtagRECT@@PAK@Z  (_AfxPreInitDialog(CWnd *,tagRECT *,ulong *))  size=35 ==== */
void __stdcall _AfxPreInitDialog(HWND *a1, LPRECT lpRect, unsigned int *a3)
{
  GetWindowRect(a1[7], lpRect);
  *a3 = CWnd::GetStyle((CWnd *)a1);
}


/* ==== 419016  ?CreateEx@CWnd@@UAEHKPBD0KABUtagRECT@@PAV1@IPAX@Z  (CWnd::CreateEx(ulong,char const *,char const *,ulong,tagRECT const &,CWnd *,uint,void *))  size=73 ==== */
int __thiscall CWnd::CreateEx(
        CWnd *this,
        unsigned int a2,
        const char *a3,
        const char *a4,
        unsigned int a5,
        const struct tagRECT *a6,
        struct CWnd *a7,
        unsigned int a8,
        void *a9)
{
  int v9; // edi

  if ( a7 )
    v9 = *((_DWORD *)a7 + 7);
  else
    v9 = 0;
  return (*(int (__thiscall **)(CWnd *, unsigned int, const char *, const char *, unsigned int, LONG, LONG, int, int, int, unsigned int, void *))(*(_DWORD *)this + 92))(
           this,
           a2,
           a3,
           a4,
           a5,
           a6->left,
           a6->top,
           a6->right - a6->left,
           a6->bottom - a6->top,
           v9,
           a8,
           a9);
}


/* ==== 41905F  unknown_libname_31  ()  size=78 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_31(void *this, int a2, int a3, int a4, _DWORD *a5, int a6, int a7, int a8)
{
  int v8; // edi

  if ( a6 )
    v8 = *(_DWORD *)(a6 + 28);
  else
    v8 = 0;
  return (*(int (__thiscall **)(void *, _DWORD, int, int, int, _DWORD, _DWORD, int, int, int, int, int))(*(_DWORD *)this + 92))(
           this,
           0,
           a2,
           a3,
           a4 | 0x40000000,
           *a5,
           a5[1],
           a5[2] - *a5,
           a5[3] - a5[1],
           v8,
           a7,
           a8);
}


/* ==== 4190AD  ?CancelToolTips@CWnd@@SGXH@Z  (CWnd::CancelToolTips(int))  size=81 ==== */
void __stdcall CWnd::CancelToolTips(int a1)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  int v2; // eax
  HWND v3; // eax
  int v4; // esi

  ModuleThreadState = AfxGetModuleThreadState();
  v2 = *((_DWORD *)ModuleThreadState + 15);
  if ( v2 )
  {
    v3 = *(HWND *)(v2 + 28);
    if ( v3 )
      SendMessageA(v3, 0x401u, 0, 0);
  }
  v4 = *((_DWORD *)ModuleThreadState + 31);
  if ( a1 && v4 && GetKeyState(1) >= 0 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v4 + 352))(v4, -1);
}


/* ==== 4190FE  ?_AfxFindPopupMenuFromID@@YGPAVCMenu@@PAV1@I@Z  (_AfxFindPopupMenuFromID(CMenu *,uint))  size=91 ==== */
struct CMenu *__stdcall _AfxFindPopupMenuFromID(HMENU *a1, unsigned int a2)
{
  int MenuItemCount; // ebx
  int i; // edi
  struct CMenu *SubMenu; // eax
  struct CMenu *result; // eax

  MenuItemCount = GetMenuItemCount(a1[1]);
  for ( i = 0; i < MenuItemCount; ++i )
  {
    SubMenu = CMenu::GetSubMenu(a1, i);
    if ( SubMenu )
    {
      result = _AfxFindPopupMenuFromID(SubMenu, a2);
      if ( result )
        return result;
    }
    else if ( GetMenuItemID(a1[1], i) == a2 )
    {
      return CMenu::FromHandlePermanent(a1[1]);
    }
  }
  return 0;
}


/* ==== 419159  ?WinHelpInternal@CWnd@@UAEXKI@Z  (CWnd::WinHelpInternal(ulong,uint))  size=81 ==== */
void __thiscall CWnd::WinHelpInternal(CWnd *this, unsigned int a2, unsigned int a3)
{
  unsigned int v4; // eax

  if ( *(_DWORD *)(*((_DWORD *)AfxGetModuleState() + 1) + 104) == 1 )
  {
    v4 = a3;
    switch ( a3 )
    {
      case 1u:
        v4 = 15;
        break;
      case 3u:
        v4 = 1;
        break;
      case 0xBu:
        v4 = 0;
        break;
    }
    (*(void (__thiscall **)(CWnd *, unsigned int, unsigned int))(*(_DWORD *)this + 120))(this, a2, v4);
  }
  else
  {
    (*(void (__thiscall **)(CWnd *, unsigned int, unsigned int))(*(_DWORD *)this + 116))(this, a2, a3);
  }
}


/* ==== 4191AA  ?OnActivateTopLevel@CWnd@@IAEJIJ@Z  (CWnd::OnActivateTopLevel(uint,long))  size=31 ==== */
int __thiscall CWnd::OnActivateTopLevel(CWnd *this, __int16 a2, int a3)
{
  if ( !a2 && (*((_BYTE *)AfxGetModuleThreadState() + 79) & 0x40) == 0 )
    CWnd::CancelToolTips(1);
  return 0;
}


/* ==== 4191D6  ?UpdateData@CWnd@@QAEHH@Z  (CWnd::UpdateData(int))  size=158 ==== */
int __thiscall CWnd::UpdateData(CWnd *this, int a2)
{
  struct _AFX_THREAD_STATE *ThreadState; // edi
  int v4; // eax
  int v6; // [esp+0h] [ebp-3Ch] BYREF
  _DWORD v7[4]; // [esp+10h] [ebp-2Ch] BYREF
  int v8; // [esp+24h] [ebp-18h]
  struct _AFX_THREAD_STATE *v9; // [esp+28h] [ebp-14h]
  int *v10; // [esp+2Ch] [ebp-10h]
  int v11; // [esp+38h] [ebp-4h]

  v10 = &v6;
  v7[0] = a2;
  v7[1] = this;
  v7[2] = 0;
  ThreadState = AfxGetThreadState();
  v8 = *((_DWORD *)ThreadState + 55);
  *((_DWORD *)ThreadState + 55) = *((_DWORD *)this + 7);
  v4 = *(_DWORD *)this;
  v9 = ThreadState;
  v11 = 0;
  (*(void (__thiscall **)(CWnd *, _DWORD *))(v4 + 244))(this, v7);
  *((_DWORD *)ThreadState + 55) = v8;
  return 1;
}


/* ==== 419274  ?CenterWindow@CWnd@@QAEXPAV1@@Z  (CWnd::CenterWindow(CWnd *))  size=437 ==== */
void __thiscall CWnd::CenterWindow(HWND *this, struct CWnd *a2)
{
  HWND v3; // edi
  HWND Parent; // eax
  LRESULT v5; // eax
  LONG WindowLongA; // eax
  HWND MainWnd; // eax
  HMONITOR v8; // eax
  HMONITOR v9; // eax
  HWND v10; // ebx
  LONG left; // ecx
  LONG top; // esi
  struct tagMONITORINFO v13; // [esp+Ch] [ebp-60h] BYREF
  struct tagRECT rcDst; // [esp+34h] [ebp-38h] BYREF
  struct tagRECT Rect; // [esp+44h] [ebp-28h] BYREF
  struct tagRECT v16; // [esp+54h] [ebp-18h] BYREF
  CWnd *v17; // [esp+64h] [ebp-8h]
  unsigned int Style; // [esp+68h] [ebp-4h]

  v17 = (CWnd *)this;
  Style = CWnd::GetStyle((CWnd *)this);
  if ( a2 )
  {
    v3 = (HWND)*((_DWORD *)a2 + 7);
  }
  else
  {
    if ( (Style & 0x40000000) != 0 )
      Parent = GetParent(this[7]);
    else
      Parent = GetWindow(this[7], 4u);
    v3 = Parent;
    if ( Parent )
    {
      v5 = SendMessageA(Parent, 0x36Bu, 0, 0);
      if ( v5 )
        v3 = (HWND)v5;
    }
  }
  GetWindowRect(this[7], &Rect);
  if ( (Style & 0x40000000) != 0 )
  {
    v10 = GetParent(this[7]);
    GetClientRect(v10, &v16);
    GetClientRect(v3, &rcDst);
    MapWindowPoints(v3, v10, (LPPOINT)&rcDst, 2u);
  }
  else
  {
    if ( v3 )
    {
      WindowLongA = GetWindowLongA(v3, -16);
      if ( (WindowLongA & 0x10000000) == 0 || (WindowLongA & 0x20000000) != 0 )
        v3 = 0;
    }
    v13.cbSize = 40;
    if ( v3 )
    {
      GetWindowRect(v3, &rcDst);
      v9 = xMonitorFromWindow(v3, 2u);
      xGetMonitorInfo(v9, &v13);
      CopyRect(&v16, &v13.rcWork);
    }
    else
    {
      MainWnd = (HWND)AfxGetMainWnd();
      if ( MainWnd )
        MainWnd = (HWND)*((_DWORD *)MainWnd + 7);
      v8 = xMonitorFromWindow(MainWnd, 1u);
      xGetMonitorInfo(v8, &v13);
      CopyRect(&rcDst, &v13.rcWork);
      CopyRect(&v16, &v13.rcWork);
    }
  }
  left = (rcDst.right + rcDst.left) / 2 - (Rect.right - Rect.left) / 2;
  top = (rcDst.bottom + rcDst.top) / 2 - (Rect.bottom - Rect.top) / 2;
  if ( left >= v16.left )
  {
    if ( left + Rect.right - Rect.left > v16.right )
      left = Rect.left + v16.right - Rect.right;
  }
  else
  {
    left = v16.left;
  }
  if ( top >= v16.top )
  {
    if ( top + Rect.bottom - Rect.top > v16.bottom )
      top = v16.bottom + Rect.top - Rect.bottom;
  }
  else
  {
    top = v16.top;
  }
  CWnd::SetWindowPos(v17, 0, left, top, -1, -1, 0x15u);
}


/* ==== 419429  ?RunModalLoop@CWnd@@QAEHK@Z  (CWnd::RunModalLoop(ulong))  size=335 ==== */
HWND __thiscall CWnd::RunModalLoop(HWND *this, char a2)
{
  int v2; // ebx
  HWND Parent; // eax
  UINT message; // eax
  LPARAM lParam; // [esp+10h] [ebp-10h]
  int v9; // [esp+14h] [ebp-Ch]
  LPMSG lpMsg; // [esp+18h] [ebp-8h]
  HWND hWnd; // [esp+1Ch] [ebp-4h]

  v2 = 1;
  v9 = 1;
  lParam = 0;
  if ( (a2 & 4) == 0 || (CWnd::GetStyle((CWnd *)this) & 0x10000000) != 0 )
    v2 = 0;
  Parent = GetParent(this[7]);
  this[14] = (HWND)((unsigned int)this[14] | 0x18);
  hWnd = Parent;
  lpMsg = AfxGetCurrentMessage();
LABEL_15:
  while ( v9 && !PeekMessageA(lpMsg, 0, 0, 0, 0) )
  {
    if ( v2 )
    {
      CWnd::ShowWindow((CWnd *)this, 1);
      UpdateWindow(this[7]);
      v2 = 0;
    }
    if ( (a2 & 1) == 0 && hWnd && !lParam )
      SendMessageA(hWnd, 0x121u, 0, (LPARAM)this[7]);
    if ( (a2 & 2) == 0 )
    {
      if ( SendMessageA(this[7], 0x36Au, 0, lParam++) )
        continue;
    }
    v9 = 0;
  }
  while ( 1 )
  {
    if ( !AfxPumpMessage() )
    {
      AfxPostQuitMessage(0);
      return HWND_MESSAGE|0x2;
    }
    if ( v2 )
    {
      message = lpMsg->message;
      if ( message == 280 || message == 260 )
      {
        CWnd::ShowWindow((CWnd *)this, 1);
        UpdateWindow(this[7]);
        v2 = 0;
      }
    }
    if ( !(*((int (__thiscall **)(HWND *))*this + 32))(this) )
      break;
    if ( AfxIsIdleMessage(lpMsg) )
    {
      v9 = 1;
      lParam = 0;
    }
    if ( !PeekMessageA(lpMsg, 0, 0, 0, 0) )
      goto LABEL_15;
  }
  this[14] = (HWND)((unsigned int)this[14] & 0xFFFFFFE7);
  return this[16];
}


/* ==== 419578  ?EndModalLoop@CWnd@@UAEXH@Z  (CWnd::EndModalLoop(int))  size=37 ==== */
void __thiscall CWnd::EndModalLoop(CWnd *this, int a2)
{
  int v2; // eax

  *((_DWORD *)this + 16) = a2;
  v2 = *((_DWORD *)this + 14);
  if ( (v2 & 0x10) != 0 )
  {
    *((_DWORD *)this + 14) = v2 & 0xFFFFFFEF;
    PostMessageA(*((HWND *)this + 7), 0, 0, 0);
  }
}


/* ==== 41959D  unknown_libname_33  ()  size=65 ==== */
// MFC 3.1-14.0 32bit
int __stdcall unknown_libname_33(WNDCLASSA *lpWndClass, const CHAR *a2, unsigned __int16 a3)
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  HICON IconA; // eax

  lpWndClass->lpszClassName = a2;
  ModuleState = AfxGetModuleState();
  IconA = LoadIconA(*((HINSTANCE *)ModuleState + 3), (LPCSTR)a3);
  lpWndClass->hIcon = IconA;
  if ( !IconA )
    lpWndClass->hIcon = LoadIconA(0, (LPCSTR)0x7F00);
  return AfxRegisterClass(lpWndClass);
}


/* ==== 4195DE  ?AfxEndDeferRegisterClass@@YGHJ@Z  (AfxEndDeferRegisterClass(long))  size=719 ==== */
BOOL __stdcall AfxEndDeferRegisterClass(int a1)
{
  int v2; // esi
  struct AFX_MODULE_STATE *v3; // ecx
  WNDCLASSA WndClass; // [esp+0h] [ebp-34h] BYREF
  tagINITCOMMONCONTROLSEX v5; // [esp+28h] [ebp-Ch] BYREF
  struct AFX_MODULE_STATE *ModuleState; // [esp+30h] [ebp-4h]
  int v7; // [esp+3Ch] [ebp+8h]

  ModuleState = AfxGetModuleState();
  v7 = ~*((_DWORD *)ModuleState + 6) & a1;
  if ( !v7 )
    return 1;
  v2 = 0;
  memset(&WndClass, 0, sizeof(WndClass));
  WndClass.lpfnWndProc = DefWindowProcA;
  WndClass.hInstance = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 2);
  WndClass.hCursor = (HCURSOR)dword_42FE40;
  v5.dwSize = 8;
  if ( (v7 & 1) != 0 )
  {
    WndClass.style = 11;
    WndClass.lpszClassName = "AfxWnd70s";
    v2 = AfxRegisterClass(&WndClass) != 0;
  }
  if ( (v7 & 0x20) != 0 )
  {
    LOBYTE(WndClass.style) |= 0x8Bu;
    WndClass.lpszClassName = "AfxOleControl70s";
    if ( AfxRegisterClass(&WndClass) )
      v2 |= 0x20u;
  }
  if ( (v7 & 2) != 0 )
  {
    WndClass.style = 0;
    WndClass.lpszClassName = "AfxControlBar70s";
    WndClass.hbrBackground = (HBRUSH)16;
    if ( AfxRegisterClass(&WndClass) )
      v2 |= 2u;
  }
  if ( (v7 & 4) != 0 )
  {
    WndClass.style = 8;
    WndClass.hbrBackground = 0;
    if ( unknown_libname_33(&WndClass, "AfxMDIFrame70s", 0x7A01u) )
      v2 |= 4u;
  }
  if ( (v7 & 8) != 0 )
  {
    WndClass.style = 11;
    WndClass.hbrBackground = (HBRUSH)6;
    if ( unknown_libname_33(&WndClass, "AfxFrameOrView70s", 0x7A02u) )
      v2 |= 8u;
  }
  if ( (v7 & 0x10) != 0 )
  {
    v5.dwICC = 255;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 16320);
    LOWORD(v7) = v7 & 0xC03F;
  }
  if ( (v7 & 0x40) != 0 )
  {
    v5.dwICC = 16;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 64);
  }
  if ( (v7 & 0x80u) != 0 )
  {
    v5.dwICC = 2;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 128);
  }
  if ( (v7 & 0x100) != 0 )
  {
    v5.dwICC = 8;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 256);
  }
  if ( (v7 & 0x200) != 0 )
  {
    v5.dwICC = 32;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 512);
  }
  if ( (v7 & 0x400) != 0 )
  {
    v5.dwICC = 1;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 1024);
  }
  if ( (v7 & 0x800) != 0 )
  {
    v5.dwICC = 64;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 2048);
  }
  if ( (v7 & 0x1000) != 0 )
  {
    v5.dwICC = 4;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 4096);
  }
  if ( (v7 & 0x2000) != 0 )
  {
    v5.dwICC = 128;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x2000);
  }
  if ( (v7 & 0x4000) != 0 )
  {
    v5.dwICC = 2048;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x4000);
  }
  if ( (v7 & 0x8000) != 0 )
  {
    v5.dwICC = 1024;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x8000);
  }
  if ( (v7 & 0x10000) != 0 )
  {
    v5.dwICC = 512;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x10000);
  }
  if ( (v7 & 0x20000) != 0 )
  {
    v5.dwICC = 256;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x20000);
  }
  if ( (v7 & 0x40000) != 0 )
  {
    v5.dwICC = 0x8000;
    v2 |= (unsigned int)_AfxInitCommonControls(&v5, 0x40000);
  }
  v3 = ModuleState;
  *((_DWORD *)ModuleState + 6) |= v2;
  if ( (*((_DWORD *)v3 + 6) & 0x3FC0) == 0x3FC0 )
  {
    *((_DWORD *)v3 + 6) |= 0x10u;
    v2 |= 0x10u;
  }
  return (v7 & v2) == v7;
}


/* ==== 4198AD  ?GetCurrentMessage@CWnd@@KGPBUtagMSG@@XZ  (CWnd::GetCurrentMessage(void))  size=53 ==== */
const struct tagMSG *__stdcall CWnd::GetCurrentMessage()
{
  struct CNoTrackObject *Data; // esi
  DWORD MessagePos; // eax

  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  *((_DWORD *)Data + 26) = GetMessageTime();
  MessagePos = GetMessagePos();
  *((_DWORD *)Data + 28) = SHIWORD(MessagePos);
  *((_DWORD *)Data + 27) = (__int16)MessagePos;
  return (const struct tagMSG *)((char *)Data + 88);
}


/* ==== 4198E2  ?Default@CWnd@@IAEJXZ  (CWnd::Default(void))  size=39 ==== */
int __thiscall CWnd::Default(CWnd *this)
{
  struct CNoTrackObject *Data; // eax

  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  return (*(int (__thiscall **)(CWnd *, _DWORD, _DWORD, _DWORD))(*(_DWORD *)this + 272))(
           this,
           *((_DWORD *)Data + 23),
           *((_DWORD *)Data + 24),
           *((_DWORD *)Data + 25));
}


/* ==== 419909  ?afxMapHWND@@YGPAVCHandleMap@@H@Z  (afxMapHWND(int))  size=124 ==== */
struct CHandleMap *__stdcall afxMapHWND(void *Block)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  void (__noreturn *v2)(); // ebx
  CHandleMap *v3; // ecx
  CHandleMap *v4; // eax

  ModuleThreadState = AfxGetModuleThreadState();
  if ( !*((_DWORD *)ModuleThreadState + 5) && Block )
  {
    v2 = AfxSetNewHandler((void (__noreturn *)())AfxCriticalNewHandler);
    v3 = (CHandleMap *)operator new(0x60u);
    if ( v3 )
      v4 = CHandleMap::CHandleMap(
             v3,
             (struct CRuntimeClass *)&off_425D14,
             (void (__stdcall *)(struct CObject *))ConstructDestruct<CWnd>::Construct,
             unknown_libname_48,
             0x1Cu,
             1);
    else
      v4 = 0;
    *((_DWORD *)ModuleThreadState + 5) = v4;
    AfxSetNewHandler(v2);
  }
  return (struct CHandleMap *)*((_DWORD *)ModuleThreadState + 5);
}


/* ==== 419985  ?FromHandle@CWnd@@SGPAV1@PAUHWND__@@@Z  (CWnd::FromHandle(HWND__ *))  size=39 ==== */
struct CWnd *__stdcall CWnd::FromHandle(HWND a1)
{
  CHandleMap *v1; // esi
  CWnd *v2; // edi

  v1 = afxMapHWND((void *)1);
  v2 = CHandleMap::FromHandle(v1, a1);
  CWnd::AttachControlSite(v2, v1);
  return v2;
}


/* ==== 4199AC  ?FromHandlePermanent@CWnd@@SGPAV1@PAUHWND__@@@Z  (CWnd::FromHandlePermanent(HWND__ *))  size=26 ==== */
struct CWnd *__stdcall CWnd::FromHandlePermanent(unsigned int a1)
{
  struct CHandleMap *v1; // ecx
  struct CWnd *result; // eax

  v1 = afxMapHWND(0);
  result = 0;
  if ( v1 )
    return (struct CWnd *)CMapPtrToPtr::GetValueAt((struct CHandleMap *)((char *)v1 + 28), a1);
  return result;
}


/* ==== 4199C6  ?Attach@CWnd@@QAEHPAUHWND__@@@Z  (CWnd::Attach(HWND__ *))  size=57 ==== */
int __thiscall CWnd::Attach(CWnd *this, HWND a2)
{
  struct CHandleMap *v4; // edi

  if ( !a2 )
    return 0;
  v4 = afxMapHWND((void *)1);
  *((_DWORD *)this + 7) = a2;
  *(_DWORD *)sub_4178C6((struct CHandleMap *)((char *)v4 + 28), (unsigned int)a2) = this;
  CWnd::AttachControlSite(this, v4);
  return 1;
}


/* ==== 4199FF  ?Detach@CWnd@@QAEPAUHWND__@@XZ  (CWnd::Detach(void))  size=46 ==== */
int __thiscall CWnd::Detach(CWnd *this)
{
  int v2; // edi
  struct CHandleMap *v3; // eax

  v2 = *((_DWORD *)this + 7);
  if ( v2 )
  {
    v3 = afxMapHWND(0);
    if ( v3 )
      sub_417785((_DWORD *)v3 + 7, *((_DWORD *)this + 7));
    *((_DWORD *)this + 7) = 0;
  }
  *((_DWORD *)this + 19) = 0;
  return v2;
}


/* ==== 419A2D  ?AfxUnhookWindowCreate@@YGHXZ  (AfxUnhookWindowCreate(void))  size=66 ==== */
int __stdcall AfxUnhookWindowCreate()
{
  struct CNoTrackObject *Data; // esi

  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  if ( *((_BYTE *)AfxGetModuleState() + 20) && *((_DWORD *)Data + 10) )
  {
    UnhookWindowsHookEx(*((HHOOK *)Data + 10));
    *((_DWORD *)Data + 10) = 0;
  }
  if ( !*((_DWORD *)Data + 5) )
    return 1;
  *((_DWORD *)Data + 5) = 0;
  return 0;
}


/* ==== 419A6F  sub_419A6F  ()  size=32 ==== */
int __stdcall sub_419A6F(int a1)
{
  if ( !*(_DWORD *)(a1 + 40) )
  {
    AfxEndDeferRegisterClass(1);
    *(_DWORD *)(a1 + 40) = "AfxWnd70s";
  }
  return 1;
}


/* ==== 419A8F  ?OnDestroy@CWnd@@IAEXXZ  (CWnd::OnDestroy(void))  size=59 ==== */
void __thiscall CWnd::OnDestroy(CWnd *this)
{
  int v2; // ecx
  int v3; // eax
  int v4; // eax

  v2 = *((_DWORD *)this + 18);
  if ( v2 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v2 + 4))(v2, 1);
  v3 = *((_DWORD *)this + 10);
  *((_DWORD *)this + 18) = 0;
  if ( v3 )
    (*(void (__stdcall **)(int, _DWORD, _DWORD))(*(_DWORD *)v3 + 12))(v3, 0, 0);
  v4 = *((_DWORD *)this + 9);
  if ( v4 )
    (*(void (__stdcall **)(_DWORD))(*(_DWORD *)v4 + 8))(*((_DWORD *)this + 9));
  CWnd::Default(this);
}


/* ==== 419ACA  ?OnNcDestroy@CWnd@@IAEXXZ  (CWnd::OnNcDestroy(void))  size=273 ==== */
void __thiscall CWnd::OnNcDestroy(CWnd *this)
{
  struct CWinThread *Thread; // eax
  struct CWinThread *v3; // edi
  int v4; // ecx
  int v5; // ecx
  int v6; // edi
  LONG WindowLongA; // ebx
  LONG v8; // eax
  HWND v9; // [esp-10h] [ebp-4Ch]
  LPARAM lParam[12]; // [esp+Ch] [ebp-30h] BYREF

  Thread = AfxGetThread();
  v3 = Thread;
  if ( Thread )
  {
    if ( *((CWnd **)Thread + 7) == this )
    {
      if ( !*((_BYTE *)AfxGetModuleState() + 20)
        && (v3 != *((struct CWinThread **)AfxGetModuleState() + 1) || AfxOleCanExitApp()) )
      {
        AfxPostQuitMessage(0);
      }
      *((_DWORD *)v3 + 7) = 0;
    }
    if ( *((CWnd **)v3 + 8) == this )
      *((_DWORD *)v3 + 8) = 0;
  }
  v4 = *((_DWORD *)this + 17);
  if ( v4 )
  {
    (*(void (__thiscall **)(int))(*(_DWORD *)v4 + 80))(v4);
    *((_DWORD *)this + 17) = 0;
  }
  v5 = *((_DWORD *)this + 18);
  if ( v5 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v5 + 4))(v5, 1);
  *((_DWORD *)this + 18) = 0;
  if ( (*((_BYTE *)this + 56) & 1) != 0 )
  {
    v6 = *((_DWORD *)AfxGetModuleThreadState() + 15);
    if ( v6 )
    {
      if ( *(_DWORD *)(v6 + 28) )
      {
        memset(lParam, 0, sizeof(lParam));
        lParam[2] = *((_DWORD *)this + 7);
        lParam[3] = lParam[2];
        v9 = *(HWND *)(v6 + 28);
        lParam[0] = 40;
        lParam[1] = 1;
        SendMessageA(v9, 0x405u, 0, (LPARAM)lParam);
      }
    }
  }
  WindowLongA = GetWindowLongA(*((HWND *)this + 7), -4);
  CWnd::Default(this);
  if ( GetWindowLongA(*((HWND *)this + 7), -4) == WindowLongA )
  {
    v8 = *(_DWORD *)(*(int (__thiscall **)(CWnd *))(*(_DWORD *)this + 240))(this);
    if ( v8 )
      SetWindowLongA(*((HWND *)this + 7), -4, v8);
  }
  CWnd::Detach(this);
  (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 276))(this);
}


/* ==== 419BDB  ?DestroyWindow@CWnd@@UAEHXZ  (CWnd::DestroyWindow(void))  size=84 ==== */
int __thiscall CWnd::DestroyWindow(CWnd *this)
{
  int v2; // edi
  struct CHandleMap *v4; // eax

  v2 = 0;
  if ( *((_DWORD *)this + 7) )
  {
    v4 = afxMapHWND(0);
    CMapPtrToPtr::GetValueAt((struct CHandleMap *)((char *)v4 + 28), *((_DWORD *)this + 7));
  }
  else if ( !*((_DWORD *)this + 19) )
  {
    return 0;
  }
  if ( *((_DWORD *)this + 7) || *((_DWORD *)this + 19) )
  {
    if ( *((_DWORD *)this + 19) )
      return (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 19) + 88))(*((_DWORD *)this + 19));
    else
      return DestroyWindow(*((HWND *)this + 7));
  }
  return v2;
}


/* ==== 419C2F  ?OnNTCtlColor@CWnd@@IAEJIJ@Z  (CWnd::OnNTCtlColor(uint,long))  size=70 ==== */
int __thiscall CWnd::OnNTCtlColor(CWnd *this, unsigned int a2, int a3)
{
  _DWORD v5[3]; // [esp+4h] [ebp-Ch] BYREF

  v5[1] = a2;
  v5[0] = a3;
  v5[2] = *((_DWORD *)CThreadLocalObject::GetData(
                        (CThreadLocalObject *)&unk_42E340,
                        CThreadLocal<_AFX_THREAD_STATE>::CreateObject)
          + 23)
        - 306;
  return (*(int (__thiscall **)(CWnd *, int, _DWORD, _DWORD *))(*(_DWORD *)this + 264))(this, 25, 0, v5);
}


/* ==== 419C75  ?GetDescendantWindow@CWnd@@SGPAV1@PAUHWND__@@HH@Z  (CWnd::GetDescendantWindow(HWND__ *,int,int))  size=119 ==== */
struct CWnd *__stdcall CWnd::GetDescendantWindow(HWND hDlg, int nIDDlgItem, int a3)
{
  HWND DlgItem; // eax
  HWND v4; // esi
  struct CWnd *result; // eax
  HWND v6; // esi

  DlgItem = GetDlgItem(hDlg, nIDDlgItem);
  v4 = DlgItem;
  if ( !DlgItem )
    goto LABEL_7;
  if ( !GetTopWindow(DlgItem) || (result = CWnd::GetDescendantWindow(v4, nIDDlgItem, a3)) == 0 )
  {
    if ( !a3 )
      return CWnd::FromHandle(v4);
    result = CWnd::FromHandlePermanent((unsigned int)v4);
    if ( !result )
    {
LABEL_7:
      for ( result = (struct CWnd *)GetTopWindow(hDlg); ; result = (struct CWnd *)GetWindow(v6, 2u) )
      {
        v6 = (HWND)result;
        if ( !result )
          break;
        result = CWnd::GetDescendantWindow((HWND)result, nIDDlgItem, a3);
        if ( result )
          break;
      }
    }
  }
  return result;
}


/* ==== 419CEC  ?WalkPreTranslateTree@CWnd@@SGHPAUHWND__@@PAUtagMSG@@@Z  (CWnd::WalkPreTranslateTree(HWND__ *,tagMSG *))  size=66 ==== */
int __stdcall CWnd::WalkPreTranslateTree(HWND a1, struct tagMSG *a2)
{
  HWND i; // esi
  struct CWnd *v3; // eax

  for ( i = a2->hwnd; ; i = GetParent(i) )
  {
    if ( !i )
      return 0;
    v3 = CWnd::FromHandlePermanent((unsigned int)i);
    if ( v3 )
    {
      if ( (*(int (__thiscall **)(struct CWnd *, struct tagMSG *))(*(_DWORD *)v3 + 256))(v3, a2) )
        break;
    }
    if ( i == a1 )
      return 0;
  }
  return 1;
}


/* ==== 419D2E  ?SendChildNotifyLastMsg@CWnd@@QAEHPAJ@Z  (CWnd::SendChildNotifyLastMsg(long *))  size=45 ==== */
int __thiscall CWnd::SendChildNotifyLastMsg(CWnd *this, int *a2)
{
  struct CNoTrackObject *Data; // eax

  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  return (*(int (__thiscall **)(CWnd *, _DWORD, _DWORD, _DWORD, int *))(*(_DWORD *)this + 280))(
           this,
           *((_DWORD *)Data + 23),
           *((_DWORD *)Data + 24),
           *((_DWORD *)Data + 25),
           a2);
}


/* ==== 419D5B  ?OnSetFocus@CWnd@@IAEXPAV1@@Z  (CWnd::OnSetFocus(CWnd *))  size=35 ==== */
void __thiscall CWnd::OnSetFocus(CWnd *this, struct CWnd *a2)
{
  if ( !*((_DWORD *)this + 18)
    || !(*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 18) + 144))(*((_DWORD *)this + 18)) )
  {
    CWnd::Default(this);
  }
}


/* ==== 419D7E  ?OnHelpInfo@CWnd@@IAEHPAUtagHELPINFO@@@Z  (CWnd::OnHelpInfo(tagHELPINFO *))  size=106 ==== */
BOOL __thiscall CWnd::OnHelpInfo(CWnd *this, struct tagHELPINFO *a2)
{
  struct CWnd *MainWnd; // esi

  if ( (CWnd::GetStyle(this) & 0x40000000) != 0 )
    return CWnd::Default(this) != 0;
  MainWnd = AfxGetMainWnd();
  if ( !MainWnd || GetKeyState(16) < 0 || GetKeyState(17) < 0 || GetKeyState(18) < 0 )
    return CWnd::Default(this) != 0;
  SendMessageA(*((HWND *)MainWnd + 7), 0x111u, 0xE146u, 0);
  return 1;
}


/* ==== 419DE8  ?OnGetObject@CWnd@@IAEJIJ@Z  (CWnd::OnGetObject(uint,long))  size=58 ==== */
int __thiscall CWnd::OnGetObject(CWnd *this, unsigned int a2, int a3)
{
  int v4; // eax
  int v6; // [esp+4h] [ebp-4h] BYREF

  if ( *((_BYTE *)this + 32)
    && (v4 = *(_DWORD *)this,
        v6 = 0,
        (*(int (__thiscall **)(CWnd *, unsigned int, int, int *))(v4 + 228))(this, a2, a3, &v6) >= 0) )
  {
    return v6;
  }
  else
  {
    return CWnd::Default(this);
  }
}


/* ==== 419E22  sub_419E22  ()  size=33 ==== */
// ?OnVScroll@CWnd@@IAEXIIPAVCScrollBar@@@Z
// doubtful name
int __thiscall sub_419E22(CWnd *this, int a2, int a3, CWnd *a4)
{
  int result; // eax

  if ( !a4 )
    return CWnd::Default(this);
  result = CWnd::SendChildNotifyLastMsg(a4, 0);
  if ( !result )
    return CWnd::Default(this);
  return result;
}


/* ==== 419E43  ?OnEnterIdle@CWnd@@IAEXIPAV1@@Z  (CWnd::OnEnterIdle(uint,CWnd *))  size=64 ==== */
void __thiscall CWnd::OnEnterIdle(CWnd *this, unsigned int a2, struct CWnd *a3)
{
  MSG Msg; // [esp+Ch] [ebp-1Ch] BYREF

  while ( PeekMessageA(&Msg, 0, 0x121u, 0x121u, 1u) )
    DispatchMessageA(&Msg);
  CWnd::Default(this);
}


/* ==== 419E83  ?OnCtlColor@CWnd@@IAEPAUHBRUSH__@@PAVCDC@@PAV1@I@Z  (CWnd::OnCtlColor(CDC *,CWnd *,uint))  size=39 ==== */
struct CWnd *__thiscall CWnd::OnCtlColor(CWnd *this, struct CDC *a2, struct CWnd *a3, unsigned int a4)
{
  if ( CWnd::SendChildNotifyLastMsg(a3, (int *)&a3) )
    return a3;
  else
    return (struct CWnd *)CWnd::Default(this);
}


/* ==== 419EAA  ?_AfxPostInitDialog@@YGXPAVCWnd@@ABUtagRECT@@K@Z  (_AfxPostInitDialog(CWnd *,tagRECT const &,ulong))  size=121 ==== */
void __stdcall _AfxPostInitDialog(HWND *a1, const struct tagRECT *a2, int a3)
{
  HWND Window; // eax
  CWnd *v4; // eax
  struct tagRECT Rect; // [esp+0h] [ebp-10h] BYREF

  if ( (a3 & 0x10000000) == 0 && (CWnd::GetStyle((CWnd *)a1) & 0x50000000) == 0 )
  {
    GetWindowRect(a1[7], &Rect);
    if ( a2->left == Rect.left && a2->top == Rect.top )
    {
      Window = GetWindow(a1[7], 4u);
      v4 = CWnd::FromHandle(Window);
      if ( !v4 || !CWnd::IsWindowEnabled(v4) )
      {
        if ( (*((int (__thiscall **)(HWND *))*a1 + 71))(a1) )
          CWnd::CenterWindow(a1, 0);
      }
    }
  }
}


/* ==== 419F23  ?AfxCallWndProc@@YGJPAVCWnd@@PAUHWND__@@IIJ@Z  (AfxCallWndProc(CWnd *,HWND__ *,uint,uint,long))  size=237 ==== */
int __stdcall AfxCallWndProc(struct CWnd *a1, HWND a2, unsigned int a3, unsigned int a4, int a5)
{
  struct CNoTrackObject *Data; // ebx
  unsigned int v6; // esi
  struct CWnd *v7; // edi
  int result; // eax
  int v9; // [esp+0h] [ebp-4Ch] BYREF
  _BYTE v10[28]; // [esp+Ch] [ebp-40h] BYREF
  struct tagRECT Rect; // [esp+28h] [ebp-24h] BYREF
  struct CNoTrackObject *v12; // [esp+38h] [ebp-14h]
  int *v13; // [esp+3Ch] [ebp-10h]
  int v14; // [esp+48h] [ebp-4h]

  v13 = &v9;
  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  qmemcpy(v10, (char *)Data + 88, sizeof(v10));
  v6 = a3;
  v7 = a1;
  *((_DWORD *)Data + 22) = a2;
  *((_DWORD *)Data + 24) = a4;
  *((_DWORD *)Data + 25) = a5;
  v12 = Data;
  *((_DWORD *)Data + 23) = v6;
  v14 = 0;
  if ( v6 == 2 && *((_DWORD *)v7 + 18) )
    (*(void (__thiscall **)(_DWORD, _DWORD))(**((_DWORD **)v7 + 18) + 96))(*((_DWORD *)v7 + 18), 0);
  a1 = 0;
  if ( v6 == 272 )
    _AfxPreInitDialog((HWND *)v7, &Rect, (unsigned int *)&a1);
  a5 = (*(int (__thiscall **)(struct CWnd *, unsigned int, unsigned int, int))(*(_DWORD *)v7 + 264))(v7, v6, a4, a5);
  if ( v6 == 272 )
    _AfxPostInitDialog((HWND *)v7, &Rect, (int)a1);
  result = a5;
  qmemcpy((char *)Data + 88, v10, 0x1Cu);
  return result;
}


/* ==== 41A010  ?AfxWndProc@@YGJPAUHWND__@@IIJ@Z  (AfxWndProc(HWND__ *,uint,uint,long))  size=75 ==== */
LRESULT __stdcall AfxWndProc(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam)
{
  HWND *v5; // eax

  if ( Msg == 864 )
    return 1;
  v5 = (HWND *)CWnd::FromHandlePermanent((unsigned int)hWnd);
  if ( v5 && v5[7] == hWnd )
    return AfxCallWndProc((struct CWnd *)v5, hWnd, Msg, wParam, lParam);
  else
    return DefWindowProcA(hWnd, Msg, wParam, lParam);
}


/* ==== 41A05B  ??1CWnd@@UAE@XZ  (CWnd::~CWnd(void))  size=124 ==== */
void __thiscall CWnd::~CWnd(CWnd *this)
{
  int v2; // ecx
  int v3; // eax

  *(_DWORD *)this = &CWnd::`vftable';
  if ( *((_DWORD *)this + 7)
    && this != (CWnd *)&unk_42FCB0
    && this != (CWnd *)&unk_42FD00
    && this != (CWnd *)&unk_42FD50
    && this != (CWnd *)&unk_42FDA0 )
  {
    CWnd::DestroyWindow(this);
  }
  v2 = *((_DWORD *)this + 18);
  if ( v2 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v2 + 4))(v2, 1);
  v3 = *((_DWORD *)this + 19);
  if ( v3 && *(CWnd **)(v3 + 36) == this )
    *(_DWORD *)(v3 + 36) = 0;
  CCmdTarget::~CCmdTarget(this);
}


/* ==== 41A0D7  sub_41A0D7  ()  size=43 ==== */
// ?OnVKeyToItem@CWnd@@IAEHIPAVCListBox@@I@Z
// doubtful name
CWnd *__thiscall sub_41A0D7(CWnd *this, int a2, CWnd *a3, int a4)
{
  if ( a3 && CWnd::SendChildNotifyLastMsg(a3, (int *)&a3) )
    return a3;
  else
    return (CWnd *)CWnd::Default(this);
}


/* ==== 41A102  ?OnMeasureItem@CWnd@@IAEXHPAUtagMEASUREITEMSTRUCT@@@Z  (CWnd::OnMeasureItem(int,tagMEASUREITEMSTRUCT *))  size=120 ==== */
void __thiscall CWnd::OnMeasureItem(HWND *this, int a2, struct tagMEASUREITEMSTRUCT *a3)
{
  struct CNoTrackObject *Data; // eax
  struct CMenu *v5; // eax
  struct CMenu *PopupMenuFromID; // eax
  CWnd *DescendantWindow; // eax
  HMENU Menu; // [esp-4h] [ebp-Ch]

  if ( a3->CtlType == 1 )
  {
    Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
    if ( *((HWND *)Data + 29) == this[7] )
    {
      v5 = CMenu::FromHandle(*((HMENU *)Data + 30));
    }
    else
    {
      Menu = GetMenu(this[7]);
      v5 = CMenu::FromHandle(Menu);
    }
    PopupMenuFromID = _AfxFindPopupMenuFromID((HMENU *)v5, a3->itemID);
    if ( PopupMenuFromID )
      (*(void (__thiscall **)(struct CMenu *, struct tagMEASUREITEMSTRUCT *))(*(_DWORD *)PopupMenuFromID + 16))(
        PopupMenuFromID,
        a3);
    goto LABEL_9;
  }
  DescendantWindow = CWnd::GetDescendantWindow(this[7], a3->CtlID, 1);
  if ( !DescendantWindow || !CWnd::SendChildNotifyLastMsg(DescendantWindow, 0) )
LABEL_9:
    CWnd::Default((CWnd *)this);
}


/* ==== 41A17A  ?GetParentFrame@CWnd@@QBEPAVCFrameWnd@@XZ  (CWnd::GetParentFrame(void))  size=63 ==== */
struct CFrameWnd *__thiscall CWnd::GetParentFrame(CWnd *this)
{
  HWND v1; // eax
  struct CFrameWnd *result; // eax
  HWND i; // eax
  struct CFrameWnd *v4; // esi

  if ( !this )
    return 0;
  v1 = (HWND)*((_DWORD *)this + 7);
  if ( !v1 )
    return 0;
  for ( i = GetParent(v1); ; i = GetParent(*((HWND *)v4 + 7)) )
  {
    result = CWnd::FromHandle(i);
    v4 = result;
    if ( !result )
      break;
    if ( (*(int (__thiscall **)(struct CFrameWnd *))(*(_DWORD *)result + 288))(result) )
      return v4;
  }
  return result;
}


/* ==== 41A1B9  ?GetTopLevelFrame@CWnd@@QBEPAVCFrameWnd@@XZ  (CWnd::GetTopLevelFrame(void))  size=65 ==== */
struct CFrameWnd *__thiscall CWnd::GetTopLevelFrame(CWnd *this)
{
  CWnd *ParentFrame; // esi
  CWnd *i; // ecx
  struct CFrameWnd *v4; // eax

  ParentFrame = this;
  if ( !this || !*((_DWORD *)this + 7) )
    return 0;
  if ( !(*(int (__thiscall **)(CWnd *))(*(_DWORD *)this + 288))(this) )
    ParentFrame = CWnd::GetParentFrame(ParentFrame);
  if ( ParentFrame )
  {
    for ( i = ParentFrame; ; i = v4 )
    {
      v4 = CWnd::GetParentFrame(i);
      if ( !v4 )
        break;
      ParentFrame = v4;
    }
  }
  return ParentFrame;
}


/* ==== 41A1FA  ?SendMessageToDescendants@CWnd@@SGXPAUHWND__@@IIJHH@Z  (CWnd::SendMessageToDescendants(HWND__ *,uint,uint,long,int,int))  size=125 ==== */
void __stdcall CWnd::SendMessageToDescendants(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam, int a5, int a6)
{
  HWND i; // eax
  HWND *v7; // eax
  HWND v8; // esi

  for ( i = GetTopWindow(hWnd); ; i = GetWindow(v8, 2u) )
  {
    v8 = i;
    if ( !i )
      break;
    if ( a6 )
    {
      v7 = (HWND *)CWnd::FromHandlePermanent((unsigned int)i);
      if ( v7 )
        AfxCallWndProc((struct CWnd *)v7, v7[7], Msg, wParam, lParam);
    }
    else
    {
      SendMessageA(i, Msg, wParam, lParam);
    }
    if ( a5 )
    {
      if ( GetTopWindow(v8) )
        CWnd::SendMessageToDescendants(v8, Msg, wParam, lParam, a5, a6);
    }
  }
}


/* ==== 41A277  ?ReflectLastMsg@CWnd@@KGHPAUHWND__@@PAJ@Z  (CWnd::ReflectLastMsg(HWND__ *,long *))  size=175 ==== */
struct CHandleMap *__stdcall CWnd::ReflectLastMsg(HWND hWnd, int *a2)
{
  struct CHandleMap *result; // eax
  CMapPtrToPtr *v3; // esi
  CWnd *ValueAt; // eax
  HWND Parent; // eax
  _DWORD *v6; // eax
  int v7; // eax
  void *v8; // esi
  int Msg; // eax
  BOOL v10; // esi
  _BYTE v11[28]; // [esp+0h] [ebp-5Ch] BYREF
  int v12; // [esp+1Ch] [ebp-40h]
  void *v13; // [esp+4Ch] [ebp-10h]
  int v14; // [esp+58h] [ebp-4h]

  result = afxMapHWND(0);
  if ( result )
  {
    v3 = (struct CHandleMap *)((char *)result + 28);
    ValueAt = (CWnd *)CMapPtrToPtr::GetValueAt((struct CHandleMap *)((char *)result + 28), (unsigned int)hWnd);
    if ( ValueAt )
    {
      return (struct CHandleMap *)CWnd::SendChildNotifyLastMsg(ValueAt, a2);
    }
    else
    {
      Parent = GetParent(hWnd);
      v6 = CMapPtrToPtr::GetValueAt(v3, (unsigned int)Parent);
      if ( v6
        && (v7 = v6[18]) != 0
        && (v8 = CMapPtrToPtr::GetValueAt((CMapPtrToPtr *)(v7 + 32), (unsigned int)hWnd)) != 0 )
      {
        CWnd::CWnd((CWnd *)v11, hWnd);
        v14 = 0;
        v13 = v8;
        Msg = CWnd::SendChildNotifyLastMsg((CWnd *)v11, a2);
        v12 = 0;
        v14 = -1;
        v10 = Msg != 0;
        CWnd::~CWnd((CWnd *)v11);
        return (struct CHandleMap *)v10;
      }
      else
      {
        return 0;
      }
    }
  }
  return result;
}


/* ==== 41A326  ?OnParentNotify@CWnd@@IAEXIJ@Z  (CWnd::OnParentNotify(uint,long))  size=45 ==== */
void __thiscall CWnd::OnParentNotify(CWnd *this, __int16 a2, HWND hWnd)
{
  if ( a2 != 1 && a2 != 2 || !CWnd::ReflectLastMsg(hWnd, 0) )
    CWnd::Default(this);
}


/* ==== 41A353  ?OnDragList@CWnd@@IAEJIJ@Z  (CWnd::OnDragList(uint,long))  size=42 ==== */
int __thiscall CWnd::OnDragList(CWnd *this, unsigned int a2, int a3)
{
  if ( CWnd::ReflectLastMsg(*(HWND *)(a3 + 4), &a3) )
    return a3;
  else
    return CWnd::Default(this);
}


/* ==== 41A37D  ?SubclassWindow@CWnd@@QAEHPAUHWND__@@@Z  (CWnd::SubclassWindow(HWND__ *))  size=66 ==== */
int __thiscall CWnd::SubclassWindow(CWnd *this, HWND hWnd)
{
  int result; // eax
  LONG *v4; // esi
  LONG v5; // eax

  result = CWnd::Attach(this, hWnd);
  if ( result )
  {
    (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 80))(this);
    v4 = (LONG *)(*(int (__thiscall **)(CWnd *))(*(_DWORD *)this + 240))(this);
    v5 = SetWindowLongA(hWnd, -4, (LONG)AfxWndProc);
    if ( !*v4 )
      *v4 = v5;
    return 1;
  }
  return result;
}


/* ==== 41A3BF  sub_41A3BF  ()  size=28 ==== */
CWnd *__thiscall sub_41A3BF(CWnd *Block, char a2)
{
  CWnd::~CWnd(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41A3DB  sub_41A3DB  ()  size=69 ==== */
int __thiscall sub_41A3DB(int this, int *a2)
{
  int WindowTextLengthA; // eax
  CHAR *v4; // eax
  int v6; // [esp-4h] [ebp-8h]

  if ( *(_DWORD *)(this + 76) )
    return (*(int (__thiscall **)(_DWORD, int *))(**(_DWORD **)(this + 76) + 140))(*(_DWORD *)(this + 76), a2);
  WindowTextLengthA = GetWindowTextLengthA(*(HWND *)(this + 28));
  v6 = WindowTextLengthA + 1;
  v4 = (CHAR *)sub_40989B(a2, WindowTextLengthA);
  GetWindowTextA(*(HWND *)(this + 28), v4, v6);
  return ATL::CSimpleStringT<char,0>::ReleaseBuffer((const char **)a2, (const char *)0xFFFFFFFF);
}


/* ==== 41A420  ?OnDrawItem@CWnd@@IAEXHPAUtagDRAWITEMSTRUCT@@@Z  (CWnd::OnDrawItem(int,tagDRAWITEMSTRUCT *))  size=61 ==== */
void __thiscall CWnd::OnDrawItem(CWnd *this, int a2, struct tagDRAWITEMSTRUCT *a3)
{
  struct CMenu *v4; // eax

  if ( a3->CtlType == 1 && (v4 = CMenu::FromHandlePermanent((HMENU)a3->hwndItem)) != 0 )
  {
    (*(void (__thiscall **)(struct CMenu *, struct tagDRAWITEMSTRUCT *))(*(_DWORD *)v4 + 12))(v4, a3);
  }
  else if ( !CWnd::ReflectLastMsg(a3->hwndItem, 0) )
  {
    CWnd::Default(this);
  }
}


/* ==== 41A45D  ?OnCompareItem@CWnd@@IAEHHPAUtagCOMPAREITEMSTRUCT@@@Z  (CWnd::OnCompareItem(int,tagCOMPAREITEMSTRUCT *))  size=42 ==== */
struct tagCOMPAREITEMSTRUCT *__thiscall CWnd::OnCompareItem(CWnd *this, int a2, struct tagCOMPAREITEMSTRUCT *a3)
{
  if ( CWnd::ReflectLastMsg(a3->hwndItem, (int *)&a3) )
    return a3;
  else
    return (struct tagCOMPAREITEMSTRUCT *)CWnd::Default(this);
}


/* ==== 41A487  ?OnDeleteItem@CWnd@@IAEXHPAUtagDELETEITEMSTRUCT@@@Z  (CWnd::OnDeleteItem(int,tagDELETEITEMSTRUCT *))  size=32 ==== */
void __thiscall CWnd::OnDeleteItem(CWnd *this, int a2, struct tagDELETEITEMSTRUCT *a3)
{
  if ( !CWnd::ReflectLastMsg(a3->hwndItem, 0) )
    CWnd::Default(this);
}


/* ==== 41A4A7  unknown_libname_34  ()  size=115 ==== */
// MFC 3.1-14.0 32bit
int __stdcall unknown_libname_34(int a1, int a2, int a3, int a4)
{
  struct CNoTrackObject *Data; // esi
  HMODULE LibraryA; // eax
  HWND (__stdcall *HtmlHelpA)(HWND, LPCSTR, UINT, DWORD_PTR); // eax

  AfxLockGlobals(12);
  Data = CProcessLocalObject::GetData((CProcessLocalObject *)&unk_42FDF4, sub_41F4F4);
  if ( !*((_DWORD *)Data + 2) )
  {
    LibraryA = LoadLibraryA("hhctrl.ocx");
    *((_DWORD *)Data + 1) = LibraryA;
    if ( !LibraryA )
      return 0;
    HtmlHelpA = (HWND (__stdcall *)(HWND, LPCSTR, UINT, DWORD_PTR))GetProcAddress(LibraryA, "HtmlHelpA");
    *((_DWORD *)Data + 2) = HtmlHelpA;
    if ( !HtmlHelpA )
    {
      FreeLibrary(*((HMODULE *)Data + 1));
      *((_DWORD *)Data + 1) = 0;
      return 0;
    }
  }
  AfxUnlockGlobals(12);
  return (*((int (__stdcall **)(int, int, int, int))Data + 2))(a1, a2, a3, a4);
}


/* ==== 41A51A  ?OnCommand@CWnd@@MAEHIJ@Z  (CWnd::OnCommand(uint,long))  size=140 ==== */
int __thiscall CWnd::OnCommand(CWnd *this, unsigned int a2, HWND hWnd)
{
  int v3; // edi
  int v5; // eax
  _BYTE v7[4]; // [esp+Ch] [ebp-2Ch] BYREF
  int v8; // [esp+10h] [ebp-28h]
  int v9; // [esp+34h] [ebp-4h]
  unsigned int v10; // [esp+40h] [ebp+8h]

  v3 = (unsigned __int16)a2;
  v10 = HIWORD(a2);
  if ( hWnd )
  {
    if ( *((_DWORD *)CThreadLocalObject::GetData(
                       (CThreadLocalObject *)&unk_42E340,
                       CThreadLocal<_AFX_THREAD_STATE>::CreateObject)
         + 55) == *((_DWORD *)this + 7)
      || CWnd::ReflectLastMsg(hWnd, 0) )
    {
      return 1;
    }
    if ( v3 )
      return (*(int (__thiscall **)(CWnd *, int, unsigned int, _DWORD, _DWORD))(*(_DWORD *)this + 12))(
               this,
               v3,
               v10,
               0,
               0);
  }
  else if ( v3 )
  {
    sub_4187F2((CCmdUI *)v7);
    v5 = *(_DWORD *)this;
    v8 = v3;
    (*(void (__thiscall **)(CWnd *, int, int, _BYTE *, _DWORD))(v5 + 12))(this, v3, -1, v7, 0);
    if ( v9 )
    {
      v10 = 0;
      return (*(int (__thiscall **)(CWnd *, int, unsigned int, _DWORD, _DWORD))(*(_DWORD *)this + 12))(
               this,
               v3,
               v10,
               0,
               0);
    }
    return 1;
  }
  return 0;
}


/* ==== 41A5A6  ?OnNotify@CWnd@@MAEHIJPAJ@Z  (CWnd::OnNotify(uint,long,long *))  size=122 ==== */
int __thiscall CWnd::OnNotify(CWnd *this, unsigned int a2, int a3, int *a4)
{
  HWND v5; // ebx
  int v8; // eax
  _DWORD v9[2]; // [esp+Ch] [ebp-Ch] BYREF
  int DlgCtrlID; // [esp+14h] [ebp-4h]
  int v11; // [esp+24h] [ebp+Ch]

  v5 = *(HWND *)a3;
  DlgCtrlID = (unsigned __int16)GetDlgCtrlID(*(HWND *)a3);
  v11 = *(_DWORD *)(a3 + 8);
  if ( *((_DWORD *)CThreadLocalObject::GetData(
                     (CThreadLocalObject *)&unk_42E340,
                     CThreadLocal<_AFX_THREAD_STATE>::CreateObject)
       + 55) == *((_DWORD *)this + 7)
    || CWnd::ReflectLastMsg(v5, a4) )
  {
    return 1;
  }
  v9[0] = a4;
  v8 = *(_DWORD *)this;
  v9[1] = a3;
  return (*(int (__thiscall **)(CWnd *, int, int, _DWORD *, _DWORD))(v8 + 12))(
           this,
           DlgCtrlID,
           (unsigned __int16)v11 | 0x4E0000,
           v9,
           0);
}


/* ==== 41A620  ?AfxGetParentOwner@@YGPAUHWND__@@PAU1@@Z  (AfxGetParentOwner(HWND__ *))  size=69 ==== */
HWND __stdcall AfxGetParentOwner(HWND hWnd)
{
  CWnd *v1; // eax
  HWND result; // eax

  v1 = CWnd::FromHandlePermanent((unsigned int)hWnd);
  if ( v1 )
  {
    result = (HWND)CWnd::GetOwner(v1);
    if ( result )
      return (HWND)*((_DWORD *)result + 7);
  }
  else if ( (GetWindowLongA(hWnd, -16) & 0x40000000) != 0 )
  {
    return GetParent(hWnd);
  }
  else
  {
    return GetWindow(hWnd, 4u);
  }
  return result;
}


/* ==== 41A665  ?GetTopLevelParent@CWnd@@QBEPAV1@XZ  (CWnd::GetTopLevelParent(void))  size=40 ==== */
struct CWnd *__thiscall CWnd::GetTopLevelParent(CWnd *this)
{
  HWND ParentOwner; // eax
  HWND v3; // esi

  if ( !this )
    return 0;
  ParentOwner = (HWND)*((_DWORD *)this + 7);
  if ( !ParentOwner )
    return 0;
  do
  {
    v3 = ParentOwner;
    ParentOwner = AfxGetParentOwner(ParentOwner);
  }
  while ( ParentOwner );
  return CWnd::FromHandle(v3);
}


/* ==== 41A68D  ?OnSysColorChange@CWnd@@IAEXXZ  (CWnd::OnSysColorChange(void))  size=70 ==== */
void __thiscall CWnd::OnSysColorChange(HWND *this)
{
  int v2; // eax

  v2 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( v2 && *(HWND **)(v2 + 28) == this )
    AUX_DATA::UpdateSysColors((AUX_DATA *)&dword_42FE00);
  if ( (CWnd::GetStyle((CWnd *)this) & 0x40000000) == 0 )
    CWnd::SendMessageToDescendants(this[7], 0x15u, 0, 0, 1, 1);
  CWnd::Default((CWnd *)this);
}


/* ==== 41A71E  ?OnDisplayChange@CWnd@@IAEJIJ@Z  (CWnd::OnDisplayChange(uint,long))  size=73 ==== */
int __thiscall CWnd::OnDisplayChange(HWND *this, unsigned int a2, int a3)
{
  const struct tagMSG *CurrentMessage; // eax

  if ( AfxGetMainWnd() == (struct CWnd *)this )
    AUX_DATA::UpdateSysMetrics((AUX_DATA *)&dword_42FE00);
  if ( (CWnd::GetStyle((CWnd *)this) & 0x40000000) == 0 )
  {
    CurrentMessage = CWnd::GetCurrentMessage();
    CWnd::SendMessageToDescendants(
      this[7],
      CurrentMessage->message,
      CurrentMessage->wParam,
      CurrentMessage->lParam,
      1,
      1);
  }
  return CWnd::Default((CWnd *)this);
}


/* ==== 41A767  ?ExecuteDlgInit@CWnd@@QAEHPAX@Z  (CWnd::ExecuteDlgInit(void *))  size=225 ==== */
int __thiscall CWnd::ExecuteDlgInit(HWND *this, unsigned __int16 *a2)
{
  unsigned __int16 *v2; // esi
  unsigned __int16 v4; // cx
  unsigned __int16 *v5; // esi
  unsigned __int16 v6; // ax
  int v7; // edx
  LPARAM v8; // esi
  LRESULT v9; // eax
  _DWORD v11[9]; // [esp+8h] [ebp-2Ch] BYREF
  int v12; // [esp+2Ch] [ebp-8h]
  int v13; // [esp+30h] [ebp-4h]
  unsigned __int16 v14; // [esp+3Ch] [ebp+8h]

  v2 = a2;
  v13 = 1;
  if ( !a2 )
  {
LABEL_17:
    CWnd::SendMessageToDescendants(this[7], 0x364u, 0, 0, 0, 0);
    return v13;
  }
  do
  {
    v4 = *v2;
    v14 = *v2;
    if ( !*v2 )
      break;
    v5 = v2 + 1;
    v6 = *v5++;
    v7 = *(_DWORD *)v5;
    v8 = (LPARAM)(v5 + 2);
    v12 = v7;
    if ( v6 == 4660 )
    {
      ((void (__stdcall *)())Target)();
      v11[1] = -1;
      v11[0] = 1;
      v11[2] = v8;
      v9 = SendDlgItemMessageA(this[7], v14, 0x401u, 0, (LPARAM)v11);
    }
    else
    {
      if ( v6 == 1025 )
      {
        v6 = 384;
      }
      else
      {
        if ( v6 == 1027 )
          v6 = 323;
        if ( v6 != 384 && v6 != 323 )
          goto LABEL_15;
      }
      v9 = SendDlgItemMessageA(this[7], v4, v6, 0, v8);
    }
    if ( v9 == -1 )
      v13 = 0;
LABEL_15:
    v2 = (unsigned __int16 *)(v12 + v8);
  }
  while ( v13 );
  if ( v13 )
    goto LABEL_17;
  return v13;
}


/* ==== 41A848  ?_AfxHandleActivate@@YGXPAVCWnd@@I0@Z  (_AfxHandleActivate(CWnd *,uint,CWnd *))  size=97 ==== */
void __stdcall _AfxHandleActivate(LPARAM *a1, WPARAM wParam, struct CWnd *a3)
{
  HWND *TopLevelParent; // ebx
  LPARAM lParam; // [esp+4h] [ebp-8h] BYREF
  int v5; // [esp+8h] [ebp-4h]

  if ( (CWnd::GetStyle((CWnd *)a1) & 0x40000000) == 0 )
  {
    TopLevelParent = (HWND *)CWnd::GetTopLevelParent((CWnd *)a1);
    if ( TopLevelParent != (HWND *)CWnd::GetTopLevelParent(a3) )
    {
      lParam = a1[7];
      if ( a3 )
        v5 = *((_DWORD *)a3 + 7);
      else
        v5 = 0;
      SendMessageA(TopLevelParent[7], 0x36Eu, wParam, (LPARAM)&lParam);
    }
  }
}


/* ==== 41A8A9  ?_AfxHandleSetCursor@@YGHPAVCWnd@@II@Z  (_AfxHandleSetCursor(CWnd *,uint,uint))  size=118 ==== */
int __stdcall _AfxHandleSetCursor(struct CWnd *a1, unsigned int a2, unsigned int a3)
{
  struct CWnd *TopLevelParent; // eax
  HWND LastActivePopup; // eax
  HWND *v5; // esi
  HWND ForegroundWindow; // eax

  if ( a2 != -2 || a3 != 513 && a3 != 519 && a3 != 516 )
    return 0;
  TopLevelParent = CWnd::GetTopLevelParent(a1);
  if ( !TopLevelParent )
    return 0;
  LastActivePopup = GetLastActivePopup(*((HWND *)TopLevelParent + 7));
  v5 = (HWND *)CWnd::FromHandle(LastActivePopup);
  if ( !v5 )
    return 0;
  ForegroundWindow = GetForegroundWindow();
  if ( v5 == (HWND *)CWnd::FromHandle(ForegroundWindow) || !CWnd::IsWindowEnabled((CWnd *)v5) )
    return 0;
  SetForegroundWindow(v5[7]);
  return 1;
}


/* ==== 41A91F  ?_AfxActivationWndProc@@YGJPAUHWND__@@IIJ@Z  (_AfxActivationWndProc(HWND__ *,uint,uint,long))  size=344 ==== */
LRESULT __stdcall _AfxActivationWndProc(HWND hWnd, UINT Msg, WPARAM wParam, unsigned int lParam)
{
  LRESULT (__stdcall *PropA)(HWND, UINT, WPARAM, LPARAM); // eax
  BOOL v5; // ebx
  HWND *v6; // esi
  ATOM AtomA; // ax
  struct CWnd *v9; // eax
  struct CWnd *v10; // esi
  LPARAM *v11; // eax
  int v12; // [esp+0h] [ebp-58h] BYREF
  struct tagRECT Rect; // [esp+28h] [ebp-30h] BYREF
  __int16 v14[2]; // [esp+3Ch] [ebp-1Ch] BYREF
  WNDPROC lpPrevWndFunc; // [esp+40h] [ebp-18h]
  LRESULT v16; // [esp+44h] [ebp-14h]
  int *v17; // [esp+48h] [ebp-10h]
  int v18; // [esp+54h] [ebp-4h]

  v17 = &v12;
  PropA = (LRESULT (__stdcall *)(HWND, UINT, WPARAM, LPARAM))GetPropA(hWnd, "AfxOldWndProc423");
  v16 = 0;
  v18 = 0;
  lpPrevWndFunc = PropA;
  v5 = 1;
  switch ( Msg )
  {
    case 6u:
      v10 = CWnd::FromHandle((HWND)lParam);
      v11 = (LPARAM *)CWnd::FromHandle(hWnd);
      _AfxHandleActivate(v11, wParam, v10);
LABEL_10:
      if ( !v5 )
        return v16;
      return CallWindowProcA(lpPrevWndFunc, hWnd, Msg, wParam, lParam);
    case 0x20u:
      v9 = CWnd::FromHandle(hWnd);
      v5 = _AfxHandleSetCursor(v9, (__int16)lParam, HIWORD(lParam)) == 0;
      goto LABEL_10;
    case 0x82u:
      SetWindowLongA(hWnd, -4, (LONG)lpPrevWndFunc);
      RemovePropA(hWnd, "AfxOldWndProc423");
      AtomA = GlobalFindAtomA("AfxOldWndProc423");
      GlobalDeleteAtom(AtomA);
      return CallWindowProcA(lpPrevWndFunc, hWnd, Msg, wParam, lParam);
  }
  if ( Msg != 272 )
    return CallWindowProcA(lpPrevWndFunc, hWnd, Msg, wParam, lParam);
  v6 = (HWND *)CWnd::FromHandle(hWnd);
  _AfxPreInitDialog(v6, &Rect, (unsigned int *)v14);
  v16 = CallWindowProcA(lpPrevWndFunc, hWnd, 0x110u, wParam, lParam);
  _AfxPostInitDialog(v6, &Rect, *(int *)v14);
  return v16;
}


/* ==== 41AA77  fn  ()  size=552 ==== */
LRESULT __stdcall fn(int code, HWND wParam, int *lParam)
{
  struct CNoTrackObject *Data; // eax
  int v5; // edi
  CWnd *v6; // esi
  int v7; // eax
  CHAR *v8; // eax
  ATOM v9; // ax
  LRESULT (__stdcall **v10)(HWND, UINT, WPARAM, LPARAM); // edi
  LRESULT (__stdcall *v11)(HWND, UINT, WPARAM, LPARAM); // eax
  HANDLE PropA; // eax
  struct CNoTrackObject *v13; // edi
  LRESULT v14; // esi
  tagWNDCLASSEXA wcx; // [esp+8h] [ebp-148h] BYREF
  int v16; // [esp+38h] [ebp-118h]
  LPARAM v17; // [esp+3Ch] [ebp-114h]
  struct CNoTrackObject *v18; // [esp+40h] [ebp-110h]
  CHAR ClassName[256]; // [esp+44h] [ebp-10Ch] BYREF
  CHAR Buffer[4]; // [esp+144h] [ebp-Ch] BYREF

  v17 = (LPARAM)lParam;
  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  v18 = Data;
  if ( code != 3 )
    return CallNextHookEx(*((HHOOK *)Data + 10), code, (WPARAM)wParam, (LPARAM)lParam);
  v5 = *lParam;
  v6 = (CWnd *)*((_DWORD *)Data + 5);
  v7 = *((unsigned __int8 *)AfxGetModuleState() + 20);
  v16 = v7;
  if ( v6 || (*(_BYTE *)(v5 + 35) & 0x40) == 0 && !v7 )
  {
    if ( !dword_430094 )
      goto LABEL_11;
    if ( (GetClassLongA(wParam, -26) & 0x10000) == 0 )
    {
      v8 = *(CHAR **)(v5 + 40);
      if ( (unsigned int)v8 <= 0xFFFF )
      {
        v9 = *(_WORD *)(v5 + 40);
        Buffer[0] = 0;
        GlobalGetAtomNameA(v9, Buffer, 5);
        v8 = Buffer;
      }
      if ( lstrcmpiA(v8, "ime") )
      {
LABEL_11:
        if ( v6 )
        {
          CWnd::Attach(v6, wParam);
          (*(void (__thiscall **)(CWnd *))(*(_DWORD *)v6 + 80))(v6);
          v10 = (LRESULT (__stdcall **)(HWND, UINT, WPARAM, LPARAM))(*(int (__thiscall **)(CWnd *))(*(_DWORD *)v6 + 240))(v6);
          v11 = (LRESULT (__stdcall *)(HWND, UINT, WPARAM, LPARAM))SetWindowLongA(wParam, -4, (LONG)AfxWndProc);
          if ( v11 != AfxWndProc )
            *v10 = v11;
          *((_DWORD *)v18 + 5) = 0;
          goto LABEL_25;
        }
        if ( word_42FDF0
          || (memset(&wcx, 0, sizeof(wcx)), wcx.cbSize = 48, (word_42FDF0 = GetClassInfoExA(0, "#32768", &wcx)) != 0) )
        {
          if ( (unsigned __int16)GetClassLongA(wParam, -32) == word_42FDF0 )
            goto LABEL_25;
LABEL_21:
          *(_DWORD *)Buffer = GetWindowLongA(wParam, -4);
          if ( *(_DWORD *)Buffer )
          {
            if ( !GetPropA(wParam, "AfxOldWndProc423") )
            {
              SetPropA(wParam, "AfxOldWndProc423", *(HANDLE *)Buffer);
              PropA = GetPropA(wParam, "AfxOldWndProc423");
              if ( PropA == *(HANDLE *)Buffer )
              {
                GlobalAddAtomA("AfxOldWndProc423");
                SetWindowLongA(wParam, -4, (LONG)_AfxActivationWndProc);
              }
            }
          }
          goto LABEL_25;
        }
        if ( !GetClassNameA(wParam, ClassName, 256) )
          goto LABEL_21;
        ClassName[255] = 0;
        if ( _mbscmp((const unsigned __int8 *)ClassName, "#32768") )
          goto LABEL_21;
      }
    }
  }
LABEL_25:
  v13 = v18;
  v14 = CallNextHookEx(*((HHOOK *)v18 + 10), 3, (WPARAM)wParam, v17);
  if ( v16 )
  {
    UnhookWindowsHookEx(*((HHOOK *)v13 + 10));
    *((_DWORD *)v13 + 10) = 0;
  }
  return v14;
}


/* ==== 41AC9F  ?AfxHookWindowCreate@@YGXPAVCWnd@@@Z  (AfxHookWindowCreate(CWnd *))  size=76 ==== */
void __stdcall AfxHookWindowCreate(struct CWnd *a1)
{
  struct CNoTrackObject *Data; // eax
  struct CNoTrackObject *v2; // esi
  DWORD CurrentThreadId; // eax
  HHOOK v4; // eax

  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  v2 = Data;
  if ( *((struct CWnd **)Data + 5) != a1 )
  {
    if ( !*((_DWORD *)Data + 10) )
    {
      CurrentThreadId = GetCurrentThreadId();
      v4 = SetWindowsHookExA(5, (HOOKPROC)fn, 0, CurrentThreadId);
      *((_DWORD *)v2 + 10) = v4;
      if ( !v4 )
        unknown_libname_11();
    }
    *((_DWORD *)v2 + 5) = a1;
  }
}


/* ==== 41ACEB  ?CreateEx@CWnd@@UAEHKPBD0KHHHHPAUHWND__@@PAUHMENU__@@PAX@Z  (CWnd::CreateEx(ulong,char const *,char const *,ulong,int,int,int,int,HWND__ *,HMENU__ *,void *))  size=198 ==== */
BOOL __thiscall CWnd::CreateEx(
        CWnd *this,
        DWORD a2,
        const char *a3,
        const char *a4,
        DWORD a5,
        int a6,
        int a7,
        int a8,
        int a9,
        HWND a10,
        HMENU a11,
        void *a12)
{
  HWND Window; // edi
  LPVOID lpParam; // [esp+4h] [ebp-30h] BYREF
  HINSTANCE hInstance; // [esp+8h] [ebp-2Ch]
  HMENU hMenu; // [esp+Ch] [ebp-28h]
  HWND hWndParent; // [esp+10h] [ebp-24h]
  int nHeight; // [esp+14h] [ebp-20h]
  int nWidth; // [esp+18h] [ebp-1Ch]
  int Y; // [esp+1Ch] [ebp-18h]
  int X; // [esp+20h] [ebp-14h]
  DWORD dwStyle; // [esp+24h] [ebp-10h]
  LPCSTR lpWindowName; // [esp+28h] [ebp-Ch]
  LPCSTR lpClassName; // [esp+2Ch] [ebp-8h]
  DWORD dwExStyle; // [esp+30h] [ebp-4h]

  dwExStyle = a2;
  lpClassName = a3;
  lpWindowName = a4;
  dwStyle = a5;
  X = a6;
  Y = a7;
  nWidth = a8;
  nHeight = a9;
  hWndParent = a10;
  hMenu = a11;
  hInstance = (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 2);
  lpParam = a12;
  if ( (*(int (__thiscall **)(CWnd *, LPVOID *))(*(_DWORD *)this + 100))(this, &lpParam) )
  {
    AfxHookWindowCreate(this);
    Window = CreateWindowExA(
               dwExStyle,
               lpClassName,
               lpWindowName,
               dwStyle,
               X,
               Y,
               nWidth,
               nHeight,
               hWndParent,
               hMenu,
               hInstance,
               lpParam);
    if ( !AfxUnhookWindowCreate() )
      (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 276))(this);
    return Window != 0;
  }
  else
  {
    (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 276))(this);
    return 0;
  }
}


/* ==== 41ADB1  ?PrepareForHelp@CWnd@@QAEXXZ  (CWnd::PrepareForHelp(void))  size=115 ==== */
void __thiscall CWnd::PrepareForHelp(HWND *this)
{
  struct CWnd *TopLevelParent; // esi
  HWND Capture; // eax

  if ( (*((int (__thiscall **)(HWND *))*this + 72))(this) )
    (*((void (__thiscall **)(HWND *))*this + 91))(this);
  SendMessageA(this[7], 0x1Fu, 0, 0);
  CWnd::SendMessageToDescendants(this[7], 0x1Fu, 0, 0, 1, 1);
  TopLevelParent = CWnd::GetTopLevelParent((CWnd *)this);
  SendMessageA(*((HWND *)TopLevelParent + 7), 0x1Fu, 0, 0);
  CWnd::SendMessageToDescendants(*((HWND *)TopLevelParent + 7), 0x1Fu, 0, 0, 1, 1);
  Capture = GetCapture();
  if ( Capture )
    SendMessageA(Capture, 0x1Fu, 0, 0);
}


/* ==== 41AE24  ?OnWndMsg@CWnd@@MAEHIIJPAJ@Z  (CWnd::OnWndMsg(uint,uint,long,long *))  size=1287 ==== */
int __thiscall CWnd::OnWndMsg(LPARAM *this, unsigned int a2, unsigned int a3, HWND a4, int *a5)
{
  int v6; // eax
  struct CWnd *v8; // eax
  LPARAM v9; // eax
  int v10; // ebx
  _DWORD *v11; // eax
  _DWORD *v12; // eax
  int (__thiscall *v13)(LPARAM *, struct CDC *); // ebx
  int v14; // eax
  _DWORD *i; // eax
  int v17; // eax
  struct CWnd *v18; // eax
  struct CWnd *v19; // eax
  int v20; // eax
  void *v21; // eax
  int v22; // esi
  struct CWnd *v23; // eax
  LPARAM v24; // eax
  void *ValueAt; // eax
  int v26; // eax
  int v27; // eax
  struct CWnd *v28; // eax
  struct CWnd *v29; // eax
  int v30; // eax
  struct CWnd *v31; // eax
  struct CDC *v32; // eax
  struct CWnd *v33; // eax
  struct CWnd *v34; // eax
  struct CWnd *v35; // [esp-8h] [ebp-88h]
  struct CWnd *v36; // [esp-8h] [ebp-88h]
  struct CDC *v37; // [esp-4h] [ebp-84h]
  struct CWnd *v38; // [esp-4h] [ebp-84h]
  struct CMenu *v39; // [esp-4h] [ebp-84h]
  int v40; // [esp-4h] [ebp-84h]
  unsigned int v41; // [esp-4h] [ebp-84h]
  unsigned int v42; // [esp-4h] [ebp-84h]
  unsigned int v43; // [esp-4h] [ebp-84h]
  struct CWnd *v44; // [esp-4h] [ebp-84h]
  _BYTE v45[28]; // [esp+Ch] [ebp-74h] BYREF
  void *v46; // [esp+28h] [ebp-58h]
  void *v47; // [esp+58h] [ebp-28h]
  _BYTE v48[4]; // [esp+5Ch] [ebp-24h] BYREF
  int v49; // [esp+60h] [ebp-20h]
  int v50; // [esp+6Ch] [ebp-14h]
  int v51; // [esp+70h] [ebp-10h] BYREF
  int v52; // [esp+7Ch] [ebp-4h]
  unsigned int v53; // [esp+88h] [ebp+8h]
  HWND v54; // [esp+8Ch] [ebp+Ch]
  HWND v55; // [esp+90h] [ebp+10h]

  v51 = 0;
  if ( a2 != 273 )
  {
    if ( a2 == 78 )
    {
      if ( *(_DWORD *)a4 )
      {
        v6 = (*(int (__thiscall **)(LPARAM *, unsigned int, HWND, int *))(*this + 236))(this, a3, a4, &v51);
LABEL_96:
        if ( v6 )
          goto LABEL_103;
      }
    }
    else
    {
      if ( a2 == 6 )
      {
        v8 = CWnd::FromHandle(a4);
        _AfxHandleActivate(this, a3, v8);
      }
      if ( a2 == 32 && _AfxHandleSetCursor((struct CWnd *)this, (__int16)a4, (unsigned int)a4 >> 16) )
        goto LABEL_94;
      v9 = this[18];
      if ( v9
        && *(int *)(v9 + 112) > 0
        && (a2 >= 0x200 && a2 <= 0x209 || a2 >= 0x100 && a2 <= 0x10F || a2 >= 0x281 && a2 <= 0x291)
        && (*(int (__thiscall **)(LPARAM, unsigned int, unsigned int, HWND, int *))(*(_DWORD *)this[18] + 148))(
             this[18],
             a2,
             a3,
             a4,
             &v51) )
      {
        goto LABEL_103;
      }
      v50 = (*(int (__thiscall **)(LPARAM *))(*this + 40))(this);
      AfxLockGlobals(7);
      v10 = 12 * (((unsigned __int16)a2 ^ (unsigned __int16)v50) & 0x1FF) + 4383872;
      v11 = (_DWORD *)v50;
      if ( a2 == dword_42E480[3 * (((unsigned __int16)a2 ^ (unsigned __int16)v50) & 0x1FF)]
        && v50 == dword_42E480[3 * (((unsigned __int16)a2 ^ (unsigned __int16)v50) & 0x1FF) + 2] )
      {
        v55 = (HWND)dword_42E480[3 * (((unsigned __int16)a2 ^ (unsigned __int16)v50) & 0x1FF) + 1];
        AfxUnlockGlobals(7);
        if ( v55 )
        {
          if ( a2 < 0xC000 )
          {
LABEL_29:
            v13 = (int (__thiscall *)(LPARAM *, struct CDC *))*((_DWORD *)v55 + 5);
            v14 = *((_DWORD *)v55 + 4);
            switch ( v14 )
            {
              case 1:
                v37 = CDC::FromHandle((HDC)a3);
                v17 = v13(this, v37);
                goto LABEL_102;
              case 2:
              case 3:
              case 4:
              case 24:
              case 25:
                v17 = v13(this, (struct CDC *)a3);
                goto LABEL_102;
              case 5:
              case 12:
                v39 = (struct CMenu *)((unsigned int)a4 >> 16);
                v35 = (struct CWnd *)(unsigned __int16)a4;
                v18 = CWnd::FromHandle((HWND)a3);
                goto LABEL_58;
              case 6:
                v19 = CWnd::FromHandle((HWND)a3);
                v17 = ((int (__thiscall *)(LPARAM *, struct CWnd *, HWND))v13)(this, v19, a4);
                goto LABEL_102;
              case 7:
              case 13:
                v17 = v13(this, (struct CDC *)a4);
                goto LABEL_102;
              case 8:
                CDC::CDC((CDC *)v48);
                v20 = *((_DWORD *)a4 + 1);
                v52 = 0;
                v49 = v20;
                CWnd::CWnd((CWnd *)v45);
                v21 = *(void **)a4;
                v22 = *((_DWORD *)a4 + 2);
                LOBYTE(v52) = 1;
                v46 = v21;
                v23 = CWnd::FromHandlePermanent((unsigned int)v21);
                if ( !v23 )
                {
                  v24 = this[18];
                  if ( v24 )
                  {
                    ValueAt = CMapPtrToPtr::GetValueAt((CMapPtrToPtr *)(v24 + 32), (unsigned int)v46);
                    if ( ValueAt )
                      v47 = ValueAt;
                  }
                  v23 = (struct CWnd *)v45;
                }
                v26 = ((int (__thiscall *)(LPARAM *, _BYTE *, struct CWnd *, int))v13)(this, v48, v23, v22);
                v49 = 0;
                v46 = 0;
                v51 = v26;
                LOBYTE(v52) = 0;
                CWnd::~CWnd((CWnd *)v45);
                goto LABEL_50;
              case 9:
                CDC::CDC((CDC *)v48);
                v40 = *((_DWORD *)a4 + 2);
                v49 = *((_DWORD *)a4 + 1);
                v52 = 2;
                v27 = ((int (__thiscall *)(LPARAM *, _BYTE *, int))v13)(this, v48, v40);
                v49 = 0;
                v51 = v27;
LABEL_50:
                v52 = -1;
                CDC::~CDC((CDC *)v48);
                goto LABEL_103;
              case 10:
                v39 = (struct CMenu *)HIWORD(a3);
                v28 = CWnd::FromHandle(a4);
                goto LABEL_57;
              case 11:
                v17 = ((int (__thiscall *)(LPARAM *, _DWORD, unsigned int))v13)(this, (unsigned __int16)a3, HIWORD(a3));
                goto LABEL_102;
              case 14:
              case 44:
                v17 = ((int (__thiscall *)(LPARAM *, unsigned int, HWND))v13)(this, a3, a4);
                goto LABEL_102;
              case 15:
                v39 = CMenu::FromHandle((HMENU)a4);
                v28 = (struct CWnd *)HIWORD(a3);
LABEL_57:
                v35 = v28;
                v18 = (struct CWnd *)(unsigned __int16)a3;
LABEL_58:
                v17 = ((int (__thiscall *)(LPARAM *, struct CWnd *, struct CWnd *, struct CMenu *))v13)(
                        this,
                        v18,
                        v35,
                        v39);
                goto LABEL_102;
              case 16:
                ((void (__thiscall *)(LPARAM *))v13)(this);
                goto LABEL_103;
              case 17:
                v13(this, (struct CDC *)a3);
                goto LABEL_103;
              case 18:
              case 27:
              case 42:
              case 47:
                v38 = (struct CWnd *)a4;
                goto LABEL_86;
              case 19:
                v41 = HIWORD(a3);
                v29 = (struct CWnd *)(unsigned __int16)a3;
                goto LABEL_62;
              case 20:
                v41 = SHIWORD(a4);
                v29 = (struct CWnd *)(__int16)a4;
                goto LABEL_62;
              case 21:
              case 22:
                v42 = (unsigned int)a4 >> 16;
                v30 = (unsigned __int16)a4;
                goto LABEL_92;
              case 23:
                v38 = CWnd::FromHandle(a4);
LABEL_86:
                ((void (__thiscall *)(LPARAM *, unsigned int, struct CWnd *))v13)(this, a3, v38);
                goto LABEL_103;
              case 26:
              case 37:
              case 46:
                v17 = ((int (__thiscall *)(LPARAM *))v13)(this);
                goto LABEL_102;
              case 28:
                v43 = (unsigned int)CWnd::FromHandle((HWND)a3);
                v36 = CWnd::FromHandle(a4);
                v31 = (struct CWnd *)(this[7] == (_DWORD)a4);
                goto LABEL_66;
              case 29:
                v32 = CDC::FromHandle((HDC)a3);
                goto LABEL_68;
              case 30:
                v32 = CMenu::FromHandle((HMENU)a3);
                goto LABEL_68;
              case 31:
                v43 = (unsigned int)a4 >> 16;
                v36 = (struct CWnd *)(unsigned __int16)a4;
                v31 = CMenu::FromHandle((HMENU)a3);
                goto LABEL_66;
              case 32:
                v32 = CWnd::FromHandle((HWND)a3);
                goto LABEL_68;
              case 33:
                v32 = CWnd::FromHandle(a4);
LABEL_68:
                v13(this, v32);
                goto LABEL_103;
              case 34:
                v43 = (unsigned int)a4 >> 16;
                v33 = (struct CWnd *)(unsigned __int16)a4;
                goto LABEL_76;
              case 35:
                v33 = (struct CWnd *)(__int16)a4;
                v43 = SHIWORD(a4);
LABEL_76:
                v36 = v33;
                v31 = CWnd::FromHandle((HWND)a3);
                goto LABEL_66;
              case 36:
                v41 = (unsigned int)a4;
                v29 = CWnd::FromHandle((HWND)a3);
LABEL_62:
                ((void (__thiscall *)(LPARAM *, struct CWnd *, unsigned int))v13)(this, v29, v41);
                goto LABEL_103;
              case 38:
                v43 = HIWORD(a3);
                v34 = CWnd::FromHandle(a4);
                goto LABEL_90;
              case 39:
              case 40:
                v53 = (__int16)a3;
                v54 = (HWND)SHIWORD(a3);
                if ( v14 == 39 )
                {
                  v44 = CWnd::FromHandle(a4);
                  ((void (__thiscall *)(LPARAM *, unsigned int, HWND, struct CWnd *))v13)(this, v53, v54, v44);
                }
                else
                {
                  ((void (__thiscall *)(LPARAM *, unsigned int, HWND))v13)(this, v53, v54);
                }
                goto LABEL_103;
              case 41:
              case 48:
                v13(this, (struct CDC *)a4);
                goto LABEL_103;
              case 43:
              case 51:
                ((void (__thiscall *)(LPARAM *, unsigned int, HWND))v13)(this, a3, a4);
                goto LABEL_94;
              case 45:
                v17 = ((int (__thiscall *)(LPARAM *, _DWORD, _DWORD))v13)(this, (__int16)a4, SHIWORD(a4));
                goto LABEL_102;
              case 49:
                v43 = (unsigned int)a4;
                v34 = (struct CWnd *)HIWORD(a3);
LABEL_90:
                v36 = v34;
                v31 = (struct CWnd *)(unsigned __int16)a3;
LABEL_66:
                ((void (__thiscall *)(LPARAM *, struct CWnd *, struct CWnd *, unsigned int))v13)(this, v31, v36, v43);
                break;
              case 50:
                v30 = (__int16)a4;
                v42 = SHIWORD(a4);
LABEL_92:
                ((void (__thiscall *)(LPARAM *, unsigned int, int, unsigned int))v13)(this, a3, v30, v42);
                break;
              case 52:
                v6 = ((int (__thiscall *)(LPARAM *, _DWORD, unsigned int, _DWORD, unsigned int))v13)(
                       this,
                       (unsigned __int16)a3,
                       HIWORD(a3),
                       (unsigned __int16)a4,
                       (unsigned int)a4 >> 16);
                v51 = v6;
                goto LABEL_96;
              case 65:
                v51 = ((int (__thiscall *)(LPARAM *))v13)(this);
                if ( v51 )
                  return 0;
                goto LABEL_103;
              default:
                goto LABEL_103;
            }
          }
          else
          {
LABEL_101:
            v17 = (*((int (__thiscall **)(LPARAM *, unsigned int, HWND))v55 + 5))(this, a3, a4);
LABEL_102:
            v51 = v17;
          }
          goto LABEL_103;
        }
      }
      else
      {
        dword_42E480[3 * (((unsigned __int16)a2 ^ (unsigned __int16)v50) & 0x1FF)] = a2;
        *(_DWORD *)(v10 + 8) = v11;
        while ( v11 )
        {
          if ( a2 >= 0xC000 )
          {
            for ( i = *(_DWORD **)(v50 + 4); ; i = v55 + 6 )
            {
              v55 = (HWND)unknown_libname_21(i, 49152, 0, 0);
              if ( !v55 )
                break;
              if ( **((_DWORD **)v55 + 4) == a2 )
              {
                *(_DWORD *)(v10 + 4) = v55;
                AfxUnlockGlobals(7);
                goto LABEL_101;
              }
            }
          }
          else
          {
            v12 = unknown_libname_21(*(_DWORD **)(v50 + 4), a2, 0, 0);
            v55 = (HWND)v12;
            if ( v12 )
            {
              *(_DWORD *)(v10 + 4) = v12;
              AfxUnlockGlobals(7);
              goto LABEL_29;
            }
          }
          v11 = *(_DWORD **)v50;
          v50 = *(_DWORD *)v50;
        }
        *(_DWORD *)(v10 + 4) = 0;
        AfxUnlockGlobals(7);
      }
    }
    return 0;
  }
  if ( !(*(int (__thiscall **)(LPARAM *, unsigned int, HWND))(*this + 232))(this, a3, a4) )
    return 0;
LABEL_94:
  v51 = 1;
LABEL_103:
  if ( a5 )
    *a5 = v51;
  return 1;
}


/* ==== 41B430  ?ReflectChildNotify@CWnd@@IAEHIIJPAJ@Z  (CWnd::ReflectChildNotify(uint,uint,long,long *))  size=232 ==== */
int __thiscall CWnd::ReflectChildNotify(LPARAM *this, unsigned int a2, HWND a3, HWND a4, int *a5)
{
  int v5; // edx
  int result; // eax
  struct HWND__ v7; // [esp+4h] [ebp-Ch] BYREF
  HWND Buf1; // [esp+8h] [ebp-8h] BYREF
  HWND v9; // [esp+Ch] [ebp-4h]

  if ( a2 > 0x111 )
  {
    if ( a2 < 0x114 || a2 > 0x115 && a2 != 528 )
      goto LABEL_15;
    return CWnd::OnWndMsg(this, a2 + 48128, (unsigned int)a3, a4, a5);
  }
  if ( a2 != 273 )
  {
    if ( a2 < 0x2B )
      goto LABEL_15;
    if ( a2 > 0x2F && a2 != 57 )
    {
      if ( a2 == 78 )
      {
        v5 = *((_DWORD *)a4 + 2);
        Buf1 = (HWND)a5;
        v9 = a4;
        return CCmdTarget::OnCmdMsg((CCmdTarget *)this, 0, (unsigned __int16)v5 | 0xBC4E0000, &Buf1, 0);
      }
LABEL_15:
      if ( a2 < 0x132 )
        return 0;
      if ( a2 > 0x138 )
        return 0;
      v9 = (HWND)(a2 - 306);
      Buf1 = a3;
      result = CWnd::OnWndMsg(this, 0xBC19u, 0, &v7, a5);
      if ( !*a5 )
        return 0;
      return result;
    }
    return CWnd::OnWndMsg(this, a2 + 48128, (unsigned int)a3, a4, a5);
  }
  if ( !CCmdTarget::OnCmdMsg((CCmdTarget *)this, 0, ((unsigned int)a3 >> 16) | 0xBD110000, 0, 0) )
    return 0;
  result = 1;
  if ( a5 )
    *a5 = 1;
  return result;
}


/* ==== 41B518  ?OnSettingChange@CWnd@@IAEXIPBD@Z  (CWnd::OnSettingChange(uint,char const *))  size=44 ==== */
void __thiscall CWnd::OnSettingChange(CWnd *this, unsigned int a2, const char *a3)
{
  dword_42E478 = 0;
  if ( *((_DWORD *)this + 18) )
    (*(void (__thiscall **)(_DWORD, int))(**((_DWORD **)this + 18) + 80))(*((_DWORD *)this + 18), -705);
  CWnd::OnDisplayChange((HWND *)this, 0, 0);
}


/* ==== 41B544  ?CreateAccessibleProxy@CWnd@@UAEJIJPAJ@Z  (CWnd::CreateAccessibleProxy(uint,long,long *))  size=200 ==== */
int __thiscall CWnd::CreateAccessibleProxy(LPUNKNOWN *this, WPARAM wParam, IUnknown *a3, int *a4)
{
  int v5; // edi
  int (__stdcall **v6)(_DWORD, void *, IUnknown **); // ecx
  int v7; // eax
  LONG_PTR v8; // eax
  LONG_PTR v9; // eax
  int (__stdcall ***v11)(_DWORD, void *, IUnknown **); // [esp+8h] [ebp-10h] BYREF
  int v12; // [esp+14h] [ebp-4h]

  v5 = -2147467259;
  if ( a3 == (IUnknown *)-4 )
  {
    v5 = ((int (__thiscall *)(LPUNKNOWN *))(*this)[34].lpVtbl)(this);
    if ( v5 >= 0 )
    {
      if ( this[10] )
      {
        v9 = LresultFromObject(&riid, wParam, this[10]);
        *a4 = v9;
        return 0;
      }
      else
      {
        v5 = CMFCComObject<ATL::CAccessibleProxy>::CreateInstance(&v11);
        if ( v5 >= 0 )
        {
          a3 = 0;
          v6 = *v11;
          v12 = 0;
          if ( (*v6)(v11, &unk_426508, &a3) >= 0 )
          {
            v7 = (int)a3;
            this[10] = a3;
            (*(void (__stdcall **)(int, char *, char *))(*(_DWORD *)v7 + 12))(v7, (char *)this + 44, (char *)this + 48);
            v8 = LresultFromObject(&riid, wParam, this[10]);
            *a4 = v8;
          }
          v12 = -1;
          v5 = 0;
          if ( a3 )
            a3->lpVtbl->Release(a3);
        }
      }
    }
  }
  return v5;
}


/* ==== 41B60C  ?ExecuteDlgInit@CWnd@@QAEHPBD@Z  (CWnd::ExecuteDlgInit(char const *))  size=101 ==== */
HGLOBAL __thiscall CWnd::ExecuteDlgInit(HWND *this, LPCSTR lpName)
{
  HGLOBAL v2; // edi
  unsigned __int16 *v3; // ebx
  HMODULE v5; // esi
  HRSRC ResourceA; // eax
  HGLOBAL result; // eax
  int v8; // esi

  v2 = 0;
  v3 = 0;
  if ( lpName )
  {
    v5 = (HMODULE)*((_DWORD *)AfxGetModuleState() + 3);
    ResourceA = FindResourceA(v5, lpName, (LPCSTR)0xF0);
    if ( ResourceA )
    {
      result = LoadResource(v5, ResourceA);
      v2 = result;
      if ( !result )
        return result;
      v3 = (unsigned __int16 *)LockResource(result);
    }
  }
  v8 = CWnd::ExecuteDlgInit(this, v3);
  if ( v3 )
  {
    if ( v2 )
      FreeResource(v2);
  }
  return (HGLOBAL)v8;
}


/* ==== 41B671  sub_41B671  ()  size=122 ==== */
void __thiscall sub_41B671(HWND *this, ULONG_PTR dwData, UINT uCommand)
{
  int v4; // esi
  struct AFX_MODULE_STATE *ModuleState; // eax
  struct CWnd *TopLevelParent; // eax
  struct AFX_MODULE_STATE *v7; // eax

  v4 = *((_DWORD *)AfxGetModuleState() + 1);
  ModuleState = AfxGetModuleState();
  CCmdTarget::BeginWaitCursor(*((CCmdTarget **)ModuleState + 1));
  CWnd::PrepareForHelp(this);
  TopLevelParent = CWnd::GetTopLevelParent((CWnd *)this);
  if ( !WinHelpA(*((HWND *)TopLevelParent + 7), *(LPCSTR *)(v4 + 96), uCommand, dwData) )
    AfxMessageBox(0xF107u, 0, 0xFFFFFFFF);
  v7 = AfxGetModuleState();
  CCmdTarget::EndWaitCursor(*((CCmdTarget **)v7 + 1));
}


/* ==== 41B6EB  sub_41B6EB  ()  size=121 ==== */
void __thiscall sub_41B6EB(HWND *this, int a2, int a3)
{
  int v4; // esi
  struct AFX_MODULE_STATE *ModuleState; // eax
  struct CWnd *TopLevelParent; // eax
  struct AFX_MODULE_STATE *v7; // eax

  v4 = *((_DWORD *)AfxGetModuleState() + 1);
  ModuleState = AfxGetModuleState();
  CCmdTarget::BeginWaitCursor(*((CCmdTarget **)ModuleState + 1));
  CWnd::PrepareForHelp(this);
  TopLevelParent = CWnd::GetTopLevelParent((CWnd *)this);
  if ( !unknown_libname_34(*((_DWORD *)TopLevelParent + 7), *(_DWORD *)(v4 + 96), a3, a2) )
    AfxMessageBox(0xF107u, 0, 0xFFFFFFFF);
  v7 = AfxGetModuleState();
  CCmdTarget::EndWaitCursor(*((CCmdTarget **)v7 + 1));
}


/* ==== 41B764  ?OnChildNotify@CWnd@@MAEHIIJPAJ@Z  (CWnd::OnChildNotify(uint,uint,long,long *))  size=81 ==== */
LRESULT __thiscall CWnd::OnChildNotify(CWnd *this, unsigned int a2, HWND wParam, HWND lParam, int *a5)
{
  LRESULT result; // eax

  if ( !*((_DWORD *)this + 19) )
    return CWnd::ReflectChildNotify((LPARAM *)this, a2, wParam, lParam, a5);
  result = SendMessageA(*((HWND *)this + 7), a2 + 0x2000, (WPARAM)wParam, (LPARAM)lParam);
  if ( a2 < 0x132 || a2 > 0x138 || result )
  {
    if ( a5 )
      *a5 = result;
    return 1;
  }
  return result;
}


/* ==== 41B7B5  sub_41B7B5  ()  size=112 ==== */
int __thiscall sub_41B7B5(int this, int nIDDlgItem, volatile signed __int32 **a3)
{
  HWND v4; // eax
  HWND v5; // esi
  int WindowTextLengthA; // eax
  CHAR *v7; // eax
  struct CWnd *DlgItem; // eax
  int v10; // [esp-4h] [ebp-Ch]

  sub_4015C0(a3, ValueName);
  if ( *(_DWORD *)(this + 72) )
  {
    DlgItem = CWnd::GetDlgItem((CWnd *)this, nIDDlgItem);
    if ( DlgItem )
      sub_41A3DB((int)DlgItem, (int *)a3);
  }
  else
  {
    v4 = GetDlgItem(*(HWND *)(this + 28), nIDDlgItem);
    v5 = v4;
    if ( v4 )
    {
      WindowTextLengthA = GetWindowTextLengthA(v4);
      v10 = WindowTextLengthA + 1;
      v7 = (CHAR *)sub_40989B((int *)a3, WindowTextLengthA);
      GetWindowTextA(v5, v7, v10);
      ATL::CSimpleStringT<char,0>::ReleaseBuffer((const char **)a3, (const char *)0xFFFFFFFF);
    }
  }
  return *((_DWORD *)*a3 - 3);
}


/* ==== 41B842  ??__E?wndTop@CWnd@@2V1@B@@YAXXZ  (`dynamic initializer for 'CWnd const CWnd::wndTop''(void))  size=24 ==== */
int `dynamic initializer for 'public: static CWnd const CWnd::wndTop''()
{
  CWnd::CWnd((CWnd *)&unk_42FCB0, 0);
  return atexit(sub_41B8AC);
}


/* ==== 41B872  ??__E?wndTopMost@CWnd@@2V1@B@@YAXXZ  (`dynamic initializer for 'CWnd const CWnd::wndTopMost''(void))  size=24 ==== */
int `dynamic initializer for 'public: static CWnd const CWnd::wndTopMost''()
{
  CWnd::CWnd((CWnd *)&unk_42FD50, HWND_MESSAGE|0x2);
  return atexit(sub_41B8C0);
}


/* ==== 41B88A  ??__E?wndNoTopMost@CWnd@@2V1@B@@YAXXZ  (`dynamic initializer for 'CWnd const CWnd::wndNoTopMost''(void))  size=24 ==== */
int `dynamic initializer for 'public: static CWnd const CWnd::wndNoTopMost''()
{
  CWnd::CWnd((CWnd *)&unk_42FDA0, (HWND)0xFFFFFFFE);
  return atexit(sub_41B8CA);
}


/* ==== 41B8A2  sub_41B8A2  ()  size=10 ==== */
void sub_41B8A2()
{
  CProcessLocalObject::~CProcessLocalObject((CProcessLocalObject *)&unk_42FDF4);
}


/* ==== 41B8AC  sub_41B8AC  ()  size=10 ==== */
void __cdecl sub_41B8AC()
{
  CWnd::~CWnd((CWnd *)&unk_42FCB0);
}


/* ==== 41B8B6  sub_41B8B6  ()  size=10 ==== */
void sub_41B8B6()
{
  CWnd::~CWnd((CWnd *)&unk_42FD00);
}


/* ==== 41B8C0  sub_41B8C0  ()  size=10 ==== */
void __cdecl sub_41B8C0()
{
  CWnd::~CWnd((CWnd *)&unk_42FD50);
}


/* ==== 41B8CA  sub_41B8CA  ()  size=10 ==== */
void __cdecl sub_41B8CA()
{
  CWnd::~CWnd((CWnd *)&unk_42FDA0);
}


/* ==== 41B8D4  ?OnAmbientProperty@CWnd@@UAEHPAVCOleControlSite@@JPAUtagVARIANT@@@Z  (CWnd::OnAmbientProperty(COleControlSite *,long,tagVARIANT *))  size=8 ==== */
int __thiscall CWnd::OnAmbientProperty(CWnd *this, struct COleControlSite *a2, int a3, struct tagVARIANT *a4)
{
  return (*(int (__thiscall **)(_DWORD, struct COleControlSite *, int, struct tagVARIANT *))(**((_DWORD **)this + 18)
                                                                                           + 88))(
           *((_DWORD *)this + 18),
           a2,
           a3,
           a4);
}


/* ==== 41B8DC  ?GetControlUnknown@CWnd@@QAEPAUIUnknown@@XZ  (CWnd::GetControlUnknown(void))  size=12 ==== */
struct IUnknownVtbl *__thiscall CWnd::GetControlUnknown(CWnd *this)
{
  struct IUnknownVtbl *result; // eax

  result = (struct IUnknownVtbl *)*((_DWORD *)this + 19);
  if ( result )
    return (struct IUnknownVtbl *)result[6].AddRef;
  return result;
}


/* ==== 41B8E8  ?PaintWindowlessControls@CWnd@@QAEHPAVCDC@@@Z  (CWnd::PaintWindowlessControls(CDC *))  size=22 ==== */
int __thiscall CWnd::PaintWindowlessControls(CWnd *this, struct CDC *a2)
{
  if ( *((_DWORD *)this + 18) )
    return (*(int (__thiscall **)(_DWORD, struct CDC *))(**((_DWORD **)this + 18) + 152))(*((_DWORD *)this + 18), a2);
  else
    return 0;
}


/* ==== 41B8FE  ?GetOleControlSite@CWnd@@QBEPAVCOleControlSite@@I@Z  (CWnd::GetOleControlSite(uint))  size=19 ==== */
struct COleControlSite *__thiscall CWnd::GetOleControlSite(CWnd *this, unsigned int a2)
{
  if ( *((_DWORD *)this + 18) )
    return (struct COleControlSite *)(*(int (__thiscall **)(_DWORD, unsigned int))(**((_DWORD **)this + 18) + 84))(
                                       *((_DWORD *)this + 18),
                                       a2);
  else
    return 0;
}


/* ==== 41B911  ?GetDlgItem@CWnd@@QBEPAV1@H@Z  (CWnd::GetDlgItem(int))  size=36 ==== */
struct CWnd *__thiscall CWnd::GetDlgItem(CWnd *this, int nIDDlgItem)
{
  HWND DlgItem; // eax

  if ( *((_DWORD *)this + 18) )
    return (struct CWnd *)(*(int (__thiscall **)(_DWORD, int))(**((_DWORD **)this + 18) + 116))(
                            *((_DWORD *)this + 18),
                            nIDDlgItem);
  DlgItem = GetDlgItem(*((HWND *)this + 7), nIDDlgItem);
  return CWnd::FromHandle(DlgItem);
}


/* ==== 41B935  ?GetDlgItem@CWnd@@QBEXHPAPAUHWND__@@@Z  (CWnd::GetDlgItem(int,HWND__ * *))  size=36 ==== */
void __thiscall CWnd::GetDlgItem(CWnd *this, int nIDDlgItem, HWND *a3)
{
  if ( *((_DWORD *)this + 18) )
    (*(void (__thiscall **)(_DWORD, int, HWND *))(**((_DWORD **)this + 18) + 112))(
      *((_DWORD *)this + 18),
      nIDDlgItem,
      a3);
  else
    *a3 = GetDlgItem(*((HWND *)this + 7), nIDDlgItem);
}


/* ==== 41B959  sub_41B959  ()  size=37 ==== */
int __thiscall sub_41B959(int this, int nIDDlgItem, LPCSTR lpString)
{
  if ( *(_DWORD *)(this + 72) )
    return (*(int (__thiscall **)(_DWORD, int, LPCSTR))(**(_DWORD **)(this + 72) + 136))(
             *(_DWORD *)(this + 72),
             nIDDlgItem,
             lpString);
  else
    return SetDlgItemTextA(*(HWND *)(this + 28), nIDDlgItem, lpString);
}


/* ==== 41B97E  ?IsDialogMessageA@CWnd@@QAEHPAUtagMSG@@@Z  (CWnd::IsDialogMessageA(tagMSG *))  size=51 ==== */
int __thiscall CWnd::IsDialogMessageA(HWND *this, struct tagMSG *lpMsg)
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  if ( (*((_BYTE *)this + 57) & 1) == 0 )
    return IsDialogMessageA(this[7], lpMsg);
  ModuleState = AfxGetModuleState();
  return (*(int (__thiscall **)(_DWORD, HWND *, struct tagMSG *))(**((_DWORD **)ModuleState + 1038) + 36))(
           *((_DWORD *)ModuleState + 1038),
           this,
           lpMsg);
}


/* ==== 41B9B1  ?GetStyle@CWnd@@QBEKXZ  (CWnd::GetStyle(void))  size=26 ==== */
LONG __thiscall CWnd::GetStyle(CWnd *this)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 19) + 120))(*((_DWORD *)this + 19));
  else
    return GetWindowLongA(*((HWND *)this + 7), -16);
}


/* ==== 41B9CB  ?GetExStyle@CWnd@@QBEKXZ  (CWnd::GetExStyle(void))  size=26 ==== */
LONG __thiscall CWnd::GetExStyle(CWnd *this)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 19) + 124))(*((_DWORD *)this + 19));
  else
    return GetWindowLongA(*((HWND *)this + 7), -20);
}


/* ==== 41B9E5  ?ModifyStyleEx@CWnd@@QAEHKKI@Z  (CWnd::ModifyStyleEx(ulong,ulong,uint))  size=42 ==== */
int __thiscall CWnd::ModifyStyleEx(CWnd *this, unsigned int a2, unsigned int a3, unsigned int a4)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD, unsigned int, unsigned int, unsigned int))(**((_DWORD **)this + 19) + 132))(
             *((_DWORD *)this + 19),
             a2,
             a3,
             a4);
  else
    return CWnd::ModifyStyleEx(*((HWND *)this + 7), a2, a3, a4);
}


/* ==== 41BA0F  sub_41BA0F  ()  size=33 ==== */
int __thiscall sub_41BA0F(int this, LPCSTR lpString)
{
  if ( *(_DWORD *)(this + 76) )
    return (*(int (__thiscall **)(_DWORD, LPCSTR))(**(_DWORD **)(this + 76) + 136))(*(_DWORD *)(this + 76), lpString);
  else
    return SetWindowTextA(*(HWND *)(this + 28), lpString);
}


/* ==== 41BA30  ?MoveWindow@CWnd@@QAEXHHHHH@Z  (CWnd::MoveWindow(int,int,int,int,int))  size=62 ==== */
void __thiscall CWnd::MoveWindow(CWnd *this, int X, int Y, int nWidth, int nHeight, BOOL bRepaint)
{
  if ( *((_DWORD *)this + 19) )
    (*(void (__thiscall **)(_DWORD, int, int, int, int))(**((_DWORD **)this + 19) + 152))(
      *((_DWORD *)this + 19),
      X,
      Y,
      nWidth,
      nHeight);
  else
    MoveWindow(*((HWND *)this + 7), X, Y, nWidth, nHeight, bRepaint);
}


/* ==== 41BA6E  ?ShowWindow@CWnd@@QAEHH@Z  (CWnd::ShowWindow(int))  size=33 ==== */
int __thiscall CWnd::ShowWindow(CWnd *this, int nCmdShow)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD, int))(**((_DWORD **)this + 19) + 160))(*((_DWORD *)this + 19), nCmdShow);
  else
    return ShowWindow(*((HWND *)this + 7), nCmdShow);
}


/* ==== 41BA8F  ?IsWindowEnabled@CWnd@@QBEHXZ  (CWnd::IsWindowEnabled(void))  size=27 ==== */
int __thiscall CWnd::IsWindowEnabled(CWnd *this)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 19) + 164))(*((_DWORD *)this + 19));
  else
    return IsWindowEnabled(*((HWND *)this + 7));
}


/* ==== 41BAAA  ?EnableWindow@CWnd@@QAEHH@Z  (CWnd::EnableWindow(int))  size=33 ==== */
int __thiscall CWnd::EnableWindow(CWnd *this, BOOL bEnable)
{
  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD, BOOL))(**((_DWORD **)this + 19) + 168))(*((_DWORD *)this + 19), bEnable);
  else
    return EnableWindow(*((HWND *)this + 7), bEnable);
}


/* ==== 41BACB  ?SetFocus@CWnd@@QAEPAV1@XZ  (CWnd::SetFocus(void))  size=33 ==== */
struct CWnd *__thiscall CWnd::SetFocus(CWnd *this)
{
  HWND v1; // eax

  if ( *((_DWORD *)this + 19) )
    return (struct CWnd *)(*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 19) + 176))(*((_DWORD *)this + 19));
  v1 = SetFocus(*((HWND *)this + 7));
  return CWnd::FromHandle(v1);
}


/* ==== 41BAEC  ?AttachControlSite@CWnd@@QAEXPAV1@I@Z  (CWnd::AttachControlSite(CWnd *,uint))  size=37 ==== */
void __thiscall CWnd::AttachControlSite(CWnd *this, struct CWnd *a2, unsigned int a3)
{
  if ( !*((_DWORD *)this + 19) )
  {
    if ( *((_DWORD *)a2 + 18) )
      (*(void (__thiscall **)(_DWORD, CWnd *, unsigned int))(**((_DWORD **)a2 + 18) + 156))(
        *((_DWORD *)a2 + 18),
        this,
        a3);
  }
}


/* ==== 41BB11  ?SetWindowPos@CWnd@@QAEHPBV1@HHHHI@Z  (CWnd::SetWindowPos(CWnd const *,int,int,int,int,uint))  size=60 ==== */
int __thiscall CWnd::SetWindowPos(CWnd *this, HWND hWndInsertAfter, int X, int Y, int a5, int cy, UINT uFlags)
{
  HWND v7; // eax

  if ( *((_DWORD *)this + 19) )
    return (*(int (__thiscall **)(_DWORD, HWND, int, int, int, int, UINT))(**((_DWORD **)this + 19) + 156))(
             *((_DWORD *)this + 19),
             hWndInsertAfter,
             X,
             Y,
             a5,
             cy,
             uFlags);
  v7 = hWndInsertAfter;
  if ( hWndInsertAfter )
    v7 = (HWND)*((_DWORD *)hWndInsertAfter + 7);
  return SetWindowPos(*((HWND *)this + 7), v7, X, Y, a5, cy, uFlags);
}


/* ==== 41BB4D  ?AttachControlSite@CWnd@@IAEXPAVCHandleMap@@@Z  (CWnd::AttachControlSite(CHandleMap *))  size=65 ==== */
void __thiscall CWnd::AttachControlSite(HWND *this, struct CHandleMap *a2)
{
  HWND Parent; // eax
  _DWORD **ValueAt; // eax

  if ( this )
  {
    if ( !this[19] )
    {
      Parent = GetParent(this[7]);
      ValueAt = (_DWORD **)CMapPtrToPtr::GetValueAt((struct CHandleMap *)((char *)a2 + 28), (unsigned int)Parent);
      if ( ValueAt )
      {
        if ( ValueAt[18] )
          (*(void (__thiscall **)(_DWORD *, HWND *, _DWORD))(*ValueAt[18] + 156))(ValueAt[18], this, 0);
      }
    }
  }
}


/* ==== 41BB8E  ??0CCmdTarget@@QAE@XZ  (CCmdTarget::CCmdTarget(void))  size=26 ==== */
CCmdTarget *__thiscall CCmdTarget::CCmdTarget(CCmdTarget *this)
{
  CCmdTarget *result; // eax

  result = this;
  *((_DWORD *)this + 1) = 1;
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 4) = 0;
  *((_DWORD *)this + 5) = 1;
  *((_DWORD *)this + 6) = 0;
  return result;
}


/* ==== 41BBA8  ??1CCmdTarget@@UAE@XZ  (CCmdTarget::~CCmdTarget(void))  size=13 ==== */
void __thiscall CCmdTarget::~CCmdTarget(CCmdTarget *this)
{
  int v1; // eax

  v1 = *((_DWORD *)this + 4);
  if ( v1 )
    (*(void (**)(void))(v1 + 28))();
}


/* ==== 41BBB5  ?_AfxDispatchCmdMsg@@YGHPAVCCmdTarget@@IHP81@AEXXZPAXIPAUAFX_CMDHANDLERINFO@@@Z  (_AfxDispatchCmdMsg(CCmdTarget *,uint,int,void (CCmdTarget::*)(void),void *,uint,AFX_CMDHANDLERINFO *))  size=230 ==== */
int __stdcall _AfxDispatchCmdMsg(int a1, int a2, int a3, void (__thiscall *a4)(int), _DWORD *a5, int a6, _DWORD *a7)
{
  int v7; // edi
  int result; // eax
  int v9; // eax
  _DWORD *v10; // esi

  v7 = 1;
  if ( a7 )
  {
    *a7 = a1;
    a7[1] = a4;
    return 1;
  }
  else
  {
    switch ( a6 )
    {
      case '5':
        a4(a1);
        goto LABEL_19;
      case '6':
        v9 = ((int (__thiscall *)(int))a4)(a1);
        goto LABEL_18;
      case '7':
        ((void (__thiscall *)(int, int))a4)(a1, a2);
        goto LABEL_19;
      case '8':
        v9 = ((int (__thiscall *)(int, int))a4)(a1, a2);
        goto LABEL_18;
      case '9':
        ((void (__thiscall *)(int, _DWORD, _DWORD))a4)(a1, a5[1], *a5);
        goto LABEL_19;
      case ':':
        v9 = ((int (__thiscall *)(int, _DWORD, _DWORD))a4)(a1, a5[1], *a5);
        goto LABEL_18;
      case ';':
        ((void (__thiscall *)(int, int, _DWORD, _DWORD))a4)(a1, a2, a5[1], *a5);
        goto LABEL_19;
      case '<':
        v9 = ((int (__thiscall *)(int, int, _DWORD, _DWORD))a4)(a1, a2, a5[1], *a5);
        goto LABEL_18;
      case '=':
        v10 = a5;
        ((void (__thiscall *)(int, _DWORD *))a4)(a1, a5);
        goto LABEL_14;
      case '>':
        v10 = a5;
        ((void (__thiscall *)(int, _DWORD *, int))a4)(a1, a5, a2);
LABEL_14:
        v9 = v10[7] == 0;
        v10[7] = 0;
        goto LABEL_18;
      case '?':
        ((void (__thiscall *)(int, _DWORD *))a4)(a1, a5);
        goto LABEL_19;
      case '@':
        v9 = ((int (__thiscall *)(int, _DWORD *))a4)(a1, a5);
LABEL_18:
        v7 = v9;
LABEL_19:
        result = v7;
        break;
      default:
        result = 0;
        break;
    }
  }
  return result;
}


/* ==== 41BCCD  ?OnCmdMsg@CCmdTarget@@UAEHIHPAXPAUAFX_CMDHANDLERINFO@@@Z  (CCmdTarget::OnCmdMsg(uint,int,void *,AFX_CMDHANDLERINFO *))  size=268 ==== */
int __thiscall CCmdTarget::OnCmdMsg(
        CCmdTarget *this,
        unsigned int a2,
        unsigned int a3,
        _DWORD *Buf1,
        struct AFX_CMDHANDLERINFO *a5)
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  _DWORD *v9; // edi
  int i; // esi
  int v11; // eax
  bool v12; // zf
  unsigned int v13; // ebx
  int j; // esi
  _DWORD *v15; // eax
  int v16; // [esp+10h] [ebp+Ch]
  void *Buf1a; // [esp+14h] [ebp+10h]

  if ( a3 == -2 )
  {
    ModuleState = AfxGetModuleState();
    return (*(int (__thiscall **)(_DWORD, CCmdTarget *, unsigned int, _DWORD *, struct AFX_CMDHANDLERINFO *))(**((_DWORD **)ModuleState + 1038) + 4))(
             *((_DWORD *)ModuleState + 1038),
             this,
             a2,
             Buf1,
             a5);
  }
  if ( a3 == -3 )
  {
    v16 = 0;
    Buf1a = (void *)Buf1[12];
    v9 = (_DWORD *)(*(int (__thiscall **)(CCmdTarget *))(*(_DWORD *)this + 44))(this);
LABEL_19:
    if ( v9 && !v16 )
    {
      for ( i = v9[1]; ; i += 12 )
      {
        v11 = *(_DWORD *)(i + 4);
        if ( !v11 || !*(_DWORD *)(i + 8) || v16 )
        {
          v9 = (_DWORD *)*v9;
          goto LABEL_19;
        }
        if ( a2 == v11 )
        {
          if ( Buf1a )
          {
            if ( *(_DWORD *)i && unknown_libname_4(Buf1a, *(void **)i) )
            {
LABEL_15:
              Buf1[1] = *(_DWORD *)(i + 8);
              v16 = 1;
              continue;
            }
          }
          else if ( !*(_DWORD *)i )
          {
            goto LABEL_15;
          }
        }
      }
    }
    return v16;
  }
  else
  {
    if ( a3 == -1 || (v13 = HIWORD(a3), v12 = HIWORD(a3) == 0, a3 = (unsigned __int16)a3, v12) )
      v13 = 273;
    for ( j = (*(int (__thiscall **)(CCmdTarget *))(*(_DWORD *)this + 40))(this); ; j = *(_DWORD *)j )
    {
      if ( !j )
        return 0;
      v15 = unknown_libname_21(*(_DWORD **)(j + 4), v13, a3, a2);
      if ( v15 )
        break;
    }
    return _AfxDispatchCmdMsg((int)this, a2, a3, (void (__thiscall *)(int))v15[5], Buf1, v15[4], a5);
  }
}


/* ==== 41BDD9  sub_41BDD9  ()  size=6 ==== */
int __stdcall sub_41BDD9(int a1)
{
  return 1;
}


/* ==== 41BDDF  ?GetTypeLib@CCmdTarget@@UAEJKPAPAUITypeLib@@@Z  (CCmdTarget::GetTypeLib(ulong,ITypeLib * *))  size=8 ==== */
int __thiscall CCmdTarget::GetTypeLib(CCmdTarget *this, unsigned int a2, struct ITypeLib **a3)
{
  return -2147312566;
}


/* ==== 41BDE7  sub_41BDE7  ()  size=6 ==== */
void *sub_41BDE7()
{
  return &unk_4266A0;
}


/* ==== 41BDED  sub_41BDED  ()  size=6 ==== */
void *sub_41BDED()
{
  return &unk_4266C8;
}


/* ==== 41BDF3  sub_41BDF3  ()  size=6 ==== */
void *sub_41BDF3()
{
  return &unk_426700;
}


/* ==== 41BDF9  sub_41BDF9  ()  size=6 ==== */
void *sub_41BDF9()
{
  return &unk_42671C;
}


/* ==== 41BDFF  ?OnFinalRelease@CCmdTarget@@UAEXXZ  (CCmdTarget::OnFinalRelease(void))  size=46 ==== */
void __thiscall CCmdTarget::OnFinalRelease(CCmdTarget *this)
{
  CTypeLibCache *v2; // eax

  AfxLockGlobals(13);
  v2 = (CTypeLibCache *)(*(int (__thiscall **)(CCmdTarget *))(*(_DWORD *)this + 32))(this);
  if ( v2 )
    CTypeLibCache::Unlock(v2);
  AfxUnlockGlobals(13);
  (*(void (__thiscall **)(CCmdTarget *, int))(*(_DWORD *)this + 4))(this, 1);
}


/* ==== 41BE2D  sub_41BE2D  ()  size=5 ==== */
int __stdcall sub_41BE2D(int a1)
{
  return 0;
}


/* ==== 41BE32  sub_41BE32  ()  size=6 ==== */
void *sub_41BE32()
{
  return &unk_42672C;
}


/* ==== 41BE38  sub_41BE38  ()  size=6 ==== */
void *sub_41BE38()
{
  return &unk_426740;
}


/* ==== 41BE3E  ??0CCmdUI@@QAE@XZ  (CCmdUI::CCmdUI(void))  size=38 ==== */
CCmdUI *__thiscall CCmdUI::CCmdUI(CCmdUI *this)
{
  CCmdUI *result; // eax

  result = this;
  *(_DWORD *)this = off_42674C;
  *((_DWORD *)this + 8) = 0;
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 1) = 0;
  *((_DWORD *)this + 9) = 0;
  *((_DWORD *)this + 4) = 0;
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 5) = 0;
  *((_DWORD *)this + 7) = 0;
  *((_DWORD *)this + 6) = 0;
  return result;
}


/* ==== 41BE64  ?BeginWaitCursor@CCmdTarget@@QAEXXZ  (CCmdTarget::BeginWaitCursor(void))  size=21 ==== */
void __thiscall CCmdTarget::BeginWaitCursor(CCmdTarget *this)
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  ModuleState = AfxGetModuleState();
  (*(void (__thiscall **)(_DWORD, int))(**((_DWORD **)ModuleState + 1) + 156))(*((_DWORD *)ModuleState + 1), 1);
}


/* ==== 41BE79  ?EndWaitCursor@CCmdTarget@@QAEXXZ  (CCmdTarget::EndWaitCursor(void))  size=21 ==== */
void __thiscall CCmdTarget::EndWaitCursor(CCmdTarget *this)
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  ModuleState = AfxGetModuleState();
  (*(void (__thiscall **)(_DWORD, int))(**((_DWORD **)ModuleState + 1) + 156))(*((_DWORD *)ModuleState + 1), -1);
}


/* ==== 41BE8E  ?Enable@CCmdUI@@UAEXH@Z  (CCmdUI::Enable(int))  size=127 ==== */
void __thiscall CCmdUI::Enable(CCmdUI *this, BOOL a2)
{
  int v3; // eax
  int v4; // edi
  HWND Parent; // eax
  struct CWnd *v6; // eax

  v3 = *((_DWORD *)this + 3);
  if ( v3 )
  {
    if ( *((_DWORD *)this + 4) )
      return;
    EnableMenuItem(*(HMENU *)(v3 + 4), *((_DWORD *)this + 2), (a2 ? 0 : 3) | 0x400);
  }
  else
  {
    if ( !a2 )
    {
      v4 = *((_DWORD *)this + 5);
      if ( GetFocus() == *(HWND *)(v4 + 28) )
      {
        Parent = GetParent(*(HWND *)(v4 + 28));
        v6 = CWnd::FromHandle(Parent);
        SendMessageA(*((HWND *)v6 + 7), 0x28u, 0, 0);
      }
    }
    CWnd::EnableWindow(*((CWnd **)this + 5), a2);
  }
  *((_DWORD *)this + 6) = 1;
}


/* ==== 41BF0D  ?SetCheck@CCmdUI@@UAEXH@Z  (CCmdUI::SetCheck(int))  size=101 ==== */
void __thiscall CCmdUI::SetCheck(CCmdUI *this, WPARAM wParam)
{
  int v3; // eax

  v3 = *((_DWORD *)this + 3);
  if ( v3 )
  {
    if ( !*((_DWORD *)this + 4) )
      CheckMenuItem(*(HMENU *)(v3 + 4), *((_DWORD *)this + 2), (wParam != 0 ? 8 : 0) | 0x400);
  }
  else if ( (SendMessageA(*(HWND *)(*((_DWORD *)this + 5) + 28), 0x87u, 0, 0) & 0x2000) != 0 )
  {
    SendMessageA(*(HWND *)(*((_DWORD *)this + 5) + 28), 0xF1u, wParam, 0);
  }
}


/* ==== 41BF72  ?SetRadio@CCmdUI@@UAEXH@Z  (CCmdUI::SetRadio(int))  size=86 ==== */
void __thiscall CCmdUI::SetRadio(CCmdUI *this, int a2)
{
  (*(void (__thiscall **)(CCmdUI *, bool))(*(_DWORD *)this + 4))(this, a2 != 0);
  if ( *((_DWORD *)this + 3) )
  {
    if ( !*((_DWORD *)this + 4) )
    {
      if ( hBitmapChecked || (sub_41F67D(), hBitmapChecked) )
        SetMenuItemBitmaps(*(HMENU *)(*((_DWORD *)this + 3) + 4), *((_DWORD *)this + 2), 0x400u, 0, hBitmapChecked);
    }
  }
}


/* ==== 41BFC8  sub_41BFC8  ()  size=84 ==== */
int __thiscall sub_41BFC8(int this, LPCSTR lpNewItem)
{
  int result; // eax
  UINT MenuState; // eax

  result = *(_DWORD *)(this + 12);
  if ( !result )
    return sub_41E07D(*(HWND *)(*(_DWORD *)(this + 20) + 28), lpNewItem);
  if ( !*(_DWORD *)(this + 16) )
  {
    MenuState = GetMenuState(*(HMENU *)(result + 4), *(_DWORD *)(this + 8), 0x400u);
    return sub_4098D4(
             *(HMENU **)(this + 12),
             *(_DWORD *)(this + 8),
             MenuState & 0xFFFFF2FB | 0x400,
             *(_DWORD *)(this + 4),
             lpNewItem);
  }
  return result;
}


/* ==== 41C01C  sub_41C01C  ()  size=343 ==== */
int __stdcall sub_41C01C(LPCSTR lpString, int a2)
{
  HANDLE FirstFileA; // eax
  ATL::CTime *v4; // eax
  ATL::CTime *v5; // eax
  ATL::CTime *v6; // eax
  _BYTE v7[8]; // [esp+8h] [ebp-80h] BYREF
  _WIN32_FIND_DATAA FindFileData; // [esp+10h] [ebp-78h] BYREF

  if ( !lpString || lstrlenA(lpString) >= 260 )
    return 0;
  if ( !sub_41CA22((LPSTR)(a2 + 34), lpString) )
  {
    *(_BYTE *)(a2 + 34) = 0;
    return 0;
  }
  FirstFileA = FindFirstFileA(lpString, &FindFileData);
  if ( FirstFileA == (HANDLE)-1 )
    return 0;
  FindClose(FirstFileA);
  *(_BYTE *)(a2 + 32) = FindFileData.dwFileAttributes & 0x7F;
  *(_QWORD *)(a2 + 24) = (int)FindFileData.nFileSizeLow;
  if ( ATL::CTime::IsValidFILETIME(&FindFileData.ftCreationTime) )
  {
    v4 = ATL::CTime::CTime((ATL::CTime *)v7, &FindFileData.ftCreationTime, -1);
    *(_DWORD *)a2 = *(_DWORD *)v4;
    *(_DWORD *)(a2 + 4) = *((_DWORD *)v4 + 1);
  }
  else
  {
    *(_DWORD *)a2 = 0;
    *(_DWORD *)(a2 + 4) = 0;
  }
  if ( ATL::CTime::IsValidFILETIME(&FindFileData.ftLastAccessTime) )
  {
    v5 = ATL::CTime::CTime((ATL::CTime *)v7, &FindFileData.ftLastAccessTime, -1);
    *(_DWORD *)(a2 + 16) = *(_DWORD *)v5;
    *(_DWORD *)(a2 + 20) = *((_DWORD *)v5 + 1);
  }
  else
  {
    *(_DWORD *)(a2 + 16) = 0;
    *(_DWORD *)(a2 + 20) = 0;
  }
  if ( ATL::CTime::IsValidFILETIME(&FindFileData.ftLastWriteTime) )
  {
    v6 = ATL::CTime::CTime((ATL::CTime *)v7, &FindFileData.ftLastWriteTime, -1);
    *(_DWORD *)(a2 + 8) = *(_DWORD *)v6;
    *(_DWORD *)(a2 + 12) = *((_DWORD *)v6 + 1);
  }
  else
  {
    *(_DWORD *)(a2 + 8) = 0;
    *(_DWORD *)(a2 + 12) = 0;
  }
  if ( !*(_QWORD *)a2 )
  {
    *(_DWORD *)a2 = *(_DWORD *)(a2 + 8);
    *(_DWORD *)(a2 + 4) = *(_DWORD *)(a2 + 12);
  }
  if ( !*(_QWORD *)(a2 + 16) )
  {
    *(_DWORD *)(a2 + 16) = *(_DWORD *)(a2 + 8);
    *(_DWORD *)(a2 + 20) = *(_DWORD *)(a2 + 12);
  }
  return 1;
}


/* ==== 41C173  ?AfxLoadString@@YGHIPADI@Z  (AfxLoadString(uint,char *,uint))  size=75 ==== */
int __stdcall AfxLoadString(unsigned int a1, LPSTR lpMultiByteStr, unsigned int a3)
{
  struct AFX_MODULE_STATE *ModuleState; // eax
  HRSRC v4; // eax
  int result; // eax

  if ( !lpMultiByteStr )
    return 0;
  ModuleState = AfxGetModuleState();
  v4 = sub_4031F0(*((HMODULE *)ModuleState + 3), a1);
  if ( !v4 )
  {
    *lpMultiByteStr = 0;
    return 0;
  }
  result = WideCharToMultiByte(0, 0, (LPCWCH)v4 + 1, *(_WORD *)v4, lpMultiByteStr, a3 - 1, 0, 0);
  lpMultiByteStr[result] = 0;
  return result;
}


/* ==== 41C1BE  ?AfxFindStringResourceHandle@@YGPAUHINSTANCE__@@I@Z  (AfxFindStringResourceHandle(uint))  size=11 ==== */
HINSTANCE __stdcall AfxFindStringResourceHandle(unsigned int a1)
{
  return (HINSTANCE)*((_DWORD *)AfxGetModuleState() + 3);
}


/* ==== 41C1C9  sub_41C1C9  ()  size=6 ==== */
_UNKNOWN **sub_41C1C9()
{
  return &off_426944;
}


/* ==== 41C1CF  ?ProcessWndProcException@CWinApp@@UAEJPAVCException@@PBUtagMSG@@@Z  (CWinApp::ProcessWndProcException(CException *,tagMSG const *))  size=117 ==== */
int __thiscall CWinApp::ProcessWndProcException(CWinApp *this, struct CException *a2, const struct tagMSG *a3)
{
  int v3; // ebx
  int v4; // edi

  if ( a3->message == 1 || a3->message == 15 )
    return j_unknown_libname_35(a2, a3);
  v3 = 0;
  v4 = 61704;
  if ( a3->message == 273 )
  {
    if ( !a3->lParam )
      v4 = 61705;
    v3 = 1;
  }
  if ( CObject::IsKindOf(a2, (const struct CRuntimeClass *)&off_4257C0) )
  {
    (*(void (__stdcall **)(int, int))(*(_DWORD *)a2 + 16))(4144, v4);
  }
  else if ( !CObject::IsKindOf(a2, (const struct CRuntimeClass *)&off_425B78) )
  {
    (*(void (__stdcall **)(int, int))(*(_DWORD *)a2 + 16))(16, v4);
  }
  return v3;
}


/* ==== 41C244  ?OnIdle@CWinApp@@UAEHJ@Z  (CWinApp::OnIdle(long))  size=102 ==== */
BOOL __thiscall CWinApp::OnIdle(CWinApp *this, int a2)
{
  int v2; // ebx
  int v4; // eax

  v2 = a2;
  if ( a2 > 0 )
  {
    if ( a2 == 1 )
      CWinThread::OnIdle(this, 1);
  }
  else
  {
    CWinThread::OnIdle(this, a2);
    a2 = 0;
    if ( *((_DWORD *)this + 21) )
    {
      a2 = (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 21) + 16))(*((_DWORD *)this + 21));
      while ( a2 )
      {
        v4 = (*(int (__thiscall **)(_DWORD, int *))(**((_DWORD **)this + 21) + 20))(*((_DWORD *)this + 21), &a2);
        (*(void (__thiscall **)(int))(*(_DWORD *)v4 + 136))(v4);
      }
    }
  }
  return v2 < 1;
}


/* ==== 41C2AA  ?DevModeChange@CWinApp@@QAEXPAD@Z  (CWinApp::DevModeChange(char *))  size=158 ==== */
void __thiscall CWinApp::DevModeChange(CWinApp *this, char *lpString2)
{
  void *v3; // eax
  const CHAR *v4; // eax
  SIZE_T v5; // eax
  HGLOBAL v6; // eax
  struct _devicemodeA *v7; // eax
  HANDLE phPrinter; // [esp+8h] [ebp-4h] BYREF

  v3 = (void *)*((_DWORD *)this + 28);
  if ( v3 )
  {
    v4 = (const CHAR *)GlobalLock(v3);
    if ( !lstrcmpA(&v4[*((unsigned __int16 *)v4 + 1)], lpString2) )
    {
      if ( OpenPrinterA(lpString2, &phPrinter, 0) )
      {
        if ( *((_DWORD *)this + 27) )
          AfxGlobalFree(*((HGLOBAL *)this + 27));
        v5 = DocumentPropertiesA(0, phPrinter, lpString2, 0, 0, 0);
        v6 = GlobalAlloc(0x42u, v5);
        *((_DWORD *)this + 27) = v6;
        v7 = (struct _devicemodeA *)GlobalLock(v6);
        if ( DocumentPropertiesA(0, phPrinter, lpString2, v7, 0, 2u) != 1 )
        {
          AfxGlobalFree(*((HGLOBAL *)this + 27));
          *((_DWORD *)this + 27) = 0;
        }
        ClosePrinter(phPrinter);
      }
    }
  }
}


/* ==== 41C348  ?Run@CWinApp@@UAEHXZ  (CWinApp::Run(void))  size=33 ==== */
int __thiscall CWinApp::Run(CWinApp *this)
{
  if ( !*((_DWORD *)this + 7) && AfxOleGetUserCtrl() )
    AfxPostQuitMessage(0);
  return CWinThread::Run(this);
}


/* ==== 41C369  sub_41C369  ()  size=52 ==== */
int __thiscall sub_41C369(_DWORD *this, int a2, int a3)
{
  HWND *MainWnd; // esi

  MainWnd = (HWND *)AfxGetMainWnd();
  this[22] = 0;
  PostMessageA(MainWnd[7], 0x36Au, 0, 0);
  return (*((int (__thiscall **)(HWND *, int, int))*MainWnd + 29))(MainWnd, a2, a3);
}


/* ==== 41C39D  sub_41C39D  ()  size=52 ==== */
int __thiscall sub_41C39D(_DWORD *this, int a2, int a3)
{
  HWND *MainWnd; // esi

  MainWnd = (HWND *)AfxGetMainWnd();
  this[22] = 0;
  PostMessageA(MainWnd[7], 0x36Au, 0, 0);
  return (*((int (__thiscall **)(HWND *, int, int))*MainWnd + 30))(MainWnd, a2, a3);
}


/* ==== 41C3D1  ?WinHelpInternal@CWinApp@@UAEXKI@Z  (CWinApp::WinHelpInternal(ulong,uint))  size=52 ==== */
void __thiscall CWinApp::WinHelpInternal(CWinApp *this, unsigned int a2, unsigned int a3)
{
  HWND *MainWnd; // esi

  MainWnd = (HWND *)AfxGetMainWnd();
  *((_DWORD *)this + 22) = 0;
  PostMessageA(MainWnd[7], 0x36Au, 0, 0);
  (*((void (__thiscall **)(HWND *, unsigned int, unsigned int))*MainWnd + 31))(MainWnd, a2, a3);
}


/* ==== 41C405  ?AfxGetThread@@YGPAVCWinThread@@XZ  (AfxGetThread(void))  size=9 ==== */
struct CWinThread *__stdcall AfxGetThread()
{
  return (struct CWinThread *)*((_DWORD *)AfxGetModuleThreadState() + 1);
}


/* ==== 41C40E  ?AfxGetCurrentMessage@@YGPAUtagMSG@@XZ  (AfxGetCurrentMessage(void))  size=9 ==== */
struct tagMSG *__stdcall AfxGetCurrentMessage()
{
  return (struct tagMSG *)((char *)AfxGetThreadState() + 48);
}


/* ==== 41C417  unknown_libname_35  ()  size=37 ==== */
// MFC 3.1-14.0 32bit
int __stdcall unknown_libname_35(int a1, int a2)
{
  int v2; // eax

  v2 = *(_DWORD *)(a2 + 4);
  if ( v2 == 1 )
    return -1;
  if ( v2 == 15 )
    ValidateRect(*(HWND *)a2, 0);
  return 0;
}


/* ==== 41C43C  ?AfxProcessWndProcException@@YGJPAVCException@@PBUtagMSG@@@Z  (AfxProcessWndProcException(CException *,tagMSG const *))  size=22 ==== */
int __stdcall AfxProcessWndProcException(int a1, int a2)
{
  int v2; // ecx

  v2 = *((_DWORD *)AfxGetModuleThreadState() + 1);
  if ( v2 )
    return (*(int (__thiscall **)(int, int, int))(*(_DWORD *)v2 + 108))(v2, a1, a2);
  else
    return unknown_libname_35(a1, a2);
}


/* ==== 41C452  ?Delete@CWinThread@@UAEXXZ  (CWinThread::Delete(void))  size=14 ==== */
void __thiscall CWinThread::Delete(CWinThread *this)
{
  if ( *((_DWORD *)this + 9) )
    (*(void (__thiscall **)(CWinThread *, int))(*(_DWORD *)this + 4))(this, 1);
}


/* ==== 41C460  sub_41C460  ()  size=3 ==== */
int sub_41C460()
{
  return 0;
}


/* ==== 41C463  ?Run@CWinThread@@UAEHXZ  (CWinThread::Run(void))  size=141 ==== */
int __thiscall CWinThread::Run(CWinThread *this)
{
  int v2; // ebx
  bool v4; // zf
  int v5; // eax
  int v7; // [esp+10h] [ebp-8h]
  struct _AFX_THREAD_STATE *ThreadState; // [esp+14h] [ebp-4h]

  v2 = 1;
  ThreadState = AfxGetThreadState();
  v7 = 0;
LABEL_2:
  while ( v2 )
  {
    if ( PeekMessageA((LPMSG)((char *)ThreadState + 48), 0, 0, 0, 0) )
      break;
    if ( !(*(int (__thiscall **)(CWinThread *, int))(*(_DWORD *)this + 96))(this, v7++) )
      v2 = 0;
  }
  while ( 1 )
  {
    v4 = (*(int (__thiscall **)(CWinThread *))(*(_DWORD *)this + 92))(this) == 0;
    v5 = *(_DWORD *)this;
    if ( v4 )
      return (*(int (__thiscall **)(CWinThread *))(v5 + 104))(this);
    if ( (*(int (__thiscall **)(CWinThread *, int))(v5 + 100))(this, (int)ThreadState + 48) )
    {
      v2 = 1;
      v7 = 0;
    }
    if ( !PeekMessageA((LPMSG)((char *)ThreadState + 48), 0, 0, 0, 0) )
      goto LABEL_2;
  }
}


/* ==== 41C4F0  sub_41C4F0  ()  size=9 ==== */
int sub_41C4F0()
{
  return *((_DWORD *)AfxGetThreadState() + 14);
}


/* ==== 41C4F9  ?DispatchThreadMessageEx@CWinThread@@IAEHPAUtagMSG@@@Z  (CWinThread::DispatchThreadMessageEx(tagMSG *))  size=118 ==== */
int __thiscall CWinThread::DispatchThreadMessageEx(CWinThread *this, struct tagMSG *a2)
{
  _DWORD *i; // esi
  UINT message; // eax
  _DWORD *v4; // eax
  _DWORD *j; // eax

  for ( i = (_DWORD *)(*(int (__fastcall **)(CWinThread *))(*(_DWORD *)this + 40))(this); i; i = (_DWORD *)*i )
  {
    message = a2->message;
    if ( message >= 0xC000 )
    {
      for ( j = (_DWORD *)i[1]; ; j = v4 + 6 )
      {
        v4 = unknown_libname_21(j, 49152, 0, 0);
        if ( !v4 )
          break;
        if ( *(_DWORD *)v4[4] == a2->message )
          goto LABEL_4;
      }
    }
    else
    {
      v4 = unknown_libname_21((_DWORD *)i[1], message, 0, 0);
      if ( v4 )
      {
LABEL_4:
        ((void (__thiscall *)(CWinThread *, WPARAM, LPARAM))v4[5])(this, a2->wParam, a2->lParam);
        return 1;
      }
    }
  }
  return 0;
}


/* ==== 41C56F  j_unknown_libname_35  ()  size=5 ==== */
// attributes: thunk
int __stdcall j_unknown_libname_35(int a1, int a2)
{
  return unknown_libname_35(a1, a2);
}


/* ==== 41C574  ?IsEnterKey@@YAHPAUtagMSG@@@Z  (IsEnterKey(tagMSG *))  size=26 ==== */
BOOL __cdecl IsEnterKey(struct tagMSG *a1)
{
  return a1->message == 256 && a1->wParam == 13;
}


/* ==== 41C58E  ?AfxInternalPreTranslateMessage@@YAHPAUtagMSG@@@Z  (AfxInternalPreTranslateMessage(tagMSG *))  size=108 ==== */
int __cdecl AfxInternalPreTranslateMessage(struct tagMSG *a1)
{
  CWinThread *v1; // ecx
  HWND MainWnd; // eax
  struct CWnd *v4; // esi
  CWnd *v5; // eax

  v1 = (CWinThread *)*((_DWORD *)AfxGetModuleThreadState() + 1);
  if ( v1 && !a1->hwnd && CWinThread::DispatchThreadMessageEx(v1, a1) )
    return 1;
  MainWnd = (HWND)AfxGetMainWnd();
  v4 = (struct CWnd *)MainWnd;
  if ( MainWnd )
    MainWnd = (HWND)*((_DWORD *)MainWnd + 7);
  if ( CWnd::WalkPreTranslateTree(MainWnd, a1) )
    return 1;
  if ( !v4 )
    return 0;
  v5 = CWnd::FromHandle(a1->hwnd);
  if ( CWnd::GetTopLevelParent(v5) == v4 )
    return 0;
  return (*(int (__thiscall **)(struct CWnd *, struct tagMSG *))(*(_DWORD *)v4 + 256))(v4, a1);
}


/* ==== 41C5FA  ?AfxPreTranslateMessage@@YAHPAUtagMSG@@@Z  (AfxPreTranslateMessage(tagMSG *))  size=27 ==== */
int __cdecl AfxPreTranslateMessage(struct tagMSG *a1)
{
  int v1; // ecx

  v1 = *((_DWORD *)AfxGetModuleThreadState() + 1);
  if ( v1 )
    return (*(int (__thiscall **)(int, struct tagMSG *))(*(_DWORD *)v1 + 88))(v1, a1);
  else
    return AfxInternalPreTranslateMessage(a1);
}


/* ==== 41C615  ?AfxInternalIsIdleMessage@@YAHPAUtagMSG@@@Z  (AfxInternalIsIdleMessage(tagMSG *))  size=108 ==== */
BOOL __cdecl AfxInternalIsIdleMessage(struct tagMSG *a1)
{
  UINT message; // eax
  struct _AFX_THREAD_STATE *ThreadState; // ebx

  message = a1->message;
  if ( message != 512 && message != 160 )
    return message != 15 && message != 280;
  ThreadState = AfxGetThreadState();
  if ( unknown_libname_5((_DWORD *)ThreadState + 19, a1->pt.x, a1->pt.y) && a1->message == *((_DWORD *)ThreadState + 21) )
  {
    return 0;
  }
  else
  {
    *(POINT *)((char *)ThreadState + 76) = a1->pt;
    *((_DWORD *)ThreadState + 21) = a1->message;
    return 1;
  }
}


/* ==== 41C681  ?AfxIsIdleMessage@@YAHPAUtagMSG@@@Z  (AfxIsIdleMessage(tagMSG *))  size=27 ==== */
int __cdecl AfxIsIdleMessage(struct tagMSG *a1)
{
  int v1; // ecx

  v1 = *((_DWORD *)AfxGetModuleThreadState() + 1);
  if ( v1 )
    return (*(int (__thiscall **)(int, struct tagMSG *))(*(_DWORD *)v1 + 100))(v1, a1);
  else
    return AfxInternalIsIdleMessage(a1);
}


/* ==== 41C69C  ?allocate@?$allocator@D@std@@QAEPADI@Z_0  (std::allocator<char>::allocate(uint))  size=13 ==== */
BOOL __stdcall std::allocator<char>::allocate(struct tagMSG *a1)
{
  return AfxInternalIsIdleMessage(a1);
}


/* ==== 41C6A9  ?allocate@?$allocator@D@std@@QAEPADI@Z_1  (std::allocator<char>::allocate(uint))  size=13 ==== */
int __stdcall std::allocator<char>::allocate(struct tagMSG *a1)
{
  return AfxInternalPreTranslateMessage(a1);
}


/* ==== 41C6B6  ?GetMainWnd@CWinThread@@UAEPAVCWnd@@XZ  (CWinThread::GetMainWnd(void))  size=27 ==== */
struct CWnd *__thiscall CWinThread::GetMainWnd(CWinThread *this)
{
  struct CWnd *result; // eax
  HWND ActiveWindow; // eax

  result = (struct CWnd *)*((_DWORD *)this + 8);
  if ( !result )
  {
    result = (struct CWnd *)*((_DWORD *)this + 7);
    if ( !result )
    {
      ActiveWindow = GetActiveWindow();
      return CWnd::FromHandle(ActiveWindow);
    }
  }
  return result;
}


/* ==== 41C6D1  ?AfxInternalPumpMessage@@YGHXZ  (AfxInternalPumpMessage(void))  size=68 ==== */
BOOL __stdcall AfxInternalPumpMessage()
{
  struct _AFX_THREAD_STATE *ThreadState; // edi
  BOOL result; // eax

  ThreadState = AfxGetThreadState();
  result = GetMessageA((LPMSG)((char *)ThreadState + 48), 0, 0, 0);
  if ( result )
  {
    if ( *((_DWORD *)ThreadState + 13) != 874 && !AfxPreTranslateMessage((struct tagMSG *)((char *)ThreadState + 48)) )
    {
      TranslateMessage((const MSG *)((char *)ThreadState + 48));
      DispatchMessageA((const MSG *)((char *)ThreadState + 48));
    }
    return 1;
  }
  return result;
}


/* ==== 41C715  ?AfxPumpMessage@@YGHXZ  (AfxPumpMessage(void))  size=22 ==== */
int __stdcall AfxPumpMessage()
{
  int v0; // ecx

  v0 = *((_DWORD *)AfxGetModuleThreadState() + 1);
  if ( v0 )
    return (*(int (__thiscall **)(int))(*(_DWORD *)v0 + 92))(v0);
  else
    return AfxInternalPumpMessage();
}


/* ==== 41C72B  ?_AfxMsgFilterHook@@YGJHIJ@Z  (_AfxMsgFilterHook(int,uint,long))  size=89 ==== */
LRESULT __stdcall _AfxMsgFilterHook(int code, WPARAM wParam, LPARAM lParam)
{
  int v3; // ecx
  struct CNoTrackObject *Data; // eax

  if ( !*((_BYTE *)AfxGetModuleState() + 20) && code >= 0 )
  {
    v3 = *((_DWORD *)AfxGetModuleThreadState() + 1);
    if ( v3 )
      return (*(int (__thiscall **)(int, int, LPARAM))(*(_DWORD *)v3 + 112))(v3, code, lParam);
  }
  Data = CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
  return CallNextHookEx(*((HHOOK *)Data + 11), code, wParam, lParam);
}


/* ==== 41C784  ?ProcessMessageFilter@CWinThread@@UAEHHPAUtagMSG@@@Z  (CWinThread::ProcessMessageFilter(int,tagMSG *))  size=288 ==== */
int __thiscall CWinThread::ProcessMessageFilter(CWinThread *this, int a2, struct tagMSG *a3)
{
  CWnd *v4; // eax
  CFrameWnd *TopLevelFrame; // eax
  CFrameWnd *v6; // edi
  struct CWnd *MainWnd; // edi
  UINT message; // eax
  struct CNoTrackObject *Data; // eax
  struct CNoTrackObject *v10; // ebx
  CWinThread *v11; // esi
  _BYTE v12[28]; // [esp+8h] [ebp-20h] BYREF
  CWinThread *v13; // [esp+24h] [ebp-4h]

  v13 = this;
  if ( !a3 )
    return 0;
  if ( a2 )
  {
    if ( a2 != 2 )
      return 0;
    v4 = CWnd::FromHandle(a3->hwnd);
    if ( v4 )
    {
      TopLevelFrame = CWnd::GetTopLevelFrame(v4);
      v6 = TopLevelFrame;
      if ( TopLevelFrame )
      {
        if ( CFrameWnd::IsTracking(TopLevelFrame) )
        {
          if ( *((_DWORD *)v6 + 25) )
          {
            MainWnd = AfxGetMainWnd();
            if ( *((_DWORD *)v13 + 7) )
            {
              if ( IsEnterKey(a3) || a3->message == 514 )
              {
                SendMessageA(*((HWND *)MainWnd + 7), 0x111u, 0xE146u, 0);
                return 1;
              }
            }
          }
        }
      }
    }
  }
  AfxGetMainWnd();
  if ( !a2 )
  {
    if ( *((_DWORD *)v13 + 8) )
    {
      message = a3->message;
      if ( message >= 0x100 && message <= 0x109 )
      {
        Data = CThreadLocalObject::GetData(
                 (CThreadLocalObject *)&unk_42E340,
                 CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
        v10 = Data;
        if ( !*((_DWORD *)Data + 56) )
        {
          *((_DWORD *)Data + 56) = 1;
          qmemcpy(v12, a3, sizeof(v12));
          v11 = v13;
          if ( CWnd::IsWindowEnabled(*((CWnd **)v13 + 8))
            && (*(int (__thiscall **)(CWinThread *, _BYTE *))(*(_DWORD *)v11 + 88))(v11, v12) )
          {
            *((_DWORD *)v10 + 56) = 0;
            return 1;
          }
          *((_DWORD *)v10 + 56) = 0;
        }
      }
    }
  }
  return 0;
}


/* ==== 41C8A4  j_?AfxInternalPumpMessage@@YGHXZ  (AfxInternalPumpMessage(void))  size=5 ==== */
// attributes: thunk
BOOL __stdcall AfxInternalPumpMessage()
{
  return ?AfxInternalPumpMessage@@YGHXZ();
}


/* ==== 41C8A9  ?AfxInitThread@@YGXXZ  (AfxInitThread(void))  size=46 ==== */
void __stdcall AfxInitThread()
{
  struct _AFX_THREAD_STATE *ThreadState; // esi
  DWORD CurrentThreadId; // eax

  if ( !*((_BYTE *)AfxGetModuleState() + 20) )
  {
    ThreadState = AfxGetThreadState();
    CurrentThreadId = GetCurrentThreadId();
    *((_DWORD *)ThreadState + 11) = SetWindowsHookExA(-1, _AfxMsgFilterHook, 0, CurrentThreadId);
  }
}


/* ==== 41C8D7  ?OnIdle@CWinThread@@UAEHJ@Z  (CWinThread::OnIdle(long))  size=265 ==== */
BOOL __thiscall CWinThread::OnIdle(CWinThread *this, int a2)
{
  HWND *v2; // edi
  struct AFX_MODULE_STATE *v3; // eax
  int i; // esi
  struct AFX_MODULE_STATE *ModuleState; // eax

  if ( a2 > 0 )
  {
    ModuleState = AfxGetModuleState();
    if ( !*((_DWORD *)CThreadLocalObject::GetData(
                        (struct AFX_MODULE_STATE *)((char *)ModuleState + 4208),
                        CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject)
          + 4) )
    {
      AfxLockTempMaps();
      AfxUnlockTempMaps(1u);
    }
  }
  else
  {
    v2 = (HWND *)*((_DWORD *)this + 7);
    if ( v2 && v2[7] && IsWindowVisible(v2[7]) )
    {
      AfxCallWndProc((struct CWnd *)v2, v2[7], 0x363u, 1u, 0);
      CWnd::SendMessageToDescendants(v2[7], 0x363u, 1u, 0, 1, 1);
    }
    v3 = AfxGetModuleState();
    for ( i = *((_DWORD *)CThreadLocalObject::GetData(
                            (struct AFX_MODULE_STATE *)((char *)v3 + 4208),
                            CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject)
              + 2); i; i = *(_DWORD *)(i + 104) )
    {
      if ( *(_DWORD *)(i + 28) && (HWND *)i != v2 )
      {
        if ( !*(_DWORD *)(i + 156) )
          CWnd::ShowWindow((CWnd *)i, 0);
        if ( IsWindowVisible(*(HWND *)(i + 28)) || *(int *)(i + 156) >= 0 )
        {
          AfxCallWndProc((struct CWnd *)i, *(HWND *)(i + 28), 0x363u, 1u, 0);
          CWnd::SendMessageToDescendants(*(HWND *)(i + 28), 0x363u, 1u, 0, 1, 1);
        }
        if ( *(int *)(i + 156) > 0 )
          CWnd::ShowWindow((CWnd *)i, *(_DWORD *)(i + 156));
        *(_DWORD *)(i + 156) = -1;
      }
    }
  }
  return a2 < 0;
}


/* ==== 41C9E0  sub_41C9E0  ()  size=66 ==== */
int __stdcall sub_41C9E0(LPCSTR lpString2, int *a2)
{
  void *v2; // edi

  v2 = (void *)sub_4014A0(a2, 260);
  memset(v2, 0, 0x104u);
  lstrcpynA((LPSTR)v2, lpString2, 260);
  PathStripToRootA((LPSTR)v2);
  return ATL::CSimpleStringT<char,0>::ReleaseBuffer((const char **)a2, (const char *)0xFFFFFFFF);
}


/* ==== 41CA22  sub_41CA22  ()  size=337 ==== */
int __stdcall sub_41CA22(LPSTR lpBuffer, LPCSTR lpFileName)
{
  DWORD FullPathNameA; // eax
  void *v4; // eax
  int v5; // esi
  HANDLE FirstFileA; // eax
  int v7; // eax
  DWORD MaximumComponentLength; // [esp+Ch] [ebp-160h] BYREF
  DWORD FileSystemFlags; // [esp+10h] [ebp-15Ch] BYREF
  LPSTR FilePart; // [esp+14h] [ebp-158h] BYREF
  LPCSTR pszPath; // [esp+18h] [ebp-154h] BYREF
  struct _WIN32_FIND_DATAA FindFileData; // [esp+1Ch] [ebp-150h] BYREF
  int v13; // [esp+168h] [ebp-4h]

  FullPathNameA = GetFullPathNameA(lpFileName, 0x104u, lpBuffer, &FilePart);
  if ( !FullPathNameA )
  {
    lstrcpynA(lpBuffer, lpFileName, 260);
    return 0;
  }
  if ( FullPathNameA >= 0x104 )
    return 0;
  v4 = sub_417937();
  pszPath = (LPCSTR)((*(int (__thiscall **)(void *))(*(_DWORD *)v4 + 12))(v4) + 16);
  v13 = 0;
  sub_41C9E0(lpBuffer, (int *)&pszPath);
  if ( PathIsUNCA(pszPath) )
    goto LABEL_16;
  if ( GetVolumeInformationA(pszPath, 0, 0, 0, &MaximumComponentLength, &FileSystemFlags, 0, 0) )
  {
    if ( (FileSystemFlags & 2) == 0 )
      CharUpperA(lpBuffer);
    if ( (FileSystemFlags & 4) == 0 )
    {
      FirstFileA = FindFirstFileA(lpFileName, &FindFileData);
      if ( FirstFileA != (HANDLE)-1 )
      {
        FindClose(FirstFileA);
        if ( !FilePart )
          goto LABEL_7;
        if ( FilePart <= lpBuffer )
          goto LABEL_7;
        v7 = lstrlenA(FindFileData.cFileName);
        if ( (int)&FilePart[v7 - (_DWORD)lpBuffer] >= 260 )
          goto LABEL_7;
        lstrcpyA(FilePart, FindFileData.cFileName);
      }
    }
LABEL_16:
    v5 = 1;
    goto LABEL_17;
  }
LABEL_7:
  v5 = 0;
LABEL_17:
  ATL::CStringData::Release((ATL::CStringData *)(pszPath - 16));
  return v5;
}


/* ==== 41CB73  ?IsDerivedFrom@CRuntimeClass@@QBEHPBU1@@Z  (CRuntimeClass::IsDerivedFrom(CRuntimeClass const *))  size=34 ==== */
int __thiscall CRuntimeClass::IsDerivedFrom(CRuntimeClass *this, const struct CRuntimeClass *a2)
{
  if ( a2 )
  {
    while ( this )
    {
      if ( this == a2 )
        return 1;
      this = (CRuntimeClass *)*((_DWORD *)this + 4);
    }
  }
  return 0;
}


/* ==== 41CB95  ?IsKindOf@CObject@@QBEHPBUCRuntimeClass@@@Z  (CObject::IsKindOf(CRuntimeClass const *))  size=11 ==== */
int __thiscall CObject::IsKindOf(CObject *this, const struct CRuntimeClass *a2)
{
  CRuntimeClass *v2; // eax

  v2 = (CRuntimeClass *)(**(int (__thiscall ***)(CObject *))this)(this);
  return CRuntimeClass::IsDerivedFrom(v2, a2);
}


/* ==== 41CBA0  ?AfxDynamicDownCast@@YAPAVCObject@@PAUCRuntimeClass@@PAV1@@Z  (AfxDynamicDownCast(CRuntimeClass *,CObject *))  size=38 ==== */
struct CObject *__cdecl AfxDynamicDownCast(struct CRuntimeClass *a1, struct CObject *a2)
{
  CRuntimeClass *v2; // eax

  if ( a2
    && (v2 = (CRuntimeClass *)(**(int (__thiscall ***)(struct CObject *))a2)(a2), CRuntimeClass::IsDerivedFrom(v2, a1)) )
  {
    return a2;
  }
  else
  {
    return 0;
  }
}


/* ==== 41CBC6  ?AfxClassInit@@YGXPAUCRuntimeClass@@@Z  (AfxClassInit(CRuntimeClass *))  size=38 ==== */
void __stdcall AfxClassInit(struct CRuntimeClass *a1)
{
  AfxGetModuleState();
  AfxLockGlobals(0);
  unknown_libname_54(a1);
  AfxUnlockGlobals(0);
}


/* ==== 41CBEC  ?UpdateSysColors@AUX_DATA@@QAEXXZ  (AUX_DATA::UpdateSysColors(void))  size=68 ==== */
void __thiscall AUX_DATA::UpdateSysColors(AUX_DATA *this)
{
  *((_DWORD *)this + 10) = GetSysColor(15);
  *((_DWORD *)this + 11) = GetSysColor(16);
  *((_DWORD *)this + 12) = GetSysColor(20);
  *((_DWORD *)this + 13) = GetSysColor(18);
  *((_DWORD *)this + 14) = GetSysColor(6);
  *((_DWORD *)this + 9) = GetSysColorBrush(15);
  *((_DWORD *)this + 8) = GetSysColorBrush(6);
}


/* ==== 41CC30  ?UpdateSysMetrics@AUX_DATA@@QAEXXZ  (AUX_DATA::UpdateSysMetrics(void))  size=90 ==== */
void __thiscall AUX_DATA::UpdateSysMetrics(AUX_DATA *this)
{
  HDC DC; // edi

  *((_DWORD *)this + 2) = GetSystemMetrics(11);
  *((_DWORD *)this + 3) = GetSystemMetrics(12);
  dword_42FE00 = GetSystemMetrics(2) + 1;
  dword_42FE04 = GetSystemMetrics(3) + 1;
  DC = GetDC(0);
  *((_DWORD *)this + 6) = GetDeviceCaps(DC, 88);
  *((_DWORD *)this + 7) = GetDeviceCaps(DC, 90);
  ReleaseDC(0, DC);
}


/* ==== 41CC8A  ?HasFont@@YAHPBUDLGTEMPLATE@@@Z  (HasFont(DLGTEMPLATE const *))  size=23 ==== */
DWORD __cdecl HasFont(const struct DLGTEMPLATE *a1)
{
  DWORD style; // eax

  if ( HIWORD(a1->style) == 0xFFFF )
    style = *(_DWORD *)&a1->y;
  else
    style = a1->style;
  return style & 0x40;
}


/* ==== 41CCA1  ?SetTemplate@CDialogTemplate@@IAEHPBUDLGTEMPLATE@@I@Z  (CDialogTemplate::SetTemplate(DLGTEMPLATE const *,uint))  size=84 ==== */
int __thiscall CDialogTemplate::SetTemplate(CDialogTemplate *this, const struct DLGTEMPLATE *Src, unsigned int a3)
{
  int result; // eax
  struct DLGTEMPLATE *v5; // edi
  DWORD v6; // eax
  void *v7; // [esp-8h] [ebp-Ch]

  *((_DWORD *)this + 1) = a3;
  result = (int)GlobalAlloc(0x40u, a3 + 64);
  *(_DWORD *)this = result;
  if ( result )
  {
    v5 = (struct DLGTEMPLATE *)GlobalLock((HGLOBAL)result);
    memcpy_0(v5, Src, *((_DWORD *)this + 1));
    v6 = HasFont(v5);
    v7 = *(void **)this;
    *((_DWORD *)this + 2) = v6 == 0;
    GlobalUnlock(v7);
    return 1;
  }
  return result;
}


/* ==== 41CCF5  ??1InitialThreadParam@UMSFreeVirtualProcessorRoot@details@Concurrency@@QAE@XZ  (Concurrency::details::UMSFreeVirtualProcessorRoot::InitialThreadParam::~InitialThreadParam(void))  size=14 ==== */
void __thiscall Concurrency::details::UMSFreeVirtualProcessorRoot::InitialThreadParam::~InitialThreadParam(
        HGLOBAL *this)
{
  if ( *this )
    GlobalFree(*this);
}


/* ==== 41CD03  ?Detach@?$CComPtrBase@UICustomDestinationList@@@ATL@@QAEPAUICustomDestinationList@@XZ  (ATL::CComPtrBase<ICustomDestinationList>::Detach(void))  size=6 ==== */
int __thiscall ATL::CComPtrBase<ICustomDestinationList>::Detach(int *this)
{
  int result; // eax

  result = *this;
  *this = 0;
  return result;
}


/* ==== 41CD09  ?GetFontSizeField@CDialogTemplate@@KAPAEPBUDLGTEMPLATE@@@Z  (CDialogTemplate::GetFontSizeField(DLGTEMPLATE const *))  size=75 ==== */
WORD *__cdecl CDialogTemplate::GetFontSizeField(const struct DLGTEMPLATE *a1)
{
  WORD *result; // eax

  if ( HIWORD(a1->style) == 0xFFFF )
    result = &a1[1].cdit;
  else
    result = (WORD *)&a1[1];
  if ( *result == 0xFFFF )
  {
    result += 2;
  }
  else
  {
    while ( *result++ )
      ;
  }
  if ( *result == 0xFFFF )
  {
    result += 2;
  }
  else
  {
    while ( *result++ )
      ;
  }
  while ( *result++ )
    ;
  return result;
}


/* ==== 41CD54  ?GetTemplateSize@CDialogTemplate@@KAIPBUDLGTEMPLATE@@@Z  (CDialogTemplate::GetTemplateSize(DLGTEMPLATE const *))  size=195 ==== */
int __cdecl CDialogTemplate::GetTemplateSize(const struct DLGTEMPLATE *a1)
{
  BOOL v2; // ebx
  WORD *FontSizeField; // esi
  const wchar_t *v4; // esi
  unsigned __int16 cy; // ax
  int v6; // ecx
  int v7; // ebx
  unsigned __int16 *v8; // eax
  unsigned __int16 v11; // dx
  struct DLGTEMPLATE *v14; // [esp+14h] [ebp+8h]

  v2 = HIWORD(a1->style) == 0xFFFF;
  v14 = (struct DLGTEMPLATE *)v2;
  FontSizeField = CDialogTemplate::GetFontSizeField(a1);
  if ( HasFont(a1) )
  {
    v4 = &FontSizeField[2 * v2 + 1];
    FontSizeField = (WORD *)&v4[wcslen(v4) + 1];
  }
  if ( v2 )
    cy = a1->cy;
  else
    cy = a1->cdit;
  if ( cy )
  {
    v6 = v2 ? 24 : 18;
    v7 = cy;
    do
    {
      v8 = (unsigned __int16 *)(v6 + (((unsigned int)FontSizeField + 3) & 0xFFFFFFFC));
      if ( *v8 == 0xFFFF )
      {
        v8 += 2;
      }
      else
      {
        while ( *v8++ )
          ;
      }
      if ( *v8 == 0xFFFF )
      {
        v8 += 2;
      }
      else
      {
        while ( *v8++ )
          ;
      }
      v11 = *v8;
      if ( *v8 && !v14 )
        v11 -= 2;
      --v7;
      FontSizeField = (unsigned __int16 *)((char *)v8 + v11 + 2);
    }
    while ( v7 );
  }
  return (char *)FontSizeField - (char *)a1;
}


/* ==== 41CE17  sub_41CE17  ()  size=328 ==== */
int __thiscall sub_41CE17(int this, const CHAR *a2, WORD a3)
{
  const struct DLGTEMPLATE *v5; // ebx
  WORD *FontSizeField; // eax
  size_t v7; // ecx
  WORD *v8; // esi
  _BYTE *v9; // eax
  char *v10; // esi
  __int16 cy; // dx
  HGLOBAL v12; // [esp-Ch] [ebp-68h]
  WORD *v13; // [esp+4h] [ebp-58h]
  DWORD v14; // [esp+8h] [ebp-54h]
  _BYTE *v15; // [esp+8h] [ebp-54h]
  BOOL v16; // [esp+Ch] [ebp-50h]
  int v17; // [esp+10h] [ebp-4Ch]
  LPCSTR lpString; // [esp+14h] [ebp-48h]
  WCHAR WideCharStr[32]; // [esp+18h] [ebp-44h] BYREF

  if ( !*(_DWORD *)(this + 4) )
    return 0;
  v5 = (const struct DLGTEMPLATE *)GlobalLock(*(HGLOBAL *)this);
  v16 = HIWORD(v5->style) == 0xFFFF;
  v14 = HasFont(v5);
  v17 = 2 * v16 + 1;
  if ( v16 )
    *(_DWORD *)&v5->y |= 0x40u;
  else
    v5->style |= 0x40u;
  if ( lstrlenA(a2) >= 32 )
    return 0;
  lpString = (LPCSTR)(2 * (2 * v16 + 1) + 2 * MultiByteToWideChar(0, 0, a2, -1, WideCharStr, 32));
  FontSizeField = CDialogTemplate::GetFontSizeField(v5);
  v7 = 0;
  v8 = FontSizeField;
  v13 = FontSizeField;
  if ( v14 )
    v7 = v17 * 2 + 2 * wcslen(&FontSizeField[v17]) + 2;
  v9 = (_BYTE *)(((unsigned int)v8 + v7 + 3) & 0xFFFFFFFC);
  v10 = (char *)((int)&lpString[(_DWORD)v8 + 3] & 0xFFFFFFFC);
  v15 = v9;
  if ( v16 )
    cy = v5->cy;
  else
    cy = v5->cdit;
  if ( lpString != (LPCSTR)v7 )
  {
    if ( cy )
      memcpy(v10, v9, *(_DWORD *)(this + 4) + (char *)v5 - v9);
  }
  *v13 = a3;
  memcpy(&v13[v17], WideCharStr, (size_t)&lpString[-(v17 * 2)]);
  v12 = *(HGLOBAL *)this;
  *(_DWORD *)(this + 4) += v10 - v15;
  GlobalUnlock(v12);
  *(_DWORD *)(this + 8) = 0;
  return 1;
}


/* ==== 41CF5F  sub_41CF5F  ()  size=162 ==== */
int __thiscall sub_41CF5F(void *this, WORD a2)
{
  __int16 v2; // bx
  const CHAR *v3; // edi
  HGDIOBJ StockObject; // eax
  HDC DC; // eax
  HDC v6; // esi
  int DeviceCaps; // eax
  int pv[7]; // [esp+10h] [ebp-40h] BYREF
  char v11; // [esp+2Ch] [ebp-24h] BYREF

  v2 = 10;
  v3 = "System";
  StockObject = GetStockObject(17);
  if ( StockObject || (StockObject = GetStockObject(13)) != 0 )
  {
    if ( GetObjectA(StockObject, 60, pv) )
    {
      v3 = &v11;
      DC = GetDC(0);
      v6 = DC;
      if ( pv[0] < 0 )
        pv[0] = -pv[0];
      DeviceCaps = GetDeviceCaps(DC, 90);
      v2 = MulDiv(pv[0], 72, DeviceCaps);
      ReleaseDC(0, v6);
    }
  }
  if ( !a2 )
    a2 = v2;
  return sub_41CE17((int)this, v3, a2);
}


/* ==== 41D001  ??0CDialogTemplate@@QAE@PBUDLGTEMPLATE@@@Z  (CDialogTemplate::CDialogTemplate(DLGTEMPLATE const *))  size=47 ==== */
CDialogTemplate *__thiscall CDialogTemplate::CDialogTemplate(CDialogTemplate *this, const struct DLGTEMPLATE *Src)
{
  unsigned int TemplateSize; // eax

  if ( Src )
  {
    TemplateSize = CDialogTemplate::GetTemplateSize(Src);
    CDialogTemplate::SetTemplate(this, Src, TemplateSize);
  }
  else
  {
    *(_DWORD *)this = 0;
    *((_DWORD *)this + 1) = 0;
    *((_DWORD *)this + 2) = 0;
  }
  return this;
}


/* ==== 41D030  ?GetFont@CDialogTemplate@@SAHPBUDLGTEMPLATE@@AAV?$CStringT@DV?$StrTraitMFC@DV?$ChTraitsCRT@D@ATL@@@@@ATL@@AAG@Z  (CDialogTemplate::GetFont(DLGTEMPLATE const *,ATL::CStringT<char,StrTraitMFC<char,ATL::ChTraitsCRT<char>>> &,ushort &))  size=100 ==== */
DWORD __cdecl CDialogTemplate::GetFont(struct DLGTEMPLATE *a1, int *a2, WORD *a3)
{
  DWORD result; // eax
  WORD *FontSizeField; // eax
  const WCHAR *v5; // esi
  CHAR *v6; // eax

  result = HasFont(a1);
  if ( result )
  {
    FontSizeField = CDialogTemplate::GetFontSizeField(a1);
    *a3 = *FontSizeField;
    v5 = &FontSizeField[2 * (HIWORD(a1->style) == 0xFFFF) + 1];
    v6 = (CHAR *)sub_40989B(a2, 32);
    WideCharToMultiByte(0, 0, v5, -1, v6, 32, 0, 0);
    ATL::CSimpleStringT<char,0>::ReleaseBuffer((const char **)a2, (const char *)0xFFFFFFFF);
    return 1;
  }
  return result;
}


/* ==== 41D094  ?AfxLockTempMaps@@YGXXZ  (AfxLockTempMaps(void))  size=9 ==== */
void __stdcall AfxLockTempMaps()
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // eax

  ModuleThreadState = AfxGetModuleThreadState();
  ++*((_DWORD *)ModuleThreadState + 4);
}


/* ==== 41D09D  ??0CHandleMap@@QAE@PAUCRuntimeClass@@P6GXPAVCObject@@@Z2IH@Z  (CHandleMap::CHandleMap(CRuntimeClass *,void (*)(CObject *),void (*)(CObject *),uint,int))  size=132 ==== */
CHandleMap *__thiscall CHandleMap::CHandleMap(
        CHandleMap *this,
        struct CRuntimeClass *a2,
        void (__stdcall *a3)(struct CObject *),
        void (__stdcall *a4)(struct CObject *),
        unsigned int a5,
        int a6)
{
  *(_DWORD *)this = &CHandleMap::`vftable';
  CFixedAllocNoSync::CFixedAllocNoSync((CHandleMap *)((char *)this + 4), *((_DWORD *)a2 + 1), 0x40u);
  sub_417842((_DWORD *)this + 7, 10);
  sub_417842((_DWORD *)this + 14, 4);
  unknown_libname_18((int)this + 56, 7, 0);
  *((_DWORD *)this + 5) = a3;
  *((_DWORD *)this + 6) = a4;
  *((_DWORD *)this + 22) = a5;
  *((_DWORD *)this + 21) = a2;
  *((_DWORD *)this + 23) = a6;
  return this;
}


/* ==== 41D121  ?FromHandle@CHandleMap@@QAEPAVCObject@@PAX@Z  (CHandleMap::FromHandle(void *))  size=194 ==== */
struct CObject *__thiscall CHandleMap::FromHandle(CHandleMap *this, int (__cdecl *a2)(unsigned int))
{
  struct CObject *result; // eax
  int (__cdecl **v5)(unsigned int); // ecx
  void (__noreturn *v6)(); // eax
  _DWORD *v7; // eax
  _DWORD *v8; // ebx
  _DWORD *v9; // eax
  int (__cdecl **v10)(unsigned int); // eax
  _DWORD v11[5]; // [esp+0h] [ebp-20h] BYREF
  int v12; // [esp+1Ch] [ebp-4h]
  void (__noreturn *v13)(); // [esp+28h] [ebp+8h]

  v11[4] = v11;
  if ( !a2 )
    return 0;
  result = (struct CObject *)CMapPtrToPtr::GetValueAt((CHandleMap *)((char *)this + 28), (unsigned int)a2);
  if ( !result )
  {
    result = (struct CObject *)CMapPtrToPtr::GetValueAt((CHandleMap *)((char *)this + 56), (unsigned int)a2);
    if ( result )
    {
      v5 = (int (__cdecl **)(unsigned int))((char *)result + *((_DWORD *)this + 22));
      *v5 = a2;
      if ( *((_DWORD *)this + 23) == 2 )
        v5[1] = a2;
    }
    else
    {
      v6 = AfxSetNewHandler((void (__noreturn *)())AfxCriticalNewHandler);
      v12 = 0;
      v13 = v6;
      v7 = CFixedAllocNoSync::Alloc((CHandleMap *)((char *)this + 4));
      v8 = v7;
      if ( !v7 )
        unknown_libname_11();
      (*((void (__stdcall **)(_DWORD *))this + 5))(v7);
      v9 = (_DWORD *)sub_4178C6((CHandleMap *)((char *)this + 56), (unsigned int)a2);
      v12 = -1;
      *v9 = v8;
      AfxSetNewHandler(v13);
      v10 = (int (__cdecl **)(unsigned int))((char *)v8 + *((_DWORD *)this + 22));
      *v10 = a2;
      if ( *((_DWORD *)this + 23) == 2 )
        v10[1] = a2;
      return (struct CObject *)v8;
    }
  }
  return result;
}


/* ==== 41D1E3  ?DeleteTemp@CHandleMap@@QAEXXZ  (CHandleMap::DeleteTemp(void))  size=99 ==== */
void __thiscall CHandleMap::DeleteTemp(CHandleMap *this)
{
  bool v2; // zf
  _DWORD *v3; // eax
  void *v4; // [esp+4h] [ebp-Ch] BYREF
  struct __POSITION *v5; // [esp+8h] [ebp-8h] BYREF
  void *v6; // [esp+Ch] [ebp-4h] BYREF

  if ( this )
  {
    v2 = *((_DWORD *)this + 17) == 0;
    v5 = (struct __POSITION *)-(*((_DWORD *)this + 17) != 0);
    if ( !v2 )
    {
      do
      {
        CMapPtrToPtr::GetNextAssoc((CHandleMap *)((char *)this + 56), &v5, &v4, &v6);
        v3 = (char *)v6 + *((_DWORD *)this + 22);
        *v3 = 0;
        if ( *((_DWORD *)this + 23) == 2 )
          v3[1] = 0;
        (*((void (__stdcall **)(void *))this + 6))(v6);
      }
      while ( v5 );
    }
    sub_4176D2((int)this + 56);
    CFixedAllocNoSync::FreeAll((CPlex **)this + 1);
  }
}


/* ==== 41D246  ?AfxUnlockTempMaps@@YGHH@Z  (AfxUnlockTempMaps(int))  size=249 ==== */
BOOL __stdcall AfxUnlockTempMaps(size_t Size)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // ebx
  int v2; // eax
  int v3; // eax
  struct CWinThread *Thread; // eax
  void (__stdcall *v5)(_DWORD, _DWORD); // eax
  int v6; // edi
  struct CNoTrackObject *DataNA; // eax
  struct CNoTrackObject *v8; // esi
  void *v9; // eax
  void *v10; // eax
  size_t Sizea; // [esp+10h] [ebp+8h]

  ModuleThreadState = AfxGetModuleThreadState();
  v2 = *((_DWORD *)ModuleThreadState + 4);
  if ( v2 )
  {
    v3 = v2 - 1;
    *((_DWORD *)ModuleThreadState + 4) = v3;
    if ( !v3 )
    {
      if ( Size )
      {
        if ( Size != -1 )
        {
          Thread = AfxGetThread();
          if ( Thread )
          {
            v5 = (void (__stdcall *)(_DWORD, _DWORD))*((_DWORD *)Thread + 14);
            if ( v5 )
              v5(0, 0);
          }
        }
        CHandleMap::DeleteTemp(*((CHandleMap **)ModuleThreadState + 8));
        CHandleMap::DeleteTemp(*((CHandleMap **)ModuleThreadState + 7));
        CHandleMap::DeleteTemp(*((CHandleMap **)ModuleThreadState + 6));
        CHandleMap::DeleteTemp(*((CHandleMap **)ModuleThreadState + 5));
        CHandleMap::DeleteTemp(*((CHandleMap **)ModuleThreadState + 9));
      }
      v6 = *((_DWORD *)AfxGetModuleState() + 1);
      DataNA = CThreadLocalObject::GetDataNA((CThreadLocalObject *)&unk_42E340);
      v8 = DataNA;
      if ( DataNA
        && v6
        && (!*((_DWORD *)DataNA + 3) || _msize(*((void **)DataNA + 3)) < *(_DWORD *)(v6 + 148))
        && *(_DWORD *)(v6 + 148) )
      {
        v9 = (void *)*((_DWORD *)v8 + 3);
        Sizea = 0;
        if ( v9 )
        {
          Sizea = _msize(v9);
          free(*((void **)v8 + 3));
        }
        v10 = malloc(*(_DWORD *)(v6 + 148));
        *((_DWORD *)v8 + 3) = v10;
        if ( !v10 && Sizea )
          *((_DWORD *)v8 + 3) = malloc(Sizea);
      }
    }
  }
  return *((_DWORD *)ModuleThreadState + 4) != 0;
}


/* ==== 41D33F  ?afxMapHMENU@@YGPAVCHandleMap@@H@Z  (afxMapHMENU(int))  size=124 ==== */
struct CHandleMap *__stdcall afxMapHMENU(void *Block)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  void (__noreturn *v2)(); // ebx
  CHandleMap *v3; // ecx
  CHandleMap *v4; // eax

  ModuleThreadState = AfxGetModuleThreadState();
  if ( !*((_DWORD *)ModuleThreadState + 6) && Block )
  {
    v2 = AfxSetNewHandler((void (__noreturn *)())AfxCriticalNewHandler);
    v3 = (CHandleMap *)operator new(0x60u);
    if ( v3 )
      v4 = CHandleMap::CHandleMap(v3, (struct CRuntimeClass *)&off_426E38, sub_420980, unknown_libname_48, 4u, 1);
    else
      v4 = 0;
    *((_DWORD *)ModuleThreadState + 6) = v4;
    AfxSetNewHandler(v2);
  }
  return (struct CHandleMap *)*((_DWORD *)ModuleThreadState + 6);
}


/* ==== 41D3BB  ?FromHandle@CMenu@@SGPAV1@PAUHMENU__@@@Z  (CMenu::FromHandle(HMENU__ *))  size=14 ==== */
struct CMenu *__stdcall CMenu::FromHandle(int (__cdecl *a1)(unsigned int))
{
  CHandleMap *v1; // eax

  v1 = afxMapHMENU((void *)1);
  return CHandleMap::FromHandle(v1, a1);
}


/* ==== 41D3C9  ?FromHandlePermanent@CMenu@@SGPAV1@PAUHMENU__@@@Z  (CMenu::FromHandlePermanent(HMENU__ *))  size=26 ==== */
struct CMenu *__stdcall CMenu::FromHandlePermanent(unsigned int a1)
{
  struct CHandleMap *v1; // ecx
  struct CMenu *result; // eax

  v1 = afxMapHMENU(0);
  result = 0;
  if ( v1 )
    return (struct CMenu *)CMapPtrToPtr::GetValueAt((struct CHandleMap *)((char *)v1 + 28), a1);
  return result;
}


/* ==== 41D3E3  sub_41D3E3  ()  size=42 ==== */
unsigned int __thiscall sub_41D3E3(unsigned int *this)
{
  unsigned int v2; // edi
  struct CHandleMap *v3; // eax

  v2 = this[1];
  if ( v2 )
  {
    v3 = afxMapHMENU(0);
    if ( v3 )
      sub_417785((_DWORD *)v3 + 7, this[1]);
  }
  this[1] = 0;
  return v2;
}


/* ==== 41D423  _WinMain@16_0  ()  size=119 ==== */
int __stdcall WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
{
  int v4; // ebx
  struct CWinThread *Thread; // esi
  int v6; // edi
  int v7; // eax

  v4 = -1;
  Thread = AfxGetThread();
  v6 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( AfxWinInit(hInstance, hPrevInstance, lpCmdLine, nShowCmd)
    && (!v6 || (*(int (__thiscall **)(int))(*(_DWORD *)v6 + 144))(v6)) )
  {
    if ( (*(int (__thiscall **)(struct CWinThread *))(*(_DWORD *)Thread + 80))(Thread) )
    {
      v7 = (*(int (__thiscall **)(struct CWinThread *))(*(_DWORD *)Thread + 84))(Thread);
    }
    else
    {
      if ( *((_DWORD *)Thread + 7) )
        (*(void (__thiscall **)(_DWORD))(**((_DWORD **)Thread + 7) + 96))(*((_DWORD *)Thread + 7));
      v7 = (*(int (__thiscall **)(struct CWinThread *))(*(_DWORD *)Thread + 104))(Thread);
    }
    v4 = v7;
  }
  AfxWinTerm();
  return v4;
}


/* ==== 41D49A  unknown_libname_36  ()  size=10 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_36(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  this[2] = a2;
  return result;
}


/* ==== 41D4A4  unknown_libname_37  ()  size=10 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_37(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  this[1] = a2;
  return result;
}


/* ==== 41D4AE  ?ReleaseAttribDC@CDC@@UAEXXZ  (CDC::ReleaseAttribDC(void))  size=5 ==== */
void __thiscall CDC::ReleaseAttribDC(CDC *this)
{
  *((_DWORD *)this + 2) = 0;
}


/* ==== 41D4B3  ?Clear@TaskStack@details@Concurrency@@QAEXXZ  (Concurrency::details::TaskStack::Clear(void))  size=5 ==== */
void __thiscall Concurrency::details::TaskStack::Clear(Concurrency::details::TaskStack *this)
{
  *((_DWORD *)this + 1) = 0;
}


/* ==== 41D4B8  ?SaveDC@CDC@@UAEHXZ  (CDC::SaveDC(void))  size=49 ==== */
int __thiscall CDC::SaveDC(HDC *this)
{
  int v2; // ebx

  v2 = 0;
  if ( this[2] )
    v2 = SaveDC(this[2]);
  if ( this[1] != this[2] && SaveDC(this[1]) )
    return -1;
  return v2;
}


/* ==== 41D4E9  ?RestoreDC@CDC@@UAEHH@Z  (CDC::RestoreDC(int))  size=62 ==== */
BOOL __thiscall CDC::RestoreDC(CDC *this, int nSavedDC)
{
  HDC v3; // ecx
  BOOL result; // eax
  HDC v5; // esi

  v3 = (HDC)*((_DWORD *)this + 1);
  result = 1;
  if ( v3 != *((HDC *)this + 2) )
    result = RestoreDC(v3, nSavedDC);
  v5 = (HDC)*((_DWORD *)this + 2);
  if ( v5 )
    return result && RestoreDC(v5, nSavedDC);
  return result;
}


/* ==== 41D527  sub_41D527  ()  size=47 ==== */
int __thiscall sub_41D527(_DWORD *this, COLORREF color)
{
  HDC v3; // ecx
  int result; // eax
  HDC v5; // esi

  v3 = (HDC)this[1];
  result = -1;
  if ( v3 != (HDC)this[2] )
    result = SetBkColor(v3, color);
  v5 = (HDC)this[2];
  if ( v5 )
    return SetBkColor(v5, color);
  return result;
}


/* ==== 41D556  sub_41D556  ()  size=47 ==== */
int __thiscall sub_41D556(_DWORD *this, COLORREF color)
{
  HDC v3; // ecx
  int result; // eax
  HDC v5; // esi

  v3 = (HDC)this[1];
  result = -1;
  if ( v3 != (HDC)this[2] )
    result = SetTextColor(v3, color);
  v5 = (HDC)this[2];
  if ( v5 )
    return SetTextColor(v5, color);
  return result;
}


/* ==== 41D585  sub_41D585  ()  size=46 ==== */
int __thiscall sub_41D585(_DWORD *this, int iMode)
{
  HDC v3; // ecx
  int result; // eax
  HDC v5; // esi

  v3 = (HDC)this[1];
  result = 0;
  if ( v3 != (HDC)this[2] )
    result = SetMapMode(v3, iMode);
  v5 = (HDC)this[2];
  if ( v5 )
    return SetMapMode(v5, iMode);
  return result;
}


/* ==== 41D5B3  sub_41D5B3  ()  size=16 ==== */
int __thiscall sub_41D5B3(HDC *this, LPRECT lprect)
{
  return GetClipBox(this[1], lprect);
}


/* ==== 41D5C3  unknown_libname_38  ()  size=25 ==== */
// MFC 3.1-14.0 32bit
void __noreturn unknown_libname_38()
{
  void *pExceptionObject; // [esp+0h] [ebp-4h] BYREF

  pExceptionObject = &unk_42E348;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI5PAVCResourceException__);
}


/* ==== 41D5DD  unknown_libname_39  ()  size=25 ==== */
// MFC 3.1-14.0 32bit
void __noreturn unknown_libname_39()
{
  void *pExceptionObject; // [esp+0h] [ebp-4h] BYREF

  pExceptionObject = &unk_42E3E0;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI5PAVCUserException__);
}


/* ==== 41D5F7  ??0CDC@@QAE@XZ  (CDC::CDC(void))  size=20 ==== */
CDC *__thiscall CDC::CDC(CDC *this)
{
  CDC *result; // eax

  result = this;
  *(_DWORD *)this = &CDC::`vftable';
  *((_DWORD *)this + 1) = 0;
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 3) = 0;
  return result;
}


/* ==== 41D60B  ?SetViewportOrg@CDC@@UAE?AVCPoint@@HH@Z  (CDC::SetViewportOrg(int,int))  size=76 ==== */
struct tagPOINT *__thiscall CDC::SetViewportOrg(_DWORD *this, struct tagPOINT *a2, int x, int y)
{
  HDC v5; // eax
  HDC v6; // esi
  struct tagPOINT *result; // eax
  struct tagPOINT pt; // [esp+8h] [ebp-8h] BYREF

  v5 = (HDC)this[1];
  if ( v5 != (HDC)this[2] )
    SetViewportOrgEx(v5, x, y, &pt);
  v6 = (HDC)this[2];
  if ( v6 )
    SetViewportOrgEx(v6, x, y, &pt);
  result = a2;
  *a2 = pt;
  return result;
}


/* ==== 41D657  ?OffsetViewportOrg@CDC@@UAE?AVCPoint@@HH@Z  (CDC::OffsetViewportOrg(int,int))  size=76 ==== */
struct tagPOINT *__thiscall CDC::OffsetViewportOrg(_DWORD *this, struct tagPOINT *a2, int x, int y)
{
  HDC v5; // eax
  HDC v6; // esi
  struct tagPOINT *result; // eax
  struct tagPOINT pt; // [esp+8h] [ebp-8h] BYREF

  v5 = (HDC)this[1];
  if ( v5 != (HDC)this[2] )
    OffsetViewportOrgEx(v5, x, y, &pt);
  v6 = (HDC)this[2];
  if ( v6 )
    OffsetViewportOrgEx(v6, x, y, &pt);
  result = a2;
  *a2 = pt;
  return result;
}


/* ==== 41D6A3  ?SetViewportExt@CDC@@UAE?AVCSize@@HH@Z  (CDC::SetViewportExt(int,int))  size=76 ==== */
tagSIZE *__thiscall CDC::SetViewportExt(_DWORD *this, tagSIZE *a2, int x, int y)
{
  HDC v5; // eax
  HDC v6; // esi
  tagSIZE *result; // eax
  tagSIZE sz; // [esp+8h] [ebp-8h] BYREF

  v5 = (HDC)this[1];
  if ( v5 != (HDC)this[2] )
    SetViewportExtEx(v5, x, y, &sz);
  v6 = (HDC)this[2];
  if ( v6 )
    SetViewportExtEx(v6, x, y, &sz);
  result = a2;
  *a2 = sz;
  return result;
}


/* ==== 41D6EF  ?ScaleViewportExt@CDC@@UAE?AVCSize@@HHHH@Z  (CDC::ScaleViewportExt(int,int,int,int))  size=88 ==== */
struct tagSIZE *__thiscall CDC::ScaleViewportExt(_DWORD *this, struct tagSIZE *a2, int xn, int a4, int yn, int yd)
{
  HDC v7; // eax
  HDC v8; // esi
  struct tagSIZE *result; // eax
  struct tagSIZE sz; // [esp+8h] [ebp-8h] BYREF

  v7 = (HDC)this[1];
  if ( v7 != (HDC)this[2] )
    ScaleViewportExtEx(v7, xn, a4, yn, yd, &sz);
  v8 = (HDC)this[2];
  if ( v8 )
    ScaleViewportExtEx(v8, xn, a4, yn, yd, &sz);
  result = a2;
  *a2 = sz;
  return result;
}


/* ==== 41D747  ?SetWindowExt@CDC@@UAE?AVCSize@@HH@Z  (CDC::SetWindowExt(int,int))  size=76 ==== */
struct tagSIZE *__thiscall CDC::SetWindowExt(_DWORD *this, struct tagSIZE *a2, int x, int y)
{
  HDC v5; // eax
  HDC v6; // esi
  struct tagSIZE *result; // eax
  struct tagSIZE sz; // [esp+8h] [ebp-8h] BYREF

  v5 = (HDC)this[1];
  if ( v5 != (HDC)this[2] )
    SetWindowExtEx(v5, x, y, &sz);
  v6 = (HDC)this[2];
  if ( v6 )
    SetWindowExtEx(v6, x, y, &sz);
  result = a2;
  *a2 = sz;
  return result;
}


/* ==== 41D793  ?ScaleWindowExt@CDC@@UAE?AVCSize@@HHHH@Z  (CDC::ScaleWindowExt(int,int,int,int))  size=88 ==== */
struct tagSIZE *__thiscall CDC::ScaleWindowExt(_DWORD *this, struct tagSIZE *a2, int xn, int xd, int yn, int yd)
{
  HDC v7; // eax
  HDC v8; // esi
  struct tagSIZE *result; // eax
  struct tagSIZE sz; // [esp+8h] [ebp-8h] BYREF

  v7 = (HDC)this[1];
  if ( v7 != (HDC)this[2] )
    ScaleWindowExtEx(v7, xn, xd, yn, yd, &sz);
  v8 = (HDC)this[2];
  if ( v8 )
    ScaleWindowExtEx(v8, xn, xd, yn, yd, &sz);
  result = a2;
  *a2 = sz;
  return result;
}


/* ==== 41D7EB  sub_41D7EB  ()  size=60 ==== */
LONG __thiscall sub_41D7EB(HWND *this, LPPOINT lpPoint)
{
  LPPOINT v3; // ebx
  LONG result; // eax

  ScreenToClient(this[7], lpPoint);
  v3 = lpPoint + 1;
  ScreenToClient(this[7], lpPoint + 1);
  result = CWnd::GetExStyle((CWnd *)this);
  if ( ((unsigned int)&_ImageBase & result) != 0 )
  {
    result = lpPoint->x;
    lpPoint->x = v3->x;
    v3->x = result;
  }
  return result;
}


/* ==== 41D827  ?afxMapHDC@@YGPAVCHandleMap@@H@Z  (afxMapHDC(int))  size=124 ==== */
struct CHandleMap *__stdcall afxMapHDC(void *Block)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  void (__noreturn *v2)(); // ebx
  CHandleMap *v3; // ecx
  CHandleMap *v4; // eax

  ModuleThreadState = AfxGetModuleThreadState();
  if ( !*((_DWORD *)ModuleThreadState + 7) && Block )
  {
    v2 = AfxSetNewHandler((void (__noreturn *)())AfxCriticalNewHandler);
    v3 = (CHandleMap *)operator new(0x60u);
    if ( v3 )
      v4 = CHandleMap::CHandleMap(
             v3,
             (struct CRuntimeClass *)&off_425B58,
             ConstructDestruct<CDC>::Construct,
             unknown_libname_48,
             4u,
             2);
    else
      v4 = 0;
    *((_DWORD *)ModuleThreadState + 7) = v4;
    AfxSetNewHandler(v2);
  }
  return (struct CHandleMap *)*((_DWORD *)ModuleThreadState + 7);
}


/* ==== 41D8A3  ?FromHandle@CDC@@SGPAV1@PAUHDC__@@@Z  (CDC::FromHandle(HDC__ *))  size=14 ==== */
struct CDC *__stdcall CDC::FromHandle(int (__cdecl *a1)(unsigned int))
{
  CHandleMap *v1; // eax

  v1 = afxMapHDC((void *)1);
  return CHandleMap::FromHandle(v1, a1);
}


/* ==== 41D8B1  ?Attach@CDC@@QAEHPAUHDC__@@@Z  (CDC::Attach(HDC__ *))  size=55 ==== */
int __thiscall CDC::Attach(CDC *this, HDC a2)
{
  struct CHandleMap *v4; // eax

  if ( !a2 )
    return 0;
  v4 = afxMapHDC((void *)1);
  *((_DWORD *)this + 1) = a2;
  *(_DWORD *)sub_4178C6((struct CHandleMap *)((char *)v4 + 28), (unsigned int)a2) = this;
  (*(void (__thiscall **)(CDC *, _DWORD))(*(_DWORD *)this + 12))(this, *((_DWORD *)this + 1));
  return 1;
}


/* ==== 41D8E8  ?Detach@CDC@@QAEPAUHDC__@@XZ  (CDC::Detach(void))  size=49 ==== */
int __thiscall CDC::Detach(CDC *this)
{
  int v2; // edi
  struct CHandleMap *v3; // eax

  v2 = *((_DWORD *)this + 1);
  if ( v2 )
  {
    v3 = afxMapHDC(0);
    if ( v3 )
      sub_417785((_DWORD *)v3 + 7, *((_DWORD *)this + 1));
  }
  (*(void (__thiscall **)(CDC *))(*(_DWORD *)this + 20))(this);
  *((_DWORD *)this + 1) = 0;
  return v2;
}


/* ==== 41D919  ??1CDC@@UAE@XZ  (CDC::~CDC(void))  size=25 ==== */
void __thiscall CDC::~CDC(CDC *this)
{
  bool v1; // zf
  HDC v2; // eax

  v1 = *((_DWORD *)this + 1) == 0;
  *(_DWORD *)this = &CDC::`vftable';
  if ( !v1 )
  {
    v2 = (HDC)CDC::Detach(this);
    DeleteDC(v2);
  }
}


/* ==== 41D932  ??0CPaintDC@@QAE@PAVCWnd@@@Z  (CPaintDC::CPaintDC(CWnd *))  size=91 ==== */
CPaintDC *__thiscall CPaintDC::CPaintDC(CPaintDC *this, struct CWnd *a2)
{
  HDC v3; // eax
  HWND v5; // [esp-8h] [ebp-1Ch]

  *((_DWORD *)this + 1) = 0;
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 3) = 0;
  *(_DWORD *)this = &CPaintDC::`vftable';
  v5 = (HWND)*((_DWORD *)a2 + 7);
  *((_DWORD *)this + 4) = v5;
  v3 = BeginPaint(v5, (LPPAINTSTRUCT)((char *)this + 20));
  if ( !CDC::Attach(this, v3) )
    unknown_libname_38();
  return this;
}


/* ==== 41D98D  ??1CPaintDC@@UAE@XZ  (CPaintDC::~CPaintDC(void))  size=71 ==== */
void __thiscall CPaintDC::~CPaintDC(CPaintDC *this)
{
  *(_DWORD *)this = &CPaintDC::`vftable';
  EndPaint(*((HWND *)this + 4), (const PAINTSTRUCT *)((char *)this + 20));
  CDC::Detach(this);
  CDC::~CDC(this);
}


/* ==== 41D9D4  ?afxMapHGDIOBJ@@YGPAVCHandleMap@@H@Z  (afxMapHGDIOBJ(int))  size=124 ==== */
struct CHandleMap *__stdcall afxMapHGDIOBJ(int a1)
{
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  void (__noreturn *v2)(); // ebx
  CHandleMap *v3; // ecx
  CHandleMap *v4; // eax

  ModuleThreadState = AfxGetModuleThreadState();
  if ( !*((_DWORD *)ModuleThreadState + 8) && a1 )
  {
    v2 = AfxSetNewHandler((void (__noreturn *)())AfxCriticalNewHandler);
    v3 = (CHandleMap *)operator new(0x60u);
    if ( v3 )
      v4 = CHandleMap::CHandleMap(v3, (struct CRuntimeClass *)&off_425B08, sub_41EECF, unknown_libname_48, 4u, 1);
    else
      v4 = 0;
    *((_DWORD *)ModuleThreadState + 8) = v4;
    AfxSetNewHandler(v2);
  }
  return (struct CHandleMap *)*((_DWORD *)ModuleThreadState + 8);
}


/* ==== 41DA50  ?FromHandle@CGdiObject@@SGPAV1@PAX@Z  (CGdiObject::FromHandle(void *))  size=14 ==== */
struct CGdiObject *__stdcall CGdiObject::FromHandle(int (__cdecl *a1)(unsigned int))
{
  CHandleMap *v1; // eax

  v1 = afxMapHGDIOBJ(1);
  return CHandleMap::FromHandle(v1, a1);
}


/* ==== 41DA5E  sub_41DA5E  ()  size=45 ==== */
int __thiscall sub_41DA5E(_DWORD *this, unsigned int a2)
{
  struct CHandleMap *v4; // eax

  if ( !a2 )
    return 0;
  v4 = afxMapHGDIOBJ(1);
  this[1] = a2;
  *(_DWORD *)sub_4178C6((struct CHandleMap *)((char *)v4 + 28), a2) = this;
  return 1;
}


/* ==== 41DA8B  ?Detach@CGdiObject@@QAEPAXXZ  (CGdiObject::Detach(void))  size=42 ==== */
int __thiscall CGdiObject::Detach(CGdiObject *this)
{
  int v2; // edi
  struct CHandleMap *v3; // eax

  v2 = *((_DWORD *)this + 1);
  if ( v2 )
  {
    v3 = afxMapHGDIOBJ(0);
    if ( v3 )
      sub_417785((_DWORD *)v3 + 7, *((_DWORD *)this + 1));
  }
  *((_DWORD *)this + 1) = 0;
  return v2;
}


/* ==== 41DAB5  ?DeleteObject@CGdiObject@@QAEHXZ  (CGdiObject::DeleteObject(void))  size=22 ==== */
BOOL __thiscall CGdiObject::DeleteObject(CGdiObject *this)
{
  void *v2; // eax

  if ( !*((_DWORD *)this + 1) )
    return 0;
  v2 = (void *)CGdiObject::Detach(this);
  return DeleteObject(v2);
}


/* ==== 41DACB  sub_41DACB  ()  size=28 ==== */
CDC *__thiscall sub_41DACB(CDC *Block, char a2)
{
  CDC::~CDC(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41DAE7  ?SelectStockObject@CDC@@UAEPAVCGdiObject@@H@Z  (CDC::SelectStockObject(int))  size=60 ==== */
struct CGdiObject *__thiscall CDC::SelectStockObject(CDC *this, int i)
{
  HGDIOBJ StockObject; // eax
  HDC v4; // ecx
  void *v5; // ebx
  int (__cdecl *v6)(unsigned int); // eax
  HDC v7; // esi

  StockObject = GetStockObject(i);
  v4 = (HDC)*((_DWORD *)this + 1);
  v5 = StockObject;
  v6 = 0;
  if ( v4 != *((HDC *)this + 2) )
    v6 = (int (__cdecl *)(unsigned int))SelectObject(v4, v5);
  v7 = (HDC)*((_DWORD *)this + 2);
  if ( v7 )
    v6 = (int (__cdecl *)(unsigned int))SelectObject(v7, v5);
  return CGdiObject::FromHandle(v6);
}


/* ==== 41DB23  unknown_libname_40  ()  size=70 ==== */
// MFC 3.1-14.0 32bit
struct CGdiObject *__thiscall unknown_libname_40(_DWORD *this, int a2)
{
  HDC v3; // ecx
  HGDIOBJ v4; // eax
  HDC v5; // esi
  void *v6; // eax

  v3 = (HDC)this[1];
  v4 = 0;
  if ( v3 != (HDC)this[2] )
  {
    if ( a2 )
      v4 = *(HGDIOBJ *)(a2 + 4);
    v4 = SelectObject(v3, v4);
  }
  v5 = (HDC)this[2];
  if ( v5 )
  {
    if ( a2 )
      v6 = *(void **)(a2 + 4);
    else
      v6 = 0;
    v4 = SelectObject(v5, v6);
  }
  return CGdiObject::FromHandle((int (__cdecl *)(unsigned int))v4);
}


/* ==== 41DB69  sub_41DB69  ()  size=28 ==== */
CPaintDC *__thiscall sub_41DB69(CPaintDC *Block, char a2)
{
  CPaintDC::~CPaintDC(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41DB85  ?OnAppExit@CWinApp@@IAEXXZ  (CWinApp::OnAppExit(void))  size=19 ==== */
void __thiscall CWinApp::OnAppExit(CWinApp *this)
{
  SendMessageA(*(HWND *)(*((_DWORD *)this + 7) + 28), 0x10u, 0, 0);
}


/* ==== 41DB98  ?Read@CArchive@@QAEIPAXI@Z  (CArchive::Read(void *,uint))  size=301 ==== */
unsigned int __thiscall CArchive::Read(CArchive *this, char *a2, unsigned int a3)
{
  const void *v5; // eax
  size_t v6; // edi
  size_t v7; // ebx
  size_t v8; // edi
  int v9; // eax
  size_t v10; // edi
  int v11; // eax
  char *v12; // eax
  size_t v13; // edi
  int v14; // [esp+8h] [ebp-8h]
  int v15; // [esp+8h] [ebp-8h]
  size_t v16; // [esp+Ch] [ebp-4h]
  size_t v17; // [esp+Ch] [ebp-4h]
  char *v18; // [esp+18h] [ebp+8h]

  if ( !a3 || !a2 )
    return 0;
  if ( (*((_BYTE *)this + 24) & 1) == 0 )
    sub_41DFF7(4, *((_DWORD *)this + 5));
  v5 = (const void *)*((_DWORD *)this + 10);
  v6 = *((_DWORD *)this + 11) - (_DWORD)v5;
  if ( a3 < v6 )
    v6 = a3;
  memcpy_0(a2, v5, v6);
  *((_DWORD *)this + 10) += v6;
  v18 = &a2[v6];
  v7 = a3 - v6;
  if ( a3 != v6 )
  {
    v8 = v7 - v7 % *((_DWORD *)this + 8);
    v14 = 0;
    v16 = v8;
    do
    {
      v9 = (*(int (__thiscall **)(_DWORD, char *, size_t))(**((_DWORD **)this + 9) + 52))(
             *((_DWORD *)this + 9),
             v18,
             v16);
      v18 += v9;
      v14 += v9;
      v16 -= v9;
    }
    while ( v9 && v16 );
    v7 -= v14;
    if ( v7 )
    {
      if ( v14 == v8 )
      {
        v10 = 0;
        if ( *((_DWORD *)this + 2) )
        {
          (*(void (__thiscall **)(_DWORD, _DWORD, _DWORD, char *, char *))(**((_DWORD **)this + 9) + 80))(
            *((_DWORD *)this + 9),
            0,
            *((_DWORD *)this + 8),
            (char *)this + 48,
            (char *)this + 44);
          v12 = (char *)*((_DWORD *)this + 12);
        }
        else
        {
          if ( *((_DWORD *)this + 3) || (v17 = *((_DWORD *)this + 8), v7 > v17) )
            v17 = v7;
          v15 = *((_DWORD *)this + 12);
          do
          {
            v11 = (*(int (__thiscall **)(_DWORD, int, size_t))(**((_DWORD **)this + 9) + 52))(
                    *((_DWORD *)this + 9),
                    v15,
                    v17);
            v15 += v11;
            v17 -= v11;
            v10 += v11;
          }
          while ( v11 && v17 && v10 < v7 );
          v12 = (char *)*((_DWORD *)this + 12);
          *((_DWORD *)this + 11) = &v12[v10];
        }
        v13 = *((_DWORD *)this + 11) - (_DWORD)v12;
        *((_DWORD *)this + 10) = v12;
        if ( v7 < v13 )
          v13 = v7;
        memcpy_0(v18, v12, v13);
        *((_DWORD *)this + 10) += v13;
        v7 -= v13;
      }
    }
  }
  return a3 - v7;
}


/* ==== 41DCC5  ?Flush@CArchive@@QAEXXZ  (CArchive::Flush(void))  size=119 ==== */
void __thiscall CArchive::Flush(CArchive *this)
{
  int v2; // eax
  int v3; // edx
  int v4; // eax
  int *v5; // edi
  int v6; // edx

  v2 = *((_DWORD *)this + 10);
  if ( (*((_BYTE *)this + 24) & 1) != 0 )
  {
    v3 = *((_DWORD *)this + 11);
    if ( v3 != v2 )
      (*(void (__thiscall **)(_DWORD, int, int, int))(**((_DWORD **)this + 9) + 40))(
        *((_DWORD *)this + 9),
        v2 - v3,
        (v2 - v3) >> 31,
        1);
    v4 = *((_DWORD *)this + 11);
  }
  else
  {
    v5 = (int *)((char *)this + 48);
    v6 = *((_DWORD *)this + 12);
    if ( *((_DWORD *)this + 2) )
    {
      if ( v2 != v6 )
        (*(void (__stdcall **)(int, int, _DWORD, _DWORD))(**((_DWORD **)this + 9) + 80))(2, v2 - v6, 0, 0);
      (*(void (__thiscall **)(_DWORD, int, _DWORD, char *, char *))(**((_DWORD **)this + 9) + 80))(
        *((_DWORD *)this + 9),
        1,
        *((_DWORD *)this + 8),
        (char *)this + 48,
        (char *)this + 44);
    }
    else if ( v2 != v6 )
    {
      (*(void (__thiscall **)(_DWORD, int, int))(**((_DWORD **)this + 9) + 56))(*((_DWORD *)this + 9), v6, v2 - v6);
    }
    v4 = *v5;
  }
  *((_DWORD *)this + 10) = v4;
}


/* ==== 41DD3C  ?FillBuffer@CArchive@@QAEXI@Z  (CArchive::FillBuffer(uint))  size=232 ==== */
void __thiscall CArchive::FillBuffer(CArchive *this, unsigned int a2)
{
  char *v3; // ecx
  signed int v4; // edi
  char *v5; // eax
  unsigned int v6; // ebx
  unsigned int v7; // ebx
  char *v8; // edi
  int v9; // eax
  int v10; // eax
  int v11; // [esp-8h] [ebp-1Ch]
  unsigned int v12; // [esp+Ch] [ebp-8h]
  unsigned int v13; // [esp+10h] [ebp-4h]

  if ( (*((_BYTE *)this + 24) & 1) == 0 )
    sub_41DFF7(4, *((_DWORD *)this + 5));
  v3 = (char *)*((_DWORD *)this + 10);
  v4 = *((_DWORD *)this + 11) - (_DWORD)v3;
  v12 = v4 + a2;
  if ( *((_DWORD *)this + 2) )
  {
    if ( v4 )
      (*(void (__thiscall **)(_DWORD, char *, int, int))(**((_DWORD **)this + 9) + 40))(
        *((_DWORD *)this + 9),
        &v3[-*((_DWORD *)this + 11)],
        (int)&v3[-*((_DWORD *)this + 11)] >> 31,
        1);
    (*(void (__thiscall **)(_DWORD, _DWORD, _DWORD, char *, char *))(**((_DWORD **)this + 9) + 80))(
      *((_DWORD *)this + 9),
      0,
      *((_DWORD *)this + 8),
      (char *)this + 48,
      (char *)this + 44);
    *((_DWORD *)this + 10) = *((_DWORD *)this + 12);
  }
  else
  {
    v5 = (char *)*((_DWORD *)this + 12);
    if ( v3 > v5 )
    {
      if ( v4 > 0 )
      {
        memcpy(v5, v3, v4);
        v5 = (char *)*((_DWORD *)this + 12);
        *((_DWORD *)this + 10) = v5;
        *((_DWORD *)this + 11) = &v5[v4];
      }
      v6 = a2;
      v13 = v4;
      if ( !*((_DWORD *)this + 3) )
        v6 = *((_DWORD *)this + 8);
      v7 = v6 - v4;
      v8 = &v5[v4];
      do
      {
        v9 = (*(int (__thiscall **)(_DWORD, char *, unsigned int))(**((_DWORD **)this + 9) + 52))(
               *((_DWORD *)this + 9),
               v8,
               v7);
        v13 += v9;
        v8 += v9;
        v7 -= v9;
      }
      while ( v9 && v7 && v13 < a2 );
      v10 = *((_DWORD *)this + 12);
      *((_DWORD *)this + 10) = v10;
      *((_DWORD *)this + 11) = v13 + v10;
    }
  }
  if ( *((_DWORD *)this + 11) - *((_DWORD *)this + 10) < v12 )
    sub_41DFF7(v11, 3);
}


/* ==== 41DE24  ?Write@CArchive@@QAEXPBXI@Z  (CArchive::Write(void const *,uint))  size=177 ==== */
void __thiscall CArchive::Write(CArchive *this, char *Src, unsigned int a3)
{
  void *v4; // eax
  size_t v5; // edi
  unsigned int v6; // ebx
  unsigned int v7; // edi
  size_t v8; // ebx
  char *Srca; // [esp+10h] [ebp+8h]
  char *Srcb; // [esp+10h] [ebp+8h]

  if ( a3 && Src )
  {
    if ( (*((_BYTE *)this + 24) & 1) != 0 )
      sub_41DFF7(2, *((_DWORD *)this + 5));
    v4 = (void *)*((_DWORD *)this + 10);
    v5 = *((_DWORD *)this + 11) - (_DWORD)v4;
    if ( a3 < v5 )
      v5 = a3;
    memcpy_0(v4, Src, v5);
    *((_DWORD *)this + 10) += v5;
    Srca = &Src[v5];
    v6 = a3 - v5;
    if ( a3 != v5 )
    {
      CArchive::Flush(this);
      v7 = v6 - v6 % *((_DWORD *)this + 8);
      (*(void (__thiscall **)(_DWORD, char *, unsigned int))(**((_DWORD **)this + 9) + 56))(
        *((_DWORD *)this + 9),
        Srca,
        v7);
      Srcb = &Srca[v7];
      v8 = v6 - v7;
      if ( *((_DWORD *)this + 2) )
      {
        (*(void (__thiscall **)(_DWORD, int, _DWORD, char *, char *))(**((_DWORD **)this + 9) + 80))(
          *((_DWORD *)this + 9),
          1,
          *((_DWORD *)this + 8),
          (char *)this + 48,
          (char *)this + 44);
        *((_DWORD *)this + 10) = *((_DWORD *)this + 12);
      }
      memcpy_0(*((void **)this + 10), Srcb, v8);
      *((_DWORD *)this + 10) += v8;
    }
  }
}


/* ==== 41DED5  ?WriteCount@CArchive@@QAEXK@Z  (CArchive::WriteCount(ulong))  size=44 ==== */
void __thiscall CArchive::WriteCount(CArchive *this, unsigned int a2)
{
  if ( a2 >= 0xFFFF )
  {
    CArchive::operator<<(this, 0xFFFF);
    unknown_libname_6(this, a2);
  }
  else
  {
    CArchive::operator<<(this, a2);
  }
}


/* ==== 41DF01  ?ReadCount@CArchive@@QAEKXZ  (CArchive::ReadCount(void))  size=47 ==== */
unsigned int __thiscall CArchive::ReadCount(CArchive *this)
{
  int v3; // [esp+4h] [ebp-4h] BYREF

  unknown_libname_7(this, (_WORD *)&v3 + 1);
  if ( HIWORD(v3) != 0xFFFF )
    return HIWORD(v3);
  unknown_libname_8(this, &v3);
  return v3;
}


/* ==== 41DF30  sub_41DF30  ()  size=199 ==== */
int __thiscall sub_41DF30(_DWORD *this, LPSTR lpString1, int iMaxLength, _DWORD *a4)
{
  void *v5; // eax
  _DWORD *v6; // esi
  bool v7; // zf
  int v9; // [esp+0h] [ebp-24h] BYREF
  LPCSTR lpString2[2]; // [esp+10h] [ebp-14h] BYREF
  int v11; // [esp+20h] [ebp-4h]

  lpString2[1] = (LPCSTR)&v9;
  if ( !lpString1 )
    return 0;
  if ( a4 )
    *a4 = this[2] + 61872;
  v11 = 0;
  v5 = sub_417937();
  lpString2[0] = (LPCSTR)((*(int (__thiscall **)(void *))(*(_DWORD *)v5 + 12))(v5) + 16);
  LOBYTE(v11) = 1;
  sub_402C40(&a4, this + 3);
  v6 = a4;
  v7 = *(a4 - 3) == 0;
  LOBYTE(v11) = 2;
  if ( v7 )
  {
    sub_4041F0((int *)&a4, 0xF006u);
    v6 = a4;
  }
  sub_41E877(lpString2, this[2] + 61872, (char)v6);
  lstrcpynA(lpString1, lpString2[0], iMaxLength);
  ATL::CStringData::Release((ATL::CStringData *)(v6 - 4));
  ATL::CStringData::Release((ATL::CStringData *)(lpString2[0] - 16));
  return 1;
}


/* ==== 41DFF7  sub_41DFF7  ()  size=67 ==== */
void __cdecl __noreturn sub_41DFF7(volatile signed __int32 *a1, const void *a2)
{
  volatile signed __int32 **v2; // ecx
  volatile signed __int32 **v3; // eax
  volatile signed __int32 **pExceptionObject; // [esp+4h] [ebp-10h] BYREF
  int v5; // [esp+10h] [ebp-4h]

  v2 = (volatile signed __int32 **)operator new(0x10u);
  v3 = 0;
  v5 = 0;
  if ( v2 )
    v3 = sub_409C3B(v2, a1, a2);
  v5 = -1;
  pExceptionObject = v3;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI4PAVCArchiveException__);
}


/* ==== 41E03A  sub_41E03A  ()  size=67 ==== */
BOOL __stdcall sub_41E03A(HWND hWnd, LPCSTR lpString2)
{
  CHAR ClassName[32]; // [esp+4h] [ebp-24h] BYREF

  GetClassNameA(hWnd, ClassName, 32);
  return lstrcmpiA(ClassName, lpString2) == 0;
}


/* ==== 41E07D  sub_41E07D  ()  size=108 ==== */
int __stdcall sub_41E07D(HWND hWnd, LPCSTR lpString)
{
  unsigned int v2; // ebx
  int result; // eax
  CHAR String[256]; // [esp+Ch] [ebp-104h] BYREF

  v2 = lstrlenA(lpString);
  if ( v2 > 0x100 )
    return SetWindowTextA(hWnd, lpString);
  if ( GetWindowTextA(hWnd, String, 256) != v2 )
    return SetWindowTextA(hWnd, lpString);
  result = lstrcmpA(String, lpString);
  if ( result )
    return SetWindowTextA(hWnd, lpString);
  return result;
}


/* ==== 41E0E9  ?AfxDeleteObject@@YGXPAPAX@Z  (AfxDeleteObject(void * *))  size=25 ==== */
void __stdcall AfxDeleteObject(void **a1)
{
  if ( *a1 )
  {
    DeleteObject(*a1);
    *a1 = 0;
  }
}


/* ==== 41E102  ?AfxGlobalFree@@YGXPAX@Z  (AfxGlobalFree(void *))  size=48 ==== */
void __stdcall AfxGlobalFree(HGLOBAL hMem)
{
  int v1; // eax
  int v2; // edi

  if ( hMem )
  {
    v1 = (unsigned __int8)GlobalFlags(hMem);
    if ( v1 )
    {
      v2 = v1;
      do
      {
        GlobalUnlock(hMem);
        --v2;
      }
      while ( v2 );
    }
    GlobalFree(hMem);
  }
}


/* ==== 41E132  ?AfxCriticalNewHandler@@YAHI@Z  (AfxCriticalNewHandler(uint))  size=77 ==== */
int __cdecl AfxCriticalNewHandler(unsigned int a1)
{
  struct _AFX_THREAD_STATE *ThreadState; // eax
  struct _AFX_THREAD_STATE *v2; // esi
  size_t v3; // eax

  ThreadState = AfxGetThreadState();
  v2 = ThreadState;
  if ( !ThreadState || !*((_DWORD *)ThreadState + 3) )
    unknown_libname_11();
  v3 = _msize(*((void **)ThreadState + 3));
  if ( v3 > a1 + 4 )
  {
    _expand(*((void **)v2 + 3), v3 - a1 - 4);
  }
  else
  {
    free(*((void **)v2 + 3));
    *((_DWORD *)v2 + 3) = 0;
  }
  return 1;
}


/* ==== 41E17F  ?_AfxChildWindowFromPoint@@YGPAUHWND__@@PAU1@UtagPOINT@@@Z  (_AfxChildWindowFromPoint(HWND__ *,tagPOINT))  size=114 ==== */
HWND __stdcall _AfxChildWindowFromPoint(HWND hWnd, POINT Point)
{
  HWND result; // eax
  HWND v3; // esi
  struct tagRECT Rect; // [esp+8h] [ebp-10h] BYREF

  ClientToScreen(hWnd, &Point);
  for ( result = GetWindow(hWnd, 5u); ; result = GetWindow(v3, 2u) )
  {
    v3 = result;
    if ( !result )
      break;
    if ( (unsigned __int16)GetDlgCtrlID(result) )
    {
      if ( (GetWindowLongA(v3, -16) & 0x10000000) != 0 )
      {
        GetWindowRect(v3, &Rect);
        if ( PtInRect(&Rect, Point) )
          return v3;
      }
    }
  }
  return result;
}


/* ==== 41E1F1  unknown_libname_41  ()  size=63 ==== */
// MFC 3.1-14.0 32bit
HWND __thiscall unknown_libname_41(int this, HWND a2)
{
  HWND v2; // edi
  HWND result; // eax

  v2 = a2;
  CWnd::GetDlgItem(*(CWnd **)(this + 4), (int)a2, &a2);
  if ( !a2 && !CWnd::GetOleControlSite(*(CWnd **)(this + 4), (unsigned int)v2) )
    unknown_libname_12();
  *(_DWORD *)(this + 12) = 0;
  result = a2;
  *(_DWORD *)(this + 8) = v2;
  return result;
}


/* ==== 41E230  ?DDX_Control@@YGXPAVCDataExchange@@HAAVCWnd@@@Z  (DDX_Control(CDataExchange *,int,CWnd &))  size=137 ==== */
void __stdcall DDX_Control(CWnd **a1, HWND a2, HWND a3)
{
  HWND *v3; // edi
  HWND *v4; // esi

  v3 = (HWND *)a3;
  if ( !*((_DWORD *)a3 + 7) && !CWnd::GetControlUnknown((CWnd *)a3) )
  {
    unknown_libname_41((int)a1, a2);
    CWnd::GetDlgItem(a1[1], (int)a2, &a3);
    if ( !a3 )
      goto LABEL_13;
    if ( !CWnd::SubclassWindow((CWnd *)v3, a3) )
      unknown_libname_12();
    if ( a3 )
    {
      v4 = (HWND *)a1[1];
      if ( v4[7] != GetParent(v3[7]) )
        CWnd::AttachControlSite((CWnd *)v3, (struct CWnd *)v4, 0);
    }
    else
    {
LABEL_13:
      if ( CWnd::GetOleControlSite(a1[1], (unsigned int)a2) )
        CWnd::AttachControlSite((CWnd *)v3, a1[1], (unsigned int)a2);
    }
  }
}


/* ==== 41E2B9  ?GetRoutingFrame_@CCmdTarget@@KGPAVCFrameWnd@@XZ  (CCmdTarget::GetRoutingFrame_(void))  size=12 ==== */
struct CFrameWnd *__stdcall CCmdTarget::GetRoutingFrame_()
{
  return (struct CFrameWnd *)*((_DWORD *)AfxGetThreadState() + 59);
}


/* ==== 41E2C5  ?EnableModeless@CWinApp@@QAEXH@Z  (CWinApp::EnableModeless(int))  size=45 ==== */
void __thiscall CWinApp::EnableModeless(CWinApp *this, int a2)
{
  struct CWnd *MainWnd; // esi

  MainWnd = AfxGetMainWnd();
  if ( MainWnd && (*(int (__thiscall **)(struct CWnd *))(*(_DWORD *)MainWnd + 288))(MainWnd) )
  {
    if ( *((_DWORD *)MainWnd + 31) )
      (*(void (__thiscall **)(_DWORD, int))(**((_DWORD **)MainWnd + 31) + 100))(*((_DWORD *)MainWnd + 31), a2);
  }
}


/* ==== 41E2F2  ?GetSafeOwner_@CWnd@@SGPAUHWND__@@PAU2@PAPAU2@@Z  (CWnd::GetSafeOwner_(HWND__ *,HWND__ * *))  size=158 ==== */
HWND __stdcall CWnd::GetSafeOwner_(HWND hWnd, HWND *a2)
{
  HWND i; // esi
  struct CWnd *RoutingFrame; // eax
  HWND v4; // edi
  HWND j; // eax

  i = hWnd;
  if ( hWnd )
    goto LABEL_6;
  RoutingFrame = CCmdTarget::GetRoutingFrame_();
  if ( RoutingFrame || (RoutingFrame = AfxGetMainWnd()) != 0 )
  {
    for ( i = (HWND)*((_DWORD *)RoutingFrame + 7); i; i = GetParent(i) )
    {
LABEL_6:
      if ( (GetWindowLongA(i, -16) & 0x40000000) == 0 )
        break;
    }
  }
  else
  {
    i = 0;
  }
  v4 = i;
  for ( j = i; j; j = GetParent(j) )
    v4 = j;
  if ( !hWnd && i )
    i = GetLastActivePopup(i);
  if ( a2 )
  {
    if ( v4 && IsWindowEnabled(v4) && v4 != i )
    {
      *a2 = v4;
      EnableWindow(v4, 0);
    }
    else
    {
      *a2 = 0;
    }
  }
  return i;
}


/* ==== 41E390  sub_41E390  ()  size=317 ==== */
int __thiscall sub_41E390(CWinApp *this, const CHAR *a2, UINT uType, int a4)
{
  CWinApp *v4; // edi
  int *v5; // esi
  HWND SafeOwner; // eax
  HWND v7; // ebx
  LRESULT v8; // eax
  UINT v9; // eax
  CHAR *v10; // ebx
  int v11; // ebx
  HWND hWnd; // [esp+10h] [ebp-7Ch]
  int v15; // [esp+18h] [ebp-74h]
  HWND v16; // [esp+1Ch] [ebp-70h] BYREF
  CHAR Filename[260]; // [esp+20h] [ebp-6Ch] BYREF

  v4 = this;
  v5 = 0;
  CWinApp::EnableModeless(this, 0);
  SafeOwner = CWnd::GetSafeOwner_(0, &v16);
  v7 = SafeOwner;
  hWnd = SafeOwner;
  if ( SafeOwner != v16 )
    EnableWindow(SafeOwner, 1);
  if ( v7 && (v8 = SendMessageA(v7, 0x376u, 0, 0)) != 0 )
  {
    v5 = (int *)v8;
  }
  else if ( v4 )
  {
    v5 = (int *)((char *)v4 + 116);
  }
  v15 = 0;
  if ( v5 )
  {
    v15 = *v5;
    if ( a4 )
      *v5 = a4 + 196608;
  }
  if ( (uType & 0xF0) == 0 )
  {
    v9 = uType & 0xF;
    if ( v9 <= 1 || v9 > 2 && v9 <= 4 )
      uType |= 0x30u;
  }
  Filename[0] = 0;
  if ( v4 )
  {
    v10 = (CHAR *)*((_DWORD *)v4 + 19);
  }
  else
  {
    v10 = Filename;
    v4 = this;
    if ( GetModuleFileNameA(0, Filename, 0x104u) == 260 )
      Filename[259] = 0;
  }
  v11 = MessageBoxA(hWnd, a2, v10, uType);
  if ( v5 )
    *v5 = v15;
  if ( v16 )
    EnableWindow(v16, 1);
  CWinApp::EnableModeless(v4, 1);
  return v11;
}


/* ==== 41E4CD  sub_41E4CD  ()  size=34 ==== */
int __stdcall sub_41E4CD(const CHAR *a1, UINT a2, int a3)
{
  int v3; // eax

  v3 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( v3 )
    return (*(int (__thiscall **)(int, const CHAR *, UINT, int))(*(_DWORD *)v3 + 152))(v3, a1, a2, a3);
  else
    return sub_41E390(0, a1, a2, a3);
}


/* ==== 41E4EF  ?AfxMessageBox@@YGHIII@Z  (AfxMessageBox(uint,uint,uint))  size=98 ==== */
int __userpurge AfxMessageBox@<eax>(int a1@<ecx>, const CHAR *a2@<esi>, unsigned int a3, UINT a4, unsigned int a5)
{
  void *v5; // eax
  int v6; // eax
  int v7; // edi
  int v9[4]; // [esp+0h] [ebp-10h] BYREF

  v9[0] = a1;
  v5 = sub_417937();
  (*(void (__thiscall **)(void *, int))(*(_DWORD *)v5 + 12))(v5, v9[0]);
  v9[3] = 0;
  sub_4041F0(v9, a3);
  v6 = a5;
  if ( a5 == -1 )
    v6 = a3;
  v9[0] = (int)a2;
  v7 = sub_41E4CD(a2, a4, v6);
  ATL::CStringData::Release((ATL::CStringData *)(a2 - 16));
  return v7;
}


/* ==== 41E551  ?DoWaitCursor@CWinApp@@UAEXH@Z  (CWinApp::DoWaitCursor(int))  size=83 ==== */
void __thiscall CWinApp::DoWaitCursor(CWinApp *this, int a2)
{
  HCURSOR v3; // eax
  HCURSOR v4; // [esp-4h] [ebp-Ch]

  AfxLockGlobals(2);
  *((_DWORD *)this + 31) += a2;
  if ( *((int *)this + 31) <= 0 )
  {
    v4 = (HCURSOR)*((_DWORD *)this + 32);
    *((_DWORD *)this + 31) = 0;
    SetCursor(v4);
  }
  else
  {
    v3 = SetCursor(hCursor);
    if ( a2 > 0 && *((_DWORD *)this + 31) == 1 )
      *((_DWORD *)this + 32) = v3;
  }
  AfxUnlockGlobals(2);
}


/* ==== 41E5A4  ?SaveAllModified@CWinApp@@UAEHXZ  (CWinApp::SaveAllModified(void))  size=18 ==== */
int __thiscall CWinApp::SaveAllModified(CWinApp *this)
{
  if ( *((_DWORD *)this + 21) )
    return (*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 21) + 32))(*((_DWORD *)this + 21));
  else
    return 1;
}


/* ==== 41E5B6  unknown_libname_42  ()  size=23 ==== */
// MFC 3.1-14.0 32bit
_DWORD *__thiscall unknown_libname_42(_DWORD *this, int a2)
{
  _DWORD *result; // eax

  result = this + 33;
  if ( this[33] )
    return (_DWORD *)(*(int (__thiscall **)(_DWORD, int))(*(_DWORD *)*result + 4))(*result, a2);
  return result;
}


/* ==== 41E5CD  unknown_libname_43  ()  size=8 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_43(_DWORD **this)
{
  return (*(int (__thiscall **)(_DWORD *))(*this[21] + 28))(this[21]);
}


/* ==== 41E5D5  ?OnUpdateRecentFileMenu@CWinApp@@IAEXPAVCCmdUI@@@Z  (CWinApp::OnUpdateRecentFileMenu(CCmdUI *))  size=33 ==== */
void __thiscall CWinApp::OnUpdateRecentFileMenu(CWinApp *this, struct CCmdUI *a2)
{
  if ( *((_DWORD *)this + 33) )
    (*(void (__thiscall **)(_DWORD, struct CCmdUI *))(**((_DWORD **)this + 33) + 12))(*((_DWORD *)this + 33), a2);
  else
    (**(void (__thiscall ***)(struct CCmdUI *, _DWORD))a2)(a2, 0);
}


/* ==== 41E5F6  unknown_libname_44  ()  size=19 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_44(_DWORD **this, int a2)
{
  if ( this[21] )
    return (*(int (__thiscall **)(_DWORD *, int))(*this[21] + 48))(this[21], a2);
  else
    return 0;
}


/* ==== 41E609  ?OnOpenRecentFile@CWinApp@@IAEHI@Z  (CWinApp::OnOpenRecentFile(uint))  size=54 ==== */
int __thiscall CWinApp::OnOpenRecentFile(CWinApp *this, unsigned int a2)
{
  _DWORD *v2; // esi

  v2 = (_DWORD *)((char *)this + 132);
  if ( !(*(int (__thiscall **)(CWinApp *, _DWORD))(*(_DWORD *)this + 136))(
          this,
          *(_DWORD *)(*(_DWORD *)(*((_DWORD *)this + 33) + 8) + 4 * (a2 - 57616))) )
    (**(void (__thiscall ***)(_DWORD, unsigned int))*v2)(*v2, a2 - 57616);
  return 1;
}


/* ==== 41E63F  ?GetFirstDocTemplatePosition@CWinApp@@QBEPAU__POSITION@@XZ  (CWinApp::GetFirstDocTemplatePosition(void))  size=17 ==== */
struct __POSITION *__thiscall CWinApp::GetFirstDocTemplatePosition(CWinApp *this)
{
  if ( *((_DWORD *)this + 21) )
    return (struct __POSITION *)(*(int (__thiscall **)(_DWORD))(**((_DWORD **)this + 21) + 16))(*((_DWORD *)this + 21));
  else
    return 0;
}


/* ==== 41E650  ?Concatenate@?$CSimpleStringT@D$0A@@ATL@@KAXAAV12@PBDH1H@Z  (ATL::CSimpleStringT<char,0>::Concatenate(ATL::CSimpleStringT<char,0> &,char const *,int,char const *,int))  size=67 ==== */
int __cdecl ATL::CSimpleStringT<char,0>::Concatenate(int *a1, void *Src, size_t Size, void *a4, size_t a5)
{
  char *v5; // ebx

  v5 = (char *)sub_4014A0(a1, Size + a5);
  memcpy_0(v5, Src, Size);
  memcpy_0(&v5[Size], a4, a5);
  return ATL::CSimpleStringT<char,0>::SetLength(a1, Size + a5);
}


/* ==== 41E693  sub_41E693  ()  size=126 ==== */
_DWORD *__cdecl sub_41E693(_DWORD *a1, void **a2, char *Str)
{
  void **v3; // esi
  int v4; // eax
  size_t v5; // eax

  v3 = a2;
  v4 = (*(int (__thiscall **)(_DWORD))(**((_DWORD **)*a2 - 4) + 16))(*((_DWORD *)*a2 - 4));
  a2 = (void **)((*(int (__thiscall **)(int))(*(_DWORD *)v4 + 12))(v4) + 16);
  if ( Str )
    v5 = strlen(Str);
  else
    v5 = 0;
  ATL::CSimpleStringT<char,0>::Concatenate((int *)&a2, *v3, *((_DWORD *)*v3 - 3), Str, v5);
  sub_402C40(a1, &a2);
  ATL::CStringData::Release((ATL::CStringData *)(a2 - 4));
  return a1;
}


/* ==== 41E711  ?AfxFormatStrings@@YGXAAV?$CStringT@DV?$StrTraitMFC@DV?$ChTraitsCRT@D@ATL@@@@@ATL@@PBDPBQBDH@Z  (AfxFormatStrings(ATL::CStringT<char,StrTraitMFC<char,ATL::ChTraitsCRT<char>>> &,char const *,char const * const *,int))  size=255 ==== */
int __stdcall AfxFormatStrings(int *a1, CHAR *a2, int a3, int a4)
{
  CHAR *v4; // esi
  int v5; // ebx
  CHAR *v6; // edi
  char v7; // al
  int v8; // eax
  const CHAR *v9; // eax
  CHAR *v10; // edi
  unsigned __int8 v11; // cl
  char v12; // al
  int v13; // eax
  const CHAR *v14; // eax

  v4 = a2;
  v5 = 0;
  v6 = a2;
  if ( *a2 )
  {
    while ( *v6 == 37 )
    {
      v7 = v6[1];
      if ( v7 >= 49 && v7 <= 57 )
      {
        v8 = v7 - 49;
      }
      else
      {
        if ( v7 < 65 || v7 > 90 )
          break;
        v8 = v7 - 56;
      }
      v6 += 2;
      if ( v8 < a4 )
      {
        v9 = *(const CHAR **)(a3 + 4 * v8);
        if ( v9 )
          v5 += lstrlenA(v9);
        goto LABEL_16;
      }
LABEL_15:
      ++v5;
LABEL_16:
      if ( !*v6 )
        goto LABEL_17;
    }
    if ( (byte_431781[(unsigned __int8)*v6] & 4) != 0 )
    {
      ++v5;
      ++v6;
    }
    ++v6;
    goto LABEL_15;
  }
LABEL_17:
  v10 = (CHAR *)sub_4014A0(a1, v5);
  while ( *v4 )
  {
    v11 = *v4;
    if ( *v4 != 37 )
      goto LABEL_29;
    v12 = v4[1];
    if ( v12 >= 49 && v12 <= 57 )
    {
      v13 = v12 - 49;
      goto LABEL_25;
    }
    if ( v12 >= 65 && v12 <= 90 )
    {
      v13 = v12 - 56;
LABEL_25:
      v4 += 2;
      if ( v13 < a4 )
      {
        v14 = *(const CHAR **)(a3 + 4 * v13);
        if ( v14 )
        {
          lstrcpyA(v10, v14);
          v10 += lstrlenA(v10);
        }
      }
      else
      {
        *v10++ = 63;
      }
    }
    else
    {
LABEL_29:
      if ( (byte_431781[v11] & 4) != 0 )
      {
        *v10++ = v11;
        ++v4;
      }
      *v10++ = *v4++;
    }
  }
  return ATL::CSimpleStringT<char,0>::ReleaseBuffer((const char **)a1, &v10[-*a1]);
}


/* ==== 41E810  sub_41E810  ()  size=103 ==== */
void __userpurge sub_41E810(int a1@<ecx>, CHAR *a2@<esi>, int *a3, unsigned int a4, int a5, int a6)
{
  void *v6; // eax
  int v7[4]; // [esp+0h] [ebp-10h] BYREF

  v7[0] = a1;
  v6 = sub_417937();
  (*(void (__thiscall **)(void *, int))(*(_DWORD *)v6 + 12))(v6, v7[0]);
  v7[3] = 0;
  if ( sub_4041F0(v7, a4) )
  {
    v7[0] = (int)a2;
    AfxFormatStrings(a3, a2, a5, a6);
    ATL::CStringData::Release((ATL::CStringData *)(a2 - 16));
  }
  else
  {
    ATL::CStringData::Release((ATL::CStringData *)(v7[0] - 16));
  }
}


/* ==== 41E877  sub_41E877  ()  size=23 ==== */
void __userpurge sub_41E877(int a1@<ecx>, CHAR *a2@<esi>, int *a3, unsigned int a4, char a5)
{
  sub_41E810(a1, a2, a3, a4, (int)&a5, 1);
}


/* ==== 41E88E  sub_41E88E  ()  size=134 ==== */
HKEY __thiscall sub_41E88E(int this, LPCSTR lpAppName, LPCSTR lpValueName, int Data)
{
  HKEY result; // eax
  HKEY v6; // esi
  LSTATUS v7; // edi
  CHAR String[16]; // [esp+Ch] [ebp-14h] BYREF

  if ( *(_DWORD *)(this + 80) )
  {
    result = CWinApp::GetSectionKey((CWinApp *)this, lpAppName);
    v6 = result;
    if ( result )
    {
      v7 = RegSetValueExA(result, lpValueName, 0, 4u, (const BYTE *)&Data, 4u);
      RegCloseKey(v6);
      return (HKEY)(v7 == 0);
    }
  }
  else
  {
    wsprintfA(String, "%d", Data);
    return (HKEY)WritePrivateProfileStringA(lpAppName, lpValueName, String, *(LPCSTR *)(this + 100));
  }
  return result;
}


/* ==== 41E914  ?AfxOleCanExitApp@@YGHXZ  (AfxOleCanExitApp(void))  size=16 ==== */
BOOL __stdcall AfxOleCanExitApp()
{
  return *((_DWORD *)AfxGetModuleState() + 11) == 0;
}


/* ==== 41E924  ?AfxOleLockApp@@YGXXZ  (AfxOleLockApp(void))  size=16 ==== */
void __stdcall AfxOleLockApp()
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  ModuleState = AfxGetModuleState();
  InterlockedIncrement((volatile LONG *)ModuleState + 11);
}


/* ==== 41E934  ?AfxOleSetUserCtrl@@YGXH@Z  (AfxOleSetUserCtrl(int))  size=15 ==== */
void __stdcall AfxOleSetUserCtrl(int a1)
{
  *((_DWORD *)AfxGetModuleState() + 12) = a1;
}


/* ==== 41E943  ?AfxOleGetUserCtrl@@YGHXZ  (AfxOleGetUserCtrl(void))  size=9 ==== */
int __stdcall AfxOleGetUserCtrl()
{
  return *((_DWORD *)AfxGetModuleState() + 12);
}


/* ==== 41E94C  ?AfxOleOnReleaseAllObjects@@YGXXZ  (AfxOleOnReleaseAllObjects(void))  size=76 ==== */
void __stdcall AfxOleOnReleaseAllObjects()
{
  int v0; // esi
  CWnd *v1; // ecx

  if ( !*((_DWORD *)AfxGetModuleState() + 12) )
  {
    AfxOleSetUserCtrl(1);
    v0 = *((_DWORD *)AfxGetModuleState() + 1);
    if ( v0 && (v1 = *(CWnd **)(v0 + 28)) != 0 )
    {
      if ( CWnd::IsWindowEnabled(v1) )
        (*(void (__thiscall **)(_DWORD))(**(_DWORD **)(v0 + 28) + 96))(*(_DWORD *)(v0 + 28));
    }
    else if ( !*((_BYTE *)AfxGetModuleState() + 20) )
    {
      AfxPostQuitMessage(0);
    }
  }
}


/* ==== 41E998  ?AfxOleUnlockApp@@YGXXZ  (AfxOleUnlockApp(void))  size=25 ==== */
void __stdcall AfxOleUnlockApp()
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  ModuleState = AfxGetModuleState();
  if ( !InterlockedDecrement((volatile LONG *)ModuleState + 11) )
    AfxOleOnReleaseAllObjects();
}


/* ==== 41E9C2  ??__E_afxMsgMouseWheel@@YAXXZ  (`dynamic initializer for '_afxMsgMouseWheel''(void))  size=69 ==== */
UINT `dynamic initializer for '_afxMsgMouseWheel''()
{
  UINT result; // eax

  if ( (GetVersion() & 0x80000000) != 0 && (unsigned __int16)GetVersion() == 4
    || (result = GetVersion(), (result & 0x80000000) == 0) && (result = GetVersion(), (_WORD)result == 3) )
  {
    result = RegisterWindowMessageA("MSWHEEL_ROLLMSG");
    dword_4300B8 = result;
  }
  else
  {
    dword_4300B8 = 0;
  }
  return result;
}


/* ==== 41EA07  sub_41EA07  ()  size=6 ==== */
char **sub_41EA07()
{
  return &off_42570C;
}


/* ==== 41EA0D  sub_41EA0D  ()  size=37 ==== */
int __thiscall sub_41EA0D(int *this, char *Str)
{
  size_t v3; // eax

  if ( Str )
    v3 = strlen(Str);
  else
    v3 = 0;
  return ATL::CSimpleStringT<char,0>::Append(this, Str, v3);
}


/* ==== 41EA32  sub_41EA32  ()  size=6 ==== */
char **sub_41EA32()
{
  return &off_4257C0;
}


/* ==== 41EA38  sub_41EA38  ()  size=6 ==== */
char **sub_41EA38()
{
  return &off_42578C;
}


/* ==== 41EA3E  sub_41EA3E  ()  size=6 ==== */
char **sub_41EA3E()
{
  return &off_425758;
}


/* ==== 41EA44  ?CreateObject@?$CThreadLocal@V_AFX_THREAD_STATE@@@@SGPAVCNoTrackObject@@XZ  (CThreadLocal<_AFX_THREAD_STATE>::CreateObject(void))  size=52 ==== */
struct CNoTrackObject *__stdcall CThreadLocal<_AFX_THREAD_STATE>::CreateObject()
{
  _AFX_THREAD_STATE *v0; // ecx
  struct CNoTrackObject *result; // eax

  v0 = (_AFX_THREAD_STATE *)unknown_libname_53(0x104u);
  result = 0;
  if ( v0 )
    return _AFX_THREAD_STATE::_AFX_THREAD_STATE(v0);
  return result;
}


/* ==== 41EACF  sub_41EACF  ()  size=10 ==== */
void sub_41EACF()
{
  sub_408BA8(dword_42E178);
}


/* ==== 41EAD9  sub_41EAD9  ()  size=10 ==== */
void sub_41EAD9()
{
  sub_408BAF(dword_42E210);
}


/* ==== 41EAE3  sub_41EAE3  ()  size=10 ==== */
void sub_41EAE3()
{
  sub_408BB6(dword_42E2A8);
}


/* ==== 41EAED  sub_41EAED  ()  size=6 ==== */
char **sub_41EAED()
{
  return &off_425860;
}


/* ==== 41EAF3  j_??1CThreadLocalObject@@QAE@XZ  (CThreadLocalObject::~CThreadLocalObject(void))  size=5 ==== */
// attributes: thunk
void __thiscall CThreadLocalObject::~CThreadLocalObject(CThreadLocalObject *this)
{
  ??1CThreadLocalObject@@QAE@XZ(this);
}


/* ==== 41EAF8  j_??1CProcessLocalObject@@QAE@XZ_0  (CProcessLocalObject::~CProcessLocalObject(void))  size=5 ==== */
// attributes: thunk
void __thiscall CProcessLocalObject::~CProcessLocalObject(CProcessLocalObject *this)
{
  ??1CProcessLocalObject@@QAE@XZ(this);
}


/* ==== 41EAFD  ?Unlock@CTypeLibCache@@QAEXXZ  (CTypeLibCache::Unlock(void))  size=53 ==== */
void __thiscall CTypeLibCache::Unlock(CTypeLibCache *this)
{
  int v2; // eax
  int v3; // eax

  if ( !InterlockedDecrement((volatile LONG *)this + 8) )
  {
    v2 = *((_DWORD *)this + 7);
    if ( v2 )
    {
      (*(void (__stdcall **)(_DWORD))(*(_DWORD *)v2 + 8))(*((_DWORD *)this + 7));
      *((_DWORD *)this + 7) = 0;
    }
    v3 = *((_DWORD *)this + 2);
    if ( v3 )
    {
      (*(void (__stdcall **)(_DWORD))(*(_DWORD *)v3 + 8))(*((_DWORD *)this + 2));
      *((_DWORD *)this + 2) = 0;
    }
  }
}


/* ==== 41EB32  ??0_AFX_THREAD_STATE@@QAE@XZ  (_AFX_THREAD_STATE::_AFX_THREAD_STATE(void))  size=25 ==== */
_AFX_THREAD_STATE *__thiscall _AFX_THREAD_STATE::_AFX_THREAD_STATE(_AFX_THREAD_STATE *this)
{
  _AFX_THREAD_STATE *result; // eax

  result = this;
  *(_DWORD *)this = &_AFX_THREAD_STATE::`vftable';
  *((_DWORD *)this + 13) = 0;
  *((_DWORD *)this + 21) = 0;
  *((_DWORD *)this + 19) = 0;
  *((_DWORD *)this + 20) = 0;
  return result;
}


/* ==== 41EB4B  ??1_AFX_THREAD_STATE@@UAE@XZ  (_AFX_THREAD_STATE::~_AFX_THREAD_STATE(void))  size=53 ==== */
void __thiscall _AFX_THREAD_STATE::~_AFX_THREAD_STATE(_AFX_THREAD_STATE *this)
{
  HHOOK v2; // eax
  void *v3; // esi

  v2 = (HHOOK)*((_DWORD *)this + 11);
  *(_DWORD *)this = &_AFX_THREAD_STATE::`vftable';
  if ( v2 )
    UnhookWindowsHookEx(v2);
  if ( *((_DWORD *)this + 10) )
    UnhookWindowsHookEx(*((HHOOK *)this + 10));
  v3 = (void *)*((_DWORD *)this + 3);
  if ( v3 )
    free(v3);
}


/* ==== 41EB80  ??1AFX_MODULE_STATE@@UAE@XZ  (AFX_MODULE_STATE::~AFX_MODULE_STATE(void))  size=110 ==== */
void __thiscall AFX_MODULE_STATE::~AFX_MODULE_STATE(AFX_MODULE_STATE *this)
{
  void (__thiscall ***v2)(_DWORD, int); // ecx
  _DWORD *v3; // edi
  int v4; // ecx

  *(_DWORD *)this = &AFX_MODULE_STATE::`vftable';
  v2 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 1041);
  if ( v2 )
    (**v2)(v2, 1);
  v3 = (_DWORD *)((char *)this + 4204);
  v4 = *((_DWORD *)this + 1051);
  if ( v4 )
  {
    (*(void (__thiscall **)(int, char *))(*(_DWORD *)v4 + 12))(v4, (char *)this + 4168);
    if ( *v3 )
      (*(void (__thiscall **)(_DWORD, int))(*(_DWORD *)*v3 + 4))(*v3, 1);
  }
  CThreadLocalObject::~CThreadLocalObject((AFX_MODULE_STATE *)((char *)this + 4208));
}


/* ==== 41EBEE  ??1AFX_MODULE_THREAD_STATE@@UAE@XZ  (AFX_MODULE_THREAD_STATE::~AFX_MODULE_THREAD_STATE(void))  size=163 ==== */
void __thiscall AFX_MODULE_THREAD_STATE::~AFX_MODULE_THREAD_STATE(AFX_MODULE_THREAD_STATE *this)
{
  int v2; // ecx
  void (__thiscall ***v3)(_DWORD, int); // ecx
  void (__thiscall ***v4)(_DWORD, int); // ecx
  void (__thiscall ***v5)(_DWORD, int); // ecx
  void (__thiscall ***v6)(_DWORD, int); // ecx
  void (__thiscall ***v7)(_DWORD, int); // ecx
  int v8; // eax
  void *v9; // eax
  int v10; // ecx
  int v11; // ecx
  int v12; // ecx

  v2 = *((_DWORD *)this + 15);
  *(_DWORD *)this = &AFX_MODULE_THREAD_STATE::`vftable';
  if ( v2 )
    (*(void (__thiscall **)(int))(*(_DWORD *)v2 + 312))(v2);
  v3 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 5);
  if ( v3 )
    (**v3)(v3, 1);
  v4 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 6);
  if ( v4 )
    (**v4)(v4, 1);
  v5 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 7);
  if ( v5 )
    (**v5)(v5, 1);
  v6 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 8);
  if ( v6 )
    (**v6)(v6, 1);
  v7 = (void (__thiscall ***)(_DWORD, int))*((_DWORD *)this + 9);
  if ( v7 )
    (**v7)(v7, 1);
  v8 = *((_DWORD *)this + 14);
  if ( v8 )
  {
    while ( *(_DWORD *)(v8 + 12) )
    {
      v9 = (void *)sub_417456(*((_DWORD **)this + 14));
      j__free(v9);
      v8 = *((_DWORD *)this + 14);
    }
  }
  v10 = *((_DWORD *)this + 12);
  if ( v10 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v10 + 4))(v10, 1);
  v11 = *((_DWORD *)this + 13);
  if ( v11 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v11 + 4))(v11, 1);
  v12 = *((_DWORD *)this + 14);
  if ( v12 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v12 + 4))(v12, 1);
}


/* ==== 41EC91  ??_G_AFX_THREAD_STATE@@UAEPAXI@Z  (_AFX_THREAD_STATE::`scalar deleting destructor'(uint))  size=27 ==== */
_AFX_THREAD_STATE *__thiscall _AFX_THREAD_STATE::`scalar deleting destructor'(_AFX_THREAD_STATE *this, char a2)
{
  _AFX_THREAD_STATE::~_AFX_THREAD_STATE(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 41ECAC  ??0AFX_MODULE_STATE@@QAE@H@Z  (AFX_MODULE_STATE::AFX_MODULE_STATE(int))  size=96 ==== */
AFX_MODULE_STATE *__thiscall AFX_MODULE_STATE::AFX_MODULE_STATE(AFX_MODULE_STATE *this, char a2)
{
  AFX_MODULE_STATE *result; // eax
  _DWORD *v3; // ecx

  result = this;
  *(_DWORD *)this = &AFX_MODULE_STATE::`vftable';
  *((_DWORD *)this + 7) = 0;
  *((_DWORD *)this + 8) = 0;
  *((_DWORD *)this + 9) = 0;
  *((_DWORD *)this + 10) = 0;
  v3 = (_DWORD *)((char *)this + 4156);
  *v3 = 0;
  v3[1] = 0;
  *((_DWORD *)result + 1043) = -1;
  *((_DWORD *)result + 1044) = 0;
  *((_DWORD *)result + 1049) = 0;
  *((_DWORD *)result + 1050) = 0;
  *((_DWORD *)result + 10) = 28;
  *((_DWORD *)result + 8) = 20;
  *((_DWORD *)result + 6) = 0;
  *((_BYTE *)result + 20) = a2;
  *((_DWORD *)result + 12) = 1;
  *((_DWORD *)result + 1040) = 24;
  return result;
}


/* ==== 41ED0C  ??_GAFX_MODULE_STATE@@UAEPAXI@Z  (AFX_MODULE_STATE::`scalar deleting destructor'(uint))  size=27 ==== */
AFX_MODULE_STATE *__thiscall AFX_MODULE_STATE::`scalar deleting destructor'(AFX_MODULE_STATE *this, char a2)
{
  AFX_MODULE_STATE::~AFX_MODULE_STATE(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 41ED27  ??0AFX_MODULE_THREAD_STATE@@QAE@XZ  (AFX_MODULE_THREAD_STATE::AFX_MODULE_THREAD_STATE(void))  size=39 ==== */
AFX_MODULE_THREAD_STATE *__thiscall AFX_MODULE_THREAD_STATE::AFX_MODULE_THREAD_STATE(AFX_MODULE_THREAD_STATE *this)
{
  AFX_MODULE_THREAD_STATE *result; // eax

  result = this;
  *(_DWORD *)this = &AFX_MODULE_THREAD_STATE::`vftable';
  *((_DWORD *)this + 2) = 0;
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 17) = -1;
  *((_DWORD *)this + 30) = -1;
  *((_DWORD *)this + 3) = 104;
  *((_DWORD *)this + 10) = j_unknown_libname_11;
  return result;
}


/* ==== 41ED4E  ??_GAFX_MODULE_THREAD_STATE@@UAEPAXI@Z  (AFX_MODULE_THREAD_STATE::`scalar deleting destructor'(uint))  size=27 ==== */
AFX_MODULE_THREAD_STATE *__thiscall AFX_MODULE_THREAD_STATE::`scalar deleting destructor'(
        AFX_MODULE_THREAD_STATE *this,
        char a2)
{
  AFX_MODULE_THREAD_STATE::~AFX_MODULE_THREAD_STATE(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 41ED7D  ??_GAFX_MODULE_STATE@@UAEPAXI@Z_0  (AFX_MODULE_STATE::`scalar deleting destructor'(uint))  size=27 ==== */
AFX_MODULE_STATE *__thiscall AFX_MODULE_STATE::`scalar deleting destructor'(AFX_MODULE_STATE *this, char a2)
{
  AFX_MODULE_STATE::~AFX_MODULE_STATE(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 41ED98  j_??1AFX_MODULE_STATE@@UAE@XZ  (AFX_MODULE_STATE::~AFX_MODULE_STATE(void))  size=5 ==== */
// attributes: thunk
void __thiscall AFX_MODULE_STATE::~AFX_MODULE_STATE(AFX_MODULE_STATE *this)
{
  ??1AFX_MODULE_STATE@@UAE@XZ(this);
}


/* ==== 41ED9D  ?CreateObject@?$CThreadLocal@VAFX_MODULE_THREAD_STATE@@@@SGPAVCNoTrackObject@@XZ  (CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject(void))  size=24 ==== */
struct CNoTrackObject *__stdcall CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject()
{
  AFX_MODULE_THREAD_STATE *v0; // eax

  v0 = (AFX_MODULE_THREAD_STATE *)unknown_libname_53(0x80u);
  if ( v0 )
    return AFX_MODULE_THREAD_STATE::AFX_MODULE_THREAD_STATE(v0);
  else
    return 0;
}


/* ==== 41EDB5  ?CreateObject@?$CProcessLocal@V_AFX_BASE_MODULE_STATE@@@@SGPAVCNoTrackObject@@XZ  (CProcessLocal<_AFX_BASE_MODULE_STATE>::CreateObject(void))  size=24 ==== */
struct CNoTrackObject *__stdcall CProcessLocal<_AFX_BASE_MODULE_STATE>::CreateObject()
{
  AFX_MODULE_STATE *v0; // esi
  AFX_MODULE_STATE *v2; // eax

  v2 = (AFX_MODULE_STATE *)unknown_libname_53(0x1074u);
  if ( !v2 )
    return 0;
  v0 = v2;
  AFX_MODULE_STATE::AFX_MODULE_STATE(v2, 1);
  *(_DWORD *)v0 = &_AFX_BASE_MODULE_STATE::`vftable';
  return v0;
}


/* ==== 41EDCD  ?AfxGetThreadState@@YGPAV_AFX_THREAD_STATE@@XZ  (AfxGetThreadState(void))  size=16 ==== */
struct _AFX_THREAD_STATE *__stdcall AfxGetThreadState()
{
  return CThreadLocalObject::GetData((CThreadLocalObject *)&unk_42E340, CThreadLocal<_AFX_THREAD_STATE>::CreateObject);
}


/* ==== 41EDDD  ?AfxGetModuleState@@YGPAVAFX_MODULE_STATE@@XZ  (AfxGetModuleState(void))  size=38 ==== */
struct AFX_MODULE_STATE *__stdcall AfxGetModuleState()
{
  struct AFX_MODULE_STATE *result; // eax

  result = (struct AFX_MODULE_STATE *)*((_DWORD *)CThreadLocalObject::GetData(
                                                    (CThreadLocalObject *)&unk_42E340,
                                                    CThreadLocal<_AFX_THREAD_STATE>::CreateObject)
                                      + 1);
  if ( !result )
    return CProcessLocalObject::GetData(
             (CProcessLocalObject *)&unk_42E344,
             CProcessLocal<_AFX_BASE_MODULE_STATE>::CreateObject);
  return result;
}


/* ==== 41EE03  ?AfxGetModuleThreadState@@YGPAVAFX_MODULE_THREAD_STATE@@XZ  (AfxGetModuleThreadState(void))  size=23 ==== */
struct AFX_MODULE_THREAD_STATE *__stdcall AfxGetModuleThreadState()
{
  struct AFX_MODULE_STATE *ModuleState; // eax

  ModuleState = AfxGetModuleState();
  return CThreadLocalObject::GetData(
           (struct AFX_MODULE_STATE *)((char *)ModuleState + 4208),
           CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject);
}


/* ==== 41EE32  sub_41EE32  ()  size=10 ==== */
void sub_41EE32()
{
  CThreadLocalObject::~CThreadLocalObject((CThreadLocalObject *)&unk_42E340);
}


/* ==== 41EE3C  sub_41EE3C  ()  size=10 ==== */
void sub_41EE3C()
{
  CProcessLocalObject::~CProcessLocalObject((CProcessLocalObject *)&unk_42E344);
}


/* ==== 41EE46  sub_41EE46  ()  size=6 ==== */
char **sub_41EE46()
{
  return &off_425BA4;
}


/* ==== 41EE4C  sub_41EE4C  ()  size=6 ==== */
char **sub_41EE4C()
{
  return &off_425B78;
}


/* ==== 41EE52  sub_41EE52  ()  size=6 ==== */
_UNKNOWN **sub_41EE52()
{
  return &off_425B58;
}


/* ==== 41EE58  sub_41EE58  ()  size=6 ==== */
char **sub_41EE58()
{
  return &off_425B30;
}


/* ==== 41EE5E  sub_41EE5E  ()  size=6 ==== */
char **sub_41EE5E()
{
  return &off_425B08;
}


/* ==== 41EE64  sub_41EE64  ()  size=6 ==== */
char **sub_41EE64()
{
  return &off_425AE4;
}


/* ==== 41EE6A  unknown_libname_48  ()  size=14 ==== */
// MFC 3.1-14.0 32bit
void __stdcall unknown_libname_48(struct CObject *a1)
{
  (*(void (__thiscall **)(struct CObject *, _DWORD))(*(_DWORD *)a1 + 4))(a1, 0);
}


/* ==== 41EE78  ?CreateObject@CDC@@SGPAVCObject@@XZ  (CDC::CreateObject(void))  size=33 ==== */
struct CObject *__stdcall CDC::CreateObject()
{
  struct CObject *result; // eax

  result = (struct CObject *)operator new(0x10u);
  if ( !result )
    return 0;
  *(_DWORD *)result = &CDC::`vftable';
  *((_DWORD *)result + 1) = 0;
  *((_DWORD *)result + 2) = 0;
  *((_DWORD *)result + 3) = 0;
  return result;
}


/* ==== 41EEB3  ?Construct@?$ConstructDestruct@VCDC@@@@SGXPAVCObject@@@Z  (ConstructDestruct<CDC>::Construct(CObject *))  size=28 ==== */
void __stdcall ConstructDestruct<CDC>::Construct(struct CObject *a1)
{
  if ( a1 )
  {
    *(_DWORD *)a1 = &CDC::`vftable';
    *((_DWORD *)a1 + 1) = 0;
    *((_DWORD *)a1 + 2) = 0;
    *((_DWORD *)a1 + 3) = 0;
  }
}


/* ==== 41EECF  sub_41EECF  ()  size=21 ==== */
void __stdcall sub_41EECF(struct CObject *a1)
{
  if ( a1 )
  {
    *((_DWORD *)a1 + 1) = 0;
    *(_DWORD *)a1 = &CGdiObject::`vftable';
  }
}


/* ==== 41EF1E  sub_41EF1E  ()  size=10 ==== */
void sub_41EF1E()
{
  sub_408CE1(dword_42E348);
}


/* ==== 41EF28  sub_41EF28  ()  size=10 ==== */
void sub_41EF28()
{
  sub_408D0A(dword_42E3E0);
}


/* ==== 41EF32  sub_41EF32  ()  size=6 ==== */
char **sub_41EF32()
{
  return &off_425D14;
}


/* ==== 41EF38  ?CreateObject@CWnd@@SGPAVCObject@@XZ  (CWnd::CreateObject(void))  size=50 ==== */
struct CObject *__stdcall CWnd::CreateObject()
{
  CWnd *v0; // ecx
  struct CObject *result; // eax

  v0 = (CWnd *)operator new(0x50u);
  result = 0;
  if ( v0 )
    return CWnd::CWnd(v0);
  return result;
}


/* ==== 41EF6A  ?Construct@?$ConstructDestruct@VCWnd@@@@SGXPAVCObject@@@Z  (ConstructDestruct<CWnd>::Construct(CObject *))  size=44 ==== */
CWnd *__stdcall ConstructDestruct<CWnd>::Construct(CWnd *a1)
{
  CWnd *result; // eax

  result = (CWnd *)&loc_421511;
  if ( a1 )
    return CWnd::CWnd(a1);
  return result;
}


/* ==== 41EF9F  ?get_accParent@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAPAUIDispatch@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accParent(IDispatch * *))  size=47 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accParent(int a1, int a2)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 )
    return (*(int (__stdcall **)(_DWORD, int))(**(_DWORD **)(a1 + 8) + 28))(*(_DWORD *)(a1 + 8), a2);
  return -2147467261;
}


/* ==== 41EFCE  ?get_accChildCount@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAJ@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accChildCount(long *))  size=47 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accChildCount(int a1, int a2)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 )
    return (*(int (__stdcall **)(_DWORD, int))(**(_DWORD **)(a1 + 8) + 32))(*(_DWORD *)(a1 + 8), a2);
  return -2147467261;
}


/* ==== 41EFFD  ?get_accChild@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPAUIDispatch@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accChild(tagVARIANT,IDispatch * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accChild(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 36))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F03D  ?get_accName@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accName(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accName(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 40))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F07D  ?get_accValue@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accValue(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accValue(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 44))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F0BD  ?get_accDescription@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accDescription(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accDescription(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 48))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F0FD  ?get_accRole@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAU3@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accRole(tagVARIANT,tagVARIANT *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accRole(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 52))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F13D  ?get_accState@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAU3@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accState(tagVARIANT,tagVARIANT *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accState(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 56))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F17D  ?get_accHelp@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accHelp(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accHelp(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 60))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F1BD  ?get_accHelpTopic@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAPA_WUtagVARIANT@@PAJ@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accHelpTopic(wchar_t * *,tagVARIANT,long *))  size=72 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accHelpTopic(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6,
        int a7)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 && a7 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 64))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6,
             a7);
  return -2147467261;
}


/* ==== 41F205  ?get_accKeyboardShortcut@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accKeyboardShortcut(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accKeyboardShortcut(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 68))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F245  ?get_accFocus@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAUtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accFocus(tagVARIANT *))  size=47 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accFocus(int a1, int a2)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 )
    return (*(int (__stdcall **)(_DWORD, int))(**(_DWORD **)(a1 + 8) + 72))(*(_DWORD *)(a1 + 8), a2);
  return -2147467261;
}


/* ==== 41F274  ?get_accSelection@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAUtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accSelection(tagVARIANT *))  size=47 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accSelection(int a1, int a2)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 )
    return (*(int (__stdcall **)(_DWORD, int))(**(_DWORD **)(a1 + 8) + 76))(*(_DWORD *)(a1 + 8), a2);
  return -2147467261;
}


/* ==== 41F2A3  ?get_accDefaultAction@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@PAPA_W@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accDefaultAction(tagVARIANT,wchar_t * *))  size=64 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::get_accDefaultAction(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a6 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 80))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  return -2147467261;
}


/* ==== 41F2E3  ?accSelect@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJJUtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accSelect(long,tagVARIANT))  size=50 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accSelect(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 84))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  else
    return -2147417848;
}


/* ==== 41F315  ?accLocation@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAJ000UtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accLocation(long *,long *,long *,long *,tagVARIANT))  size=88 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accLocation(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6,
        int a7,
        int a8,
        int a9)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a2 && a3 && a4 && a5 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 88))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6,
             a7,
             a8,
             a9);
  return -2147467261;
}


/* ==== 41F36D  ?accNavigate@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJJUtagVARIANT@@PAU3@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accNavigate(long,tagVARIANT,tagVARIANT *))  size=67 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accNavigate(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6,
        int a7)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a7 )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 92))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6,
             a7);
  return -2147467261;
}


/* ==== 41F3B0  ?accHitTest@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJJJPAUtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accHitTest(long,long,tagVARIANT *))  size=54 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accHitTest(int a1, int a2, int a3, int a4)
{
  if ( !*(_DWORD *)(a1 + 8) )
    return -2147417848;
  if ( a4 )
    return (*(int (__stdcall **)(_DWORD, int, int, int))(**(_DWORD **)(a1 + 8) + 96))(*(_DWORD *)(a1 + 8), a2, a3, a4);
  return -2147467261;
}


/* ==== 41F3E6  ?accDoDefaultAction@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJUtagVARIANT@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accDoDefaultAction(tagVARIANT))  size=46 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::accDoDefaultAction(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int))(**(_DWORD **)(a1 + 8) + 100))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5);
  else
    return -2147417848;
}


/* ==== 41F414  unknown_libname_51  ()  size=24 ==== */
// MFC 3.1-14.0 32bit
int __stdcall unknown_libname_51(int a1, int a2, int a3, int a4, int a5, int a6)
{
  return *(_DWORD *)(a1 + 8) != 0 ? -2147467263 : -2147417848;
}


/* ==== 41F42C  ?SetServer@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAUIAccessible@@PAUIAccessibleServer@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::SetServer(IAccessible *,IAccessibleServer *))  size=23 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::SetServer(int a1, int a2, int a3)
{
  *(_DWORD *)(a1 + 4) = a2;
  *(_DWORD *)(a1 + 8) = a3;
  return 0;
}


/* ==== 41F443  ?Invoke@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJJABU_GUID@@KGPAUtagDISPPARAMS@@PAUtagVARIANT@@PAUtagEXCEPINFO@@PAI@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::Invoke(long,_GUID const &,ulong,ushort,tagDISPPARAMS *,tagVARIANT *,tagEXCEPINFO *,uint *))  size=56 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::Invoke(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6,
        int a7,
        int a8,
        int a9)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 24))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6,
             a7,
             a8,
             a9);
  else
    return -2147417848;
}


/* ==== 41F47B  ?GetIDsOfNames@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJABU_GUID@@PAPA_WIKPAJ@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetIDsOfNames(_GUID const &,wchar_t * *,uint,ulong,long *))  size=47 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetIDsOfNames(
        int a1,
        int a2,
        int a3,
        int a4,
        int a5,
        int a6)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int, int, int, int, int))(**(_DWORD **)(a1 + 8) + 20))(
             *(_DWORD *)(a1 + 8),
             a2,
             a3,
             a4,
             a5,
             a6);
  else
    return -2147417848;
}


/* ==== 41F4AA  ?GetTypeInfoCount@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJPAI@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetTypeInfoCount(uint *))  size=33 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetTypeInfoCount(int a1, int a2)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int))(**(_DWORD **)(a1 + 8) + 12))(*(_DWORD *)(a1 + 8), a2);
  else
    return -2147417848;
}


/* ==== 41F4CB  ?GetTypeInfo@?$IAccessibleProxyImpl@VCAccessibleProxy@ATL@@@ATL@@UAGJIKPAPAUITypeInfo@@@Z  (ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetTypeInfo(uint,ulong,ITypeInfo * *))  size=41 ==== */
int __stdcall ATL::IAccessibleProxyImpl<ATL::CAccessibleProxy>::GetTypeInfo(int a1, int a2, int a3, int a4)
{
  if ( *(_DWORD *)(a1 + 8) )
    return (*(int (__stdcall **)(_DWORD, int, int, int))(**(_DWORD **)(a1 + 8) + 16))(*(_DWORD *)(a1 + 8), a2, a3, a4);
  else
    return -2147417848;
}


/* ==== 41F4F4  sub_41F4F4  ()  size=21 ==== */
struct CNoTrackObject *__stdcall sub_41F4F4()
{
  struct CNoTrackObject *result; // eax

  result = (struct CNoTrackObject *)unknown_libname_53(0xCu);
  if ( !result )
    return 0;
  *(_DWORD *)result = &_AFX_HTMLHELP_STATE::`vftable';
  return result;
}


/* ==== 41F509  ??0?$CMFCComObject@VCAccessibleProxy@ATL@@@@QAE@PAX@Z  (CMFCComObject<ATL::CAccessibleProxy>::CMFCComObject<ATL::CAccessibleProxy>(void *))  size=45 ==== */
_DWORD *__thiscall CMFCComObject<ATL::CAccessibleProxy>::CMFCComObject<ATL::CAccessibleProxy>(_DWORD *this, int a2)
{
  this[5] = 0;
  this[2] = 0;
  this[3] = 0;
  *this = &CMFCComObject<ATL::CAccessibleProxy>::`vftable';
  this[1] = &CMFCComObject<ATL::CAccessibleProxy>::`vftable';
  this[4] = &off_42651C;
  AfxOleLockApp();
  return this;
}


/* ==== 41F536  sub_41F536  ()  size=28 ==== */
void *__thiscall sub_41F536(void *Block, char a2)
{
  CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>();
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41F552  ??1?$CMFCComObject@VCAccessibleProxy@ATL@@@@UAE@XZ  (CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(void))  size=37 ==== */
void __thiscall CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(
        ATL::CAccessibleProxy *this)
{
  *(_DWORD *)this = &CMFCComObject<ATL::CAccessibleProxy>::`vftable';
  *((_DWORD *)this + 1) = &CMFCComObject<ATL::CAccessibleProxy>::`vftable';
  *((_DWORD *)this + 4) = &off_42651C;
  *((_DWORD *)this + 5) = -1073741823;
  ATL::CAccessibleProxy::FinalRelease(this);
  AfxOleUnlockApp();
}


/* ==== 41F577  ?AddRef@?$CMFCComObject@VCAccessibleProxy@ATL@@@@UAGKXZ  (CMFCComObject<ATL::CAccessibleProxy>::AddRef(void))  size=13 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::AddRef(int a1)
{
  return ++*(_DWORD *)(a1 + 20);
}


/* ==== 41F584  ?Release@?$CMFCComObject@VCAccessibleProxy@ATL@@@@UAGKXZ  (CMFCComObject<ATL::CAccessibleProxy>::Release(void))  size=30 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::Release(_DWORD *a1)
{
  bool v1; // zf
  int v2; // esi

  v1 = a1[5]-- == 1;
  v2 = a1[5];
  if ( v1 && a1 )
    (*(void (__thiscall **)(_DWORD *, int))(*a1 + 112))(a1, 1);
  return v2;
}


/* ==== 41F5A2  ?QueryInterface@?$CMFCComObject@VCAccessibleProxy@ATL@@@@UAGJABU_GUID@@PAPAX@Z  (CMFCComObject<ATL::CAccessibleProxy>::QueryInterface(_GUID const &,void * *))  size=25 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::QueryInterface(char *a1, struct _GUID *a2, void **a3)
{
  return ATL::AtlInternalQueryInterface(a1, (const struct ATL::_ATL_INTMAP_ENTRY *)&off_4265E0, a2, a3);
}


/* ==== 41F5BB  ?QueryInterface@?$CMFCComObject@VCAccessibleProxy@ATL@@@@W3AGJABU_GUID@@PAPAX@Z  ([thunk]:CMFCComObject<ATL::CAccessibleProxy>::QueryInterface`adjustor{4}' (_GUID const &,void * *))  size=10 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::QueryInterface(int a1, struct _GUID *a2, void **a3)
{
  return CMFCComObject<ATL::CAccessibleProxy>::QueryInterface((char *)(a1 - 4), a2, a3);
}


/* ==== 41F5C5  sub_41F5C5  ()  size=10 ==== */
int __stdcall sub_41F5C5(int a1)
{
  return CMFCComObject<ATL::CAccessibleProxy>::AddRef(a1 - 4);
}


/* ==== 41F5CF  sub_41F5CF  ()  size=10 ==== */
int __stdcall sub_41F5CF(int a1)
{
  return CMFCComObject<ATL::CAccessibleProxy>::Release((_DWORD *)(a1 - 4));
}


/* ==== 41F5D9  ?QueryInterface@?$CMFCComObject@VCAccessibleProxy@ATL@@@@WBA@AGJABU_GUID@@PAPAX@Z  ([thunk]:CMFCComObject<ATL::CAccessibleProxy>::QueryInterface`adjustor{16}' (_GUID const &,void * *))  size=10 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::QueryInterface(int a1, struct _GUID *a2, void **a3)
{
  return CMFCComObject<ATL::CAccessibleProxy>::QueryInterface((char *)(a1 - 16), a2, a3);
}


/* ==== 41F5E3  sub_41F5E3  ()  size=10 ==== */
int __stdcall sub_41F5E3(int a1)
{
  return CMFCComObject<ATL::CAccessibleProxy>::AddRef(a1 - 16);
}


/* ==== 41F5ED  sub_41F5ED  ()  size=10 ==== */
int __stdcall sub_41F5ED(int a1)
{
  return CMFCComObject<ATL::CAccessibleProxy>::Release((_DWORD *)(a1 - 16));
}


/* ==== 41F5F7  ?CreateInstance@?$CMFCComObject@VCAccessibleProxy@ATL@@@@SGJPAPAV1@@Z  (CMFCComObject<ATL::CAccessibleProxy>::CreateInstance(CMFCComObject<ATL::CAccessibleProxy> * *))  size=134 ==== */
int __stdcall CMFCComObject<ATL::CAccessibleProxy>::CreateInstance(_DWORD *a1)
{
  _DWORD *v2; // ecx
  _DWORD *v3; // eax
  int v4; // [esp+0h] [ebp-2Ch] BYREF
  void *Block; // [esp+10h] [ebp-1Ch]
  int v6; // [esp+14h] [ebp-18h]
  int v7; // [esp+18h] [ebp-14h]
  int *v8; // [esp+1Ch] [ebp-10h]
  int v9; // [esp+28h] [ebp-4h]

  v8 = &v4;
  if ( !a1 )
    return -2147467261;
  *a1 = 0;
  v7 = -2147024882;
  v6 = 0;
  v9 = 0;
  v2 = operator new(0x18u);
  Block = v2;
  LOBYTE(v9) = 1;
  if ( v2 )
    v3 = CMFCComObject<ATL::CAccessibleProxy>::CMFCComObject<ATL::CAccessibleProxy>(v2, 0);
  else
    v3 = 0;
  if ( v3 )
    v7 = 0;
  *a1 = v3;
  return v7;
}


/* ==== 41F67D  sub_41F67D  ()  size=236 ==== */
HBITMAP sub_41F67D()
{
  unsigned int v0; // eax
  int v1; // ebx
  unsigned int v2; // eax
  int v3; // esi
  int v4; // edi
  _BYTE *v5; // edx
  int v6; // esi
  int v7; // eax
  int v8; // eax
  HBITMAP result; // eax
  int nHeight; // [esp+10h] [ebp-18h]
  int v11; // [esp+14h] [ebp-14h]
  unsigned __int8 *v12; // [esp+18h] [ebp-10h]
  _WORD Bits[64]; // [esp+1Ch] [ebp-Ch] BYREF

  v0 = GetMenuCheckMarkDimensions();
  v1 = (__int16)v0;
  v2 = HIWORD(v0);
  nHeight = (__int16)v2;
  if ( v1 > 32 )
    v1 = 32;
  v3 = (v1 + 15) >> 4;
  v4 = 16 * v3 + (v1 - 4) / 2 - v1;
  if ( v4 > 12 )
    LOBYTE(v4) = 12;
  if ( (__int16)v2 > 32 )
    nHeight = 32;
  memset(Bits, 255, sizeof(Bits));
  v5 = &Bits[v3 * ((nHeight - 6) >> 1)];
  v12 = (unsigned __int8 *)&unk_426680;
  v6 = 2 * v3;
  v11 = 5;
  do
  {
    HIWORD(v7) = HIWORD(v12);
    LOWORD(v7) = *v12++;
    v8 = ~(v7 << v4);
    *v5 = BYTE1(v8);
    v5[1] = v8;
    v5 += v6;
    --v11;
  }
  while ( v11 );
  result = CreateBitmap(v1, nHeight, 1u, 1u, Bits);
  hBitmapChecked = result;
  if ( !result )
  {
    result = LoadBitmapA(0, (LPCSTR)0x7FE3);
    hBitmapChecked = result;
  }
  return result;
}


/* ==== 41F769  sub_41F769  ()  size=6 ==== */
char **sub_41F769()
{
  return &off_42675C;
}


/* ==== 41F76F  sub_41F76F  ()  size=6 ==== */
char **sub_41F76F()
{
  return &off_42679C;
}


/* ==== 41F775  sub_41F775  ()  size=137 ==== */
HMODULE __cdecl sub_41F775(LCID Locale)
{
  char *Format; // ecx
  const char *v2; // esi
  CHAR String1[4]; // [esp+4h] [ebp-11Ch] BYREF
  CHAR LibFileName[276]; // [esp+8h] [ebp-118h] BYREF

  v2 = Format;
  if ( Locale == 2048 )
  {
    lstrcpyA(String1, "LOC");
  }
  else if ( !GetLocaleInfoA(Locale, 3u, String1, 4) )
  {
    return 0;
  }
  if ( (unsigned int)_snprintf(LibFileName, 0x112u, v2, String1) <= 0x111 )
    return LoadLibraryA(LibFileName);
  return 0;
}


/* ==== 41F7FE  unknown_libname_52  ()  size=22 ==== */
// MFC 3.1-14.0 32bit
BOOL __stdcall unknown_libname_52(HMODULE hModule, LPCSTR lpType, LPCSTR lpName, WORD wLanguage, _WORD *lParam)
{
  BOOL result; // eax

  result = (BOOL)lParam;
  if ( lParam )
  {
    *lParam = wLanguage;
    return 1;
  }
  return result;
}


/* ==== 41F814  sub_41F814  ()  size=485 ==== */
HMODULE __stdcall sub_41F814(char *a1)
{
  int v1; // esi
  LANGID (__stdcall *GetUserDefaultUILanguage)(); // eax
  LANGID v3; // ax
  LANGID (__stdcall *GetSystemDefaultUILanguage)(); // eax
  LCID v5; // ebx
  LCID v6; // edi
  HMODULE ModuleHandleA; // eax
  LCID v8; // edi
  int v9; // esi
  int v10; // edi
  HMODULE result; // eax
  int v12; // [esp-4h] [ebp-50h]
  LCID v13; // [esp+Ch] [ebp-40h]
  LCID v14; // [esp+10h] [ebp-3Ch]
  LCID v15; // [esp+14h] [ebp-38h]
  LCID v16; // [esp+18h] [ebp-34h]
  char *Format; // [esp+20h] [ebp-2Ch]
  LONG_PTR v18; // [esp+24h] [ebp-28h] BYREF
  DWORD Type; // [esp+28h] [ebp-24h] BYREF
  HMODULE hModule; // [esp+2Ch] [ebp-20h] BYREF
  LCID Locale; // [esp+30h] [ebp-1Ch] BYREF
  LONG_PTR lParam; // [esp+34h] [ebp-18h] BYREF
  BYTE Data[16]; // [esp+38h] [ebp-14h] BYREF

  Format = a1;
  lParam = 0;
  v1 = 0;
  hModule = GetModuleHandleA("kernel32.dll");
  GetUserDefaultUILanguage = (LANGID (__stdcall *)())GetProcAddress(hModule, "GetUserDefaultUILanguage");
  if ( GetUserDefaultUILanguage )
  {
    v3 = GetUserDefaultUILanguage();
    Locale = v3 & 0x3FF;
    v13 = ConvertDefaultLocale(Locale | v3 & 0xFC00);
    v14 = ConvertDefaultLocale(Locale);
    GetSystemDefaultUILanguage = (LANGID (__stdcall *)())GetProcAddress(hModule, "GetSystemDefaultUILanguage");
    lParam = ((int (*)(void))GetSystemDefaultUILanguage)();
    v5 = lParam & 0x3FF;
    v15 = ConvertDefaultLocale(v5 | lParam & 0xFC00);
    v16 = ConvertDefaultLocale(v5);
    v12 = 4;
LABEL_13:
    v1 = v12;
    goto LABEL_14;
  }
  if ( (GetVersion() & 0x80000000) == 0 )
  {
    ModuleHandleA = GetModuleHandleA("ntdll.dll");
    if ( ModuleHandleA )
    {
      lParam = 0;
      EnumResourceLanguagesA(
        ModuleHandleA,
        (LPCSTR)0x10,
        (LPCSTR)1,
        (ENUMRESLANGPROCA)unknown_libname_52,
        (LONG_PTR)&lParam);
      if ( (_WORD)lParam )
      {
        v8 = lParam & 0x3FF;
        v13 = ConvertDefaultLocale(v8 | lParam & 0xFC00);
        v14 = ConvertDefaultLocale(v8);
        v12 = 2;
        goto LABEL_13;
      }
    }
  }
  else
  {
    Locale = 0;
    if ( !RegOpenKeyExA(HKEY_CURRENT_USER, "Control Panel\\Desktop\\ResourceLocale", 0, 0x20019u, (PHKEY)&Locale) )
    {
      hModule = (HMODULE)16;
      if ( !RegQueryValueExA((HKEY)Locale, 0, 0, &Type, Data, (LPDWORD)&hModule)
        && Type == 1
        && sscanf((const char *const)Data, "%x", &v18) == 1 )
      {
        lParam = v18;
        v6 = v18 & 0x3FF;
        v13 = ConvertDefaultLocale((unsigned __int16)v18);
        v14 = ConvertDefaultLocale(v6);
        v1 = 2;
      }
      RegCloseKey((HKEY)Locale);
    }
  }
LABEL_14:
  *(&v13 + v1) = 2048;
  v9 = v1 + 1;
  v10 = 0;
  if ( v9 <= 0 )
    return 0;
  while ( 1 )
  {
    result = sub_41F775(*(&v13 + v10));
    if ( result )
      break;
    if ( ++v10 >= v9 )
      return 0;
  }
  return result;
}


/* ==== 41F9F9  ?LoadSysPolicies@CWinApp@@UAEHXZ  (CWinApp::LoadSysPolicies(void))  size=202 ==== */
int __thiscall CWinApp::LoadSysPolicies(CWinApp *this)
{
  char **v1; // ebx
  char *i; // esi
  int v3; // ecx
  bool v4; // zf
  DWORD cbData; // [esp+8h] [ebp-14h] BYREF
  CWinApp *v7; // [esp+Ch] [ebp-10h]
  DWORD Type; // [esp+10h] [ebp-Ch] BYREF
  BYTE Data[4]; // [esp+14h] [ebp-8h] BYREF
  HKEY phkResult; // [esp+18h] [ebp-4h] BYREF

  *((_DWORD *)this + 39) = 0;
  v7 = this;
  phkResult = 0;
  *(_DWORD *)Data = 0;
  cbData = 4;
  Type = 0;
  v1 = off_42C960;
  if ( off_42C960[0] )
  {
    do
    {
      if ( !RegOpenKeyExA(HKEY_CURRENT_USER, *v1, 0, 1u, &phkResult) )
      {
        for ( i = v1[1]; *(_DWORD *)i; i += 8 )
        {
          if ( !RegQueryValueExA(phkResult, *(LPCSTR *)i, 0, &Type, Data, &cbData) && Type == 4 )
          {
            v3 = *((_DWORD *)i + 1);
            if ( *(_DWORD *)Data )
              *((_DWORD *)v7 + 39) |= v3;
            else
              *((_DWORD *)v7 + 39) &= ~v3;
          }
          *(_DWORD *)Data = 0;
          cbData = 4;
          Type = 0;
        }
      }
      RegCloseKey(phkResult);
      v1 += 2;
      v4 = *v1 == 0;
      phkResult = 0;
    }
    while ( !v4 );
  }
  RegCloseKey(0);
  return 1;
}


/* ==== 41FAC3  ?InitApplication@CWinApp@@UAEHXZ  (CWinApp::InitApplication(void))  size=64 ==== */
int __thiscall CWinApp::InitApplication(CWinApp *this)
{
  int v2; // ecx

  if ( dword_42FDF8 )
  {
    if ( !*((_DWORD *)this + 21) )
      *((_DWORD *)this + 21) = dword_42FDF8;
    dword_42FDF8 = 0;
  }
  v2 = *((_DWORD *)this + 21);
  if ( v2 )
    (*(void (__thiscall **)(int, _DWORD))(*(_DWORD *)v2 + 12))(v2, 0);
  else
    dword_42C8F4 = 0;
  (*(void (__thiscall **)(CWinApp *))(*(_DWORD *)this + 180))(this);
  return 1;
}


/* ==== 41FB03  sub_41FB03  ()  size=138 ==== */
HMODULE __thiscall sub_41FB03(HMODULE *this)
{
  DWORD ModuleFileNameA; // eax
  CHAR *ExtensionA; // eax
  CHAR Filename[260]; // [esp+4h] [ebp-110h] BYREF
  CHAR String2[8]; // [esp+108h] [ebp-Ch] BYREF

  ModuleFileNameA = GetModuleFileNameA(this[16], Filename, 0x104u);
  if ( !ModuleFileNameA )
    return 0;
  if ( ModuleFileNameA == 260 )
    return 0;
  ExtensionA = PathFindExtensionA(Filename);
  strcpy(String2, "%s.dll");
  if ( (unsigned int)(ExtensionA - Filename + 7) > 0x104 )
    return 0;
  lstrcpyA(ExtensionA, String2);
  return sub_41F814(Filename);
}


/* ==== 41FB8D  ??1CWinApp@@UAE@XZ  (CWinApp::~CWinApp(void))  size=296 ==== */
void __thiscall CWinApp::~CWinApp(CWinApp *this)
{
  int v2; // ecx
  int v3; // ecx
  ATOM v4; // ax
  ATOM v5; // ax
  int v6; // ecx
  struct AFX_MODULE_STATE *ModuleState; // eax

  *(_DWORD *)this = &CWinApp::`vftable';
  v2 = *((_DWORD *)this + 21);
  if ( v2 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v2 + 4))(v2, 1);
  v3 = *((_DWORD *)this + 33);
  if ( v3 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v3 + 24))(v3, 1);
  if ( !*((_BYTE *)AfxGetModuleState() + 20) )
  {
    if ( dword_42FDFC )
    {
      (*(void (__thiscall **)(int, int))(*(_DWORD *)dword_42FDFC + 4))(dword_42FDFC, 1);
      dword_42FDFC = 0;
    }
    if ( dword_42FDF8 )
    {
      (*(void (__thiscall **)(int, int))(*(_DWORD *)dword_42FDF8 + 4))(dword_42FDF8, 1);
      dword_42FDF8 = 0;
    }
  }
  if ( *((_DWORD *)this + 27) )
    AfxGlobalFree(*((HGLOBAL *)this + 27));
  if ( *((_DWORD *)this + 28) )
    AfxGlobalFree(*((HGLOBAL *)this + 28));
  v4 = *((_WORD *)this + 70);
  if ( v4 )
    GlobalDeleteAtom(v4);
  v5 = *((_WORD *)this + 71);
  if ( v5 )
    GlobalDeleteAtom(v5);
  v6 = *((_DWORD *)this + 34);
  if ( v6 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v6 + 4))(v6, 1);
  ModuleState = AfxGetModuleState();
  if ( *((_DWORD *)ModuleState + 4) == *((_DWORD *)this + 19) )
    *((_DWORD *)ModuleState + 4) = 0;
  if ( *((CWinApp **)ModuleState + 1) == this )
    *((_DWORD *)ModuleState + 1) = 0;
  free(*((void **)this + 19));
  free(*((void **)this + 20));
  free(*((void **)this + 23));
  free(*((void **)this + 24));
  free(*((void **)this + 25));
  *((_DWORD *)this + 10) = 0;
  CWinThread::~CWinThread(this);
}


/* ==== 41FCB5  ?SaveStdProfileSettings@CWinApp@@IAEXXZ  (CWinApp::SaveStdProfileSettings(void))  size=53 ==== */
void __thiscall CWinApp::SaveStdProfileSettings(CWinApp *this)
{
  if ( *((_DWORD *)this + 33) )
    (*(void (__thiscall **)(_DWORD))(**((_DWORD **)this + 33) + 20))(*((_DWORD *)this + 33));
  if ( *((_DWORD *)this + 36) )
    sub_41E88E((int)this, "Settings", "PreviewPages", *((_DWORD *)this + 36));
}


/* ==== 41FCEA  ?ExitInstance@CWinApp@@UAEHXZ  (CWinApp::ExitInstance(void))  size=84 ==== */
WPARAM __thiscall CWinApp::ExitInstance(CWinApp *this)
{
  int v2; // eax
  int v3; // eax
  void (*v4)(void); // eax

  v2 = *((_DWORD *)this + 34);
  if ( !v2 || (v3 = *(_DWORD *)(v2 + 16), v3 != 6) && v3 != 5 )
  {
    if ( !*((_BYTE *)AfxGetModuleState() + 20) )
      CWinApp::SaveStdProfileSettings(this);
  }
  v4 = (void (*)(void))*((_DWORD *)this + 38);
  if ( v4 )
    v4();
  if ( *((_DWORD *)this + 30) )
  {
    FreeLibrary(*((HMODULE *)this + 30));
    *((_DWORD *)this + 30) = 0;
  }
  return AfxGetCurrentMessage()->wParam;
}


/* ==== 41FD3E  sub_41FD3E  ()  size=6 ==== */
char **sub_41FD3E()
{
  return &off_426920;
}


/* ==== 41FD44  sub_41FD44  ()  size=28 ==== */
CWinApp *__thiscall sub_41FD44(CWinApp *Block, char a2)
{
  CWinApp::~CWinApp(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 41FD60  ?InitInstance@CWinApp@@UAEHXZ  (CWinApp::InitInstance(void))  size=56 ==== */
int __thiscall CWinApp::InitInstance(CWinApp *this)
{
  int v2; // edi

  (*(void (__thiscall **)(CWinApp *))(*(_DWORD *)this + 124))(this);
  v2 = (*(int (__thiscall **)(CWinApp *))(*(_DWORD *)this + 176))(this);
  *((_DWORD *)this + 30) = v2;
  if ( v2 )
  {
    *((_DWORD *)AfxGetModuleState() + 3) = v2;
    InterlockedExchange(&dword_4305AC, *((_DWORD *)this + 30));
  }
  return 1;
}


/* ==== 41FD98  ??0CWinApp@@QAE@PBD@Z  (CWinApp::CWinApp(char const *))  size=216 ==== */
CWinApp *__thiscall CWinApp::CWinApp(CWinApp *this, char *Source)
{
  struct AFX_MODULE_STATE *ModuleState; // ebx

  CWinThread::CWinThread(this);
  *(_DWORD *)this = &CWinApp::`vftable';
  if ( Source )
    *((_DWORD *)this + 19) = _strdup(Source);
  else
    *((_DWORD *)this + 19) = 0;
  ModuleState = AfxGetModuleState();
  *((_DWORD *)CThreadLocalObject::GetData(
                (struct AFX_MODULE_STATE *)((char *)ModuleState + 4208),
                CThreadLocal<AFX_MODULE_THREAD_STATE>::CreateObject)
  + 1) = this;
  *((_DWORD *)this + 10) = GetCurrentThread();
  *((_DWORD *)this + 11) = GetCurrentThreadId();
  *((_DWORD *)ModuleState + 1) = this;
  *((_DWORD *)this + 16) = 0;
  *((_DWORD *)this + 30) = 0;
  *((_DWORD *)this + 24) = 0;
  *((_DWORD *)this + 25) = 0;
  *((_DWORD *)this + 20) = 0;
  *((_DWORD *)this + 23) = 0;
  *((_DWORD *)this + 33) = 0;
  *((_DWORD *)this + 21) = 0;
  *((_WORD *)this + 71) = 0;
  *((_WORD *)this + 70) = 0;
  *((_DWORD *)this + 17) = 0;
  *((_DWORD *)this + 34) = 0;
  *((_DWORD *)this + 31) = 0;
  *((_DWORD *)this + 32) = 0;
  *((_DWORD *)this + 27) = 0;
  *((_DWORD *)this + 28) = 0;
  *((_DWORD *)this + 36) = 0;
  *((_DWORD *)this + 38) = 0;
  *((_DWORD *)this + 22) = 0;
  *((_DWORD *)this + 26) = 0;
  *((_DWORD *)this + 37) = 512;
  return this;
}


/* ==== 41FE70  sub_41FE70  ()  size=4 ==== */
int sub_41FE70()
{
  return 1;
}


/* ==== 41FE74  sub_41FE74  ()  size=299 ==== */
LSTATUS __stdcall sub_41FE74(HKEY hKey, LPCSTR *a2)
{
  LSTATUS v2; // esi
  const CHAR *v4; // [esp-8h] [ebp-144h]
  int v5; // [esp+0h] [ebp-13Ch] BYREF
  HKEY v6; // [esp+10h] [ebp-12Ch]
  LPCSTR *v7; // [esp+14h] [ebp-128h]
  HKEY phkResult; // [esp+18h] [ebp-124h] BYREF
  int v9; // [esp+1Ch] [ebp-120h] BYREF
  CHAR Name[264]; // [esp+20h] [ebp-11Ch] BYREF
  int *v11; // [esp+12Ch] [ebp-10h]
  int v12; // [esp+138h] [ebp-4h]

  v11 = &v5;
  v4 = *a2;
  v6 = hKey;
  v7 = a2;
  v2 = RegOpenKeyA(hKey, v4, &phkResult);
  if ( !v2 )
  {
    while ( 1 )
    {
      v2 = RegEnumKeyA(phkResult, 0, Name, 0x104u);
      if ( v2 )
        break;
      v12 = 0;
      sub_404670((volatile signed __int32 **)&v9, (int)Name);
      LOBYTE(v12) = 1;
      v2 = sub_41FE74(phkResult, (int)&v9);
      LOBYTE(v12) = 0;
      ATL::CStringData::Release((ATL::CStringData *)(v9 - 16));
      if ( v2 )
        break;
      v12 = -1;
    }
    if ( v2 == 259 || v2 == 1010 )
      v2 = RegDeleteKeyA(v6, *a2);
    RegCloseKey(phkResult);
  }
  return v2;
}


/* ==== 41FF9F  sub_41FF9F  ()  size=375 ==== */
int __thiscall sub_41FF9F(int this)
{
  int v2; // eax
  void **v3; // eax
  LPCSTR v4; // edi
  char *v6; // [esp-10h] [ebp-148h]
  char *v7; // [esp-4h] [ebp-13Ch]
  LONG cbData; // [esp+8h] [ebp-130h] BYREF
  int v9; // [esp+Ch] [ebp-12Ch] BYREF
  struct __POSITION *FirstDocTemplatePosition; // [esp+10h] [ebp-128h] BYREF
  LPCSTR v11; // [esp+14h] [ebp-124h] BYREF
  HKEY phkResult; // [esp+18h] [ebp-120h] BYREF
  LPCSTR lpSubKey; // [esp+1Ch] [ebp-11Ch] BYREF
  CHAR Name[264]; // [esp+20h] [ebp-118h] BYREF
  int v15; // [esp+134h] [ebp-4h]

  phkResult = 0;
  FirstDocTemplatePosition = CWinApp::GetFirstDocTemplatePosition((CWinApp *)this);
  while ( FirstDocTemplatePosition )
  {
    v2 = (*(int (__thiscall **)(_DWORD, struct __POSITION **))(**(_DWORD **)(this + 84) + 20))(
           *(_DWORD *)(this + 84),
           &FirstDocTemplatePosition);
    if ( v2 )
      (*(void (__thiscall **)(int, _DWORD, int, _DWORD, _DWORD))(*(_DWORD *)v2 + 12))(v2, 0, -4, 0, 0);
  }
  if ( *(_DWORD *)(this + 80) )
  {
    sub_404670((volatile signed __int32 **)&lpSubKey, (int)"Software\\");
    v7 = *(char **)(this + 80);
    v15 = 0;
    sub_41EA0D((int *)&lpSubKey, v7);
    v3 = (void **)sub_41E693(&v9, (void **)&lpSubKey, "\\");
    v6 = *(char **)(this + 100);
    LOBYTE(v15) = 1;
    sub_41E693(&v11, v3, v6);
    LOBYTE(v15) = 3;
    ATL::CStringData::Release((ATL::CStringData *)(v9 - 16));
    sub_41FE74(HKEY_CURRENT_USER, &v11);
    if ( !RegOpenKeyA(HKEY_CURRENT_USER, lpSubKey, &phkResult) )
    {
      if ( RegEnumKeyA(phkResult, 0, Name, 0x104u) == 259 )
        sub_41FE74(HKEY_CURRENT_USER, &lpSubKey);
      RegCloseKey(phkResult);
    }
    v4 = v11;
    RegQueryValueA(HKEY_CURRENT_USER, v11, Name, &cbData);
    ATL::CStringData::Release((ATL::CStringData *)(v4 - 16));
    ATL::CStringData::Release((ATL::CStringData *)(lpSubKey - 16));
  }
  return 1;
}


/* ==== 420116  ?CommonConstruct@CWinThread@@QAEXXZ  (CWinThread::CommonConstruct(void))  size=55 ==== */
void __thiscall CWinThread::CommonConstruct(CWinThread *this)
{
  struct _AFX_THREAD_STATE *ThreadState; // eax

  *((_DWORD *)this + 7) = 0;
  *((_DWORD *)this + 8) = 0;
  *((_DWORD *)this + 10) = 0;
  *((_DWORD *)this + 11) = 0;
  ThreadState = AfxGetThreadState();
  *((_DWORD *)ThreadState + 13) = 0;
  *((_DWORD *)ThreadState + 21) = 0;
  GetCursorPos((LPPOINT)((char *)ThreadState + 76));
  *((_DWORD *)this + 15) = 0;
  *((_DWORD *)this + 14) = 0;
  *((_DWORD *)this + 9) = 1;
}


/* ==== 42014D  sub_42014D  ()  size=6 ==== */
char **sub_42014D()
{
  return &off_426C64;
}


/* ==== 420153  sub_420153  ()  size=28 ==== */
CWinThread *__thiscall sub_420153(CWinThread *Block, char a2)
{
  CWinThread::~CWinThread(Block);
  if ( (a2 & 1) != 0 )
    j__free(Block);
  return Block;
}


/* ==== 42016F  ??0CWinThread@@QAE@XZ  (CWinThread::CWinThread(void))  size=61 ==== */
CWinThread *__thiscall CWinThread::CWinThread(CWinThread *this)
{
  CCmdTarget::CCmdTarget(this);
  *(_DWORD *)this = &CWinThread::`vftable';
  *((_DWORD *)this + 12) = 0;
  *((_DWORD *)this + 13) = 0;
  CWinThread::CommonConstruct(this);
  return this;
}


/* ==== 4201AC  sub_4201AC  ()  size=6 ==== */
char **sub_4201AC()
{
  return &off_426D14;
}


/* ==== 4201B2  ??0AUX_DATA@@QAE@XZ  (AUX_DATA::AUX_DATA(void))  size=85 ==== */
AUX_DATA *__thiscall AUX_DATA::AUX_DATA(AUX_DATA *this)
{
  *((_DWORD *)this + 21) = GetVersion() >> 31;
  AUX_DATA::UpdateSysMetrics(this);
  *((_DWORD *)this + 9) = 0;
  AUX_DATA::UpdateSysColors(this);
  *((_DWORD *)this + 15) = LoadCursorA(0, (LPCSTR)0x7F02);
  *((_DWORD *)this + 16) = LoadCursorA(0, (LPCSTR)0x7F00);
  *((_DWORD *)this + 4) = 2;
  *((_DWORD *)this + 5) = 2;
  *((_DWORD *)this + 20) = 0;
  *((_DWORD *)this + 17) = 0;
  return this;
}


/* ==== 42021D  sub_42021D  ()  size=11 ==== */
void sub_42021D()
{
  AfxDeleteObject((void **)&hBitmapChecked);
}


/* ==== 420228  unknown_libname_53  ()  size=24 ==== */
// MFC 3.1-14.0 32bit
HLOCAL __stdcall unknown_libname_53(SIZE_T uBytes)
{
  HLOCAL result; // eax

  result = LocalAlloc(0x40u, uBytes);
  if ( !result )
    unknown_libname_11();
  return result;
}


/* ==== 420240  ??3CNoTrackObject@@SGXPAX@Z  (CNoTrackObject::operator delete(void *))  size=16 ==== */
void __stdcall CNoTrackObject::operator delete(void *a1)
{
  if ( a1 )
    LocalFree(a1);
}


/* ==== 420250  ?AllocSlot@CThreadSlotData@@QAEHXZ  (CThreadSlotData::AllocSlot(void))  size=268 ==== */
int __thiscall CThreadSlotData::AllocSlot(CThreadSlotData *this)
{
  int v2; // eax
  int v3; // edi
  _BYTE *v4; // ecx
  int v5; // ebx
  HGLOBAL v6; // eax
  const void *v7; // esi
  HGLOBAL v8; // eax
  HGLOBAL hMem; // [esp+Ch] [ebp-8h]
  char *hMema; // [esp+Ch] [ebp-8h]
  struct _RTL_CRITICAL_SECTION *lpCriticalSection; // [esp+10h] [ebp-4h]

  lpCriticalSection = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  v2 = *((_DWORD *)this + 1);
  v3 = *((_DWORD *)this + 2);
  if ( v3 >= v2 || (*(_BYTE *)(*((_DWORD *)this + 4) + 8 * v3) & 1) != 0 )
  {
    v3 = 1;
    if ( v2 <= 1 )
      goto LABEL_8;
    v4 = (_BYTE *)(*((_DWORD *)this + 4) + 8);
    do
    {
      if ( (*v4 & 1) == 0 )
        break;
      ++v3;
      v4 += 8;
    }
    while ( v3 < v2 );
    if ( v3 >= v2 )
    {
LABEL_8:
      v5 = v2 + 32;
      if ( *((_DWORD *)this + 4) )
      {
        hMem = GlobalHandle(*((LPCVOID *)this + 4));
        GlobalUnlock(hMem);
        v6 = GlobalReAlloc(hMem, 8 * v5, 0x2002u);
      }
      else
      {
        v6 = GlobalAlloc(2u, 8 * v5);
      }
      if ( !v6 )
      {
        v7 = (const void *)*((_DWORD *)this + 4);
        if ( v7 )
        {
          v8 = GlobalHandle(v7);
          GlobalLock(v8);
        }
        LeaveCriticalSection(lpCriticalSection);
        unknown_libname_11();
      }
      hMema = (char *)GlobalLock(v6);
      memset(&hMema[8 * *((_DWORD *)this + 1)], 0, 8 * (v5 - *((_DWORD *)this + 1)));
      *((_DWORD *)this + 1) = v5;
      *((_DWORD *)this + 4) = hMema;
    }
  }
  if ( v3 >= *((_DWORD *)this + 3) )
    *((_DWORD *)this + 3) = v3 + 1;
  *(_DWORD *)(*((_DWORD *)this + 4) + 8 * v3) |= 1u;
  *((_DWORD *)this + 2) = v3 + 1;
  LeaveCriticalSection(lpCriticalSection);
  return v3;
}


/* ==== 42035C  ?GetThreadValue@CThreadSlotData@@QAEPAXH@Z  (CThreadSlotData::GetThreadValue(int))  size=70 ==== */
int __thiscall CThreadSlotData::GetThreadValue(CThreadSlotData *this, int a2)
{
  struct _RTL_CRITICAL_SECTION *v3; // ebx
  _DWORD *Value; // eax
  int v5; // edi

  v3 = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  if ( a2 > 0 && a2 < *((_DWORD *)this + 3) && (Value = TlsGetValue(*(_DWORD *)this)) != 0 && a2 < Value[2] )
    v5 = *(_DWORD *)(Value[3] + 4 * a2);
  else
    v5 = 0;
  LeaveCriticalSection(v3);
  return v5;
}


/* ==== 4203A2  ?GetDataNA@CThreadLocalObject@@QAEPAVCNoTrackObject@@XZ  (CThreadLocalObject::GetDataNA(void))  size=26 ==== */
struct CNoTrackObject *__thiscall CThreadLocalObject::GetDataNA(CThreadLocalObject *this)
{
  if ( *(_DWORD *)this && dword_42FE5C )
    return (struct CNoTrackObject *)CThreadSlotData::GetThreadValue(dword_42FE5C, *(_DWORD *)this);
  else
    return 0;
}


/* ==== 4203BC  ?GetData@CProcessLocalObject@@QAEPAVCNoTrackObject@@P6GPAV2@XZ@Z  (CProcessLocalObject::GetData(CNoTrackObject * (*)(void)))  size=92 ==== */
struct CNoTrackObject *__thiscall CProcessLocalObject::GetData(
        CProcessLocalObject *this,
        struct CNoTrackObject *(__stdcall *a2)())
{
  bool v3; // zf
  _DWORD v5[5]; // [esp+0h] [ebp-20h] BYREF
  int v6; // [esp+1Ch] [ebp-4h]

  v3 = *(_DWORD *)this == 0;
  v5[4] = v5;
  if ( v3 )
  {
    AfxLockGlobals(16);
    v3 = *(_DWORD *)this == 0;
    v6 = 0;
    if ( v3 )
      *(_DWORD *)this = a2();
    v6 = -1;
    AfxUnlockGlobals(16);
  }
  return *(struct CNoTrackObject **)this;
}


/* ==== 420418  ??1CProcessLocalObject@@QAE@XZ  (CProcessLocalObject::~CProcessLocalObject(void))  size=37 ==== */
void __thiscall CProcessLocalObject::~CProcessLocalObject(CProcessLocalObject *this)
{
  if ( *(_DWORD *)this )
    (***(void (__thiscall ****)(_DWORD, int))this)(*(_DWORD *)this, 1);
}


/* ==== 42043D  unknown_libname_54  ()  size=19 ==== */
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_54(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  *(_DWORD *)(a2 + this[1]) = *this;
  *this = a2;
  return result;
}


/* ==== 420450  ?Remove@CSimpleList@@QAEHPAX@Z  (CSimpleList::Remove(void *))  size=62 ==== */
int __thiscall CSimpleList::Remove(CSimpleList *this, char *a2)
{
  char *v2; // edx
  int result; // eax
  int v4; // ecx
  char *v5; // edi

  v2 = *(char **)this;
  result = 0;
  if ( *(_DWORD *)this )
  {
    if ( v2 == a2 )
    {
      *(_DWORD *)this = *(_DWORD *)&a2[*((_DWORD *)this + 1)];
      return 1;
    }
    v4 = *((_DWORD *)this + 1);
    do
    {
      v5 = *(char **)&v2[v4];
      if ( v5 == a2 )
        break;
      v2 = *(char **)&v2[v4];
    }
    while ( v5 );
    if ( v2 )
    {
      *(_DWORD *)&v2[v4] = *(_DWORD *)&a2[v4];
      return 1;
    }
  }
  return result;
}


/* ==== 42048E  sub_42048E  ()  size=9 ==== */
_DWORD *__thiscall sub_42048E(_DWORD *this)
{
  _DWORD *result; // eax

  result = this;
  *this = &CThreadData::`vftable';
  return result;
}


/* ==== 420497  ??0CThreadSlotData@@QAE@XZ  (CThreadSlotData::CThreadSlotData(void))  size=66 ==== */
CThreadSlotData *__thiscall CThreadSlotData::CThreadSlotData(CThreadSlotData *this)
{
  DWORD v2; // eax

  *((_DWORD *)this + 5) = 0;
  *((_DWORD *)this + 6) = 0;
  *((_DWORD *)this + 6) = 4;
  *((_DWORD *)this + 1) = 0;
  *((_DWORD *)this + 2) = 1;
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 4) = 0;
  v2 = TlsAlloc();
  *(_DWORD *)this = v2;
  if ( v2 == -1 )
    unknown_libname_11();
  InitializeCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  return this;
}


/* ==== 4204D9  ?FreeSlot@CThreadSlotData@@QAEXH@Z  (CThreadSlotData::FreeSlot(int))  size=99 ==== */
void __thiscall CThreadSlotData::FreeSlot(CThreadSlotData *this, int a2)
{
  _DWORD *i; // esi
  void (__thiscall ***v4)(_DWORD, int); // ecx
  struct _RTL_CRITICAL_SECTION *lpCriticalSection; // [esp+8h] [ebp-4h]

  lpCriticalSection = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  if ( a2 > 0 && a2 < *((_DWORD *)this + 3) )
  {
    for ( i = (_DWORD *)*((_DWORD *)this + 5); i; i = (_DWORD *)i[1] )
    {
      if ( a2 < i[2] )
      {
        v4 = *(void (__thiscall ****)(_DWORD, int))(i[3] + 4 * a2);
        if ( v4 )
          (**v4)(v4, 1);
        *(_DWORD *)(i[3] + 4 * a2) = 0;
      }
    }
    *(_DWORD *)(*((_DWORD *)this + 4) + 8 * a2) &= ~1u;
    LeaveCriticalSection(lpCriticalSection);
  }
}


/* ==== 42053C  ?SetValue@CThreadSlotData@@QAEXHPAX@Z  (CThreadSlotData::SetValue(int,void *))  size=263 ==== */
void __thiscall CThreadSlotData::SetValue(CThreadSlotData *this, int a2, void *a3)
{
  struct _RTL_CRITICAL_SECTION *v4; // esi
  _DWORD *Value; // eax
  _DWORD *v6; // esi
  int v7; // ecx
  _DWORD *v8; // eax
  void *v9; // eax
  char *v10; // eax
  int v11; // ecx
  int v12; // eax
  struct _RTL_CRITICAL_SECTION *lpCriticalSection; // [esp+Ch] [ebp-4h]

  v4 = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  lpCriticalSection = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  if ( a2 <= 0 || a2 >= *((_DWORD *)this + 3) )
  {
    LeaveCriticalSection(v4);
    return;
  }
  Value = TlsGetValue(*(_DWORD *)this);
  v6 = Value;
  if ( !Value )
  {
    v8 = unknown_libname_53(0x10u);
    if ( v8 )
      v6 = sub_42048E(v8);
    else
      v6 = 0;
    v6[2] = 0;
    v6[3] = 0;
    *(_DWORD *)((char *)v6 + *((_DWORD *)this + 6)) = *((_DWORD *)this + 5);
    *((_DWORD *)this + 5) = v6;
    goto LABEL_11;
  }
  v7 = a2;
  if ( a2 >= Value[2] && a3 )
  {
LABEL_11:
    v9 = (void *)v6[3];
    if ( v9 )
      v10 = (char *)LocalReAlloc(v9, 4 * *((_DWORD *)this + 3), 2u);
    else
      v10 = (char *)LocalAlloc(0, 4 * *((_DWORD *)this + 3));
    if ( !v10 )
    {
      LeaveCriticalSection(lpCriticalSection);
      unknown_libname_11();
    }
    v11 = v6[2];
    v6[3] = v10;
    memset(&v10[4 * v11], 0, 4 * (*((_DWORD *)this + 3) - v11));
    v6[2] = *((_DWORD *)this + 3);
    TlsSetValue(*(_DWORD *)this, v6);
    v7 = a2;
  }
  v12 = v6[3];
  if ( v12 )
  {
    if ( v7 < v6[2] )
      *(_DWORD *)(v12 + 4 * v7) = a3;
  }
  LeaveCriticalSection(lpCriticalSection);
}


/* ==== 420643  sub_420643  ()  size=27 ==== */
void *__thiscall sub_420643(void *this, char a2)
{
  nullsub_2();
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 42065E  nullsub_2  ()  size=1 ==== */
void nullsub_2()
{
  ;
}


/* ==== 42065F  ?DeleteValues@CThreadSlotData@@QAEXPAUCThreadData@@PAUHINSTANCE__@@@Z  (CThreadSlotData::DeleteValues(CThreadData *,HINSTANCE__ *))  size=149 ==== */
void __thiscall CThreadSlotData::DeleteValues(CThreadSlotData *this, struct CThreadData *a2, HINSTANCE a3)
{
  int v3; // ebx
  void (__thiscall ***v5)(_DWORD, int); // ecx
  int v6; // [esp+Ch] [ebp-4h]

  v3 = 1;
  v6 = 1;
  if ( *((int *)a2 + 2) <= 1 )
    goto LABEL_11;
  do
  {
    if ( !a3 || *(HINSTANCE *)(*((_DWORD *)this + 4) + 8 * v3 + 4) == a3 )
    {
      v5 = *(void (__thiscall ****)(_DWORD, int))(*((_DWORD *)a2 + 3) + 4 * v3);
      if ( v5 )
        (**v5)(v5, 1);
      *(_DWORD *)(*((_DWORD *)a2 + 3) + 4 * v3) = 0;
    }
    else if ( *(_DWORD *)(*((_DWORD *)a2 + 3) + 4 * v3) )
    {
      v6 = 0;
    }
    ++v3;
  }
  while ( v3 < *((_DWORD *)a2 + 2) );
  if ( v6 )
  {
LABEL_11:
    EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
    CSimpleList::Remove((CThreadSlotData *)((char *)this + 20), (char *)a2);
    LeaveCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
    LocalFree(*((HLOCAL *)a2 + 3));
    (**(void (__thiscall ***)(struct CThreadData *, int))a2)(a2, 1);
    TlsSetValue(*(_DWORD *)this, 0);
  }
}


/* ==== 4206F4  ?DeleteValues@CThreadSlotData@@QAEXPAUHINSTANCE__@@H@Z  (CThreadSlotData::DeleteValues(HINSTANCE__ *,int))  size=89 ==== */
void __thiscall CThreadSlotData::DeleteValues(CThreadSlotData *this, HINSTANCE a2, int a3)
{
  struct _RTL_CRITICAL_SECTION *v4; // ebx
  struct CThreadData *Value; // eax
  int v6; // eax
  int v7; // edi

  v4 = (struct _RTL_CRITICAL_SECTION *)((char *)this + 28);
  EnterCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
  if ( a3 )
  {
    v6 = *((_DWORD *)this + 5);
    if ( v6 )
    {
      do
      {
        v7 = *(_DWORD *)(v6 + 4);
        CThreadSlotData::DeleteValues(this, (struct CThreadData *)v6, a2);
        v6 = v7;
      }
      while ( v7 );
    }
  }
  else
  {
    Value = (struct CThreadData *)TlsGetValue(*(_DWORD *)this);
    if ( Value )
      CThreadSlotData::DeleteValues(this, Value, a2);
  }
  LeaveCriticalSection(v4);
}


/* ==== 42074D  ?GetData@CThreadLocalObject@@QAEPAVCNoTrackObject@@P6GPAV2@XZ@Z  (CThreadLocalObject::GetData(CNoTrackObject * (*)(void)))  size=122 ==== */
struct CNoTrackObject *__thiscall CThreadLocalObject::GetData(
        CThreadLocalObject *this,
        struct CNoTrackObject *(__stdcall *a2)())
{
  CThreadSlotData *v3; // ecx
  struct CNoTrackObject *ThreadValue; // edi

  if ( !*(_DWORD *)this )
  {
    v3 = dword_42FE5C;
    if ( !dword_42FE5C )
    {
      v3 = CThreadSlotData::CThreadSlotData((CThreadSlotData *)&unk_42FE60);
      dword_42FE5C = v3;
    }
    *(_DWORD *)this = CThreadSlotData::AllocSlot(v3);
  }
  ThreadValue = (struct CNoTrackObject *)CThreadSlotData::GetThreadValue(dword_42FE5C, *(_DWORD *)this);
  if ( !ThreadValue )
  {
    ThreadValue = a2();
    CThreadSlotData::SetValue(dword_42FE5C, *(_DWORD *)this, ThreadValue);
  }
  return ThreadValue;
}


/* ==== 4207C7  ??1CThreadLocalObject@@QAE@XZ  (CThreadLocalObject::~CThreadLocalObject(void))  size=30 ==== */
void __thiscall CThreadLocalObject::~CThreadLocalObject(CThreadLocalObject *this)
{
  if ( *(_DWORD *)this && dword_42FE5C )
    CThreadSlotData::FreeSlot(dword_42FE5C, *(_DWORD *)this);
  *(_DWORD *)this = 0;
}


/* ==== 4207E5  ?AfxTermLocalData@@YGXPAUHINSTANCE__@@H@Z  (AfxTermLocalData(HINSTANCE__ *,int))  size=18 ==== */
void __stdcall AfxTermLocalData(HINSTANCE a1, int a2)
{
  if ( dword_42FE5C )
    CThreadSlotData::DeleteValues(dword_42FE5C, a1, a2);
}


/* ==== 4207F7  ??1CThreadSlotData@@QAE@XZ  (CThreadSlotData::~CThreadSlotData(void))  size=87 ==== */
void __thiscall CThreadSlotData::~CThreadSlotData(CThreadSlotData *this)
{
  int v2; // eax
  int v3; // edi
  HGLOBAL v4; // edi

  v2 = *((_DWORD *)this + 5);
  if ( v2 )
  {
    do
    {
      v3 = *(_DWORD *)(v2 + 4);
      CThreadSlotData::DeleteValues(this, (struct CThreadData *)v2, 0);
      v2 = v3;
    }
    while ( v3 );
  }
  if ( *(_DWORD *)this != -1 )
    TlsFree(*(_DWORD *)this);
  if ( *((_DWORD *)this + 4) )
  {
    v4 = GlobalHandle(*((LPCVOID *)this + 4));
    GlobalUnlock(v4);
    GlobalFree(v4);
  }
  DeleteCriticalSection((LPCRITICAL_SECTION)((char *)this + 28));
}


/* ==== 42084E  ?AfxTlsRelease@@YGXXZ  (AfxTlsRelease(void))  size=40 ==== */
void __stdcall AfxTlsRelease()
{
  if ( !dword_42FE58 || (--dword_42FE58, !dword_42FE58) )
  {
    if ( dword_42FE5C )
    {
      CThreadSlotData::~CThreadSlotData(dword_42FE5C);
      dword_42FE5C = 0;
    }
  }
}


/* ==== 420876  sub_420876  ()  size=6 ==== */
char **sub_420876()
{
  return &off_426DF4;
}


/* ==== 42087C  ?AfxCriticalInit@@YGHXZ  (AfxCriticalInit(void))  size=36 ==== */
int __stdcall AfxCriticalInit()
{
  if ( !dword_430090 )
  {
    dword_430090 = 1;
    InitializeCriticalSection(&CriticalSection);
  }
  return dword_430090;
}


/* ==== 4208A0  ?AfxCriticalTerm@@YGXXZ  (AfxCriticalTerm(void))  size=69 ==== */
void __stdcall AfxCriticalTerm()
{
  _DWORD *v0; // esi
  struct _RTL_CRITICAL_SECTION *v1; // ebx

  if ( dword_430090 )
  {
    --dword_430090;
    DeleteCriticalSection(&CriticalSection);
    v0 = &unk_42FE98;
    v1 = &stru_42FEF8;
    do
    {
      if ( *v0 )
      {
        DeleteCriticalSection(v1);
        --*v0;
      }
      ++v1;
      ++v0;
    }
    while ( (int)v1 < (int)&dword_430090 );
  }
}


/* ==== 4208E5  ?AfxLockGlobals@@YGXH@Z  (AfxLockGlobals(int))  size=99 ==== */
void __stdcall AfxLockGlobals(int a1)
{
  if ( !dword_430090 )
    AfxCriticalInit();
  if ( !dword_42FE98[a1] )
  {
    EnterCriticalSection(&CriticalSection);
    if ( !dword_42FE98[a1] )
    {
      InitializeCriticalSection((LPCRITICAL_SECTION)(24 * a1 + 4390648));
      ++dword_42FE98[a1];
    }
    LeaveCriticalSection(&CriticalSection);
  }
  EnterCriticalSection((LPCRITICAL_SECTION)(24 * a1 + 4390648));
}


/* ==== 420948  ?AfxUnlockGlobals@@YGXH@Z  (AfxUnlockGlobals(int))  size=24 ==== */
void __stdcall AfxUnlockGlobals(int a1)
{
  LeaveCriticalSection((LPCRITICAL_SECTION)(24 * a1 + 4390648));
}


/* ==== 420960  sub_420960  ()  size=6 ==== */
char **sub_420960()
{
  return &off_426E38;
}


/* ==== 420980  sub_420980  ()  size=21 ==== */
void __stdcall sub_420980(struct CObject *a1)
{
  if ( a1 )
  {
    *((_DWORD *)a1 + 1) = 0;
    *(_DWORD *)a1 = &CMenu::`vftable';
  }
}


/* ==== 420995  ?_AfxInitDBCS@@YGHXZ  (_AfxInitDBCS(void))  size=55 ==== */
BOOL __stdcall _AfxInitDBCS()
{
  UINT OEMCP; // eax
  struct _cpinfo CPInfo; // [esp+0h] [ebp-18h] BYREF

  OEMCP = GetOEMCP();
  GetCPInfo(OEMCP, &CPInfo);
  return CPInfo.MaxCharSize > 1;
}


/* ==== 4209D7  ?AfxGetFileName@@YGIPBDPADI@Z  (AfxGetFileName(char const *,char *,uint))  size=47 ==== */
int __stdcall AfxGetFileName(LPCSTR pszPath, LPSTR lpString1, unsigned int iMaxLength)
{
  const CHAR *FileNameA; // eax

  FileNameA = PathFindFileNameA(pszPath);
  if ( !lpString1 )
    return lstrlenA(FileNameA) + 1;
  lstrcpynA(lpString1, FileNameA, iMaxLength);
  return 0;
}


/* ==== 420A06  sub_420A06  ()  size=338 ==== */
char *__thiscall sub_420A06(int this)
{
  struct AFX_MODULE_STATE *ModuleState; // ebx
  DWORD ModuleFileNameA; // eax
  char *v4; // eax
  char *result; // eax
  CHAR *lpString1; // [esp+Ch] [ebp-80h]
  CHAR MultiByteStr[256]; // [esp+10h] [ebp-7Ch] BYREF
  CHAR Filename[260]; // [esp+110h] [ebp+84h] BYREF
  CHAR String1[260]; // [esp+214h] [ebp+188h] BYREF

  ModuleState = AfxGetModuleState();
  *((_DWORD *)ModuleState + 2) = *(_DWORD *)(this + 64);
  *((_DWORD *)ModuleState + 3) = *(_DWORD *)(this + 64);
  ModuleFileNameA = GetModuleFileNameA(*(HMODULE *)(this + 64), Filename, 0x104u);
  if ( !ModuleFileNameA || ModuleFileNameA == 260 )
    unknown_libname_39();
  lpString1 = PathFindExtensionA(Filename);
  if ( !lpString1 )
    unknown_libname_39();
  *lpString1 = 0;
  if ( AfxGetFileName(Filename, String1, 0x104u) )
    unknown_libname_39();
  if ( !*(_DWORD *)(this + 92) )
    *(_DWORD *)(this + 92) = _strdup(String1);
  if ( !*(_DWORD *)(this + 76) )
  {
    if ( AfxLoadString(0xE000u, MultiByteStr, 0x100u) )
      v4 = _strdup(MultiByteStr);
    else
      v4 = _strdup(*(const char **)(this + 92));
    *(_DWORD *)(this + 76) = v4;
  }
  result = *(char **)(this + 76);
  *((_DWORD *)ModuleState + 4) = result;
  if ( !*(_DWORD *)(this + 96) )
  {
    if ( *(_DWORD *)(this + 104) == 1 )
      lstrcpyA(lpString1, ".CHM");
    else
      lstrcpyA(lpString1, ".HLP");
    *(_DWORD *)(this + 96) = _strdup(Filename);
    result = lpString1;
    *lpString1 = 0;
  }
  if ( !*(_DWORD *)(this + 100) )
  {
    lstrcatA(String1, ".INI");
    result = _strdup(String1);
    *(_DWORD *)(this + 100) = result;
  }
  return result;
}


/* ==== 420B58  ?AfxWinInit@@YGHPAUHINSTANCE__@@0PADH@Z  (AfxWinInit(HINSTANCE__ *,HINSTANCE__ *,char *,int))  size=125 ==== */
int __stdcall AfxWinInit(HINSTANCE a1, HINSTANCE a2, char *a3, int a4)
{
  UINT v4; // eax
  struct AFX_MODULE_STATE *ModuleState; // eax
  _DWORD *v6; // eax
  HMODULE ModuleHandleA; // eax

  v4 = SetErrorMode(0);
  SetErrorMode(v4 | 0x8001);
  ModuleState = AfxGetModuleState();
  *((_DWORD *)ModuleState + 2) = a1;
  *((_DWORD *)ModuleState + 3) = a1;
  v6 = (_DWORD *)*((_DWORD *)AfxGetModuleState() + 1);
  if ( v6 )
  {
    v6[17] = a3;
    v6[18] = a4;
    v6[16] = a1;
    sub_420A06((int)v6);
  }
  if ( !*((_BYTE *)AfxGetModuleState() + 20) )
    AfxInitThread();
  ModuleHandleA = GetModuleHandleA("user32.dll");
  if ( ModuleHandleA )
    NotifyWinEvent = (void (__stdcall *)(DWORD, HWND, LONG, LONG))GetProcAddress(ModuleHandleA, "NotifyWinEvent");
  return 1;
}


/* ==== 420BD5  sub_420BD5  ()  size=6 ==== */
char **sub_420BD5()
{
  return &off_426EB8;
}


/* ==== 420BDB  ?GetAppRegistryKey@CWinApp@@QAEPAUHKEY__@@XZ  (CWinApp::GetAppRegistryKey(void))  size=145 ==== */
HKEY __thiscall CWinApp::GetAppRegistryKey(LPCSTR *this)
{
  DWORD dwDisposition; // [esp+10h] [ebp-10h] BYREF
  HKEY v5; // [esp+14h] [ebp-Ch] BYREF
  HKEY hKey; // [esp+18h] [ebp-8h] BYREF
  HKEY phkResult; // [esp+1Ch] [ebp-4h] BYREF

  v5 = 0;
  phkResult = 0;
  hKey = 0;
  if ( !RegOpenKeyExA(HKEY_CURRENT_USER, "software", 0, 0x2001Fu, &phkResult)
    && !RegCreateKeyExA(phkResult, this[20], 0, 0, 0, 0x2001Fu, 0, &hKey, &dwDisposition) )
  {
    RegCreateKeyExA(hKey, this[25], 0, 0, 0, 0x2001Fu, 0, &v5, &dwDisposition);
  }
  if ( phkResult )
    RegCloseKey(phkResult);
  if ( hKey )
    RegCloseKey(hKey);
  return v5;
}


/* ==== 420C6C  ?GetSectionKey@CWinApp@@QAEPAUHKEY__@@PBD@Z  (CWinApp::GetSectionKey(char const *))  size=70 ==== */
HKEY __thiscall CWinApp::GetSectionKey(LPCSTR *this, const char *lpSubKey)
{
  HKEY AppRegistryKey; // edi
  DWORD dwDisposition; // [esp+8h] [ebp-8h] BYREF
  HKEY phkResult; // [esp+Ch] [ebp-4h] BYREF

  phkResult = 0;
  AppRegistryKey = CWinApp::GetAppRegistryKey(this);
  if ( !AppRegistryKey )
    return 0;
  RegCreateKeyExA(AppRegistryKey, lpSubKey, 0, 0, 0, 0x2001Fu, 0, &phkResult, &dwDisposition);
  RegCloseKey(AppRegistryKey);
  return phkResult;
}


/* ==== 420CB2  sub_420CB2  ()  size=6 ==== */
char **sub_420CB2()
{
  return &off_42CA70;
}


/* ==== 420CD9  ?GetErrorMessage@COleException@@UAEHPADIPAI@Z  (COleException::GetErrorMessage(char *,uint,uint *))  size=86 ==== */
int __thiscall COleException::GetErrorMessage(
        COleException *this,
        LPSTR lpString1,
        unsigned int iMaxLength,
        CHAR *Buffer)
{
  if ( Buffer )
    *(_DWORD *)Buffer = 0;
  if ( FormatMessageA(0x1100u, 0, *((_DWORD *)this + 2), 0x800u, (LPSTR)&Buffer, 0, 0) )
  {
    lstrcpynA(lpString1, Buffer, iMaxLength);
    LocalFree(Buffer);
    return 1;
  }
  else
  {
    *lpString1 = 0;
    return 0;
  }
}


/* ==== 420D2F  ?AfxThrowOleException@@YGXJ@Z  (AfxThrowOleException(long))  size=66 ==== */
void __stdcall __noreturn AfxThrowOleException(COleException *pExceptionObject)
{
  COleException *v1; // ecx
  COleException *v2; // eax

  v1 = (COleException *)operator new(0xCu);
  v2 = 0;
  if ( v1 )
    v2 = COleException::COleException(v1);
  *((_DWORD *)v2 + 2) = pExceptionObject;
  pExceptionObject = v2;
  _CxxThrowException(&pExceptionObject, (_ThrowInfo *)&_TI4PAVCOleException__);
}


/* ==== 420D71  ?InternalRelease@CCmdTarget@@QAEKXZ  (CCmdTarget::InternalRelease(void))  size=41 ==== */
LONG __thiscall CCmdTarget::InternalRelease(CCmdTarget *this)
{
  LONG v3; // edi

  if ( !*((_DWORD *)this + 1) )
    return 0;
  v3 = InterlockedDecrement((volatile LONG *)this + 1);
  if ( !v3 )
    (*(void (__thiscall **)(CCmdTarget *))(*(_DWORD *)this + 16))(this);
  return v3;
}


/* ==== 420D9A  ?ExternalRelease@CCmdTarget@@QAEKXZ  (CCmdTarget::ExternalRelease(void))  size=21 ==== */
LONG __thiscall CCmdTarget::ExternalRelease(CCmdTarget *this)
{
  if ( *((_DWORD *)this + 2) )
    return (*(int (__stdcall **)(_DWORD))(**((_DWORD **)this + 2) + 8))(*((_DWORD *)this + 2));
  else
    return CCmdTarget::InternalRelease(this);
}


/* ==== 420DAF  ?GetInterface@CCmdTarget@@QAEPAUIUnknown@@PBX@Z  (CCmdTarget::GetInterface(void const *))  size=174 ==== */
struct IUnknown *__thiscall CCmdTarget::GetInterface(CCmdTarget *this, _DWORD *a2)
{
  struct IUnknown *result; // eax
  _DWORD *v4; // edi
  _DWORD *j; // ecx
  int i; // edx
  _DWORD *v7; // ecx

  result = (struct IUnknown *)(*(int (__thiscall **)(CCmdTarget *, _DWORD *))(*(_DWORD *)this + 68))(this, a2);
  if ( !result )
  {
    v4 = (_DWORD *)(*(int (__thiscall **)(CCmdTarget *))(*(_DWORD *)this + 56))(this);
    if ( *a2 || a2[1] || a2[2] != 192 || a2[3] != 1174405120 )
    {
      do
      {
        for ( i = v4[1]; ; i += 8 )
        {
          v7 = *(_DWORD **)i;
          if ( !*(_DWORD *)i )
            break;
          if ( *v7 == *a2 && v7[1] == a2[1] && v7[2] == a2[2] && v7[3] == a2[3] )
          {
            result = (struct IUnknown *)((char *)this + *(_DWORD *)(i + 4));
            if ( result->lpVtbl )
              return result;
          }
        }
        v4 = (_DWORD *)*v4;
      }
      while ( v4 );
    }
    else
    {
      do
      {
        for ( j = (_DWORD *)v4[1]; *j; j += 2 )
        {
          result = (struct IUnknown *)((char *)this + j[1]);
          if ( result->lpVtbl )
            return result;
        }
        v4 = (_DWORD *)*v4;
      }
      while ( v4 );
    }
    return 0;
  }
  return result;
}


/* ==== 420E5D  ?QueryAggregates@CCmdTarget@@QAEPAUIUnknown@@PBX@Z  (CCmdTarget::QueryAggregates(void const *))  size=96 ==== */
struct IUnknown *__thiscall CCmdTarget::QueryAggregates(CCmdTarget *this, const void *a2)
{
  _DWORD *v2; // edi
  _DWORD *i; // eax
  _DWORD *j; // esi
  int (__stdcall ***v5)(_DWORD, const void *, struct IUnknown **); // eax
  int (__stdcall **v6)(_DWORD, const void *, struct IUnknown **); // ecx
  struct IUnknown *result; // eax
  struct IUnknown *v9; // [esp+Ch] [ebp-4h] BYREF

  v2 = (_DWORD *)(*(int (__fastcall **)(CCmdTarget *))(*(_DWORD *)this + 56))(this);
  do
  {
    for ( i = (_DWORD *)v2[1]; *i; i += 2 )
      ;
    for ( j = i + 1; *j != -1; j += 2 )
    {
      v5 = *(int (__stdcall ****)(_DWORD, const void *, struct IUnknown **))((char *)this + *j);
      if ( v5 )
      {
        v6 = *v5;
        v9 = 0;
        if ( !(*v6)(v5, a2, &v9) )
        {
          result = v9;
          if ( v9 )
            return result;
        }
      }
    }
    v2 = (_DWORD *)*v2;
  }
  while ( v2 );
  return 0;
}


/* ==== 420EBD  ?ExternalAddRef@CCmdTarget@@QAEKXZ  (CCmdTarget::ExternalAddRef(void))  size=27 ==== */
LONG __thiscall CCmdTarget::ExternalAddRef(CCmdTarget *this)
{
  if ( *((_DWORD *)this + 2) )
    return (*(int (__stdcall **)(_DWORD))(**((_DWORD **)this + 2) + 4))(*((_DWORD *)this + 2));
  else
    return InterlockedIncrement((volatile LONG *)this + 1);
}


/* ==== 420F18  ?ExternalQueryInterface@CCmdTarget@@QAEKPBXPAPAX@Z  (CCmdTarget::ExternalQueryInterface(void const *,void * *))  size=30 ==== */
int __thiscall CCmdTarget::ExternalQueryInterface(CCmdTarget *this, _DWORD *a2, void **a3)
{
  struct IUnknown *Interface; // eax
  struct IUnknown *Aggregates; // eax

  if ( *((_DWORD *)this + 2) )
    return (***((int (__stdcall ****)(_DWORD, _DWORD *, void **))this + 2))(*((_DWORD *)this + 2), a2, a3);
  Interface = CCmdTarget::GetInterface(this, a2);
  *a3 = Interface;
  if ( Interface )
  {
    CCmdTarget::ExternalAddRef(this);
    return 0;
  }
  else
  {
    Aggregates = CCmdTarget::QueryAggregates(this, a2);
    *a3 = Aggregates;
    return Aggregates != 0 ? 0 : -2147467262;
  }
}


/* ==== 420F36  ?AfxPostQuitMessage@@YGXH@Z  (AfxPostQuitMessage(int))  size=28 ==== */
void __stdcall AfxPostQuitMessage(int a1)
{
  struct CWinThread *Thread; // eax
  void (__stdcall *v2)(int, int); // eax

  Thread = AfxGetThread();
  if ( Thread )
  {
    v2 = (void (__stdcall *)(int, int))*((_DWORD *)Thread + 14);
    if ( v2 )
      v2(1, 1);
  }
  PostQuitMessage(a1);
}


/* ==== 420F52  ??1CWinThread@@UAE@XZ  (CWinThread::~CWinThread(void))  size=79 ==== */
void __thiscall CWinThread::~CWinThread(CWinThread *this)
{
  void *v2; // eax
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // eax

  *(_DWORD *)this = &CWinThread::`vftable';
  v2 = (void *)*((_DWORD *)this + 10);
  if ( v2 )
    CloseHandle(v2);
  ModuleThreadState = AfxGetModuleThreadState();
  if ( *((CWinThread **)ModuleThreadState + 1) == this )
    *((_DWORD *)ModuleThreadState + 1) = 0;
  CCmdTarget::~CCmdTarget(this);
}


/* ==== 420FA1  ?AfxWinTerm@@YGXXZ  (AfxWinTerm(void))  size=180 ==== */
void __stdcall AfxWinTerm()
{
  struct AFX_MODULE_STATE *ModuleState; // ebp
  const unsigned __int8 *v1; // ebp
  const unsigned __int8 *i; // esi
  unsigned __int8 *v3; // edi
  struct AFX_MODULE_STATE *v4; // eax
  int v5; // eax
  void (__stdcall *v6)(int, _DWORD); // eax
  struct AFX_MODULE_THREAD_STATE *ModuleThreadState; // esi
  int v8; // ecx
  struct _AFX_THREAD_STATE *ThreadState; // esi

  ModuleState = AfxGetModuleState();
  AfxLockGlobals(1);
  v1 = (const unsigned __int8 *)ModuleState + 52;
  for ( i = v1; *i; i = v3 + 1 )
  {
    v3 = _mbschr(i, 0xAu);
    *v3 = 0;
    v4 = AfxGetModuleState();
    UnregisterClassA((LPCSTR)i, *((HINSTANCE *)v4 + 2));
  }
  *v1 = 0;
  AfxUnlockGlobals(1);
  v5 = *((_DWORD *)AfxGetModuleState() + 1);
  if ( v5 )
  {
    v6 = *(void (__stdcall **)(int, _DWORD))(v5 + 56);
    if ( v6 )
      v6(1, 0);
  }
  ModuleThreadState = AfxGetModuleThreadState();
  v8 = *((_DWORD *)ModuleThreadState + 15);
  if ( v8 && (*(int (__thiscall **)(int))(*(_DWORD *)v8 + 312))(v8) )
    *((_DWORD *)ModuleThreadState + 15) = 0;
  ThreadState = AfxGetThreadState();
  if ( !*((_BYTE *)AfxGetModuleState() + 20) )
  {
    if ( *((_DWORD *)ThreadState + 11) )
    {
      UnhookWindowsHookEx(*((HHOOK *)ThreadState + 11));
      *((_DWORD *)ThreadState + 11) = 0;
    }
    if ( *((_DWORD *)ThreadState + 10) )
    {
      UnhookWindowsHookEx(*((HHOOK *)ThreadState + 10));
      *((_DWORD *)ThreadState + 10) = 0;
    }
  }
}


/* ==== 421750  sub_421750  ()  size=96 ==== */
void *sub_421750()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401640(v0);
    dword_42D9A0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9A0 = 0;
  }
  return result;
}


/* ==== 4217B0  sub_4217B0  ()  size=96 ==== */
void *sub_4217B0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_4016A0(v0);
    dword_42D9A4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9A4 = 0;
  }
  return result;
}


/* ==== 421810  sub_421810  ()  size=96 ==== */
void *sub_421810()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401700(v0);
    dword_42D9A8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9A8 = 0;
  }
  return result;
}


/* ==== 421870  sub_421870  ()  size=96 ==== */
void *sub_421870()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401760(v0);
    dword_42D9AC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9AC = 0;
  }
  return result;
}


/* ==== 4218D0  sub_4218D0  ()  size=96 ==== */
void *sub_4218D0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_4017F0(v0);
    dword_42D9B0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9B0 = 0;
  }
  return result;
}


/* ==== 421930  sub_421930  ()  size=96 ==== */
void *sub_421930()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401850(v0);
    dword_42D9B4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9B4 = 0;
  }
  return result;
}


/* ==== 421990  sub_421990  ()  size=96 ==== */
void *sub_421990()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_4018B0(v0);
    dword_42D9B8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9B8 = 0;
  }
  return result;
}


/* ==== 4219F0  sub_4219F0  ()  size=96 ==== */
void *sub_4219F0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401910(v0);
    dword_42D9BC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9BC = 0;
  }
  return result;
}


/* ==== 421A50  sub_421A50  ()  size=96 ==== */
void *sub_421A50()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401970(v0);
    dword_42D9C0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9C0 = 0;
  }
  return result;
}


/* ==== 421AB0  sub_421AB0  ()  size=96 ==== */
void *sub_421AB0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_4019D0(v0);
    dword_42D9C4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9C4 = 0;
  }
  return result;
}


/* ==== 421B10  sub_421B10  ()  size=96 ==== */
void *sub_421B10()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401A30(v0);
    dword_42D9C8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9C8 = 0;
  }
  return result;
}


/* ==== 421B70  sub_421B70  ()  size=96 ==== */
void *sub_421B70()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401AB0(v0);
    dword_42D9CC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9CC = 0;
  }
  return result;
}


/* ==== 421BD0  sub_421BD0  ()  size=96 ==== */
void *sub_421BD0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401B10(v0);
    dword_42D9D0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9D0 = 0;
  }
  return result;
}


/* ==== 421C30  sub_421C30  ()  size=96 ==== */
void *sub_421C30()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401B70(v0);
    dword_42D9D4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9D4 = 0;
  }
  return result;
}


/* ==== 421C90  sub_421C90  ()  size=96 ==== */
void *sub_421C90()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401BD0(v0);
    dword_42D9D8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9D8 = 0;
  }
  return result;
}


/* ==== 421CF0  sub_421CF0  ()  size=96 ==== */
void *sub_421CF0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401C30(v0);
    dword_42D9DC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9DC = 0;
  }
  return result;
}


/* ==== 421D50  sub_421D50  ()  size=96 ==== */
void *sub_421D50()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401C90(v0);
    dword_42D9E0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9E0 = 0;
  }
  return result;
}


/* ==== 421DB0  sub_421DB0  ()  size=96 ==== */
void *sub_421DB0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401CF0(v0);
    dword_42D9E4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9E4 = 0;
  }
  return result;
}


/* ==== 421E10  sub_421E10  ()  size=96 ==== */
void *sub_421E10()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401D50(v0);
    dword_42D9E8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9E8 = 0;
  }
  return result;
}


/* ==== 421E70  sub_421E70  ()  size=96 ==== */
void *sub_421E70()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401DB0(v0);
    dword_42D9EC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9EC = 0;
  }
  return result;
}


/* ==== 421ED0  sub_421ED0  ()  size=96 ==== */
void *sub_421ED0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401E10(v0);
    dword_42D9F0 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9F0 = 0;
  }
  return result;
}


/* ==== 421F30  sub_421F30  ()  size=96 ==== */
void *sub_421F30()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401E70(v0);
    dword_42D9F4 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9F4 = 0;
  }
  return result;
}


/* ==== 421F90  sub_421F90  ()  size=96 ==== */
void *sub_421F90()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x14u);
  if ( v0 )
  {
    result = sub_401ED0(v0);
    dword_42D9F8 = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9F8 = 0;
  }
  return result;
}


/* ==== 421FF0  sub_421FF0  ()  size=96 ==== */
void *sub_421FF0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x14u);
  if ( v0 )
  {
    result = sub_401F30(v0);
    dword_42D9FC = (int)result;
  }
  else
  {
    result = 0;
    dword_42D9FC = 0;
  }
  return result;
}


/* ==== 422050  sub_422050  ()  size=96 ==== */
void *sub_422050()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401F90(v0);
    dword_42DA00 = (int)result;
  }
  else
  {
    result = 0;
    dword_42DA00 = 0;
  }
  return result;
}


/* ==== 4220B0  sub_4220B0  ()  size=96 ==== */
void *sub_4220B0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_401FF0(v0);
    dword_42DA04 = (int)result;
  }
  else
  {
    result = 0;
    dword_42DA04 = 0;
  }
  return result;
}


/* ==== 422110  sub_422110  ()  size=96 ==== */
void *sub_422110()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_402050(v0);
    dword_42DA08 = (int)result;
  }
  else
  {
    result = 0;
    dword_42DA08 = 0;
  }
  return result;
}


/* ==== 422170  sub_422170  ()  size=96 ==== */
void *sub_422170()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_4020B0(v0);
    dword_42DA0C = (int)result;
  }
  else
  {
    result = 0;
    dword_42DA0C = 0;
  }
  return result;
}


/* ==== 4221D0  sub_4221D0  ()  size=96 ==== */
void *sub_4221D0()
{
  void *v0; // eax
  void *result; // eax

  v0 = operator new(0x10u);
  if ( v0 )
  {
    result = sub_402110(v0);
    dword_42DA10 = (int)result;
  }
  else
  {
    result = 0;
    dword_42DA10 = 0;
  }
  return result;
}


/* ==== 422280  sub_422280  ()  size=10 ==== */
void sub_422280()
{
  sub_4067F0((CWinApp *)&unk_42DA38);
}


/* ==== 42228A  sub_42228A  ()  size=10 ==== */
void sub_42228A()
{
  DeleteCriticalSection(&stru_4305BC);
  if ( unk_4305D4 )
  {
    free(unk_4305D4);
    unk_4305D4 = 0;
  }
  unk_4305D8 = 0;
  unk_4305DC = 0;
}

