/* ==== 10001000  sub_10001000  ()  size=121 ==== */
int __thiscall sub_10001000(_DWORD *this)
{
  HANDLE EventA; // esi
  char OutBuffer; // [esp+7h] [ebp-15h] BYREF
  struct _OVERLAPPED Overlapped; // [esp+8h] [ebp-14h] BYREF

  sub_10001B10();
  if ( this[1] != -1 )
  {
    OutBuffer = 0;
    EventA = CreateEventA(0, 0, 0, 0);
    Overlapped.8 = 0;
    Overlapped.hEvent = EventA;
    sub_10002BF0(0x40u, 0, 1, 0, &OutBuffer, 1, &Overlapped);
    CloseHandle(EventA);
    if ( OutBuffer )
      Sleep(0x96u);
  }
  return this[1];
}


/* ==== 10001080  sub_10001080  ()  size=88 ==== */
char __stdcall sub_10001080(int a1, LPOVERLAPPED lpOverlapped)
{
  bool v2; // bl
  char result; // al

  v2 = (unsigned __int8)sub_10002BF0(0x40u, 13, *(unsigned __int8 *)(a1 + 12), 1, 0, 0, lpOverlapped) != 0;
  result = sub_10002BF0(0x40u, 13, *(unsigned __int8 *)(a1 + 13), 0, 0, 0, lpOverlapped);
  if ( result )
    return v2;
  return result;
}


/* ==== 100010E0  sub_100010E0  ()  size=446 ==== */
char __thiscall sub_100010E0(int *this, int a2, int a3, int a4, void *a5, int *a6, int a7)
{
  char result; // al
  unsigned int v9; // ecx
  int v10; // ecx
  int v11; // eax
  unsigned int v12; // eax
  int v13; // [esp+18h] [ebp-1008h] BYREF
  unsigned int v14; // [esp+1Ch] [ebp-1004h] BYREF
  _BYTE v15[4096]; // [esp+20h] [ebp-1000h] BYREF

  if ( (unsigned int)*a6 > 0x1000 )
    return 0;
  if ( a4 && a3 )
  {
    if ( (*(int (__thiscall **)(int *, int, int, int, int))(*this + 28))(this, a2, a3, a4, a7) != 1
      || WaitForSingleObject(*(HANDLE *)(a7 + 16), 0x3E8u) )
    {
      (*(void (__thiscall **)(int *))(*this + 36))(this);
      return 0;
    }
    result = (*(int (__thiscall **)(int *, int, int *))(*this + 32))(this, a7, &v13);
    if ( !result )
      return result;
    if ( a4 != v13 )
      return 0;
  }
  if ( !a5 )
    return 1;
  v9 = *(unsigned __int16 *)(a2 + 14);
  if ( (unsigned __int16)v9 % (unsigned int)*a6 )
    v10 = *a6 + v9 - *a6 % v9;
  else
    v10 = *a6;
  v11 = *this;
  v13 = v10;
  if ( (*(int (__thiscall **)(int *, int, _BYTE *, int, int))(v11 + 24))(this, a2, v15, v10, a7) != 1
    || WaitForSingleObject(*(HANDLE *)(a7 + 16), 0x3E8u) )
  {
    (*(void (__thiscall **)(int *))(*this + 36))(this);
    return 0;
  }
  result = (*(int (__thiscall **)(int *, int, unsigned int *))(*this + 32))(this, a7, &v14);
  if ( result )
  {
    v12 = v14;
    qmemcpy(a5, v15, v14);
    *a6 = v12;
    return 1;
  }
  return result;
}


/* ==== 100012A0  sub_100012A0  ()  size=298 ==== */
char __thiscall sub_100012A0(char *this, int a2, char a3)
{
  unsigned int v3; // edx
  char result; // al
  _WORD *v5; // esi
  char *v6; // esi
  char *v7; // ecx
  char *v8; // esi

  v3 = 0;
  result = 0;
  v5 = this + 60;
  while ( *(char *)(a2 + 2) < 0 )
  {
    if ( !*(v5 - 1) )
    {
      v6 = &this[36 * v3];
      v6[56] = a3;
      *((_WORD *)v6 + 29) = *(_WORD *)(a2 + 4);
      *((_DWORD *)v6 + 16) = *(unsigned __int16 *)(a2 + 4);
      v7 = &this[36 * v3 + 72];
      *v7 = *(_BYTE *)(a2 + 2);
      if ( *((_DWORD *)v6 + 13) == 2 )
      {
        *((_DWORD *)v6 + 13) = 3;
        if ( (((unsigned __int8)*v7 ^ (unsigned __int8)v6[73]) & 0x7F) != 0 )
          *((_DWORD *)v6 + 12) = 1;
        else
          *((_DWORD *)v6 + 12) = 2;
        *((_DWORD *)v6 + 19) = v3;
        return 1;
      }
      else
      {
        *((_DWORD *)v6 + 13) = 1;
      }
      return result;
    }
LABEL_6:
    ++v3;
    v5 += 18;
    if ( v3 >= 0x20 )
      return result;
  }
  if ( *v5 )
    goto LABEL_6;
  v8 = &this[36 * v3];
  v8[57] = a3;
  *((_WORD *)v8 + 30) = *(_WORD *)(a2 + 4);
  *((_DWORD *)v8 + 17) = *(unsigned __int16 *)(a2 + 4);
  v8[73] = *(_BYTE *)(a2 + 2);
  if ( *((_DWORD *)v8 + 13) == 1 )
  {
    *((_DWORD *)v8 + 13) = 3;
    if ( (((unsigned __int8)v8[73] ^ (unsigned __int8)this[36 * v3 + 72]) & 0x7F) != 0 )
      *((_DWORD *)v8 + 12) = 1;
    else
      *((_DWORD *)v8 + 12) = 2;
    *((_DWORD *)v8 + 19) = v3;
    return 1;
  }
  else
  {
    *((_DWORD *)v8 + 13) = 2;
  }
  return result;
}


/* ==== 100013D0  sub_100013D0  ()  size=547 ==== */
char __thiscall sub_100013D0(void *this, int a2, int a3, int a4, void *a5, int *a6, LPOVERLAPPED lpOverlapped)
{
  char result; // al
  unsigned int v9; // ecx
  unsigned int v10; // eax
  int v11; // [esp+18h] [ebp-100Ch] BYREF
  _BYTE OutBuffer[4]; // [esp+1Ch] [ebp-1008h] BYREF
  unsigned int v13; // [esp+20h] [ebp-1004h] BYREF
  _BYTE v14[4096]; // [esp+24h] [ebp-1000h] BYREF

  if ( (unsigned int)*a6 > 0x1000 )
    return 0;
  if ( a4 && a3 )
  {
    result = sub_10002BF0(0x40u, 12, *(unsigned __int8 *)(a2 + 13), 0, OutBuffer, 4, lpOverlapped);
    if ( !result )
      return result;
    if ( (*(int (__thiscall **)(void *, int, int, int, LPOVERLAPPED))(*(_DWORD *)this + 28))(
           this,
           a2,
           a3,
           a4,
           lpOverlapped) != 1
      || WaitForSingleObject(lpOverlapped->hEvent, 0x3E8u) )
    {
      (*(void (__thiscall **)(void *))(*(_DWORD *)this + 36))(this);
      return 0;
    }
    result = (*(int (__thiscall **)(void *, LPOVERLAPPED, int *))(*(_DWORD *)this + 32))(this, lpOverlapped, &v11);
    if ( !result )
      return result;
    if ( a4 != v11 )
      return 0;
  }
  if ( !a5 )
    return 1;
  v9 = *(unsigned __int16 *)(a2 + 14);
  if ( (unsigned __int16)v9 % (unsigned int)*a6 )
    v11 = *a6 + v9 - *a6 % v9;
  else
    v11 = *a6;
  result = sub_10002BF0(0x40u, 12, *(unsigned __int8 *)(a2 + 12), 1, OutBuffer, 4, lpOverlapped);
  if ( result )
  {
    if ( (*(int (__thiscall **)(void *, int, _BYTE *, int, LPOVERLAPPED))(*(_DWORD *)this + 24))(
           this,
           a2,
           v14,
           v11,
           lpOverlapped) != 1
      || WaitForSingleObject(lpOverlapped->hEvent, 0x3E8u) )
    {
      (*(void (__thiscall **)(void *))(*(_DWORD *)this + 36))(this);
      return 0;
    }
    result = (*(int (__thiscall **)(void *, LPOVERLAPPED, unsigned int *))(*(_DWORD *)this + 32))(
               this,
               lpOverlapped,
               &v13);
    if ( result )
    {
      v10 = v13;
      qmemcpy(a5, v14, v13);
      *a6 = v10;
      return 1;
    }
  }
  return result;
}


/* ==== 10001600  sub_10001600  ()  size=337 ==== */
char __thiscall sub_10001600(char *this, int a2, unsigned __int8 a3)
{
  unsigned int v4; // esi
  _WORD *v5; // eax
  char result; // al
  char *v7; // edi
  char *v8; // ebp
  char *v9; // edi

  v4 = 0;
  v5 = this + 60;
  while ( *(char *)(a2 + 2) >= 0 )
  {
    if ( !*v5 )
    {
      v9 = &this[36 * v4];
      v9[57] = a3;
      *((_WORD *)v9 + 30) = *(_WORD *)(a2 + 4);
      *((_DWORD *)v9 + 17) = sub_10001760(a3, 0);
      v9[73] = *(_BYTE *)(a2 + 2);
      result = 1;
      if ( *((_DWORD *)v9 + 13) == 1 )
      {
        *((_DWORD *)v9 + 13) = 3;
        if ( (((unsigned __int8)v9[73] ^ (unsigned __int8)this[36 * v4 + 72]) & 0x7F) != 0 )
        {
          *((_DWORD *)v9 + 12) = 1;
          *((_DWORD *)v9 + 19) = v4;
          return 1;
        }
        else
        {
          *((_DWORD *)v9 + 12) = 2;
          *((_DWORD *)v9 + 19) = v4;
        }
      }
      else
      {
        *((_DWORD *)v9 + 13) = 2;
        return 0;
      }
      return result;
    }
LABEL_6:
    ++v4;
    v5 += 18;
    if ( v4 >= 0x20 )
      return 0;
  }
  if ( *(v5 - 1) )
    goto LABEL_6;
  v7 = &this[36 * v4];
  v7[56] = a3;
  *((_WORD *)v7 + 29) = *(_WORD *)(a2 + 4);
  *((_DWORD *)v7 + 16) = sub_10001760(a3, 1);
  v8 = &this[36 * v4 + 72];
  *v8 = *(_BYTE *)(a2 + 2);
  if ( *((_DWORD *)v7 + 13) == 2 )
  {
    *((_DWORD *)v7 + 13) = 3;
    if ( (((unsigned __int8)*v8 ^ (unsigned __int8)v7[73]) & 0x7F) != 0 )
      *((_DWORD *)v7 + 12) = 1;
    else
      *((_DWORD *)v7 + 12) = 2;
    *((_DWORD *)v7 + 19) = v4;
    return 1;
  }
  else
  {
    *((_DWORD *)v7 + 13) = 1;
    return 0;
  }
}


/* ==== 10001760  sub_10001760  ()  size=103 ==== */
int __stdcall sub_10001760(__int16 a1, __int16 a2)
{
  HANDLE EventA; // esi
  int OutBuffer; // [esp+8h] [ebp-18h] BYREF
  struct _OVERLAPPED Overlapped; // [esp+Ch] [ebp-14h] BYREF

  OutBuffer = 0;
  EventA = CreateEventA(0, 0, 0, 0);
  Overlapped.8 = 0;
  Overlapped.hEvent = EventA;
  sub_10002BF0(0x40u, 11, a1, a2, &OutBuffer, 4, &Overlapped);
  CloseHandle(EventA);
  return OutBuffer;
}


/* ==== 100017D0  sub_100017D0  ()  size=316 ==== */
_DWORD *__thiscall sub_100017D0(_DWORD *this)
{
  int v2; // eax

  sub_10005B70();
  CString::CString((CString *)(this + 5));
  CString::CString((CString *)(this + 6));
  CString::CString((CString *)(this + 8));
  CString::CString((CString *)(this + 9));
  `eh vector constructor iterator'(
    this + 302,
    4u,
    32,
    (void (__thiscall *)(void *))CString::CString,
    (void (__thiscall *)(void *))CString::~CString);
  `eh vector constructor iterator'(
    this + 334,
    4u,
    32,
    (void (__thiscall *)(void *))CString::CString,
    (void (__thiscall *)(void *))CString::~CString);
  *this = &off_1001D3C0;
  this[300] = -1;
  this[301] = 0;
  this[299] = 0;
  if ( operator new(0x24u) )
    v2 = sub_10007B70(this);
  else
    v2 = 0;
  this[398] = v2;
  this[4] = 0;
  CString::operator=(this + 5, Str2);
  CString::operator=(this + 6, aNoSerialNumber);
  return this;
}


/* ==== 10001930  sub_10001930  ()  size=119 ==== */
void __thiscall sub_10001930(int this)
{
  int v2; // edi

  v2 = this + 12;
  CString::~CString((CString *)(this + 20));
  CString::~CString((CString *)(v2 + 4));
  CString::~CString((CString *)(this + 8));
  CString::~CString((CString *)(this + 4));
}


/* ==== 100019B0  sub_100019B0  ()  size=100 ==== */
void __thiscall sub_100019B0(int this)
{
  `eh vector destructor iterator'((void *)(this + 140), 4u, 32, (void (__thiscall *)(void *))CString::~CString);
  `eh vector destructor iterator'((void *)(this + 12), 4u, 32, (void (__thiscall *)(void *))CString::~CString);
}


/* ==== 10001A20  sub_10001A20  ()  size=226 ==== */
int __thiscall sub_10001A20(_DWORD *this)
{
  void (__thiscall ***v2)(_DWORD, int); // ecx

  *this = &off_1001D3C0;
  sub_10001CC0();
  v2 = (void (__thiscall ***)(_DWORD, int))this[398];
  if ( v2 )
    (**v2)(v2, 1);
  `eh vector destructor iterator'(this + 334, 4u, 32, (void (__thiscall *)(void *))CString::~CString);
  `eh vector destructor iterator'(this + 302, 4u, 32, (void (__thiscall *)(void *))CString::~CString);
  CString::~CString((CString *)(this + 9));
  CString::~CString((CString *)(this + 8));
  CString::~CString((CString *)(this + 6));
  CString::~CString((CString *)(this + 5));
  return sub_10005BD0(this);
}


/* ==== 10001B10  sub_10001B10  ()  size=421 ==== */
const unsigned __int8 *__thiscall sub_10001B10(const unsigned __int8 **this)
{
  const unsigned __int8 *v2; // edi
  unsigned int v4; // edi
  const unsigned __int8 **v5; // ebp
  const unsigned __int8 *FileA; // eax
  const unsigned __int8 *v7; // esi
  LPCSTR lpFileName; // [esp+8h] [ebp-14h] BYREF
  unsigned __int8 *Str2; // [esp+Ch] [ebp-10h] BYREF
  int v10; // [esp+18h] [ebp-4h]

  CString::CString((CString *)&lpFileName);
  v2 = this[1];
  v10 = 0;
  if ( v2 == (const unsigned __int8 *)-1 )
  {
    if ( !this[301] )
      sub_10002510(this);
    if ( (unsigned __int8)sub_10009F10((unsigned __int8 *)this[6]) )
    {
      CString::CString((CString *)&Str2, (const struct CString *)(this + 5));
      LOBYTE(v10) = 1;
      v4 = 0;
      v5 = this + 302;
      while ( mbscmp(*v5, Str2) )
      {
        ++v4;
        ++v5;
        if ( v4 >= 0x20 )
          goto LABEL_11;
      }
      CString::Format(
        (CString *)&Str2,
        "_TEXT(VID_%.4X&PID_%.4X)",
        *((unsigned __int16 *)this + v4 + 764),
        *((unsigned __int16 *)this + v4 + 732));
LABEL_11:
      sub_10009F70((char *)&Str2, (int)this[6], (CString *)&lpFileName);
      LOBYTE(v10) = 0;
      CString::~CString((CString *)&Str2);
    }
    if ( *((_DWORD *)lpFileName - 2) || (unsigned __int8)sub_100028B0(this) )
    {
      if ( !*((_DWORD *)lpFileName - 2) )
        CString::Format((CString *)&lpFileName, "\\\\.\\%s%lu", aHmseusb, this[4]);
      FileA = (const unsigned __int8 *)CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x40000080u, 0);
      this[1] = FileA;
      if ( FileA != (const unsigned __int8 *)-1 && !(unsigned __int8)sub_10002A30(this) )
        (*((void (__thiscall **)(const unsigned __int8 **))*this + 2))(this);
    }
    v7 = this[1];
    v10 = -1;
    CString::~CString((CString *)&lpFileName);
    return v7;
  }
  else
  {
    v10 = -1;
    CString::~CString((CString *)&lpFileName);
    return v2;
  }
}


/* ==== 10001CC0  sub_10001CC0  ()  size=18 ==== */
int __thiscall sub_10001CC0(_DWORD *this)
{
  int result; // eax

  sub_10005C00();
  result = 0;
  this[4] = 0;
  this[10] = 0;
  return result;
}


/* ==== 10001CE0  sub_10001CE0  ()  size=6 ==== */
int sub_10001CE0()
{
  return 1;
}


/* ==== 10001CF0  sub_10001CF0  ()  size=91 ==== */
int __thiscall sub_10001CF0(_DWORD *this, int a2, LPVOID lpOutBuffer, DWORD nOutBufferSize, LPOVERLAPPED lpOverlapped)
{
  void *v5; // ecx
  int v6; // eax
  bool v7; // zf
  int result; // eax
  DWORD BytesReturned; // [esp+4h] [ebp-4h] BYREF

  v5 = (void *)this[1];
  v6 = *(unsigned __int8 *)(a2 + 12);
  BytesReturned = 0;
  if ( DeviceIoControl(
         v5,
         (4 * v6 + 8216) | 0x80000000,
         0,
         0,
         lpOutBuffer,
         nOutBufferSize,
         &BytesReturned,
         lpOverlapped) )
  {
    return 0;
  }
  v7 = GetLastError() == 997;
  result = 1;
  if ( !v7 )
    return 0;
  return result;
}


/* ==== 10001D50  sub_10001D50  ()  size=82 ==== */
int __thiscall sub_10001D50(HANDLE *this, int a2, LPVOID lpInBuffer, DWORD nInBufferSize, LPOVERLAPPED lpOverlapped)
{
  bool v5; // zf
  int result; // eax

  if ( DeviceIoControl(
         this[1],
         (4 * *(unsigned __int8 *)(a2 + 13) + 8336) | 0x80000000,
         lpInBuffer,
         nInBufferSize,
         0,
         0,
         0,
         lpOverlapped) )
  {
    return 0;
  }
  v5 = GetLastError() == 997;
  result = 1;
  if ( !v5 )
    return 0;
  return result;
}


/* ==== 10001DB0  sub_10001DB0  ()  size=5 ==== */
char __stdcall sub_10001DB0(int a1, int a2)
{
  return 1;
}


/* ==== 10001DC0  sub_10001DC0  ()  size=574 ==== */
char __thiscall sub_10001DC0(_DWORD *this, CStringList *a2, _DWORD *a3)
{
  _DWORD *v3; // edi
  _DWORD *v4; // esi
  CStringList *v5; // ebp
  const unsigned __int8 **v6; // esi
  int v7; // eax
  const struct CString *v8; // eax
  CString *v9; // ecx
  int v10; // eax
  const struct CString *v11; // eax
  CString *v12; // ecx
  int v13; // eax
  const struct CString *v14; // eax
  char v16[4]; // [esp+Ch] [ebp-30h] BYREF
  int v17; // [esp+10h] [ebp-2Ch]
  _DWORD *v18; // [esp+14h] [ebp-28h]
  char v19[4]; // [esp+18h] [ebp-24h] BYREF
  char v20[4]; // [esp+1Ch] [ebp-20h] BYREF
  char v21[4]; // [esp+20h] [ebp-1Ch] BYREF
  char v22[4]; // [esp+24h] [ebp-18h] BYREF
  char v23[4]; // [esp+28h] [ebp-14h] BYREF
  char v24[4]; // [esp+2Ch] [ebp-10h] BYREF
  int v25; // [esp+38h] [ebp-4h]

  v3 = a3;
  v4 = this;
  v18 = this;
  if ( a3 )
    *a3 = 0;
  v5 = a2;
  if ( a2 )
    CStringList::RemoveAll(a2);
  if ( !(unsigned __int8)sub_10002510(v4) )
    return 0;
  if ( v5 )
  {
    v6 = (const unsigned __int8 **)(v4 + 334);
    v17 = 32;
    do
    {
      if ( mbscmp(*(v6 - 32), Str2) )
      {
        CString::CString((CString *)&a2);
        v25 = 0;
        CString::operator=(&a2, v6 - 32);
        CString::TrimRight((CString *)&a2, asc_10022074);
        CString::TrimLeft((CString *)&a2, asc_10022074);
        if ( v18[301] == 1 )
        {
          CString::CString((CString *)v16);
          LOBYTE(v25) = 1;
          if ( (unsigned __int8)sub_1000A060(v16) )
          {
            v7 = operator+(v20, &a2, asc_10022070);
            LOBYTE(v25) = 2;
            v8 = (const struct CString *)operator+(v19, v7, v16);
            LOBYTE(v25) = 3;
            CStringList::AddTail(v5, v8);
            LOBYTE(v25) = 2;
            CString::~CString((CString *)v19);
            LOBYTE(v25) = 1;
            v9 = (CString *)v20;
          }
          else
          {
            v10 = operator+(v22, &a2, asc_10022070);
            LOBYTE(v25) = 4;
            v11 = (const struct CString *)operator+(v21, v10, v6);
            LOBYTE(v25) = 5;
            CStringList::AddTail(v5, v11);
            LOBYTE(v25) = 4;
            CString::~CString((CString *)v21);
            LOBYTE(v25) = 1;
            v9 = (CString *)v22;
          }
          CString::~CString(v9);
          LOBYTE(v25) = 0;
          v12 = (CString *)v16;
        }
        else
        {
          v13 = operator+(v24, &a2, asc_10022070);
          LOBYTE(v25) = 6;
          v14 = (const struct CString *)operator+(v23, v13, v6);
          LOBYTE(v25) = 7;
          CStringList::AddTail(v5, v14);
          LOBYTE(v25) = 6;
          CString::~CString((CString *)v23);
          LOBYTE(v25) = 0;
          v12 = (CString *)v24;
        }
        CString::~CString(v12);
        v25 = -1;
        CString::~CString((CString *)&a2);
      }
      ++v6;
      --v17;
    }
    while ( v17 );
    v4 = v18;
    v3 = a3;
  }
  if ( v3 )
    *v3 = v4[301];
  return 1;
}


/* ==== 10002000  sub_10002000  ()  size=39 ==== */
int __thiscall sub_10002000(_DWORD *this, int a2)
{
  void *v2; // eax

  v2 = (void *)this[1];
  if ( v2 == (void *)-1 )
    return sub_10005D40(a2);
  else
    return sub_10002620(v2, this[4], a2);
}


/* ==== 10002030  sub_10002030  ()  size=147 ==== */
char __thiscall sub_10002030(_DWORD *this, int a2, _DWORD *a3)
{
  unsigned int v4; // edi
  int v5; // eax
  _DWORD *v6; // edx
  int v7; // ecx

  if ( this[1] == -1 )
    return sub_10005D70(a2, a3);
  if ( a3 )
    *a3 = this[10];
  if ( !this[10] || !a2 )
    return sub_10005D70(a2, a3);
  v4 = 0;
  v5 = a2 + 8;
  v6 = this + 13;
  do
  {
    v7 = *(v6 - 1);
    v6 += 9;
    *(_DWORD *)(v5 - 4) = v7;
    *(_DWORD *)v5 = *(v6 - 9);
    *(_BYTE *)(v5 + 4) = *((_BYTE *)v6 - 32);
    *(_BYTE *)(v5 + 5) = *((_BYTE *)v6 - 31);
    *(_WORD *)(v5 + 6) = *((_WORD *)v6 - 15);
    *(_WORD *)(v5 + 8) = *((_WORD *)v6 - 14);
    *(_DWORD *)(v5 + 12) = *(v6 - 6);
    *(_DWORD *)(v5 + 16) = *(v6 - 5);
    *(_BYTE *)(v5 + 20) = *((_BYTE *)v6 - 16);
    *(_BYTE *)(v5 + 21) = *((_BYTE *)v6 - 15);
    v5 += 36;
    ++v4;
  }
  while ( v4 < this[10] );
  return 1;
}


/* ==== 100020D0  sub_100020D0  ()  size=485 ==== */
char __userpurge sub_100020D0@<al>(_DWORD *a1@<ecx>, int a2@<ebx>, HWND a3, char a4)
{
  struct CWnd *v5; // esi
  int v6; // eax
  struct AFX_MODULE_STATE *v8; // eax
  COleControl *v9; // eax
  COleControl *v10; // ebx
  CString *Font; // esi
  int v12; // eax
  int v13; // eax
  int v14; // edx
  int v15; // eax
  _DWORD v17[2]; // [esp+10h] [ebp-30h] BYREF
  _BYTE v18[28]; // [esp+18h] [ebp-28h] BYREF
  int v19; // [esp+3Ch] [ebp-4h]
  _UNKNOWN *retaddr; // [esp+40h] [ebp+0h]
  HWND v21; // [esp+44h] [ebp+4h]
  HWND v22; // [esp+44h] [ebp+4h]

  v5 = 0;
  CStringList::CStringList((CStringList *)v18, 10);
  v6 = a1[299];
  v19 = 0;
  if ( v6 )
  {
    if ( a1[300] != -1 )
    {
      sub_10002510(a1);
      if ( a1[301] == 1 )
      {
        v19 = -1;
        CStringList::~CStringList((CStringList *)v18);
        return 1;
      }
    }
  }
  if ( a3 )
    v5 = CWnd::FromHandle(a3);
  v8 = (struct AFX_MODULE_STATE *)sub_1001ADDD();
  AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)v17, v8);
  LOBYTE(v19) = 1;
  if ( !v5 )
  {
    v22 = (HWND)operator new(0x100u);
    LOBYTE(v19) = 3;
    if ( v22 )
    {
      v9 = (COleControl *)sub_10003080(a1[398], 0);
      goto LABEL_13;
    }
LABEL_12:
    v9 = 0;
    goto LABEL_13;
  }
  v21 = (HWND)operator new(0x100u);
  LOBYTE(v19) = 2;
  if ( !v21 )
    goto LABEL_12;
  v9 = (COleControl *)sub_10003080(a1[398], v5);
LABEL_13:
  v10 = v9;
  LOBYTE(v19) = 1;
  if ( v9 )
  {
    if ( (*(int (__thiscall **)(COleControl *, int))(*(_DWORD *)v9 + 192))(v9, a2) == 1 )
    {
      Font = COleControl::InternalGetFont(v10);
      v12 = CString::Find(Font, asc_10022070);
      v13 = CString::Left(Font, &a4, v12);
      CString::operator=(a1 + 5, v13);
      CString::~CString((CString *)&a4);
      v14 = CString::Find(Font, asc_10022070);
      v15 = CString::Mid(Font, &a4, strlen(asc_10022070) + v14);
      CString::operator=(a1 + 6, v15);
      LOBYTE(retaddr) = 1;
      CString::~CString((CString *)&a4);
      HIBYTE(v17[0]) = 1;
    }
    (*(void (__thiscall **)(COleControl *, int))(*(_DWORD *)v10 + 4))(v10, 1);
  }
  v19 = -1;
  *(_DWORD *)(v17[1] + 4) = v17[0];
  CStringList::~CStringList((CStringList *)v18);
  return 0;
}


/* ==== 100022C0  sub_100022C0  ()  size=336 ==== */
char __thiscall sub_100022C0(_DWORD *this, char *Buffer, unsigned __int8 *Str1)
{
  CString *p_Buffer; // ecx
  CString *v6; // esi
  _DWORD *v7; // edi
  int v8; // eax

  if ( !Buffer )
  {
    v6 = (CString *)(this + 5);
    CString::operator=(this + 5, Str1);
    v7 = this + 300;
    *v7 = -1;
    if ( CString::Find(v6, aVid) != -1 )
      return 1;
    v8 = CString::Find(v6, aPid);
    if ( v8 == -1 )
      return 1;
    CString::Mid(v6, &Buffer, v8 + 4);
    sscanf(Buffer, "%lx", v7);
    p_Buffer = (CString *)&Buffer;
    goto LABEL_14;
  }
  if ( Buffer != (char *)1 )
  {
    if ( Buffer == (char *)2 )
    {
      CString::CString((CString *)&Str1, (const struct CString *)Str1);
      if ( !mbscmp(Str1, aOn) )
      {
        this[299] = 1;
        p_Buffer = (CString *)&Str1;
LABEL_14:
        CString::~CString(p_Buffer);
        return 1;
      }
      if ( !mbscmp(Str1, aOff) )
      {
        this[299] = 0;
        p_Buffer = (CString *)&Str1;
        goto LABEL_14;
      }
      CString::~CString((CString *)&Str1);
    }
    return 0;
  }
  CString::operator=(this + 6, Str1);
  return 1;
}


/* ==== 10002410  sub_10002410  ()  size=104 ==== */
char __thiscall sub_10002410(_DWORD *this, int a2, int a3)
{
  if ( a2 )
  {
    if ( a2 == 1 )
    {
      CString::operator=(a3, this + 6);
      return 1;
    }
    else if ( a2 == 2 )
    {
      if ( this[299] )
        CString::operator=(a3, aOn);
      else
        CString::operator=(a3, aOff);
      return 1;
    }
    else
    {
      return 0;
    }
  }
  else
  {
    CString::operator=(a3, this + 5);
    return 1;
  }
}


/* ==== 10002480  sub_10002480  ()  size=138 ==== */
void __thiscall sub_10002480(_DWORD *this, unsigned __int16 **a2)
{
  int v3; // eax
  unsigned __int16 *v4; // eax
  int v5; // [esp-8h] [ebp-1Ch]
  int v6; // [esp-4h] [ebp-18h]
  _BYTE v7[4]; // [esp+4h] [ebp-10h] BYREF
  int v8; // [esp+10h] [ebp-4h]

  CString::CString((CString *)v7);
  v3 = this[1];
  v8 = 0;
  v6 = this[6];
  v5 = this[5];
  if ( v3 == -1 )
    CString::Format((CString *)v7, "USB device closed \"%s - %s\"", v5, v6);
  else
    CString::Format((CString *)v7, "USB device open \"%s - %s\"", v5, v6);
  v4 = CString::AllocSysString((CString *)v7);
  v8 = -1;
  *a2 = v4;
  CString::~CString((CString *)v7);
}


/* ==== 10002510  sub_10002510  ()  size=259 ==== */
char __thiscall sub_10002510(int *this)
{
  unsigned int v2; // edi
  HANDLE FileA; // esi
  int v4; // eax
  LPCSTR lpFileName; // [esp+0h] [ebp-14h] BYREF
  int *v7; // [esp+4h] [ebp-10h]
  int v8; // [esp+10h] [ebp-4h]

  CString::CString((CString *)&lpFileName);
  v2 = 0;
  v8 = 0;
  this[301] = 0;
  v7 = this + 302;
  do
  {
    CString::Format((CString *)&lpFileName, "\\\\.\\%s%lu", aHmseusb, v2);
    FileA = CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x40000080u, 0);
    if ( FileA == (HANDLE)-1 )
    {
      CString::operator=(v7, Str2);
    }
    else
    {
      if ( (unsigned __int8)sub_10002700(FileA, v2, this[300]) )
        ++this[301];
      CloseHandle(FileA);
    }
    ++v2;
    ++v7;
  }
  while ( v2 < 0x20 );
  v4 = this[301];
  v8 = -1;
  if ( v4 )
  {
    CString::~CString((CString *)&lpFileName);
    return 1;
  }
  else
  {
    CString::~CString((CString *)&lpFileName);
    return 0;
  }
}


/* ==== 10002620  sub_10002620  ()  size=212 ==== */
char __stdcall sub_10002620(HANDLE hDevice, int a2, _WORD *a3)
{
  __int16 v4; // ax
  _BYTE OutBuffer[8]; // [esp+8h] [ebp-214h] BYREF
  __int16 v6; // [esp+10h] [ebp-20Ch]
  __int16 v7; // [esp+12h] [ebp-20Ah]
  unsigned __int8 Dest[256]; // [esp+1Ch] [ebp-200h] BYREF
  char v9[256]; // [esp+11Ch] [ebp-100h] BYREF

  if ( hDevice == (HANDLE)-1 )
    return sub_10005D40(a3);
  if ( !(unsigned __int8)sub_10009EA0(hDevice, OutBuffer) )
    return sub_10005D40(a3);
  v4 = v6;
  a3[1] = v7;
  *a3 = v4;
  sub_10009C60(hDevice, Dest, 0x100u, (int)OutBuffer);
  sub_10009D20(hDevice, a2, v9, 0x100u, (int)OutBuffer);
  CString::operator=(a3 + 2, Dest);
  CString::operator=(a3 + 4, v9);
  return 1;
}


/* ==== 10002700  sub_10002700  ()  size=339 ==== */
char __thiscall sub_10002700(_WORD *this, HANDLE hDevice, int a3, int a4)
{
  __int16 v5; // ax
  __int16 v7; // [esp+8h] [ebp-18h] BYREF
  unsigned __int16 v8; // [esp+Ah] [ebp-16h]
  _BYTE v9[4]; // [esp+Ch] [ebp-14h] BYREF
  _BYTE v10[4]; // [esp+10h] [ebp-10h] BYREF
  int v11; // [esp+1Ch] [ebp-4h]

  CString::CString((CString *)v9);
  v11 = 0;
  CString::CString((CString *)v10);
  v11 = 1;
  if ( sub_10002620(hDevice, a3, &v7) && (a4 == -1 || a4 == v8) )
  {
    CString::operator=(&this[2 * a3 + 604], v9);
    CString::operator=(&this[2 * a3 + 668], v10);
    v5 = v7;
    this[a3 + 732] = v8;
    this[a3 + 764] = v5;
    v11 = 2;
    CString::~CString((CString *)v10);
    v11 = -1;
    CString::~CString((CString *)v9);
    return 1;
  }
  else
  {
    CString::operator=(&this[2 * a3 + 604], Str2);
    CString::operator=(&this[2 * a3 + 668], aNoSerialNumber);
    this[a3 + 732] = 0;
    this[a3 + 764] = 0;
    v11 = 3;
    CString::~CString((CString *)v10);
    v11 = -1;
    CString::~CString((CString *)v9);
    return 0;
  }
}


/* ==== 10002860  sub_10002860  ()  size=77 ==== */
void __thiscall sub_10002860(int this)
{
  CString::~CString((CString *)(this + 8));
  CString::~CString((CString *)(this + 4));
}


/* ==== 100028B0  sub_100028B0  ()  size=333 ==== */
char __thiscall sub_100028B0(int this)
{
  unsigned int v2; // ebx
  const unsigned __int8 **v3; // ebp
  const unsigned __int8 **v4; // edi
  unsigned int v5; // edi
  const unsigned __int8 **v6; // ebx
  int v8; // esi
  int v9; // [esp-4h] [ebp-1Ch]
  unsigned __int16 *v10; // [esp+10h] [ebp-8h]
  int v11; // [esp+14h] [ebp-4h] BYREF

  v2 = 0;
  v3 = (const unsigned __int8 **)(this + 24);
  v9 = *(_DWORD *)(this + 24);
  v11 = -1;
  *(_DWORD *)(this + 16) = 0;
  if ( !sub_1000A330(v9) )
  {
    v4 = (const unsigned __int8 **)(this + 1336);
    do
    {
      if ( !mbscmp(*v4, *v3) )
      {
        *(_DWORD *)(this + 16) = v2;
        CString::operator=(this + 20, this + 4 * v2 + 1208);
        return 1;
      }
      ++v2;
      ++v4;
    }
    while ( v2 < 0x20 );
  }
  sscanf((const char *const)*v3, "%lu", &v11);
  v5 = 0;
  v10 = (unsigned __int16 *)(this + 1464);
  v6 = (const unsigned __int8 **)(this + 1208);
  while ( *(_DWORD *)(this + 1200) == -1 )
  {
    if ( !mbscmp(*v6, *(const unsigned __int8 **)(this + 20)) && v5 == v11 )
    {
      *(_DWORD *)(this + 16) = v5;
      CString::operator=(v3, this + 4 * v5 + 1336);
      return 1;
    }
LABEL_13:
    ++v5;
    ++v6;
    ++v10;
    if ( v5 >= 0x20 )
      return 0;
  }
  if ( !mbscmp(*v6, Str2) || *v10 != *(_DWORD *)(this + 1200) )
    goto LABEL_13;
  *(_DWORD *)(this + 16) = v5;
  CString::operator=(this + 20, this + 4 * v5 + 1208);
  v8 = this + 4 * v5 + 1336;
  CString::operator=(v3, v8);
  CString::operator=(v3, v8);
  return 1;
}


/* ==== 10002A00  sub_10002A00  ()  size=44 ==== */
int __stdcall sub_10002A00(int a1)
{
  int result; // eax

  result = a1;
  *(_DWORD *)(a1 + 4) = 0;
  *(_DWORD *)(a1 + 8) = 0;
  *(_BYTE *)(a1 + 12) = 0;
  *(_BYTE *)(a1 + 13) = 0;
  *(_WORD *)(a1 + 14) = 0;
  *(_WORD *)(a1 + 16) = 0;
  *(_DWORD *)(a1 + 20) = 0;
  *(_DWORD *)(a1 + 24) = 0;
  *(_BYTE *)(a1 + 28) = 0;
  *(_BYTE *)(a1 + 29) = 0;
  *(_DWORD *)(a1 + 32) = 0;
  return result;
}


/* ==== 10002A30  sub_10002A30  ()  size=200 ==== */
char __thiscall sub_10002A30(void *this)
{
  int v2; // ebp
  int v3; // edi
  unsigned __int8 *v4; // ebp
  unsigned __int8 *v5; // edi
  unsigned __int8 v6; // bl
  char v8; // [esp+13h] [ebp-405h]
  unsigned __int8 v9; // [esp+14h] [ebp-404h]
  int OutBuffer; // [esp+18h] [ebp-400h] BYREF
  int v11; // [esp+1Ch] [ebp-3FCh]

  v8 = 0;
  *((_DWORD *)this + 10) = 0;
  v2 = (int)this + 1160;
  v3 = 32;
  do
  {
    sub_10002A00(v2);
    --v3;
    v2 -= 36;
  }
  while ( v3 );
  if ( !(unsigned __int8)sub_10009EE0(*((HANDLE *)this + 1), &OutBuffer) )
    return 0;
  v4 = (unsigned __int8 *)&OutBuffer + (unsigned __int8)OutBuffer;
  v5 = (unsigned __int8 *)&OutBuffer + (unsigned __int8)OutBuffer + (unsigned __int8)v11 * *v4;
  if ( v4[4] < 2u )
    return 0;
  v6 = 0;
  v9 = 0;
  do
  {
    if ( (*(unsigned __int8 (__thiscall **)(void *, unsigned __int8 *, unsigned __int8))(*(_DWORD *)this + 80))(
           this,
           v5,
           v9) )
    {
      v8 = 1;
      ++*((_DWORD *)this + 10);
    }
    v5 += *v5;
    v9 = ++v6;
  }
  while ( v6 < v4[4] );
  return v8;
}


/* ==== 10002B00  sub_10002B00  ()  size=232 ==== */
char __thiscall sub_10002B00(char *this, int a2, char a3)
{
  unsigned int v3; // edx
  char result; // al
  _WORD *v5; // esi
  char *v6; // esi
  char *v7; // ecx

  v3 = 0;
  result = 0;
  v5 = this + 60;
  while ( *(char *)(a2 + 2) < 0 )
  {
    if ( !*(v5 - 1) )
    {
      v6 = &this[36 * v3];
      v6[56] = a3;
      *((_WORD *)v6 + 29) = *(_WORD *)(a2 + 4);
      *((_DWORD *)v6 + 16) = *(unsigned __int16 *)(a2 + 4);
      this[36 * v3 + 72] = *(_BYTE *)(a2 + 2);
      if ( *((_DWORD *)v6 + 13) == 2 )
      {
        *((_DWORD *)v6 + 13) = 3;
        *((_DWORD *)v6 + 12) = 1;
        *((_DWORD *)v6 + 19) = v3;
        return 1;
      }
      else
      {
        *((_DWORD *)v6 + 13) = 1;
      }
      return result;
    }
LABEL_6:
    ++v3;
    v5 += 18;
    if ( v3 >= 0x20 )
      return result;
  }
  if ( *v5 )
    goto LABEL_6;
  v7 = &this[36 * v3];
  v7[57] = a3;
  *((_WORD *)v7 + 30) = *(_WORD *)(a2 + 4);
  *((_DWORD *)v7 + 17) = *(unsigned __int16 *)(a2 + 4);
  v7[73] = *(_BYTE *)(a2 + 2);
  if ( *((_DWORD *)v7 + 13) == 1 )
  {
    *((_DWORD *)v7 + 13) = 3;
    *((_DWORD *)v7 + 12) = 1;
    *((_DWORD *)v7 + 19) = v3;
    return 1;
  }
  else
  {
    *((_DWORD *)v7 + 13) = 2;
  }
  return result;
}


/* ==== 10002BF0  sub_10002BF0  ()  size=154 ==== */
bool __thiscall sub_10002BF0(
        HANDLE *this,
        DWORD BytesReturned,
        char a3,
        __int16 a4,
        __int16 a5,
        LPVOID lpOutBuffer,
        unsigned __int16 a7,
        LPOVERLAPPED lpOverlapped)
{
  LPOVERLAPPED v8; // esi
  _BYTE InBuffer[2]; // [esp+4h] [ebp-8h] BYREF
  __int16 v11; // [esp+6h] [ebp-6h]
  __int16 v12; // [esp+8h] [ebp-4h]
  unsigned __int16 v13; // [esp+Ah] [ebp-2h]

  InBuffer[0] = BytesReturned;
  InBuffer[1] = a3;
  v11 = a4;
  v8 = lpOverlapped;
  v12 = a5;
  v13 = a7;
  if ( DeviceIoControl(this[1], 0x80002010, InBuffer, 8u, lpOutBuffer, a7, &BytesReturned, lpOverlapped) )
    return 0;
  if ( GetLastError() == 997 )
    return WaitForSingleObject(v8->hEvent, 0x3E8u) == 0;
  return 0;
}


/* ==== 10002C90  sub_10002C90  ()  size=14 ==== */
void __stdcall sub_10002C90(void *a1)
{
  operator delete(a1);
}


/* ==== 10002CA0  ??1AFX_MAINTAIN_STATE2@@QAE@XZ  (AFX_MAINTAIN_STATE2::~AFX_MAINTAIN_STATE2(void))  size=9 ==== */
void __thiscall AFX_MAINTAIN_STATE2::~AFX_MAINTAIN_STATE2(AFX_MAINTAIN_STATE2 *this)
{
  *(_DWORD *)(*((_DWORD *)this + 1) + 4) = *(_DWORD *)this;
}


/* ==== 10002CB0  sub_10002CB0  ()  size=178 ==== */
int __cdecl sub_10002CB0(int a1)
{
  int v1; // esi

  v1 = a1;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) == 1 )
  {
    CString::CString((CString *)&a1);
    CString::operator=(&a1, aPid8236);
    (*(void (__thiscall **)(_DWORD, _DWORD, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 0, &a1);
    CString::operator=(&a1, a0);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 1, &a1);
    CString::operator=(&a1, aOff);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 2, &a1);
    CString::~CString((CString *)&a1);
  }
  return 0;
}


/* ==== 10002D70  sub_10002D70  ()  size=13 ==== */
int __cdecl sub_10002D70(int a1, _BYTE *a2)
{
  *a2 = 0;
  return 1;
}


/* ==== 10002D80  sub_10002D80  ()  size=125 ==== */
int __cdecl sub_10002D80(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         0,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10002E00  sub_10002E00  ()  size=121 ==== */
int __cdecl sub_10002E00(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, _DWORD, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 0, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10002E80  sub_10002E80  ()  size=125 ==== */
int __cdecl sub_10002E80(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         1,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10002F00  sub_10002F00  ()  size=121 ==== */
int __cdecl sub_10002F00(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 1, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10002F80  sub_10002F80  ()  size=125 ==== */
int __cdecl sub_10002F80(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         2,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10003000  sub_10003000  ()  size=121 ==== */
int __cdecl sub_10003000(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 2, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10003080  sub_10003080  ()  size=310 ==== */
int __thiscall sub_10003080(int this, int a2, int a3)
{
  CMutex *v4; // eax
  CMutex *v5; // eax
  CSingleLock *v6; // eax
  CSingleLock *v7; // eax

  Concurrency::scheduler_worker_creation_error::scheduler_worker_creation_error(
    (Concurrency::scheduler_worker_creation_error *)this,
    (const char *)0x7D0,
    a3);
  CWnd::CWnd((CWnd *)(this + 96));
  *(_DWORD *)(this + 96) = &off_1001D69C;
  CWnd::CWnd((CWnd *)(this + 160));
  *(_DWORD *)(this + 160) = &off_1001D5C4;
  CString::CString((CString *)(this + 224));
  CString::CString((CString *)(this + 232));
  *(_DWORD *)this = &off_1001D4E0;
  CString::operator=(this + 224, byte_10023388);
  *(_DWORD *)(this + 228) = a2;
  *(_DWORD *)(this + 236) = 0;
  *(_DWORD *)(this + 240) = 0;
  *(_DWORD *)(this + 248) = 0;
  *(_DWORD *)(this + 252) = 0;
  v4 = (CMutex *)operator new(8u);
  if ( v4 )
    v5 = CMutex::CMutex(v4, 1, aListboxAccessM, 0);
  else
    v5 = 0;
  *(_DWORD *)(this + 248) = v5;
  if ( v5 )
  {
    v6 = (CSingleLock *)operator new(0xCu);
    if ( v6 )
      v7 = CSingleLock::CSingleLock(v6, *(struct CSyncObject **)(this + 248), 0);
    else
      v7 = 0;
    *(_DWORD *)(this + 252) = v7;
  }
  return this;
}


/* ==== 100031C0  sub_100031C0  ()  size=30 ==== */
std::ios_base *__thiscall sub_100031C0(std::ios_base *this, char a2)
{
  std::ios_base::~ios_base(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 100031E0  j_??1CDialog@@UAE@XZ  (CDialog::~CDialog(void))  size=5 ==== */
// attributes: thunk
void __thiscall CDialog::~CDialog(CDialog *this)
{
  ??1CDialog@@UAE@XZ(this);
}


/* ==== 100031F0  ??1ios_base@std@@UAE@XZ  (std::ios_base::~ios_base(void))  size=180 ==== */
void __thiscall std::ios_base::~ios_base(std::ios_base *this)
{
  int v2; // ecx
  void *v3; // edi

  *(_DWORD *)this = &off_1001D4E0;
  v2 = *((_DWORD *)this + 62);
  if ( v2 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v2 + 4))(v2, 1);
  v3 = (void *)*((_DWORD *)this + 63);
  if ( v3 )
  {
    CSingleLock::Unlock(*((CSingleLock **)this + 63));
    operator delete(v3);
  }
  CString::~CString((std::ios_base *)((char *)this + 232));
  CString::~CString((std::ios_base *)((char *)this + 224));
  CListBox::~CListBox((std::ios_base *)((char *)this + 160));
  CButton::~CButton((std::ios_base *)((char *)this + 96));
  CDialog::~CDialog(this);
}


/* ==== 100032B0  sub_100032B0  ()  size=70 ==== */
void __thiscall sub_100032B0(int this, struct CDataExchange *a2)
{
  sub_1001A8C9(a2);
  DDX_Control(a2, 2003, (struct CWnd *)(this + 96));
  DDX_Control(a2, 2002, (struct CWnd *)(this + 160));
  DDX_Text(a2, 2004, (struct CString *)(this + 224));
}


/* ==== 10003300  sub_10003300  ()  size=6 ==== */
int (**sub_10003300())()
{
  return &off_1001E278;
}


/* ==== 10003310  sub_10003310  ()  size=6 ==== */
int (**sub_10003310())()
{
  return &off_1001D460;
}


/* ==== 10003320  sub_10003320  ()  size=88 ==== */
int __thiscall sub_10003320(HWND *this)
{
  UINT_PTR v2; // eax

  CDialog::OnInitDialog((CDialog *)this);
  this[61] = 0;
  sub_100034A0((CWnd *)this);
  v2 = SetTimer(this[8], 1u, 0x3E8u, 0);
  this[60] = (HWND)v2;
  if ( v2 )
    CWnd::ShowWindow((CWnd *)(this + 24), 0);
  else
    CWnd::ShowWindow((CWnd *)(this + 24), 5);
  return 1;
}


/* ==== 10003380  sub_10003380  ()  size=43 ==== */
void __thiscall sub_10003380(CDialog *this)
{
  if ( *((_DWORD *)this + 60) )
  {
    KillTimer(*((HWND *)this + 8), *((_DWORD *)this + 60));
    *((_DWORD *)this + 60) = 0;
  }
  CDialog::OnCancel(this);
}


/* ==== 100033B0  sub_100033B0  ()  size=154 ==== */
void __thiscall sub_100033B0(CDialog *this)
{
  LRESULT v2; // eax

  if ( *((_DWORD *)this + 60) )
  {
    KillTimer(*((HWND *)this + 8), *((_DWORD *)this + 60));
    *((_DWORD *)this + 60) = 0;
  }
  if ( SendMessageA(*((HWND *)this + 48), 0x18Bu, 0, 0) <= 0 || SendMessageA(*((HWND *)this + 48), 0x188u, 0, 0) == -1 )
  {
    CString::Empty((CDialog *)((char *)this + 232));
    CDialog::OnOK(this);
  }
  else
  {
    v2 = SendMessageA(*((HWND *)this + 48), 0x188u, 0, 0);
    CListBox::GetText((CDialog *)((char *)this + 160), v2, (CDialog *)((char *)this + 232));
    CDialog::OnOK(this);
  }
}


/* ==== 10003450  ?InternalGetFont@COleControl@@QAEAAVCFontHolder@@XZ  (COleControl::InternalGetFont(void))  size=7 ==== */
struct CFontHolder *__thiscall COleControl::InternalGetFont(COleControl *this)
{
  return (COleControl *)((char *)this + 232);
}


/* ==== 10003460  sub_10003460  ()  size=6 ==== */
void *sub_10003460()
{
  return &unk_10022124;
}


/* ==== 10003470  sub_10003470  ()  size=6 ==== */
int sub_10003470()
{
  return 2000;
}


/* ==== 10003480  sub_10003480  ()  size=23 ==== */
int __thiscall sub_10003480(CWnd *this)
{
  sub_10007BE0(*((_DWORD *)this + 57));
  return sub_100034A0(this);
}


/* ==== 100034A0  sub_100034A0  ()  size=634 ==== */
void __thiscall sub_100034A0(CWnd *this)
{
  signed int cx; // ebp
  HWND v3; // eax
  HDC DC; // eax
  struct CDC *v5; // eax
  CSingleLock *v6; // ecx
  int v7; // eax
  int v8; // ecx
  const char *v9; // eax
  _DWORD *v10; // edi
  _DWORD *v11; // eax
  int v12; // eax
  CWnd *v13; // eax
  CWnd *DlgItem; // eax
  CSingleLock *v15; // esi
  int v16; // [esp-8h] [ebp-2Ch]
  LPARAM lParam; // [esp+8h] [ebp-1Ch] BYREF
  struct CDC *v18; // [esp+Ch] [ebp-18h]
  tagSIZE psizl; // [esp+10h] [ebp-14h] BYREF
  int v20; // [esp+20h] [ebp-4h]

  cx = 0;
  CString::CString((CString *)&lParam);
  v3 = (HWND)*((_DWORD *)this + 48);
  v20 = 0;
  DC = GetDC(v3);
  v5 = CDC::FromHandle(DC);
  v6 = (CSingleLock *)*((_DWORD *)this + 63);
  v18 = v5;
  if ( v6 )
    CSingleLock::Lock(v6, 0xFAu);
  v7 = *((_DWORD *)this + 63);
  if ( !v7 || *(_DWORD *)(v7 + 8) )
  {
    if ( SendMessageA(*((HWND *)this + 48), 0x18Bu, 0, 0) > 0 )
      SendMessageA(*((HWND *)this + 48), 0x184u, 0, 0);
    v8 = *((_DWORD *)this + 57);
    if ( v8 )
      sub_10007BE0(v8);
    if ( sub_10007BC0(*((_DWORD *)this + 57)) >= 0
      && (v9 = type_info::raw_name(*((type_info **)this + 57)), (*((_DWORD *)this + 59) = v9) != 0) )
    {
      v10 = (_DWORD *)*((_DWORD *)v9 + 1);
      while ( v10 )
      {
        v11 = v10;
        v10 = (_DWORD *)*v10;
        CString::operator=(&lParam, v11 + 2);
        SendMessageA(*((HWND *)this + 48), 0x180u, 0, lParam);
        GetTextExtentPoint32A(*((HDC *)v18 + 2), (LPCSTR)lParam, *(_DWORD *)(lParam - 8), &psizl);
        if ( psizl.cx > cx )
          cx = psizl.cx;
      }
      if ( *(int *)(*((_DWORD *)this + 59) + 12) <= 0 )
      {
        DlgItem = CWnd::GetDlgItem(this, 1);
        if ( DlgItem )
          CWnd::EnableWindow(DlgItem, 0);
      }
      else
      {
        ReleaseDC(*((HWND *)this + 48), *((HDC *)v18 + 1));
        SendMessageA(*((HWND *)this + 48), 0x194u, cx, 0);
        v12 = *(_DWORD *)(*((_DWORD *)this + 59) + 12);
        if ( *((_DWORD *)this + 61) > (unsigned int)(v12 - 1) )
          *((_DWORD *)this + 61) = v12 - 1;
        SendMessageA(*((HWND *)this + 48), 0x186u, *((_DWORD *)this + 61), 0);
        v13 = CWnd::GetDlgItem(this, 1);
        if ( v13 )
          CWnd::EnableWindow(v13, 1);
      }
      v16 = *(_DWORD *)(*((_DWORD *)this + 59) + 12);
      if ( v16 == 1 )
        CString::Format((CWnd *)((char *)this + 224), "%d USB device located", 1);
      else
        CString::Format((CWnd *)((char *)this + 224), "%d USB devices located", v16);
      CWnd::UpdateData(this, 0);
    }
    else
    {
      if ( *((_DWORD *)this + 60) )
      {
        KillTimer(*((HWND *)this + 8), *((_DWORD *)this + 60));
        *((_DWORD *)this + 60) = 0;
      }
      CWnd::MessageBoxA(this, aUsb, aUnableToScanTh, 0);
      (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 208))(this);
    }
    v15 = (CSingleLock *)*((_DWORD *)this + 63);
    if ( v15 )
      CSingleLock::Unlock(v15);
  }
  else
  {
    CWnd::MessageBoxA(this, aAnotherApplica, aError, 0);
    (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 208))(this);
  }
  v20 = -1;
  CString::~CString((CString *)&lParam);
}


/* ==== 10003720  sub_10003720  ()  size=33 ==== */
int __thiscall sub_10003720(CWnd *this, int a2)
{
  if ( a2 == *((_DWORD *)this + 60) )
    sub_10003480(this);
  return CWnd::Default(this);
}


/* ==== 10003750  sub_10003750  ()  size=111 ==== */
LRESULT __thiscall sub_10003750(int this)
{
  CSingleLock *v2; // ecx
  LRESULT result; // eax
  CSingleLock *v4; // ecx

  v2 = *(CSingleLock **)(this + 252);
  if ( v2 )
    CSingleLock::Lock(v2, 0x3E8u);
  result = *(_DWORD *)(this + 252);
  if ( !result || *(_DWORD *)(result + 8) )
  {
    result = SendMessageA(*(HWND *)(this + 192), 0x18Bu, 0, 0);
    if ( result > 0 )
    {
      result = SendMessageA(*(HWND *)(this + 192), 0x188u, 0, 0);
      *(_DWORD *)(this + 244) = result;
    }
    v4 = *(CSingleLock **)(this + 252);
    if ( v4 )
      return CSingleLock::Unlock(v4);
  }
  return result;
}


/* ==== 100037C0  nullsub_2  ()  size=1 ==== */
void nullsub_2()
{
  ;
}


/* ==== 100037D0  nullsub_1  ()  size=3 ==== */
void __stdcall nullsub_1(int a1)
{
  ;
}


/* ==== 100037E0  sub_100037E0  ()  size=13 ==== */
BOOL __thiscall sub_100037E0(HWND *this)
{
  return EnableWindow(this[8], 0);
}


/* ==== 100037F0  sub_100037F0  ()  size=13 ==== */
BOOL __thiscall sub_100037F0(HWND *this)
{
  return EnableWindow(this[8], 1);
}


/* ==== 10003800  sub_10003800  ()  size=30 ==== */
CButton *__thiscall sub_10003800(CButton *this, char a2)
{
  CButton::~CButton(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10003820  sub_10003820  ()  size=30 ==== */
CListBox *__thiscall sub_10003820(CListBox *this, char a2)
{
  CListBox::~CListBox(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10003840  sub_10003840  ()  size=204 ==== */
_DWORD *__thiscall sub_10003840(_DWORD *this)
{
  int v2; // eax

  sub_10005B70();
  CString::CString((CString *)(this + 5));
  `eh vector constructor iterator'(
    this + 13,
    4u,
    32,
    (void (__thiscall *)(void *))CString::CString,
    (void (__thiscall *)(void *))CString::~CString);
  *this = &off_1001D784;
  this[12] = 0;
  if ( operator new(0x24u) )
    v2 = sub_10007B70(this);
  else
    v2 = 0;
  this[45] = v2;
  this[4] = 0;
  CString::operator=(this + 5, Str2);
  this[7] = 0;
  this[8] = 0;
  this[9] = 0;
  this[11] = 0;
  this[6] = 9600;
  *((_BYTE *)this + 40) = 17;
  *((_BYTE *)this + 41) = 19;
  return this;
}


/* ==== 10003950  sub_10003950  ()  size=131 ==== */
int __thiscall sub_10003950(_DWORD *this)
{
  void (__thiscall ***v2)(_DWORD, int); // ecx

  *this = &off_1001D784;
  sub_10005C00();
  v2 = (void (__thiscall ***)(_DWORD, int))this[45];
  if ( v2 )
    (**v2)(v2, 1);
  `eh vector destructor iterator'(this + 13, 4u, 32, (void (__thiscall *)(void *))CString::~CString);
  CString::~CString((CString *)(this + 5));
  return sub_10005BD0(this);
}


/* ==== 100039E0  sub_100039E0  ()  size=222 ==== */
int __thiscall sub_100039E0(_DWORD *this)
{
  int v2; // edi
  HANDLE FileA; // eax
  int v5; // esi
  LPCSTR lpFileName; // [esp+8h] [ebp-10h] BYREF
  int v7; // [esp+14h] [ebp-4h]

  CString::CString((CString *)&lpFileName);
  v2 = this[1];
  v7 = 0;
  if ( v2 == -1 )
  {
    if ( !this[12] )
      sub_100044A0(this);
    CString::Format((CString *)&lpFileName, "\\\\.\\%s%lu", aCom, this[4]);
    FileA = CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x40000080u, 0);
    this[1] = FileA;
    if ( FileA != (HANDLE)-1 && !(unsigned __int8)sub_10004620(this) )
      (*(void (__thiscall **)(_DWORD *))(*this + 8))(this);
    v5 = this[1];
    v7 = -1;
    CString::~CString((CString *)&lpFileName);
    return v5;
  }
  else
  {
    v7 = -1;
    CString::~CString((CString *)&lpFileName);
    return v2;
  }
}


/* ==== 10003AC0  sub_10003AC0  ()  size=6 ==== */
int sub_10003AC0()
{
  return 2;
}


/* ==== 10003AD0  sub_10003AD0  ()  size=31 ==== */
bool __thiscall sub_10003AD0(_DWORD *this, int a2, int a3)
{
  void *v3; // eax

  v3 = (void *)this[1];
  return v3 != (void *)-1 && PurgeComm(v3, 0xFu);
}


/* ==== 10003AF0  sub_10003AF0  ()  size=65 ==== */
__int64 __thiscall sub_10003AF0(unsigned int *this, int a2)
{
  return (__int64)(1.0 / ((double)this[6] * 0.1) * (double)a2 * 1000.0);
}


/* ==== 10003B40  sub_10003B40  ()  size=136 ==== */
char __thiscall sub_10003B40(_DWORD *this, CStringList *a2, _DWORD *a3)
{
  _DWORD *v3; // edi
  _DWORD *v4; // esi
  const struct CString *v5; // esi
  int v6; // ebx

  v3 = a3;
  v4 = this;
  if ( a3 )
    *a3 = 0;
  if ( a2 )
    CStringList::RemoveAll(a2);
  if ( !(unsigned __int8)sub_100044A0(v4) )
    return 0;
  if ( a2 )
  {
    v5 = (const struct CString *)(v4 + 13);
    v6 = 32;
    do
    {
      if ( mbscmp(*(const unsigned __int8 **)v5, Str2) )
        CStringList::AddTail(a2, v5);
      v5 = (const struct CString *)((char *)v5 + 4);
      --v6;
    }
    while ( v6 );
    v4 = this;
    v3 = a3;
  }
  if ( v3 )
    *v3 = v4[12];
  return 1;
}


/* ==== 10003BD0  sub_10003BD0  ()  size=66 ==== */
char __thiscall sub_10003BD0(_DWORD *this, _WORD *a2)
{
  if ( this[1] == -1 )
    return sub_10005D40(a2);
  a2[1] = 0;
  *a2 = 0;
  CString::operator=(a2 + 2, this + 5);
  CString::operator=(a2 + 4, aNoSerialNumber_0);
  return 1;
}


/* ==== 10003C20  sub_10003C20  ()  size=143 ==== */
char __thiscall sub_10003C20(_DWORD *this, int a2, _DWORD *a3)
{
  if ( this[1] == -1 )
    return sub_10005D70(a2, a3);
  if ( a3 )
    *a3 = 1;
  if ( a2 )
  {
    *(_DWORD *)(a2 + 4) = 1;
    *(_DWORD *)(a2 + 8) = 3;
    *(_BYTE *)(a2 + 12) = 0;
    *(_BYTE *)(a2 + 13) = 0;
    *(_WORD *)(a2 + 14) = 1;
    *(_WORD *)(a2 + 16) = 1;
    *(_DWORD *)(a2 + 20) = 1;
    *(_DWORD *)(a2 + 24) = 1;
    *(_BYTE *)(a2 + 28) = 0;
    *(_BYTE *)(a2 + 29) = 0;
  }
  return 1;
}


/* ==== 10003CB0  sub_10003CB0  ()  size=308 ==== */
char __thiscall sub_10003CB0(_DWORD *this, HWND a2)
{
  struct CWnd *v3; // edi
  struct AFX_MODULE_STATE *v4; // eax
  _DWORD *v5; // eax
  _DWORD *v6; // edi
  int v7; // eax
  char v9; // [esp+Fh] [ebp-31h]
  _DWORD v10[2]; // [esp+10h] [ebp-30h] BYREF
  _BYTE v11[28]; // [esp+18h] [ebp-28h] BYREF
  int v12; // [esp+3Ch] [ebp-4h]
  HWND v13; // [esp+44h] [ebp+4h]
  HWND v14; // [esp+44h] [ebp+4h]

  v9 = 0;
  v3 = 0;
  CStringList::CStringList((CStringList *)v11, 10);
  v12 = 0;
  if ( a2 )
    v3 = CWnd::FromHandle(a2);
  v4 = (struct AFX_MODULE_STATE *)sub_1001ADDD();
  AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)v10, v4);
  LOBYTE(v12) = 1;
  if ( v3 )
  {
    v13 = (HWND)operator new(0x144u);
    LOBYTE(v12) = 2;
    if ( v13 )
    {
      v5 = (_DWORD *)sub_10005270(this[45], this + 5, this[6], v3);
      goto LABEL_9;
    }
  }
  else
  {
    v14 = (HWND)operator new(0x144u);
    LOBYTE(v12) = 3;
    if ( v14 )
    {
      v5 = (_DWORD *)sub_10005270(this[45], this + 5, this[6], 0);
      goto LABEL_9;
    }
  }
  v5 = 0;
LABEL_9:
  v6 = v5;
  LOBYTE(v12) = 1;
  if ( v5 )
  {
    if ( (*(int (__thiscall **)(_DWORD *))(*v5 + 192))(v5) == 1 )
    {
      v7 = sub_100057E0(v6);
      CString::operator=(this + 5, v7);
      v9 = 1;
      this[6] = v6[78];
    }
    (*(void (__thiscall **)(_DWORD *, int))(*v6 + 4))(v6, 1);
  }
  v12 = -1;
  *(_DWORD *)(v10[1] + 4) = v10[0];
  CStringList::~CStringList((CStringList *)v11);
  return v9;
}


/* ==== 10003DF0  sub_10003DF0  ()  size=1038 ==== */
char __thiscall sub_10003DF0(_DWORD *this, char *a2, char *Buffer)
{
  bool v3; // bl
  CString *v5; // ebx
  const char **v6; // edi
  int v7; // edx
  _DWORD *v8; // esi
  int v9; // ebp
  char **p_Buffer; // ecx
  int v11; // ebp
  int v12; // ebp
  int v13; // ebp
  int v14; // ebp
  int v16; // [esp+10h] [ebp-10h] BYREF
  int v17; // [esp+1Ch] [ebp-4h]

  v3 = 0;
  switch ( (unsigned int)a2 )
  {
    case 0u:
      v5 = (CString *)Buffer;
      v6 = (const char **)(this + 5);
      CString::operator=(this + 5, Buffer);
      v7 = CString::Find(v5, aCom);
      if ( v7 == -1 )
      {
        v8 = this + 4;
        sscanf(*v6, "%lu", v8);
        CString::Format((CString *)v6, "%s%lu", aCom, *v8);
      }
      else
      {
        CString::Right(v5, &Buffer, *(_DWORD *)(*(_DWORD *)v5 - 8) - v7 - strlen(aCom));
        sscanf(Buffer, "%lu", this + 4);
        CString::~CString((CString *)&Buffer);
      }
      return 1;
    case 1u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v9 = this[6];
      v17 = 0;
      sscanf(Buffer, "%lu", this + 6);
      v3 = 1;
      if ( this[1] != -1 && !(unsigned __int8)sub_10004620(this) )
      {
        this[6] = v9;
        v3 = 0;
      }
      v17 = -1;
      p_Buffer = &Buffer;
      goto LABEL_54;
    case 2u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v11 = this[7];
      v17 = 1;
      sscanf(Buffer, "%d", &v16);
      this[7] = v16 == 7;
      v3 = 1;
      if ( this[1] != -1 && !(unsigned __int8)sub_10004620(this) )
      {
        this[7] = v11;
        v3 = 0;
      }
      v17 = -1;
      p_Buffer = &Buffer;
      goto LABEL_54;
    case 3u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v12 = this[9];
      v17 = 2;
      if ( !mbscmp((const unsigned __int8 *)Buffer, &byte_10022228) )
      {
        this[9] = 0;
        v3 = 1;
      }
      if ( !mbscmp((const unsigned __int8 *)Buffer, &byte_10022224) )
      {
        this[9] = 1;
        v3 = 1;
      }
      if ( mbscmp((const unsigned __int8 *)Buffer, &byte_10022220) )
      {
        if ( !v3 )
          goto LABEL_27;
      }
      else
      {
        this[9] = 2;
        v3 = 1;
      }
      if ( this[1] != -1 && !(unsigned __int8)sub_10004620(this) )
      {
        this[9] = v12;
        v3 = 0;
      }
LABEL_27:
      v17 = -1;
      p_Buffer = &Buffer;
      goto LABEL_54;
    case 4u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v13 = this[8];
      v17 = 3;
      if ( !mbscmp((const unsigned __int8 *)Buffer, &byte_1002221C) )
      {
        this[8] = 0;
        v3 = 1;
      }
      if ( mbscmp((const unsigned __int8 *)Buffer, ::a2) )
      {
        if ( !v3 )
          goto LABEL_36;
      }
      else
      {
        this[8] = 1;
        v3 = 1;
      }
      if ( this[1] != -1 && !(unsigned __int8)sub_10004620(this) )
      {
        this[8] = v13;
        v3 = 0;
      }
LABEL_36:
      v17 = -1;
      p_Buffer = &Buffer;
      goto LABEL_54;
    case 5u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v14 = this[11];
      v17 = 4;
      if ( !mbscmp((const unsigned __int8 *)Buffer, Source) )
      {
        this[11] = 0;
        v3 = 1;
      }
      if ( !mbscmp((const unsigned __int8 *)Buffer, aHardware) )
      {
        this[11] = 1;
        v3 = 1;
      }
      if ( mbscmp((const unsigned __int8 *)Buffer, aSoftware) )
      {
        if ( !v3 )
          goto LABEL_47;
      }
      else
      {
        this[11] = 2;
        v3 = 1;
      }
      if ( this[1] != -1 && !(unsigned __int8)sub_10004620(this) )
      {
        this[11] = v14;
        v3 = 0;
      }
LABEL_47:
      v17 = -1;
      p_Buffer = &Buffer;
LABEL_54:
      CString::~CString((CString *)p_Buffer);
      return v3;
    case 6u:
      CString::CString((CString *)&Buffer, (const struct CString *)Buffer);
      v17 = 5;
      sscanf(Buffer, "%x", this + 10);
      v3 = 1;
      if ( this[1] != -1 )
        v3 = (unsigned __int8)sub_10004620(this) != 0;
      v17 = -1;
      p_Buffer = &Buffer;
      goto LABEL_54;
    case 7u:
      CString::CString((CString *)&a2, (const struct CString *)Buffer);
      v17 = 6;
      sscanf(a2, "%x", (char *)this + 41);
      v3 = 1;
      if ( this[1] != -1 )
        v3 = (unsigned __int8)sub_10004620(this) != 0;
      v17 = -1;
      p_Buffer = &a2;
      goto LABEL_54;
    default:
      return v3;
  }
}


/* ==== 10004220  sub_10004220  ()  size=438 ==== */
char __thiscall sub_10004220(int this, int a2, CString *a3)
{
  char result; // al
  int v4; // ecx
  int v5; // ecx

  switch ( a2 )
  {
    case 0:
      CString::operator=(a3, this + 20);
      result = 1;
      break;
    case 1:
      CString::Format(a3, "%lu", *(_DWORD *)(this + 24));
      result = 1;
      break;
    case 2:
      if ( *(_DWORD *)(this + 28) == 1 )
        CString::Format(a3, "%s", a7);
      else
        CString::Format(a3, "%s", a8);
      result = 1;
      break;
    case 3:
      v4 = *(_DWORD *)(this + 36) - 1;
      if ( v4 )
      {
        if ( v4 == 1 )
          CString::Format(a3, "%s", (const char *)&byte_10022220);
        else
          CString::Format(a3, "%s", (const char *)&byte_10022228);
        result = 1;
      }
      else
      {
        CString::Format(a3, "%s", (const char *)&byte_10022224);
        result = 1;
      }
      break;
    case 4:
      if ( *(_DWORD *)(this + 32) == 1 )
        CString::Format(a3, "%s", (const char *)::a2);
      else
        CString::Format(a3, "%s", (const char *)&byte_1002221C);
      result = 1;
      break;
    case 5:
      v5 = *(_DWORD *)(this + 44) - 1;
      if ( v5 )
      {
        if ( v5 == 1 )
          CString::Format(a3, "%s", (const char *)aSoftware);
        else
          CString::Format(a3, "%s", (const char *)Source);
        result = 1;
      }
      else
      {
        CString::Format(a3, "%s", (const char *)aHardware);
        result = 1;
      }
      break;
    case 6:
      CString::Format(a3, "0x%.2X", *(unsigned __int8 *)(this + 40));
      result = 1;
      break;
    case 7:
      CString::Format(a3, "0x%.2X", *(unsigned __int8 *)(this + 41));
      result = 1;
      break;
    default:
      result = 0;
      break;
  }
  return result;
}


/* ==== 10004400  sub_10004400  ()  size=150 ==== */
void __thiscall sub_10004400(int this, unsigned __int16 **a2)
{
  int v3; // eax
  unsigned __int16 *v4; // eax
  _BYTE v5[4]; // [esp+4h] [ebp-10h] BYREF
  int v6; // [esp+10h] [ebp-4h]

  CString::CString((CString *)v5);
  v3 = *(_DWORD *)(this + 4);
  v6 = 0;
  if ( v3 == -1 )
    CString::Format((CString *)v5, "Serial device \"%s\" closed", *(const char **)(this + 20));
  else
    CString::Format(
      (CString *)v5,
      "Serial device \"%s\" open at baud rate %lu",
      *(const char **)(this + 20),
      *(_DWORD *)(this + 24));
  v4 = CString::AllocSysString((CString *)v5);
  v6 = -1;
  *a2 = v4;
  CString::~CString((CString *)v5);
}


/* ==== 100044A0  sub_100044A0  ()  size=304 ==== */
char __thiscall sub_100044A0(_DWORD *this)
{
  unsigned int v2; // edi
  _DWORD *v3; // ebx
  HANDLE FileA; // eax
  void *v5; // esi
  int v6; // eax
  int v7; // eax
  LPCSTR lpFileName; // [esp+0h] [ebp-14h] BYREF
  _BYTE v10[4]; // [esp+4h] [ebp-10h] BYREF
  int v11; // [esp+10h] [ebp-4h]

  CString::CString((CString *)&lpFileName);
  v2 = 0;
  v3 = this + 13;
  v11 = 0;
  this[12] = 0;
  do
  {
    CString::Format((CString *)&lpFileName, "\\\\.\\%s%lu", aCom, v2);
    FileA = CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x40000080u, 0);
    v5 = FileA;
    if ( FileA == (HANDLE)-1 )
    {
      CString::operator=(v3, Str2);
    }
    else
    {
      if ( (unsigned __int8)sub_100045D0(FileA) )
      {
        CString::operator=(v3, Str2);
      }
      else
      {
        v6 = CString::Right(&lpFileName, v10, *((_DWORD *)lpFileName - 2) - 4);
        LOBYTE(v11) = 1;
        CString::operator=(v3, v6);
        LOBYTE(v11) = 0;
        CString::~CString((CString *)v10);
        ++this[12];
      }
      CloseHandle(v5);
    }
    ++v2;
    ++v3;
  }
  while ( v2 < 0x20 );
  v7 = this[12];
  v11 = -1;
  if ( v7 )
  {
    CString::~CString((CString *)&lpFileName);
    return 1;
  }
  else
  {
    CString::~CString((CString *)&lpFileName);
    return 0;
  }
}


/* ==== 100045D0  sub_100045D0  ()  size=71 ==== */
bool __stdcall sub_100045D0(HANDLE hCommDev)
{
  DWORD dwSize; // [esp+0h] [ebp-404h] BYREF
  _COMMCONFIG CC; // [esp+4h] [ebp-400h] BYREF

  dwSize = 1024;
  return GetCommConfig(hCommDev, &CC, &dwSize) && CC.dwProviderSubType == 6;
}


/* ==== 10004620  sub_10004620  ()  size=264 ==== */
bool __thiscall sub_10004620(int this)
{
  void *v2; // eax
  DWORD v3; // eax
  int v4; // eax
  int v5; // eax
  unsigned int v6; // eax
  _COMMTIMEOUTS CommTimeouts; // [esp+Ch] [ebp-30h] BYREF
  struct _DCB DCB; // [esp+20h] [ebp-1Ch] BYREF

  v2 = *(void **)(this + 4);
  if ( v2 == (void *)-1 )
    return 0;
  memset(&CommTimeouts.ReadTotalTimeoutMultiplier, 0, 16);
  CommTimeouts.ReadIntervalTimeout = 1;
  SetCommTimeouts(v2, &CommTimeouts);
  memset(&DCB, 0, sizeof(DCB));
  v3 = *(_DWORD *)(this + 24);
  DCB.DCBlength = 28;
  DCB.BaudRate = v3;
  v4 = *(_DWORD *)(this + 28) - 1;
  DCB.ByteSize = 8;
  if ( !v4 )
    DCB.ByteSize = 7;
  if ( *(_DWORD *)(this + 36) == 1 )
  {
    DCB.Parity = 1;
  }
  else if ( *(_DWORD *)(this + 36) == 2 )
  {
    DCB.Parity = 2;
  }
  else
  {
    DCB.Parity = 0;
  }
  v5 = *(_DWORD *)(this + 32);
  DCB.StopBits = 0;
  if ( v5 == 1 )
    DCB.StopBits = 2;
  HIWORD(v6) = *((_WORD *)&DCB + 5);
  BYTE1(v6) = *((_BYTE *)&DCB + 9) & 0xBF;
  LOBYTE(v6) = *((_BYTE *)&DCB + 8) | 3;
  if ( *(_DWORD *)(this + 44) == 1 )
  {
    v6 = v6 & 0xFFFFCFC3 | 0x202C;
  }
  else
  {
    if ( *(_DWORD *)(this + 44) == 2 )
    {
      *((_DWORD *)&DCB + 2) = v6 & 0xFFFFCCCF | 0x1310;
      DCB.XoffChar = *(_BYTE *)(this + 40);
      DCB.XonChar = DCB.XoffChar;
      return SetCommState(*(HANDLE *)(this + 4), &DCB);
    }
    LOBYTE(v6) = *((_BYTE *)&DCB + 8) & 0xCC | 3;
  }
  *((_DWORD *)&DCB + 2) = v6;
  return SetCommState(*(HANDLE *)(this + 4), &DCB);
}


/* ==== 10004730  sub_10004730  ()  size=355 ==== */
int __cdecl sub_10004730(int a1)
{
  int v1; // esi

  v1 = a1;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) == 2 )
  {
    CString::CString((CString *)&a1);
    CString::operator=(&a1, aCom1);
    (*(void (__thiscall **)(_DWORD, _DWORD, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 0, &a1);
    CString::operator=(&a1, a9600);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 1, &a1);
    CString::operator=(&a1, a8);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 2, &a1);
    CString::operator=(&a1, &byte_10022228);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 3, &a1);
    CString::operator=(&a1, &byte_1002221C);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 4, &a1);
    CString::operator=(&a1, Source);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 5, &a1);
    CString::operator=(&a1, a0x11);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 6, &a1);
    CString::operator=(&a1, a0x13);
    (*(void (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(v1 + 4) + 72))(*(_DWORD *)(v1 + 4), 7, &a1);
    CString::~CString((CString *)&a1);
  }
  *(_DWORD *)(v1 + 12) = 0;
  *(_DWORD *)(v1 + 16) = 1024;
  *(_DWORD *)(v1 + 20) = 30;
  *(_DWORD *)(v1 + 24) = 0;
  return 0;
}


/* ==== 100048A0  sub_100048A0  ()  size=125 ==== */
int __cdecl sub_100048A0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         0,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004920  sub_10004920  ()  size=126 ==== */
int __cdecl sub_10004920(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5, aCom1);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, _DWORD, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 0, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 100049A0  sub_100049A0  ()  size=125 ==== */
int __cdecl sub_100049A0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         1,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004A20  sub_10004A20  ()  size=126 ==== */
int __cdecl sub_10004A20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5, a9600);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 1, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004AA0  sub_10004AA0  ()  size=125 ==== */
int __cdecl sub_10004AA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         2,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004B20  sub_10004B20  ()  size=121 ==== */
int __cdecl sub_10004B20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 2, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004BA0  sub_10004BA0  ()  size=125 ==== */
int __cdecl sub_10004BA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         3,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004C20  sub_10004C20  ()  size=121 ==== */
int __cdecl sub_10004C20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 3, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004CA0  sub_10004CA0  ()  size=125 ==== */
int __cdecl sub_10004CA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         4,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004D20  sub_10004D20  ()  size=121 ==== */
int __cdecl sub_10004D20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 4, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004DA0  sub_10004DA0  ()  size=125 ==== */
int __cdecl sub_10004DA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         5,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004E20  sub_10004E20  ()  size=121 ==== */
int __cdecl sub_10004E20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 5, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004EA0  sub_10004EA0  ()  size=125 ==== */
int __cdecl sub_10004EA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         6,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10004F20  sub_10004F20  ()  size=121 ==== */
int __cdecl sub_10004F20(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 6, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 10004FA0  sub_10004FA0  ()  size=125 ==== */
int __cdecl sub_10004FA0(int a1, char *a2)
{
  CString::CString((CString *)&a2, a2);
  if ( (*(unsigned __int8 (__thiscall **)(_DWORD, int, char **))(**(_DWORD **)(a1 + 4) + 72))(
         *(_DWORD *)(a1 + 4),
         7,
         &a2) )
  {
    CString::~CString((CString *)&a2);
    return 0;
  }
  else
  {
    CString::~CString((CString *)&a2);
    return 5;
  }
}


/* ==== 10005020  sub_10005020  ()  size=121 ==== */
int __cdecl sub_10005020(int a1, char *Buffer, size_t BufferCount)
{
  const char *v3; // ecx
  const char *v5; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v5 = v3;
  CString::CString((CString *)&v5);
  v6 = 0;
  (*(void (__thiscall **)(_DWORD, int, const char **))(**(_DWORD **)(a1 + 4) + 76))(*(_DWORD *)(a1 + 4), 7, &v5);
  snprintf(Buffer, BufferCount, "%s", v5);
  v6 = -1;
  CString::~CString((CString *)&v5);
  return 0;
}


/* ==== 100050A0  sub_100050A0  ()  size=30 ==== */
int __cdecl sub_100050A0(int a1, char *Buffer)
{
  sscanf(Buffer, "%lu", a1 + 12);
  return 0;
}


/* ==== 100050C0  sub_100050C0  ()  size=35 ==== */
int __cdecl sub_100050C0(int a1, char *Buffer, size_t BufferCount)
{
  snprintf(Buffer, BufferCount, "%lu", *(_DWORD *)(a1 + 12));
  return 0;
}


/* ==== 100050F0  sub_100050F0  ()  size=53 ==== */
int __cdecl sub_100050F0(int a1, char *Buffer)
{
  *(_DWORD *)(a1 + 16) = 0;
  sscanf(Buffer, "%u", a1 + 16);
  if ( *(_DWORD *)(a1 + 16) > 0x400u )
    *(_DWORD *)(a1 + 16) = 1024;
  return 0;
}


/* ==== 10005130  sub_10005130  ()  size=69 ==== */
int __cdecl sub_10005130(int a1, unsigned __int8 *Dest, size_t Count)
{
  if ( *(_DWORD *)(a1 + 16) == 1024 )
    mbsnbcpy(Dest, Source, Count);
  else
    snprintf((char *const)Dest, Count, "%u", *(_DWORD *)(a1 + 16));
  return 0;
}


/* ==== 10005180  sub_10005180  ()  size=30 ==== */
int __cdecl sub_10005180(int a1, char *Buffer)
{
  sscanf(Buffer, "%lu", a1 + 20);
  return 0;
}


/* ==== 100051A0  sub_100051A0  ()  size=35 ==== */
int __cdecl sub_100051A0(int a1, char *Buffer, size_t BufferCount)
{
  snprintf(Buffer, BufferCount, "%lu", *(_DWORD *)(a1 + 20));
  return 0;
}


/* ==== 100051D0  sub_100051D0  ()  size=76 ==== */
int __cdecl sub_100051D0(int a1, unsigned __int8 *Str1)
{
  int result; // eax

  if ( mbscmp(Str1, aOn) )
  {
    result = mbscmp(Str1, aOff);
    if ( result )
      return 5;
    else
      *(_DWORD *)(a1 + 24) = 0;
  }
  else
  {
    *(_DWORD *)(a1 + 24) = 1;
    return 0;
  }
  return result;
}


/* ==== 10005220  sub_10005220  ()  size=65 ==== */
int __cdecl sub_10005220(int a1, unsigned __int8 *Dest, size_t Count)
{
  if ( *(_DWORD *)(a1 + 24) )
    mbsnbcpy(Dest, aOn, Count);
  else
    mbsnbcpy(Dest, aOff, Count);
  return 0;
}


/* ==== 10005270  sub_10005270  ()  size=344 ==== */
int __thiscall sub_10005270(int this, int a2, int a3, int a4, int a5)
{
  CMutex *v6; // eax
  CMutex *v7; // eax
  CSingleLock *v8; // eax
  CSingleLock *v9; // eax

  Concurrency::scheduler_worker_creation_error::scheduler_worker_creation_error(
    (Concurrency::scheduler_worker_creation_error *)this,
    (const char *)0x7D3,
    a5);
  CWnd::CWnd((CWnd *)(this + 96));
  *(_DWORD *)(this + 96) = &off_1001D69C;
  CWnd::CWnd((CWnd *)(this + 160));
  *(_DWORD *)(this + 160) = &off_1001D5C4;
  CWnd::CWnd((CWnd *)(this + 224));
  *(_DWORD *)(this + 224) = &off_1001D9F4;
  CString::CString((CString *)(this + 292));
  CString::CString((CString *)(this + 296));
  *(_DWORD *)(this + 312) = a4;
  *(_DWORD *)this = &off_1001D910;
  *(_DWORD *)(this + 288) = a2;
  CString::operator=(this + 292, a3);
  *(_DWORD *)(this + 300) = 0;
  *(_DWORD *)(this + 304) = 0;
  *(_DWORD *)(this + 316) = 0;
  *(_DWORD *)(this + 320) = 0;
  v6 = (CMutex *)operator new(8u);
  if ( v6 )
    v7 = CMutex::CMutex(v6, 1, aListboxAccessM, 0);
  else
    v7 = 0;
  *(_DWORD *)(this + 316) = v7;
  if ( v7 )
  {
    v8 = (CSingleLock *)operator new(0xCu);
    if ( v8 )
      v9 = CSingleLock::CSingleLock(v8, *(struct CSyncObject **)(this + 316), 0);
    else
      v9 = 0;
    *(_DWORD *)(this + 320) = v9;
  }
  return this;
}


/* ==== 100053D0  sub_100053D0  ()  size=30 ==== */
std::ios_base *__thiscall sub_100053D0(std::ios_base *this, char a2)
{
  std::ios_base::~ios_base(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 100053F0  ??1ios_base@std@@UAE@XZ_0  (std::ios_base::~ios_base(void))  size=196 ==== */
void __thiscall std::ios_base::~ios_base(std::ios_base *this)
{
  int v2; // ecx
  void *v3; // edi

  *(_DWORD *)this = &off_1001D910;
  v2 = *((_DWORD *)this + 79);
  if ( v2 )
    (*(void (__thiscall **)(int, int))(*(_DWORD *)v2 + 4))(v2, 1);
  v3 = (void *)*((_DWORD *)this + 80);
  if ( v3 )
  {
    CSingleLock::Unlock(*((CSingleLock **)this + 80));
    operator delete(v3);
  }
  CString::~CString((std::ios_base *)((char *)this + 296));
  CString::~CString((std::ios_base *)((char *)this + 292));
  CComboBox::~CComboBox((std::ios_base *)((char *)this + 224));
  CListBox::~CListBox((std::ios_base *)((char *)this + 160));
  CButton::~CButton((std::ios_base *)((char *)this + 96));
  CDialog::~CDialog(this);
}


/* ==== 100054C0  sub_100054C0  ()  size=70 ==== */
void __thiscall sub_100054C0(int this, struct CDataExchange *a2)
{
  sub_1001A8C9(a2);
  DDX_Control(a2, 2009, (struct CWnd *)(this + 96));
  DDX_Control(a2, 2007, (struct CWnd *)(this + 160));
  DDX_Control(a2, 2008, (struct CWnd *)(this + 224));
}


/* ==== 10005510  sub_10005510  ()  size=6 ==== */
int (**sub_10005510())()
{
  return &off_1001D890;
}


/* ==== 10005520  sub_10005520  ()  size=359 ==== */
int __thiscall sub_10005520(CWnd *this)
{
  WPARAM v2; // ebp
  WPARAM v3; // eax
  _DWORD *v4; // edi
  _DWORD *v5; // eax
  UINT_PTR v6; // eax
  unsigned __int8 *Str1; // [esp+Ch] [ebp-14h] BYREF
  LPARAM lParam; // [esp+10h] [ebp-10h] BYREF
  int v10; // [esp+1Ch] [ebp-4h]

  CString::CString((CString *)&lParam);
  v2 = 0;
  v10 = 0;
  CString::CString((CString *)&Str1);
  LOBYTE(v10) = 1;
  CDialog::OnInitDialog(this);
  CString::Format((CString *)&lParam, "%ld", *((_DWORD *)this + 78));
  v3 = SendMessageA(*((HWND *)this + 64), 0x158u, 0, lParam);
  if ( v3 != -1 )
    SendMessageA(*((HWND *)this + 64), 0x14Eu, v3, 0);
  *((_DWORD *)this + 77) = 0;
  if ( (unsigned __int8)sub_10005830(this) )
  {
    type_info::raw_name(*((type_info **)this + 72));
    v4 = *(_DWORD **)(*((_DWORD *)this + 75) + 4);
    if ( v4 )
    {
      while ( 1 )
      {
        v5 = v4;
        v4 = (_DWORD *)*v4;
        CString::operator=(&Str1, v5 + 2);
        if ( !mbscmp(Str1, *((const unsigned __int8 **)this + 73)) )
          break;
        ++v2;
        if ( !v4 )
          goto LABEL_9;
      }
      *((_DWORD *)this + 77) = v2;
      SendMessageA(*((HWND *)this + 48), 0x186u, v2, 0);
    }
LABEL_9:
    v6 = SetTimer(*((HWND *)this + 8), 1u, 0x1388u, 0);
    *((_DWORD *)this + 76) = v6;
    if ( v6 )
      CWnd::ShowWindow((CWnd *)((char *)this + 96), 0);
    else
      CWnd::ShowWindow((CWnd *)((char *)this + 96), 5);
  }
  LOBYTE(v10) = 0;
  CString::~CString((CString *)&Str1);
  v10 = -1;
  CString::~CString((CString *)&lParam);
  return 1;
}


/* ==== 10005690  sub_10005690  ()  size=43 ==== */
void __thiscall sub_10005690(CDialog *this)
{
  if ( *((_DWORD *)this + 76) )
  {
    KillTimer(*((HWND *)this + 8), *((_DWORD *)this + 76));
    *((_DWORD *)this + 76) = 0;
  }
  CDialog::OnCancel(this);
}


/* ==== 100056C0  sub_100056C0  ()  size=277 ==== */
void __thiscall sub_100056C0(CDialog *this)
{
  UINT_PTR v2; // eax
  LRESULT v3; // eax
  LRESULT v4; // eax
  char *Buffer; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  CString::CString((CString *)&Buffer);
  v2 = *((_DWORD *)this + 76);
  v6 = 0;
  if ( v2 )
  {
    KillTimer(*((HWND *)this + 8), v2);
    *((_DWORD *)this + 76) = 0;
  }
  if ( SendMessageA(*((HWND *)this + 48), 0x18Bu, 0, 0) <= 0 || SendMessageA(*((HWND *)this + 48), 0x188u, 0, 0) == -1 )
  {
    CString::Empty((CDialog *)((char *)this + 296));
  }
  else
  {
    v3 = SendMessageA(*((HWND *)this + 48), 0x188u, 0, 0);
    CListBox::GetText((CDialog *)((char *)this + 160), v3, (CDialog *)((char *)this + 296));
  }
  v4 = SendMessageA(*((HWND *)this + 64), 0x147u, 0, 0);
  CComboBox::GetLBText((CDialog *)((char *)this + 224), v4, (struct CString *)&Buffer);
  sscanf(Buffer, "%ld", (char *)this + 312);
  CDialog::OnOK(this);
  v6 = -1;
  CString::~CString((CString *)&Buffer);
}


/* ==== 100057E0  sub_100057E0  ()  size=7 ==== */
int __thiscall sub_100057E0(_DWORD *this)
{
  return this[74];
}


/* ==== 100057F0  sub_100057F0  ()  size=6 ==== */
void *sub_100057F0()
{
  return &unk_10022358;
}


/* ==== 10005800  sub_10005800  ()  size=6 ==== */
int sub_10005800()
{
  return 2003;
}


/* ==== 10005810  sub_10005810  ()  size=23 ==== */
int __thiscall sub_10005810(CWnd *this)
{
  sub_10007BE0(*((_DWORD *)this + 72));
  return sub_10005830(this);
}


/* ==== 10005830  sub_10005830  ()  size=610 ==== */
char __thiscall sub_10005830(CWnd *this)
{
  signed int cx; // ebp
  HWND v3; // eax
  HDC DC; // eax
  struct CDC *v5; // eax
  int v6; // ecx
  CSingleLock *v7; // ecx
  int v8; // eax
  const char *v10; // eax
  _DWORD *v11; // edi
  _DWORD *v12; // eax
  int v13; // eax
  CWnd *v14; // eax
  CWnd *DlgItem; // eax
  CSingleLock *v16; // esi
  LPARAM lParam; // [esp+8h] [ebp-1Ch] BYREF
  struct CDC *v18; // [esp+Ch] [ebp-18h]
  struct tagSIZE psizl; // [esp+10h] [ebp-14h] BYREF
  int v20; // [esp+20h] [ebp-4h]

  cx = 0;
  CString::CString((CString *)&lParam);
  v3 = (HWND)*((_DWORD *)this + 48);
  v20 = 0;
  DC = GetDC(v3);
  v5 = CDC::FromHandle(DC);
  v6 = *((_DWORD *)this + 72);
  v18 = v5;
  if ( v6 )
    sub_10007BE0(v6);
  sub_10007BC0(*((_DWORD *)this + 72));
  v7 = (CSingleLock *)*((_DWORD *)this + 80);
  if ( v7 )
    CSingleLock::Lock(v7, 0xFAu);
  v8 = *((_DWORD *)this + 80);
  if ( !v8 || *(_DWORD *)(v8 + 8) )
  {
    if ( SendMessageA(*((HWND *)this + 48), 0x18Bu, 0, 0) > 0 )
      SendMessageA(*((HWND *)this + 48), 0x184u, 0, 0);
    v10 = type_info::raw_name(*((type_info **)this + 72));
    *((_DWORD *)this + 75) = v10;
    if ( v10 )
    {
      v11 = (_DWORD *)*((_DWORD *)v10 + 1);
      while ( v11 )
      {
        v12 = v11;
        v11 = (_DWORD *)*v11;
        CString::operator=(&lParam, v12 + 2);
        SendMessageA(*((HWND *)this + 48), 0x180u, 0, lParam);
        GetTextExtentPoint32A(*((HDC *)v18 + 2), (LPCSTR)lParam, *(_DWORD *)(lParam - 8), &psizl);
        if ( psizl.cx > cx )
          cx = psizl.cx;
      }
      if ( *(int *)(*((_DWORD *)this + 75) + 12) <= 0 )
      {
        DlgItem = CWnd::GetDlgItem(this, 1);
        if ( DlgItem )
          CWnd::EnableWindow(DlgItem, 0);
      }
      else
      {
        ReleaseDC(*((HWND *)this + 48), *((HDC *)v18 + 1));
        SendMessageA(*((HWND *)this + 48), 0x194u, cx, 0);
        v13 = *(_DWORD *)(*((_DWORD *)this + 75) + 12);
        if ( *((_DWORD *)this + 77) > (unsigned int)(v13 - 1) )
          *((_DWORD *)this + 77) = v13 - 1;
        SendMessageA(*((HWND *)this + 48), 0x186u, *((_DWORD *)this + 77), 0);
        v14 = CWnd::GetDlgItem(this, 1);
        if ( v14 )
          CWnd::EnableWindow(v14, 1);
      }
      CWnd::UpdateData(this, 0);
    }
    else
    {
      if ( *((_DWORD *)this + 76) )
      {
        KillTimer(*((HWND *)this + 8), *((_DWORD *)this + 76));
        *((_DWORD *)this + 76) = 0;
      }
      CWnd::MessageBoxA(this, aSci, aUnableToScanTh_0, 0);
      (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 208))(this);
    }
    v16 = (CSingleLock *)*((_DWORD *)this + 80);
    if ( v16 )
      CSingleLock::Unlock(v16);
    v20 = -1;
    CString::~CString((CString *)&lParam);
    return 1;
  }
  else
  {
    CWnd::MessageBoxA(this, aAnotherApplica, aError, 0);
    (*(void (__thiscall **)(CWnd *))(*(_DWORD *)this + 208))(this);
    v20 = -1;
    CString::~CString((CString *)&lParam);
    return 0;
  }
}


/* ==== 10005AA0  sub_10005AA0  ()  size=33 ==== */
int __thiscall sub_10005AA0(CWnd *this, int a2)
{
  if ( a2 == *((_DWORD *)this + 76) )
    sub_10005810(this);
  return CWnd::Default(this);
}


/* ==== 10005AD0  sub_10005AD0  ()  size=111 ==== */
LRESULT __thiscall sub_10005AD0(int this)
{
  CSingleLock *v2; // ecx
  LRESULT result; // eax
  CSingleLock *v4; // ecx

  v2 = *(CSingleLock **)(this + 320);
  if ( v2 )
    CSingleLock::Lock(v2, 0x3E8u);
  result = *(_DWORD *)(this + 320);
  if ( !result || *(_DWORD *)(result + 8) )
  {
    result = SendMessageA(*(HWND *)(this + 192), 0x18Bu, 0, 0);
    if ( result > 0 )
    {
      result = SendMessageA(*(HWND *)(this + 192), 0x188u, 0, 0);
      *(_DWORD *)(this + 308) = result;
    }
    v4 = *(CSingleLock **)(this + 320);
    if ( v4 )
      return CSingleLock::Unlock(v4);
  }
  return result;
}


/* ==== 10005B40  sub_10005B40  ()  size=8 ==== */
int __thiscall sub_10005B40(void *this)
{
  return (*(int (__thiscall **)(void *))(*(_DWORD *)this + 204))(this);
}


/* ==== 10005B50  sub_10005B50  ()  size=30 ==== */
CComboBox *__thiscall sub_10005B50(CComboBox *this, char a2)
{
  CComboBox::~CComboBox(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10005B70  sub_10005B70  ()  size=58 ==== */
_DWORD *__thiscall sub_10005B70(_DWORD *this)
{
  *this = &off_1001DAC4;
  this[1] = -1;
  this[3] = 0;
  this[2] = GetVersion() < 0x80000000;
  return this;
}


/* ==== 10005BD0  sub_10005BD0  ()  size=11 ==== */
int __thiscall sub_10005BD0(_DWORD *this)
{
  *this = &off_1001DAC4;
  return sub_10005C00();
}


/* ==== 10005BE0  ?underflow@?$basic_streambuf@DU?$char_traits@D@std@@@std@@MAEHXZ  (std::basic_streambuf<char,std::char_traits<char>>::underflow(void))  size=4 ==== */
int std::streambuf::underflow()
{
  return -1;
}


/* ==== 10005BF0  sub_10005BF0  ()  size=8 ==== */
bool __thiscall sub_10005BF0(_DWORD *this)
{
  return this[1] != -1;
}


/* ==== 10005C00  sub_10005C00  ()  size=27 ==== */
HANDLE __thiscall sub_10005C00(HANDLE *this)
{
  HANDLE result; // eax

  result = this[1];
  if ( result != (HANDLE)-1 )
  {
    result = (HANDLE)CloseHandle(this[1]);
    this[1] = (HANDLE)-1;
  }
  return result;
}


/* ==== 10005C20  sub_10005C20  ()  size=4 ==== */
int __thiscall sub_10005C20(_DWORD *this)
{
  return this[3];
}


/* ==== 10005C30  sub_10005C30  ()  size=67 ==== */
int __thiscall sub_10005C30(
        _DWORD *this,
        int a2,
        LPVOID lpBuffer,
        DWORD nNumberOfBytesToRead,
        LPOVERLAPPED lpOverlapped)
{
  bool v5; // zf
  int result; // eax
  void *v7; // [esp-14h] [ebp-1Ch]
  DWORD NumberOfBytesRead; // [esp+4h] [ebp-4h] BYREF

  v7 = (void *)this[1];
  NumberOfBytesRead = 0;
  if ( ReadFile(v7, lpBuffer, nNumberOfBytesToRead, &NumberOfBytesRead, lpOverlapped) )
    return 0;
  v5 = GetLastError() == 997;
  result = 1;
  if ( !v5 )
    return 0;
  return result;
}


/* ==== 10005C80  sub_10005C80  ()  size=61 ==== */
int __thiscall sub_10005C80(
        HANDLE *this,
        int a2,
        LPCVOID lpBuffer,
        DWORD nNumberOfBytesToWrite,
        struct _OVERLAPPED *NumberOfBytesWritten)
{
  bool v5; // zf
  int result; // eax

  if ( WriteFile(this[1], lpBuffer, nNumberOfBytesToWrite, (LPDWORD)&NumberOfBytesWritten, NumberOfBytesWritten) )
    return 0;
  v5 = GetLastError() == 997;
  result = 1;
  if ( !v5 )
    return 0;
  return result;
}


/* ==== 10005CC0  sub_10005CC0  ()  size=80 ==== */
char __thiscall sub_10005CC0(int this, LPOVERLAPPED lpOverlapped, _DWORD *a3)
{
  BOOL v4; // eax
  struct _OVERLAPPED *v5; // edi
  char v6; // bl

  v4 = 0;
  v5 = lpOverlapped;
  v6 = 1;
  if ( !*(_DWORD *)(this + 8) )
  {
    SetEvent(lpOverlapped->hEvent);
    v4 = 1;
  }
  if ( !GetOverlappedResult(*(HANDLE *)(this + 4), v5, (LPDWORD)&lpOverlapped, v4) )
    v6 = 0;
  if ( a3 )
    *a3 = lpOverlapped;
  return v6;
}


/* ==== 10005D10  sub_10005D10  ()  size=11 ==== */
BOOL __thiscall sub_10005D10(HANDLE *this)
{
  return CancelIo(this[1]);
}


/* ==== 10005D20  sub_10005D20  ()  size=5 ==== */
char __stdcall sub_10005D20(int a1, int a2)
{
  return 0;
}


/* ==== 10005D30  sub_10005D30  ()  size=15 ==== */
char __stdcall sub_10005D30(int a1, int a2, int a3, int a4, _DWORD *a5, int a6)
{
  *a5 = 0;
  return 0;
}


/* ==== 10005D40  sub_10005D40  ()  size=48 ==== */
char __stdcall sub_10005D40(_WORD *a1)
{
  a1[1] = 0;
  *a1 = 0;
  CString::operator=(a1 + 2, Str2);
  CString::operator=(a1 + 4, aNoSerialNumber);
  return 0;
}


/* ==== 10005D70  sub_10005D70  ()  size=19 ==== */
char __stdcall sub_10005D70(int a1, _DWORD *a2)
{
  if ( a2 )
    *a2 = 0;
  return 0;
}


/* ==== 10005D90  sub_10005D90  ()  size=106 ==== */
void __thiscall sub_10005D90(void *this, unsigned __int16 **a2)
{
  unsigned __int16 *v2; // eax
  void *v3; // [esp+0h] [ebp-10h] BYREF
  int v4; // [esp+Ch] [ebp-4h]

  v3 = this;
  CString::CString((CString *)&v3);
  v4 = 0;
  CString::Format((CString *)&v3, aErrorUsingDriv);
  v2 = CString::AllocSysString((CString *)&v3);
  v4 = -1;
  *a2 = v2;
  CString::~CString((CString *)&v3);
}


/* ==== 10005E00  sub_10005E00  ()  size=263 ==== */
char __thiscall sub_10005E00(_DWORD *this, HWND a2)
{
  struct CWnd *v3; // esi
  struct AFX_MODULE_STATE *v4; // eax
  Concurrency::details::UMSSchedulerProxy *v5; // eax
  Concurrency::details::UMSSchedulerProxy *v6; // esi
  char v8; // [esp+Fh] [ebp-31h]
  _DWORD v9[2]; // [esp+10h] [ebp-30h] BYREF
  _BYTE v10[28]; // [esp+18h] [ebp-28h] BYREF
  int v11; // [esp+3Ch] [ebp-4h]
  HWND v12; // [esp+44h] [ebp+4h]
  HWND v13; // [esp+44h] [ebp+4h]

  v8 = 0;
  v3 = 0;
  CStringList::CStringList((CStringList *)v10, 10);
  v11 = 0;
  if ( a2 )
    v3 = CWnd::FromHandle(a2);
  v4 = (struct AFX_MODULE_STATE *)sub_1001ADDD();
  AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)v9, v4);
  LOBYTE(v11) = 1;
  if ( v3 )
  {
    v12 = (HWND)operator new(0xE4u);
    LOBYTE(v11) = 2;
    if ( v12 )
    {
      v5 = (Concurrency::details::UMSSchedulerProxy *)sub_10006060(v3);
      goto LABEL_9;
    }
  }
  else
  {
    v13 = (HWND)operator new(0xE4u);
    LOBYTE(v11) = 3;
    if ( v13 )
    {
      v5 = (Concurrency::details::UMSSchedulerProxy *)sub_10006060(0);
      goto LABEL_9;
    }
  }
  v5 = 0;
LABEL_9:
  v6 = v5;
  LOBYTE(v11) = 1;
  if ( v5 )
  {
    if ( (*(int (__thiscall **)(Concurrency::details::UMSSchedulerProxy *))(*(_DWORD *)v5 + 192))(v5) == 1 )
    {
      this[3] = Concurrency::details::UMSSchedulerProxy::GetTransferListEvent(v6);
      v8 = 1;
    }
    (*(void (__thiscall **)(Concurrency::details::UMSSchedulerProxy *, int))(*(_DWORD *)v6 + 4))(v6, 1);
  }
  v11 = -1;
  *(_DWORD *)(v9[1] + 4) = v9[0];
  CStringList::~CStringList((CStringList *)v10);
  return v8;
}


/* ==== 10005F10  sub_10005F10  ()  size=210 ==== */
int __cdecl sub_10005F10(int a1, unsigned __int8 *Str1)
{
  int v2; // eax

  if ( !mbscmp(Str1, Source) )
  {
    if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) )
    {
      if ( !(*(unsigned __int8 (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 16))(*(_DWORD *)(a1 + 4)) )
      {
        v2 = sub_100078E0(0);
        goto LABEL_14;
      }
      return 5;
    }
    return 0;
  }
  if ( !mbscmp(Str1, (const unsigned __int8 *)aSerial) )
  {
    if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) != 2 )
    {
      if ( (*(unsigned __int8 (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 16))(*(_DWORD *)(a1 + 4)) )
        return 5;
      if ( !sub_100078E0(2) )
        return 6;
    }
    return 0;
  }
  if ( mbscmp(Str1, (const unsigned __int8 *)aUsb) )
    return 5;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) == 1 )
    return 0;
  if ( !(*(unsigned __int8 (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 16))(*(_DWORD *)(a1 + 4)) )
  {
    v2 = sub_100078E0(1);
LABEL_14:
    if ( !v2 )
      return 6;
    return 0;
  }
  return 5;
}


/* ==== 10005FF0  sub_10005FF0  ()  size=99 ==== */
int __cdecl sub_10005FF0(int a1, unsigned __int8 *Dest, size_t Count)
{
  int v3; // eax

  v3 = (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) - 1;
  if ( v3 )
  {
    if ( v3 == 1 )
      mbsnbcpy(Dest, (const unsigned __int8 *)aSerial, Count);
    else
      mbsnbcpy(Dest, Source, Count);
    return 0;
  }
  else
  {
    mbsnbcpy(Dest, (const unsigned __int8 *)aUsb, Count);
    return 0;
  }
}


/* ==== 10006060  sub_10006060  ()  size=130 ==== */
_DWORD *__thiscall sub_10006060(_DWORD *this, int a2)
{
  Concurrency::scheduler_worker_creation_error::scheduler_worker_creation_error(
    (Concurrency::scheduler_worker_creation_error *)this,
    (const char *)0x7D5,
    a2);
  CWnd::CWnd((CWnd *)(this + 24));
  this[24] = &off_1001D69C;
  CWnd::CWnd((CWnd *)(this + 40));
  this[40] = &off_1001D69C;
  *this = &off_1001DB80;
  this[56] = 0;
  return this;
}


/* ==== 100060F0  sub_100060F0  ()  size=30 ==== */
CDialog *__thiscall sub_100060F0(CDialog *this, char a2)
{
  sub_10006110(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10006110  sub_10006110  ()  size=92 ==== */
void __thiscall sub_10006110(CDialog *this)
{
  CButton::~CButton((CDialog *)((char *)this + 160));
  CButton::~CButton((CDialog *)((char *)this + 96));
  CDialog::~CDialog(this);
}


/* ==== 10006170  sub_10006170  ()  size=52 ==== */
void __thiscall sub_10006170(int this, struct CDataExchange *a2)
{
  sub_1001A8C9(a2);
  DDX_Control(a2, 2011, (struct CWnd *)(this + 96));
  DDX_Control(a2, 2010, (struct CWnd *)(this + 160));
}


/* ==== 100061B0  sub_100061B0  ()  size=6 ==== */
int (**sub_100061B0())()
{
  return &off_1001DB30;
}


/* ==== 100061C0  sub_100061C0  ()  size=37 ==== */
int __thiscall sub_100061C0(HWND *this)
{
  CDialog::OnInitDialog((CDialog *)this);
  SendMessageA(this[32], 0xF1u, 1u, 0);
  return 1;
}


/* ==== 100061F0  sub_100061F0  ()  size=11 ==== */
void __thiscall sub_100061F0(_DWORD *this)
{
  this[56] = 1;
}


/* ==== 10006200  sub_10006200  ()  size=11 ==== */
void __thiscall sub_10006200(_DWORD *this)
{
  this[56] = 2;
}


/* ==== 10006210  ?GetTransferListEvent@UMSSchedulerProxy@details@Concurrency@@QBEPAXXZ  (Concurrency::details::UMSSchedulerProxy::GetTransferListEvent(void))  size=7 ==== */
void *__thiscall Concurrency::details::UMSSchedulerProxy::GetTransferListEvent(
        Concurrency::details::UMSSchedulerProxy *this)
{
  return (void *)*((_DWORD *)this + 56);
}


/* ==== 10006220  sub_10006220  ()  size=6 ==== */
void *sub_10006220()
{
  return &unk_100223D0;
}


/* ==== 10006230  sub_10006230  ()  size=6 ==== */
int sub_10006230()
{
  return 2005;
}


/* ==== 10006240  sub_10006240  ()  size=8 ==== */
int __thiscall sub_10006240(void *this)
{
  return (*(int (__thiscall **)(void *))(*(_DWORD *)this + 228))(this);
}


/* ==== 10006250  ??_9@$BOI@AE  ([thunk]: `vcall'{232,{flat}})  size=8 ==== */
int __thiscall  __thiscall `vcall'{232,{flat}}(void *this)
{
  return (*(int (__thiscall **)(void *))(*(_DWORD *)this + 232))(this);
}


/* ==== 10006260  sub_10006260  ()  size=108 ==== */
int __thiscall sub_10006260(int this)
{
  CString::CString((CString *)this);
  memset((void *)(this + 4), 0, 0x400u);
  *(_DWORD *)(this + 1040) = 0;
  *(_DWORD *)(this + 1036) = 0;
  *(_DWORD *)(this + 1028) = 0;
  *(_BYTE *)(this + 1032) = 0;
  CString::operator=(this, aNoError_0);
  return this;
}


/* ==== 100062D0  sub_100062D0  ()  size=13 ==== */
int __thiscall sub_100062D0(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  this[259] = a2;
  return result;
}


/* ==== 100062E0  sub_100062E0  ()  size=13 ==== */
int __thiscall sub_100062E0(_DWORD *this, int a2)
{
  int result; // eax

  result = a2;
  this[260] = a2;
  return result;
}


/* ==== 100062F0  sub_100062F0  ()  size=76 ==== */
int __thiscall sub_100062F0(CString *this, char *a2)
{
  int result; // eax
  char *v4; // edi
  char i; // cl

  result = 0;
  if ( !*((_DWORD *)this + 259) )
    return 2;
  v4 = a2;
  *((_BYTE *)this + 1032) = 0;
  *((_DWORD *)this + 257) = 0;
  for ( i = *a2; *v4; i = *v4 )
  {
    ++v4;
    result = sub_10006440(this, i);
    if ( result )
      break;
  }
  return result;
}


/* ==== 10006340  sub_10006340  ()  size=221 ==== */
int __thiscall sub_10006340(_DWORD *this, char *Buffer, size_t BufferCount)
{
  int v4; // edi
  _DWORD *v5; // eax
  int v9; // eax
  int v10; // [esp+8h] [ebp-408h]
  int v11; // [esp+8h] [ebp-408h]
  int v12; // [esp+Ch] [ebp-404h]
  char v13[1024]; // [esp+10h] [ebp-400h] BYREF

  v4 = 0;
  v5 = (_DWORD *)this[259];
  v12 = 0;
  v10 = 0;
  if ( !v5 )
    return 2;
  if ( !v5[1] )
    return v10;
  while ( 1 )
  {
    v11 = (*(int (__cdecl **)(_DWORD, char *, int))(*v5 + v4 + 8))(this[260], v13, 1024);
    if ( !v11 )
      break;
LABEL_7:
    v5 = (_DWORD *)this[259];
    v4 += 12;
    if ( (unsigned int)++v12 >= v5[1] )
      return v11;
  }
  v9 = snprintf(Buffer, BufferCount, "%c%s%c%s%c", 60, *(const char **)(*(_DWORD *)this[259] + v4), 124, v13, 62);
  if ( v9 > 0 )
  {
    Buffer += v9;
    BufferCount -= v9;
    goto LABEL_7;
  }
  return 7;
}


/* ==== 10006420  sub_10006420  ()  size=29 ==== */
int __thiscall sub_10006420(void *this, int a2)
{
  CString::operator=(a2, this);
  return CString::operator=(this, aNoError_0);
}


/* ==== 10006440  sub_10006440  ()  size=263 ==== */
int __thiscall sub_10006440(CString *this, char a2)
{
  int result; // eax
  unsigned int v4; // ecx
  int v5; // edi

  result = 0;
  if ( a2 == 60 )
  {
    *((_BYTE *)this + 1032) = 1;
    *((_DWORD *)this + 257) = 0;
  }
  else if ( a2 == 62 )
  {
    if ( *((_BYTE *)this + 1032) )
    {
      *((_BYTE *)this + *((_DWORD *)this + 257) + 4) = 0;
      v5 = sub_10006550(this);
      switch ( v5 )
      {
        case 3:
          CString::Format(this, "Unknown configuration key word \"%s\"", (const char *)this + 4);
          result = 3;
          *((_BYTE *)this + 1032) = 0;
          return result;
        case 4:
          CString::Format(this, aConfigurationP);
          result = 4;
          *((_BYTE *)this + 1032) = 0;
          return result;
        case 5:
          CString::Format(this, "Bad configuration parameter for key word \"%s\"", (const char *)this + 4);
          result = 5;
          *((_BYTE *)this + 1032) = 0;
          return result;
      }
    }
    else
    {
      v5 = 3;
    }
    result = v5;
    *((_BYTE *)this + 1032) = 0;
  }
  else if ( *((_BYTE *)this + 1032) )
  {
    v4 = *((_DWORD *)this + 257);
    if ( v4 >= 0x3FF )
    {
      *((_BYTE *)this + 1032) = 0;
      return 4;
    }
    else
    {
      *((_BYTE *)this + v4 + 4) = a2;
      ++*((_DWORD *)this + 257);
    }
  }
  return result;
}


/* ==== 10006550  sub_10006550  ()  size=164 ==== */
int __thiscall sub_10006550(const char *this)
{
  const char *v2; // ebp
  _BYTE *v3; // eax
  _DWORD *v4; // eax
  int v5; // esi
  int i; // edi
  _BYTE *v8; // [esp+10h] [ebp-4h]

  v2 = this + 4;
  v3 = memchr(this + 4, 124, strlen(this + 4));
  v8 = v3;
  if ( v3 )
  {
    *v3 = 0;
    v8 = v3 + 1;
  }
  if ( !strlen(v2) )
    return 3;
  v4 = (_DWORD *)*((_DWORD *)this + 259);
  v5 = 0;
  if ( !v4[1] )
    return 3;
  for ( i = 0; mbscmp((const unsigned __int8 *)v2, *(const unsigned __int8 **)(*v4 + i)); i += 12 )
  {
    v4 = (_DWORD *)*((_DWORD *)this + 259);
    if ( (unsigned int)++v5 >= v4[1] )
      return 3;
  }
  return (*(int (__cdecl **)(_DWORD, _BYTE *))(**((_DWORD **)this + 259) + 12 * v5 + 4))(*((_DWORD *)this + 260), v8);
}


/* ==== 10006600  sub_10006600  ()  size=251 ==== */
_DWORD *__thiscall sub_10006600(_DWORD *this)
{
  _DWORD *v2; // edi
  _DWORD *v3; // eax
  _DWORD *v4; // eax

  v2 = this + 8;
  *this = &off_1001DCAC;
  sub_10006260((int)(this + 8));
  CString::CString((CString *)(this + 271));
  CString::CString((CString *)(this + 273));
  CString::CString((CString *)(this + 274));
  *this = &off_1001DC6C;
  this[275] = -1;
  this[276] = 0;
  sub_100062E0(v2, (int)this);
  v3 = operator new(0x10u);
  if ( v3 )
    v4 = sub_10005B70(v3);
  else
    v4 = 0;
  this[1] = v4;
  sub_100062D0(v2, (int)&off_1001DB28);
  this[269] = 0;
  this[270] = 0;
  this[2] = 0;
  this[3] = 0;
  this[4] = 1024;
  this[5] = 30;
  this[6] = 0;
  this[7] = 0;
  return this;
}


/* ==== 10006700  sub_10006700  ()  size=30 ==== */
void *__thiscall sub_10006700(void *this, char a2)
{
  sub_10006730();
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10006720  j_??1CString@@QAE@XZ  (CString::~CString(void))  size=5 ==== */
// attributes: thunk
void __thiscall CString::~CString(CString *this)
{
  ??1CString@@QAE@XZ(this);
}


/* ==== 10006730  sub_10006730  ()  size=155 ==== */
void __thiscall sub_10006730(_DWORD *this)
{
  void (__thiscall ***v2)(_DWORD, int); // ecx

  *this = &off_1001DC6C;
  sub_10007370(this);
  v2 = (void (__thiscall ***)(_DWORD, int))this[1];
  if ( v2 )
    (**v2)(v2, 1);
  sub_1000C580();
  CString::~CString((CString *)(this + 274));
  CString::~CString((CString *)(this + 273));
  CString::~CString((CString *)(this + 271));
  CString::~CString((CString *)(this + 8));
}


/* ==== 100067D0  sub_100067D0  ()  size=168 ==== */
int __stdcall sub_100067D0(int a1, const void *a2, _DWORD *a3)
{
  *a3 = 0;
  if ( memcmp(a2, &unk_1001E3C0, 0x10u)
    && memcmp(a2, &unk_1001DEA8, 0x10u)
    && memcmp(a2, &unk_1001DED8, 0x10u)
    && memcmp(a2, &unk_1001DF08, 0x10u)
    && memcmp(a2, &unk_1001DF38, 0x10u)
    && memcmp(a2, &unk_1001DF48, 0x10u)
    && memcmp(a2, &unk_1001DF58, 0x10u) )
  {
    return -2147467262;
  }
  *a3 = a1;
  return 0;
}


/* ==== 10006880  sub_10006880  ()  size=8 ==== */
int __stdcall sub_10006880(int a1)
{
  return 1;
}


/* ==== 10006890  ?GetLenWritten@E8A_USB@@QAEHH@Z  (E8A_USB::GetLenWritten(int))  size=5 ==== */
int __thiscall E8A_USB::GetLenWritten(E8A_USB *this, int a2)
{
  return 0;
}


/* ==== 100068A0  sub_100068A0  ()  size=1413 ==== */
int __stdcall sub_100068A0(int a1, unsigned __int16 *a2)
{
  struct AFX_MODULE_STATE *v2; // eax
  int v3; // eax
  int v4; // eax
  int v5; // eax
  unsigned __int8 *v6; // ecx
  int v7; // eax
  unsigned __int8 *v8; // eax
  int v9; // eax
  unsigned __int8 *v10; // ecx
  int v11; // eax
  unsigned __int8 *v12; // eax
  unsigned __int8 *v14; // [esp+0h] [ebp-54h]
  unsigned __int8 *Str1; // [esp+10h] [ebp-44h] BYREF
  int v16; // [esp+14h] [ebp-40h] BYREF
  int v17; // [esp+18h] [ebp-3Ch] BYREF
  int v18; // [esp+1Ch] [ebp-38h]
  _BYTE v19[8]; // [esp+20h] [ebp-34h] BYREF
  _BYTE v20[32]; // [esp+28h] [ebp-2Ch] BYREF
  int v21; // [esp+50h] [ebp-4h]

  v2 = (struct AFX_MODULE_STATE *)sub_1001ADDD();
  AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)&v17, v2);
  v21 = 0;
  sub_10008150(v19);
  LOBYTE(v21) = 1;
  CString::CString((CString *)&a2, a2);
  LOBYTE(v21) = 2;
  sub_10008210(&a2);
  LOBYTE(v21) = 1;
  CString::~CString((CString *)&a2);
  std::ios_base::~ios_base((std::ios_base *)v20);
  LOBYTE(v21) = 3;
  CString::CString((CString *)&Str1);
  LOBYTE(v21) = 4;
  sub_10008220(0, v20);
  v3 = sub_10007CF0(v20);
  CString::operator=(&Str1, v3);
  if ( mbscmp(Str1, (const unsigned __int8 *)aVersion) )
  {
    *(_DWORD *)(a1 + 1080) = 8195;
    CString::operator=(a1 + 1084, aExpectingVersi);
  }
  else
  {
    sub_10007E00(&v16);
    sub_10008220(1, v20);
    v4 = sub_10007CF0(v20);
    CString::operator=(&Str1, v4);
    if ( !mbscmp(Str1, (const unsigned __int8 *)aInterface) )
    {
      sub_10007DE0(&Str1);
      if ( mbscmp(Str1, (const unsigned __int8 *)aUsb) )
      {
        if ( mbscmp(Str1, (const unsigned __int8 *)aSerial) )
        {
          v14 = Str1;
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::Format(
            (CString *)(a1 + 1084),
            "Interface type \"%s\" is not supported by this DLL",
            (const char *)v14);
          goto LABEL_31;
        }
        if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) != 2 && !sub_100078E0(2) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aFailedToCreate_0);
          goto LABEL_31;
        }
        sub_10008220(2, v20);
        v9 = sub_10007CF0(v20);
        CString::operator=(&Str1, v9);
        if ( mbscmp(Str1, (const unsigned __int8 *)aBaud) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aExpectingBaud);
          goto LABEL_31;
        }
        sub_10007DE0(&Str1);
        if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int, unsigned __int8 **))(**(_DWORD **)(a1 + 4) + 72))(
                *(_DWORD *)(a1 + 4),
                1,
                &Str1) )
        {
          v10 = Str1;
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::Format((CString *)(a1 + 1084), "Failed to set baudrate to \"%s\"", v10);
          goto LABEL_31;
        }
        sub_10008220(3, v20);
        v11 = sub_10007CF0(v20);
        CString::operator=(&Str1, v11);
        if ( mbscmp(Str1, (const unsigned __int8 *)aPortname) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aExpectingPortn);
          goto LABEL_31;
        }
        sub_10007DE0(&Str1);
        if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, unsigned __int8 **))(**(_DWORD **)(a1 + 4) + 72))(
                *(_DWORD *)(a1 + 4),
                0,
                &Str1) )
        {
          v12 = Str1;
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::Format((CString *)(a1 + 1084), "Failed to set port name to \"%s\"", v12);
          goto LABEL_31;
        }
      }
      else
      {
        if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) != 1 && !sub_100078E0(1) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aFailedToCreate);
          goto LABEL_31;
        }
        sub_10008220(2, v20);
        v5 = sub_10007CF0(v20);
        CString::operator=(&Str1, v5);
        if ( mbscmp(Str1, (const unsigned __int8 *)aProduct) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aExpectingProdu);
          goto LABEL_31;
        }
        sub_10007DE0(&Str1);
        if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, unsigned __int8 **))(**(_DWORD **)(a1 + 4) + 72))(
                *(_DWORD *)(a1 + 4),
                0,
                &Str1) )
        {
          v6 = Str1;
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::Format((CString *)(a1 + 1084), "Failed to set USB PID or name to \"%s\"", v6);
          goto LABEL_31;
        }
        sub_10008220(3, v20);
        v7 = sub_10007CF0(v20);
        CString::operator=(&Str1, v7);
        if ( mbscmp(Str1, (const unsigned __int8 *)aBusid) )
        {
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::operator=(a1 + 1084, aExpectingBusid);
          goto LABEL_31;
        }
        sub_10007DE0(&Str1);
        if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int, unsigned __int8 **))(**(_DWORD **)(a1 + 4) + 72))(
                *(_DWORD *)(a1 + 4),
                1,
                &Str1) )
        {
          v8 = Str1;
          *(_DWORD *)(a1 + 1080) = 8195;
          CString::Format((CString *)(a1 + 1084), "Failed to set USB instance or serial number to \"%s\"", v8);
          goto LABEL_31;
        }
      }
      LOBYTE(v21) = 3;
      CString::~CString((CString *)&Str1);
      LOBYTE(v21) = 1;
      sub_10007C80(v20);
      LOBYTE(v21) = 0;
      sub_100081C0(v19);
      *(_DWORD *)(v18 + 4) = v17;
      return 0;
    }
    *(_DWORD *)(a1 + 1080) = 8195;
    CString::operator=(a1 + 1084, aExpectingInter);
  }
LABEL_31:
  LOBYTE(v21) = 3;
  CString::~CString((CString *)&Str1);
  LOBYTE(v21) = 1;
  sub_10007C80(v20);
  LOBYTE(v21) = 0;
  sub_100081C0(v19);
  *(_DWORD *)(v18 + 4) = v17;
  return -2147467259;
}


/* ==== 10006E30  sub_10006E30  ()  size=788 ==== */
int __stdcall sub_10006E30(int a1, unsigned __int16 **a2)
{
  int v2; // esi
  CString *v3; // eax
  unsigned __int16 *v4; // eax
  _BYTE v6[4]; // [esp+10h] [ebp-3Ch] BYREF
  _BYTE v7[4]; // [esp+14h] [ebp-38h] BYREF
  _BYTE v8[8]; // [esp+18h] [ebp-34h] BYREF
  _BYTE v9[32]; // [esp+20h] [ebp-2Ch] BYREF
  int v10; // [esp+48h] [ebp-4h]

  sub_10008150(v8);
  v10 = 0;
  std::ios_base::~ios_base((std::ios_base *)v9);
  LOBYTE(v10) = 1;
  CString::CString((CString *)v6);
  LOBYTE(v10) = 2;
  CString::CString((CString *)v7, aVersion);
  LOBYTE(v10) = 3;
  sub_10007CE0(v7);
  LOBYTE(v10) = 2;
  CString::~CString((CString *)v7);
  sub_10007DA0(1, 0);
  sub_10008630(v9);
  CString::CString((CString *)v7, aInterface);
  LOBYTE(v10) = 4;
  sub_10007CE0(v7);
  LOBYTE(v10) = 2;
  CString::~CString((CString *)v7);
  v2 = a1;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) == 1 )
  {
    CString::CString((CString *)&a1, aUsb);
    LOBYTE(v10) = 5;
    sub_10007D00(&a1, 0);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    sub_10008630(v9);
    CString::CString((CString *)&a1, aProduct);
    LOBYTE(v10) = 6;
    sub_10007CE0(&a1);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    (*(void (__thiscall **)(_DWORD, _DWORD, _BYTE *))(**(_DWORD **)(v2 + 4) + 76))(*(_DWORD *)(v2 + 4), 0, v6);
    sub_10007D00(v6, 0);
    sub_10008630(v9);
    CString::CString((CString *)&a1, aBusid);
    LOBYTE(v10) = 7;
    sub_10007CE0(&a1);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    (*(void (__thiscall **)(_DWORD, int, _BYTE *))(**(_DWORD **)(v2 + 4) + 76))(*(_DWORD *)(v2 + 4), 1, v6);
  }
  else
  {
    CString::CString((CString *)&a1, aSerial);
    LOBYTE(v10) = 8;
    sub_10007D00(&a1, 0);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    sub_10008630(v9);
    CString::CString((CString *)&a1, aBaud);
    LOBYTE(v10) = 9;
    sub_10007CE0(&a1);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    (*(void (__thiscall **)(_DWORD, int, _BYTE *))(**(_DWORD **)(v2 + 4) + 76))(*(_DWORD *)(v2 + 4), 1, v6);
    sub_10007D00(v6, 0);
    sub_10008630(v9);
    CString::CString((CString *)&a1, aPortname);
    LOBYTE(v10) = 10;
    sub_10007CE0(&a1);
    LOBYTE(v10) = 2;
    CString::~CString((CString *)&a1);
    (*(void (__thiscall **)(_DWORD, _DWORD, _BYTE *))(**(_DWORD **)(v2 + 4) + 76))(*(_DWORD *)(v2 + 4), 0, v6);
  }
  sub_10007D00(v6, 0);
  sub_10008630(v9);
  v3 = (CString *)sub_100086C0(v8);
  v4 = CString::AllocSysString(v3);
  LOBYTE(v10) = 1;
  *a2 = v4;
  CString::~CString((CString *)v6);
  LOBYTE(v10) = 0;
  sub_10007C80(v9);
  v10 = -1;
  sub_100081C0(v8);
  return 0;
}


/* ==== 10007150  sub_10007150  ()  size=162 ==== */
int __stdcall sub_10007150(int a1, int a2)
{
  int v3; // [esp+4h] [ebp-10h] BYREF
  int v4; // [esp+10h] [ebp-4h]

  CString::CString((CString *)&v3);
  v4 = 0;
  CString::operator=(&v3, a2);
  if ( sub_100062F0((CString *)(a1 + 32), (char *)v3) )
  {
    *(_DWORD *)(a1 + 1080) = 8196;
    v4 = -1;
    CString::~CString((CString *)&v3);
    return -2147467259;
  }
  else
  {
    v4 = -1;
    CString::~CString((CString *)&v3);
    return 0;
  }
}


/* ==== 10007200  sub_10007200  ()  size=185 ==== */
int __stdcall sub_10007200(int a1, unsigned __int16 **a2)
{
  unsigned __int16 *v2; // eax
  _BYTE v4[4]; // [esp+0h] [ebp-2010h] BYREF
  char Buffer[8192]; // [esp+4h] [ebp-200Ch] BYREF
  int v6; // [esp+200Ch] [ebp-4h]

  if ( sub_10006340((_DWORD *)(a1 + 32), Buffer, 0x2000u) )
    return -2147467259;
  CString::CString((CString *)v4);
  v6 = 0;
  CString::operator=(v4, Buffer);
  v2 = CString::AllocSysString((CString *)v4);
  v6 = -1;
  *a2 = v2;
  CString::~CString((CString *)v4);
  return 0;
}


/* ==== 100072C0  sub_100072C0  ()  size=165 ==== */
int __stdcall sub_100072C0(int a1, _DWORD *a2, _DWORD *a3, int a4)
{
  int v4; // eax

  *a2 = 0;
  *a3 = 0;
  if ( *(_DWORD *)(a1 + 1100) == -1 )
  {
    *(_DWORD *)(a1 + 8) = a4;
    v4 = sub_100076A0(a1);
    *(_DWORD *)(a1 + 1100) = v4;
    if ( v4 == -1 )
      return -2147467259;
    (*(void (__thiscall **)(_DWORD, int))(**(_DWORD **)(a1 + 4) + 56))(*(_DWORD *)(a1 + 4), a1 + 1088);
    if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int, int))(**(_DWORD **)(a1 + 4) + 60))(
            *(_DWORD *)(a1 + 4),
            a1 + 1108,
            a1 + 1104) )
    {
      (*(void (__stdcall **)(int))(*(_DWORD *)a1 + 24))(a1);
      return -2147467259;
    }
    sub_10007A60(a1);
  }
  if ( a2 )
    *a2 = *(_DWORD *)(a1 + 1104);
  *a3 = a1 + 2260;
  return 0;
}


/* ==== 10007370  sub_10007370  ()  size=120 ==== */
int __stdcall sub_10007370(_DWORD *a1)
{
  unsigned int v1; // ebx
  _DWORD *v2; // edi
  int v3; // ecx

  if ( a1[275] != -1 )
  {
    if ( a1[276] )
    {
      v1 = 0;
      v2 = a1 + 277;
      do
      {
        if ( *v2 )
          (*(void (__stdcall **)(_DWORD))(*(_DWORD *)*v2 + 8))(*v2);
        ++v1;
        v2 += 9;
      }
      while ( v1 < a1[276] );
    }
    a1[276] = 0;
    a1[275] = -1;
  }
  v3 = a1[1];
  a1[269] = 1;
  (*(void (__thiscall **)(int))(*(_DWORD *)v3 + 8))(v3);
  a1[269] = 0;
  return 0;
}


/* ==== 100073F0  sub_100073F0  ()  size=67 ==== */
int __stdcall sub_100073F0(int a1, unsigned int a2, _DWORD *a3)
{
  int v3; // eax

  *a3 = 0;
  if ( *(_DWORD *)(a1 + 1104) <= a2 )
    return -2147467259;
  v3 = *(_DWORD *)(a1 + 36 * a2 + 1108);
  *a3 = v3;
  return v3 != 0 ? 0 : -2147467259;
}


/* ==== 10007440  sub_10007440  ()  size=22 ==== */
int __stdcall sub_10007440(int a1, int a2)
{
  (*(void (__thiscall **)(_DWORD, int))(**(_DWORD **)(a1 + 4) + 64))(*(_DWORD *)(a1 + 4), a2);
  return 0;
}


/* ==== 10007460  sub_10007460  ()  size=240 ==== */
int __stdcall sub_10007460(int a1, unsigned __int16 **a2)
{
  int v2; // eax
  int v3; // eax
  unsigned __int16 *v4; // eax
  _BYTE v6[4]; // [esp+4h] [ebp-10h] BYREF
  int v7; // [esp+10h] [ebp-4h]

  CString::CString((CString *)v6);
  v7 = 0;
  v2 = *(_DWORD *)(a1 + 1080);
  if ( v2 > 8194 )
  {
    v3 = v2 - 8195;
    if ( !v3 )
    {
      CString::operator=(v6, a1 + 1084);
      goto LABEL_13;
    }
    if ( v3 == 1 )
    {
      sub_10006420((void *)(a1 + 32), (int)v6);
      goto LABEL_13;
    }
    goto LABEL_10;
  }
  if ( v2 == 8194 )
  {
    CString::operator=(v6, aDeviceWriteErr);
    goto LABEL_13;
  }
  if ( v2 == 4096 )
  {
    CString::operator=(v6, aDeviceUnobtain);
    goto LABEL_13;
  }
  if ( v2 != 8193 )
  {
LABEL_10:
    CString::operator=(v6, aNoError_0);
    goto LABEL_13;
  }
  CString::operator=(v6, aDeviceReadErro);
LABEL_13:
  v4 = CString::AllocSysString((CString *)v6);
  v7 = -1;
  *a2 = v4;
  *(_DWORD *)(a1 + 1080) = 0;
  CString::~CString((CString *)v6);
  return 0;
}


/* ==== 10007550  sub_10007550  ()  size=15 ==== */
int __stdcall sub_10007550(int a1)
{
  return (*(int (__stdcall **)(int, _DWORD))(*(_DWORD *)a1 + 44))(a1, 0);
}


/* ==== 10007560  sub_10007560  ()  size=123 ==== */
int __stdcall sub_10007560(int a1, int a2)
{
  if ( !(*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 12))(*(_DWORD *)(a1 + 4)) )
  {
    if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int))(**(_DWORD **)(a1 + 4) + 68))(*(_DWORD *)(a1 + 4), a2) )
      return 1;
    if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(a1 + 4) + 20))(*(_DWORD *)(a1 + 4)) == 2 )
    {
      if ( !sub_100078E0(2) )
        return -2147467259;
    }
    else if ( !sub_100078E0(1) )
    {
      return -2147467259;
    }
  }
  return (*(unsigned __int8 (__thiscall **)(_DWORD, int))(**(_DWORD **)(a1 + 4) + 68))(*(_DWORD *)(a1 + 4), a2) == 0;
}


/* ==== 100075E0  sub_100075E0  ()  size=177 ==== */
int __stdcall sub_100075E0(int a1, _DWORD *a2, _DWORD *a3, _DWORD *a4, _DWORD *a5)
{
  _DWORD *v5; // esi

  v5 = a2;
  if ( a2 )
  {
    CString::CString((CString *)&a2);
    CString::Format(
      (CString *)&a2,
      "Renesas Technology Communications DLL V%lu.%lu.%lu %s %s",
      3,
      232,
      171,
      aMay242007,
      a145925);
    *v5 = CString::AllocSysString((CString *)&a2);
    CString::~CString((CString *)&a2);
  }
  if ( a3 )
    *a3 = 3;
  if ( a4 )
    *a4 = 232;
  if ( a5 )
    *a5 = 171;
  return 0;
}


/* ==== 100076A0  sub_100076A0  ()  size=520 ==== */
int __thiscall sub_100076A0(_DWORD *this)
{
  int v2; // ecx
  int v3; // edi
  int v4; // edi
  _DWORD *v5; // eax
  _DWORD *v6; // ebp
  _DWORD *v7; // eax
  _DWORD *v8; // ebp
  _DWORD *v9; // eax
  int v11; // [esp+14h] [ebp-18h] BYREF
  _BYTE v12[4]; // [esp+18h] [ebp-14h] BYREF
  _BYTE v13[4]; // [esp+1Ch] [ebp-10h] BYREF
  int v14; // [esp+28h] [ebp-4h]

  CString::CString((CString *)v12);
  v14 = 0;
  CString::CString((CString *)v13);
  v2 = this[1];
  v14 = 1;
  v3 = (*(int (__thiscall **)(int))(*(_DWORD *)v2 + 4))(v2);
  if ( v3 != -1 && (*(int (__thiscall **)(_DWORD))(*(_DWORD *)this[1] + 12))(this[1]) == 1 )
  {
    (*(void (__thiscall **)(_DWORD, int *))(*(_DWORD *)this[1] + 56))(this[1], &v11);
    if ( HIWORD(v11) > 0x8236u )
    {
      if ( HIWORD(v11) == 33343 )
      {
        v4 = this[1];
        (*(void (__thiscall **)(int))(*(_DWORD *)v4 + 8))(v4);
        v9 = operator new(0x63Cu);
        v6 = v9;
        LOBYTE(v14) = 3;
        if ( v9 )
        {
          sub_100017D0(v9);
          *v6 = &off_1001DCE8;
          goto LABEL_21;
        }
LABEL_20:
        v6 = 0;
LABEL_21:
        LOBYTE(v14) = 1;
        this[1] = v6;
        if ( !v6 )
        {
          this[1] = v4;
          goto LABEL_25;
        }
        if ( v4 )
          goto LABEL_23;
        goto LABEL_25;
      }
    }
    else
    {
      if ( HIWORD(v11) == 33334 )
      {
        v4 = this[1];
        (*(void (__thiscall **)(int))(*(_DWORD *)v4 + 8))(v4);
        v7 = operator new(0x63Cu);
        v8 = v7;
        LOBYTE(v14) = 4;
        if ( v7 )
        {
          sub_100017D0(v7);
          *v8 = &off_1001DD3C;
        }
        else
        {
          v8 = 0;
        }
        LOBYTE(v14) = 1;
        this[1] = v8;
        if ( !v8 )
        {
          this[1] = v4;
          goto LABEL_25;
        }
        if ( v4 )
LABEL_23:
          (**(void (__thiscall ***)(int, int))v4)(v4, 1);
LABEL_25:
        (*(void (__thiscall **)(_DWORD, _DWORD, _BYTE *))(*(_DWORD *)this[1] + 72))(this[1], 0, v12);
        (*(void (__thiscall **)(_DWORD, int, _BYTE *))(*(_DWORD *)this[1] + 72))(this[1], 1, v13);
        v3 = (*(int (__thiscall **)(_DWORD))(*(_DWORD *)this[1] + 4))(this[1]);
        goto LABEL_26;
      }
      if ( HIWORD(v11) >= 0xAu && HIWORD(v11) <= 0xCu )
      {
        v4 = this[1];
        (*(void (__thiscall **)(int))(*(_DWORD *)v4 + 8))(v4);
        v5 = operator new(0x63Cu);
        v6 = v5;
        LOBYTE(v14) = 2;
        if ( v5 )
        {
          sub_100017D0(v5);
          *v6 = &off_1001DD90;
          goto LABEL_21;
        }
        goto LABEL_20;
      }
    }
  }
LABEL_26:
  v14 = 5;
  CString::~CString((CString *)v13);
  v14 = -1;
  CString::~CString((CString *)v12);
  return v3;
}


/* ==== 100078D0  sub_100078D0  ()  size=5 ==== */
// attributes: thunk
int __thiscall sub_100078D0(_DWORD *this)
{
  return sub_10001A20(this);
}


/* ==== 100078E0  sub_100078E0  ()  size=381 ==== */
int __thiscall sub_100078E0(_DWORD *this, int a2)
{
  void (__thiscall ***v3)(_DWORD, int); // edi
  _DWORD *v4; // eax
  _DWORD *v5; // eax
  _DWORD *v7; // eax
  _DWORD *v8; // eax
  _DWORD *v9; // eax
  _DWORD *v10; // eax

  if ( a2 )
  {
    if ( a2 == 1 )
    {
      v3 = (void (__thiscall ***)(_DWORD, int))this[1];
      v7 = operator new(0x63Cu);
      if ( v7 )
        v8 = sub_100017D0(v7);
      else
        v8 = 0;
      this[1] = v8;
      if ( v8 )
      {
        sub_100062D0(this + 8, (int)&off_1001D458);
        if ( !v3 )
          return 1;
        goto LABEL_9;
      }
    }
    else
    {
      if ( a2 != 2 )
        return 0;
      v3 = (void (__thiscall ***)(_DWORD, int))this[1];
      v4 = operator new(0xB8u);
      if ( v4 )
        v5 = sub_10003840(v4);
      else
        v5 = 0;
      this[1] = v5;
      if ( v5 )
      {
        sub_100062D0(this + 8, (int)&off_1001D888);
        if ( !v3 )
          return 1;
LABEL_9:
        (**v3)(v3, 1);
        return 1;
      }
    }
LABEL_23:
    this[1] = v3;
    return 0;
  }
  v3 = (void (__thiscall ***)(_DWORD, int))this[1];
  v9 = operator new(0x10u);
  if ( v9 )
    v10 = sub_10005B70(v9);
  else
    v10 = 0;
  this[1] = v10;
  if ( !v10 )
    goto LABEL_23;
  sub_100062D0(this + 8, (int)&off_1001DB28);
  if ( !v3 )
    return 1;
  (**v3)(v3, 1);
  return 1;
}


/* ==== 10007A60  sub_10007A60  ()  size=259 ==== */
unsigned int __thiscall sub_10007A60(int *this)
{
  unsigned int v2; // ebp
  unsigned int result; // eax
  _DWORD *v4; // edi
  int *v5; // esi
  void *v6; // eax
  int v7; // eax
  int v8; // eax

  v2 = 0;
  result = this[276];
  if ( result )
  {
    v4 = this + 566;
    v5 = this + 277;
    do
    {
      if ( v5[1] == 1 )
      {
        v6 = operator new(0x14B0u);
        if ( v6 )
          v7 = sub_10008700(v6, (int)this, (int)v5);
        else
          v7 = 0;
        *v5 = v7;
      }
      if ( v5[1] == 2 )
      {
        if ( operator new(0x30u) )
          v8 = sub_100095A0(this, v5);
        else
          v8 = 0;
        *v5 = v8;
      }
      if ( *v5 )
        (*(void (__stdcall **)(int))(*(_DWORD *)*v5 + 4))(*v5);
      *(v4 - 1) = v2;
      *v4 = v5[1];
      v4[2] = *((unsigned __int16 *)v5 + 7);
      v4[1] = v5[5];
      v4[4] = *((unsigned __int16 *)v5 + 8);
      v4[3] = v5[6];
      result = this[276];
      ++v2;
      v5 += 9;
      v4 += 6;
    }
    while ( v2 < result );
  }
  return result;
}


/* ==== 10007B70  sub_10007B70  ()  size=32 ==== */
_DWORD *__thiscall sub_10007B70(_DWORD *this, int a2)
{
  this[1] = a2;
  CStringList::CStringList((CStringList *)(this + 2), 10);
  *this = &off_1001DDE4;
  return this;
}


/* ==== 10007B90  sub_10007B90  ()  size=30 ==== */
void *__thiscall sub_10007B90(void *this, char a2)
{
  sub_10007BB0();
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10007BB0  sub_10007BB0  ()  size=14 ==== */
void __thiscall sub_10007BB0(_DWORD *this)
{
  *this = &off_1001DDE4;
  CStringList::~CStringList((CStringList *)(this + 2));
}


/* ==== 10007BC0  sub_10007BC0  ()  size=19 ==== */
int __thiscall sub_10007BC0(_DWORD **this)
{
  (*(void (__thiscall **)(_DWORD *, _DWORD **, _DWORD))(*this[1] + 52))(this[1], this + 2, 0);
  return 0;
}


/* ==== 10007BE0  sub_10007BE0  ()  size=16 ==== */
void __thiscall sub_10007BE0(int *this)
{
  if ( this[5] > 0 )
    CStringList::RemoveAll((CStringList *)(this + 2));
}


/* ==== 10007BF0  ?raw_name@type_info@@QBEPBDXZ  (type_info::raw_name(void))  size=4 ==== */
const char *__thiscall type_info::raw_name(type_info *this)
{
  return (char *)this + 8;
}


/* ==== 10007C00  ??1ios_base@std@@UAE@XZ_1  (std::ios_base::~ios_base(void))  size=95 ==== */
void __thiscall std::ios_base::~ios_base(std::ios_base *this)
{
  *(_DWORD *)this = &CObject::`vftable';
  CString::CString((std::ios_base *)((char *)this + 16));
  CString::CString((std::ios_base *)((char *)this + 20));
  *(_DWORD *)this = &off_1001DDE8;
  *((_DWORD *)this + 6) = 0;
}


/* ==== 10007C60  sub_10007C60  ()  size=30 ==== */
void *__thiscall sub_10007C60(void *this, char a2)
{
  sub_10007C80(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10007C80  sub_10007C80  ()  size=86 ==== */
void __thiscall sub_10007C80(_DWORD *this)
{
  *this = &off_1001DDE8;
  CString::~CString((CString *)(this + 5));
  CString::~CString((CString *)(this + 4));
  *this = &CObject::`vftable';
}


/* ==== 10007CE0  sub_10007CE0  ()  size=16 ==== */
int __thiscall sub_10007CE0(char *this, int a2)
{
  return CString::operator=(this + 20, a2);
}


/* ==== 10007CF0  sub_10007CF0  ()  size=4 ==== */
char *__thiscall sub_10007CF0(char *this)
{
  return this + 20;
}


/* ==== 10007D00  sub_10007D00  ()  size=124 ==== */
void __thiscall sub_10007D00(_DWORD *this, int a2, int a3)
{
  int v3; // ebx
  _DWORD *v4; // edi
  int v5; // eax
  int v6; // [esp-4h] [ebp-1Ch]

  v3 = a2;
  v6 = a2;
  v4 = this + 4;
  this[6] = 1;
  CString::operator=(this + 4, v6);
  if ( a3 )
  {
    v5 = sub_10008050((CString *)&a2, v3, 93);
    CString::operator=(v4, v5);
    CString::~CString((CString *)&a2);
  }
}


/* ==== 10007D80  sub_10007D80  ()  size=27 ==== */
int __thiscall sub_10007D80(_DWORD *this, int a2, int a3)
{
  int result; // eax

  result = (a3 != 0) + 4;
  this[1] = a2;
  this[6] = result;
  return result;
}


/* ==== 10007DA0  sub_10007DA0  ()  size=27 ==== */
int __thiscall sub_10007DA0(_DWORD *this, int a2, int a3)
{
  int result; // eax

  result = (a3 != 0) + 2;
  this[3] = a2;
  this[6] = result;
  return result;
}


/* ==== 10007DC0  sub_10007DC0  ()  size=17 ==== */
char __thiscall sub_10007DC0(int this, char a2, int a3)
{
  char result; // al

  result = a2;
  *(_DWORD *)(this + 24) = 7;
  *(_BYTE *)(this + 8) = a2;
  return result;
}


/* ==== 10007DE0  sub_10007DE0  ()  size=31 ==== */
int __thiscall sub_10007DE0(_DWORD *this, int a2)
{
  int result; // eax

  result = 0;
  if ( this[6] == 1 )
  {
    CString::operator=(a2, this + 4);
    return 1;
  }
  return result;
}


/* ==== 10007E00  sub_10007E00  ()  size=32 ==== */
int __thiscall sub_10007E00(_DWORD *this, _DWORD *a2)
{
  int v2; // edx
  int result; // eax

  v2 = this[6];
  result = 0;
  if ( v2 == 2 || v2 == 3 )
  {
    *a2 = this[3];
    return 1;
  }
  return result;
}


/* ==== 10007E20  sub_10007E20  ()  size=335 ==== */
int __thiscall sub_10007E20(int this, CString *a2)
{
  int v3; // edi
  const char *v5; // [esp-8h] [ebp-20h]
  const char *v6; // [esp-4h] [ebp-1Ch]
  _BYTE v7[4]; // [esp+8h] [ebp-10h] BYREF
  int v8; // [esp+14h] [ebp-4h]

  v3 = 1;
  switch ( *(_DWORD *)(this + 24) )
  {
    case 1:
      v6 = *(const char **)sub_10007F90((CString *)v7, this + 16, 93, 93);
      v5 = *(const char **)(this + 20);
      v8 = 0;
      CString::Format(a2, "S|%s|%s", v5, v6);
      v8 = -1;
      CString::~CString((CString *)v7);
      break;
    case 2:
      CString::Format(a2, "I|%s|%i", *(const char **)(this + 20), *(_DWORD *)(this + 12));
      break;
    case 3:
    case 5:
      CString::Format(a2, "X|%s|%.8X", *(const char **)(this + 20), *(_DWORD *)(this + 4));
      break;
    case 4:
      CString::Format(a2, "D|%s|%lu", *(const char **)(this + 20), *(_DWORD *)(this + 4));
      break;
    case 6:
      CString::Format(a2, "B|%s|%i", *(const char **)(this + 20), *(unsigned __int8 *)(this + 8));
      break;
    case 7:
      CString::Format(a2, "X|%s|%.2X", *(const char **)(this + 20), *(unsigned __int8 *)(this + 8));
      break;
    case 8:
      CString::Format(a2, "%c|%s|%s", *(char *)(this + 28), *(const char **)(this + 20), *(const char **)(this + 16));
      break;
    default:
      v3 = 0;
      break;
  }
  return v3;
}


/* ==== 10007F90  sub_10007F90  ()  size=178 ==== */
CString *__stdcall sub_10007F90(CString *a1, _DWORD *a2, int a3, int a4)
{
  int v4; // esi
  int v5; // ebp
  char v6; // bl
  _BYTE v8[4]; // [esp+Ch] [ebp-14h] BYREF
  int v9; // [esp+10h] [ebp-10h]
  int v10; // [esp+1Ch] [ebp-4h]

  v4 = 0;
  v9 = 0;
  CString::CString((CString *)v8);
  v10 = 1;
  v5 = *(_DWORD *)(*a2 - 8);
  if ( v5 > 0 )
  {
    v6 = a4;
    do
    {
      if ( *(_BYTE *)(*a2 + v4) == v6 )
        CString::operator+=(v8, a3);
      LOBYTE(a4) = *(_BYTE *)(*a2 + v4);
      CString::operator+=(v8, a4);
      ++v4;
    }
    while ( v4 < v5 );
  }
  CString::CString(a1, (const struct CString *)v8);
  v9 = 1;
  LOBYTE(v10) = 0;
  CString::~CString((CString *)v8);
  return a1;
}


/* ==== 10008050  sub_10008050  ()  size=172 ==== */
CString *__stdcall sub_10008050(CString *a1, _DWORD *a2, int a3)
{
  int v3; // esi
  int v4; // edi
  char v5; // bl
  _BYTE v7[4]; // [esp+Ch] [ebp-14h] BYREF
  int v8; // [esp+10h] [ebp-10h]
  int v9; // [esp+1Ch] [ebp-4h]

  v3 = 0;
  v8 = 0;
  CString::CString((CString *)v7);
  v9 = 1;
  v4 = *(_DWORD *)(*a2 - 8);
  if ( v4 > 0 )
  {
    v5 = a3;
    do
    {
      if ( *(_BYTE *)(*a2 + v3) == v5 && v3 != v4 - 1 )
        ++v3;
      LOBYTE(a3) = *(_BYTE *)(*a2 + v3);
      CString::operator+=(v7, a3);
      ++v3;
    }
    while ( v3 < v4 );
  }
  CString::CString(a1, (const struct CString *)v7);
  v8 = 1;
  LOBYTE(v9) = 0;
  CString::~CString((CString *)v7);
  return a1;
}


/* ==== 10008100  sub_10008100  ()  size=30 ==== */
int __thiscall sub_10008100(int this, int a2, char a3)
{
  *(_DWORD *)(this + 24) = 8;
  *(_BYTE *)(this + 28) = a3;
  return CString::operator=(this + 16, a2);
}


/* ==== 10008120  ??_Gfacet@locale@std@@UAEPAXI@Z  (std::locale::facet::`scalar deleting destructor'(uint))  size=32 ==== */
std::locale::facet *__thiscall std::locale::facet::`scalar deleting destructor'(std::locale::facet *this, char a2)
{
  *(_DWORD *)this = &CObject::`vftable';
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 10008140  sub_10008140  ()  size=7 ==== */
void __thiscall sub_10008140(_DWORD *this)
{
  *this = &CObject::`vftable';
}


/* ==== 10008150  sub_10008150  ()  size=75 ==== */
_DWORD *__thiscall sub_10008150(_DWORD *this)
{
  *this = &CObject::`vftable';
  CString::CString((CString *)(this + 1));
  *this = &off_1001DDFC;
  return this;
}


/* ==== 100081A0  sub_100081A0  ()  size=30 ==== */
void *__thiscall sub_100081A0(void *this, char a2)
{
  sub_100081C0(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 100081C0  sub_100081C0  ()  size=73 ==== */
void __thiscall sub_100081C0(_DWORD *this)
{
  *this = &off_1001DDFC;
  CString::~CString((CString *)(this + 1));
  *this = &CObject::`vftable';
}


/* ==== 10008210  sub_10008210  ()  size=16 ==== */
int __thiscall sub_10008210(char *this, int a2)
{
  return CString::operator=(this + 4, a2);
}


/* ==== 10008220  sub_10008220  ()  size=119 ==== */
int __stdcall sub_10008220(int a1, int a2)
{
  int v2; // edi
  _BYTE v4[4]; // [esp+8h] [ebp-10h] BYREF
  int v5; // [esp+14h] [ebp-4h]

  v2 = 0;
  CString::CString((CString *)v4);
  v5 = 0;
  if ( sub_100082A0(a1, v4) )
    v2 = sub_100083B0((CString *)v4, a2);
  v5 = -1;
  CString::~CString((CString *)v4);
  return v2;
}


/* ==== 100082A0  sub_100082A0  ()  size=268 ==== */
int __thiscall sub_100082A0(_DWORD *this, int a2, int a3)
{
  CString *v3; // edi
  int v4; // esi
  int v5; // eax
  BOOL v6; // ebx
  int v7; // eax
  int v8; // ebp
  bool v9; // zf
  int v10; // eax
  int v11; // eax
  int v13; // eax
  int v14; // [esp+10h] [ebp-14h]
  int v15; // [esp+14h] [ebp-10h]

  v3 = (CString *)(this + 1);
  v4 = 0;
  if ( *(_DWORD *)(this[1] - 8) )
  {
    v5 = sub_100086D0(v3, 91);
    if ( a2 < v5 )
    {
      v6 = 0;
      v15 = *(_DWORD *)(*(_DWORD *)v3 - 8);
      v14 = 0;
      v7 = CString::Find(v3, 91, 0);
      v8 = v7 + 1;
      if ( v7 == -1 )
        return 0;
      while ( 1 )
      {
        v9 = !v6;
        do
        {
          v10 = v4 + 2;
          if ( v9 )
            v10 = v8;
          v4 = CString::Find(v3, 93, v10);
          v6 = v4 + 1 < v15 && *(_BYTE *)(v4 + *(_DWORD *)v3 + 1) == 93;
          if ( v4 >= v15 )
            break;
          v9 = !v6;
        }
        while ( v6 );
        if ( ++v14 > a2 )
          break;
        v11 = CString::Find(v3, 91, v4);
        v8 = v11 + 1;
        if ( v11 == -1 )
          return 0;
      }
      v13 = CString::Mid(v3, &a2, v8, v4 - v8);
      CString::operator=(a3, v13);
      CString::~CString((CString *)&a2);
      return 1;
    }
  }
  return v4;
}


/* ==== 100083B0  sub_100083B0  ()  size=590 ==== */
int __stdcall sub_100083B0(CString *a1, char *a2)
{
  CString *v2; // esi
  int v3; // ebp
  int v4; // eax
  int v5; // edi
  int v6; // eax
  char *v7; // ebx
  const char *v8; // eax
  char v9; // al
  const char *v10; // eax
  int v11; // eax
  const char *v12; // eax
  int v13; // eax
  const char *v14; // eax
  unsigned int v15; // eax
  int v16; // eax
  int v17; // eax
  _BYTE v19[4]; // [esp+10h] [ebp-24h] BYREF
  _BYTE v20[4]; // [esp+14h] [ebp-20h] BYREF
  _BYTE v21[4]; // [esp+18h] [ebp-1Ch] BYREF
  _BYTE v22[4]; // [esp+1Ch] [ebp-18h] BYREF
  _BYTE v23[4]; // [esp+20h] [ebp-14h] BYREF
  char *EndPtr; // [esp+24h] [ebp-10h] BYREF
  int v25; // [esp+30h] [ebp-4h]

  v2 = a1;
  v3 = 0;
  if ( *(int *)(*(_DWORD *)a1 - 8) >= 5 && (int)sub_100086D0(a1, 124) >= 2 )
  {
    v4 = CString::Find(v2, 124, 2);
    v5 = v4 + 1;
    if ( v4 + 1 > 2 )
    {
      v6 = CString::Mid(v2, &a1, 2, v4 - 2);
      v7 = a2;
      sub_10007CE0(a2, v6);
      v25 = -1;
      CString::~CString((CString *)&a1);
      switch ( **(_BYTE **)v2 )
      {
        case 'B':
          v8 = *(const char **)CString::Mid(v2, &a2, v5);
          v9 = atoi(v8);
          sub_10007DC0((int)v7, v9, 0);
          v25 = -1;
          CString::~CString((CString *)&a2);
          v3 = 1;
          break;
        case 'D':
          v12 = *(const char **)CString::Mid(v2, v20, v5);
          v25 = 3;
          v13 = atol(v12);
          sub_10007D80(v7, v13, 0);
          v25 = -1;
          CString::~CString((CString *)v20);
          v3 = 1;
          break;
        case 'I':
        case 'V':
          v10 = *(const char **)CString::Mid(v2, v19, v5);
          v25 = 2;
          v11 = atoi(v10);
          sub_10007DA0(v7, v11, 0);
          v25 = -1;
          CString::~CString((CString *)v19);
          v3 = 1;
          break;
        case 'S':
          v16 = CString::Mid(v2, v22, v5);
          v25 = 5;
          sub_10007D00(v7, v16, 1);
          v25 = -1;
          CString::~CString((CString *)v22);
          v3 = 1;
          break;
        case 'X':
          v14 = *(const char **)CString::Mid(v2, v21, v5);
          v25 = 4;
          v15 = strtoul(v14, &EndPtr, 16);
          sub_10007D80(v7, v15, 1);
          v25 = -1;
          CString::~CString((CString *)v21);
          v3 = 1;
          break;
        default:
          LOBYTE(a1) = **(_BYTE **)v2;
          v17 = CString::Mid(v2, v23, v5);
          v25 = 6;
          sub_10008100((int)v7, v17, (char)a1);
          v25 = -1;
          CString::~CString((CString *)v23);
          break;
      }
    }
  }
  return v3;
}


/* ==== 10008630  sub_10008630  ()  size=138 ==== */
int __thiscall sub_10008630(char *this, int a2)
{
  int v3; // esi
  _BYTE v5[4]; // [esp+8h] [ebp-10h] BYREF
  int v6; // [esp+14h] [ebp-4h]

  v3 = 0;
  CString::CString((CString *)v5);
  v6 = 0;
  if ( sub_10007E20(a2, (CString *)v5) )
  {
    CString::operator+=(this + 4, 91);
    CString::operator+=(this + 4, v5);
    CString::operator+=(this + 4, asc_10022734);
    v3 = 1;
  }
  v6 = -1;
  CString::~CString((CString *)v5);
  return v3;
}


/* ==== 100086C0  sub_100086C0  ()  size=4 ==== */
char *__thiscall sub_100086C0(char *this)
{
  return this + 4;
}


/* ==== 100086D0  sub_100086D0  ()  size=48 ==== */
int __stdcall sub_100086D0(_DWORD *a1, char a2)
{
  int v2; // ecx
  int v3; // edi
  int v4; // esi

  v2 = 0;
  v3 = 0;
  v4 = *(_DWORD *)(*a1 - 8);
  if ( v4 <= 0 )
    return 0;
  do
  {
    if ( *(_BYTE *)(*a1 + v2) == a2 )
      ++v3;
    ++v2;
  }
  while ( v2 < v4 );
  return v3;
}


/* ==== 10008700  sub_10008700  ()  size=252 ==== */
char *__thiscall sub_10008700(char *this, int a2, int a3)
{
  *((_DWORD *)this + 1323) = 0;
  *(_DWORD *)this = &off_1001DE2C;
  *((_DWORD *)this + 4) = 0;
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 1) = a2;
  *((_DWORD *)this + 2) = a3;
  *((_DWORD *)this + 1319) = 0;
  *((_DWORD *)this + 1320) = CreateMutexA(0, 0, Name);
  *((_DWORD *)this + 1321) = CreateMutexA(0, 0, aMutextoprotect_0);
  *((_DWORD *)this + 7) = CreateEventA(0, 0, 0, 0);
  *((_DWORD *)this + 8) = CreateEventA(0, 0, 0, 0);
  *((_DWORD *)this + 1322) = CreateEventA(0, 0, 0, 0);
  *((_DWORD *)this + 294) = sub_10009890(0x100000);
  *((_DWORD *)this + 37) = sub_10009890(0x100000);
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 4) = 0;
  *((_DWORD *)this + 5) = 0;
  *((_DWORD *)this + 6) = 0;
  E8A_USB::StartThread((E8A_USB *)this, (struct _MONCTL *)(this + 36), (LPTHREAD_START_ROUTINE)StartAddress, 0, this);
  E8A_USB::StartThread((E8A_USB *)this, (struct _MONCTL *)(this + 92), (LPTHREAD_START_ROUTINE)sub_100094F0, 0, this);
  return this;
}


/* ==== 10008800  sub_10008800  ()  size=161 ==== */
BOOL __thiscall sub_10008800(HANDLE *this)
{
  *this = &off_1001DE2C;
  sub_100089C0(this);
  E8A_USB::StopThread((E8A_USB *)this, (struct _MONCTL *)(this + 9));
  E8A_USB::StopThread((E8A_USB *)this, (struct _MONCTL *)(this + 23));
  sub_100098C0(this[294]);
  sub_100098C0(this[37]);
  CloseHandle(this[7]);
  CloseHandle(this[8]);
  CloseHandle(this[1320]);
  CloseHandle(this[1321]);
  return CloseHandle(this[1322]);
}


/* ==== 100088B0  sub_100088B0  ()  size=114 ==== */
int __stdcall sub_100088B0(int a1, const void *a2, _DWORD *a3)
{
  *a3 = 0;
  if ( memcmp(a2, &unk_1001E3C0, 0x10u)
    && memcmp(a2, &unk_1001DEB8, 0x10u)
    && memcmp(a2, &unk_1001DEE8, 0x10u)
    && memcmp(a2, &unk_1001DF18, 0x10u) )
  {
    return -2147467262;
  }
  *a3 = a1;
  return 0;
}


/* ==== 10008930  sub_10008930  ()  size=22 ==== */
int __stdcall sub_10008930(int a1)
{
  ++*(_DWORD *)(a1 + 5292);
  return 0;
}


/* ==== 10008950  sub_10008950  ()  size=78 ==== */
int __stdcall sub_10008950(E8A_USB *a1)
{
  int v1; // edx

  v1 = *((_DWORD *)a1 + 1323) - 1;
  *((_DWORD *)a1 + 1323) = v1;
  if ( v1 == -1 )
    *((_DWORD *)a1 + 1323) = 0;
  if ( *((int *)a1 + 1323) <= 0 )
  {
    sub_10008E80(a1);
    if ( a1 )
    {
      sub_10008800((HANDLE *)a1);
      operator delete(a1);
    }
  }
  return 0;
}


/* ==== 100089A0  sub_100089A0  ()  size=29 ==== */
int __stdcall sub_100089A0(int a1)
{
  *(_DWORD *)(a1 + 5276) = 1;
  SetEvent(*(HANDLE *)(a1 + 44));
  return 0;
}


/* ==== 100089C0  sub_100089C0  ()  size=28 ==== */
int __stdcall sub_100089C0(int a1)
{
  sub_10008E80(a1);
  *(_DWORD *)(a1 + 5276) = 0;
  return 0;
}


/* ==== 100089E0  sub_100089E0  ()  size=96 ==== */
int __stdcall sub_100089E0(_DWORD *a1)
{
  int v1; // edi

  v1 = 0;
  sub_10008E80(a1);
  if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, _DWORD *))(**(_DWORD **)(a1[1] + 4) + 40))(
          *(_DWORD *)(a1[1] + 4),
          a1[2],
          a1 + 32) )
    v1 = -2147467259;
  sub_100098F0(a1[294]);
  sub_100098F0(a1[37]);
  if ( a1[1319] )
    (*(void (__stdcall **)(_DWORD *))(*a1 + 12))(a1);
  return v1;
}


/* ==== 10008A40  sub_10008A40  ()  size=30 ==== */
int __stdcall sub_10008A40(int a1, _DWORD *a2)
{
  *a2 = sub_10009960(*(_DWORD *)(a1 + 1176));
  return 0;
}


/* ==== 10008A60  sub_10008A60  ()  size=82 ==== */
int __stdcall sub_10008A60(int a1, int a2, int a3, _DWORD *a4)
{
  int v4; // eax

  if ( WaitForSingleObject(*(HANDLE *)(a1 + 5280), 0x3E8u) )
    return -2147467259;
  v4 = sub_10008EC0(a2, a3);
  if ( a4 )
    *a4 = v4;
  ReleaseMutex(*(HANDLE *)(a1 + 5280));
  return 0;
}


/* ==== 10008AC0  sub_10008AC0  ()  size=82 ==== */
int __stdcall sub_10008AC0(int a1, int a2, int a3, _DWORD *a4)
{
  int v4; // eax

  if ( WaitForSingleObject(*(HANDLE *)(a1 + 5284), 0x3E8u) )
    return -2147467259;
  v4 = sub_10008EF0(a2, a3);
  if ( a4 )
    *a4 = v4;
  ReleaseMutex(*(HANDLE *)(a1 + 5284));
  return 0;
}


/* ==== 10008B20  sub_10008B20  ()  size=16 ==== */
int __stdcall sub_10008B20(int a1, int a2)
{
  *(_DWORD *)(a1 + 12) = a2;
  return 0;
}


/* ==== 10008B30  sub_10008B30  ()  size=16 ==== */
int __stdcall sub_10008B30(int a1, int a2)
{
  *(_DWORD *)(a1 + 16) = a2;
  return 0;
}


/* ==== 10008B40  sub_10008B40  ()  size=294 ==== */
int __stdcall sub_10008B40(int a1, int a2, unsigned int a3, _DWORD *a4, int a5)
{
  void *v6; // ecx
  int v7; // ebx
  unsigned int v8; // edi
  unsigned int v9; // eax
  int v10; // eax
  int v11; // ebp
  DWORD v12; // eax
  DWORD v13; // eax
  HANDLE Handles[3]; // [esp+4h] [ebp-Ch] BYREF
  int v16; // [esp+14h] [ebp+4h]

  if ( WaitForSingleObject(*(HANDLE *)(a1 + 5280), 0x3E8u) )
    return -2147467259;
  v6 = *(void **)(a1 + 28);
  v7 = a2;
  v16 = 0;
  v8 = a3;
  Handles[0] = *(HANDLE *)(a1 + 5288);
  Handles[1] = v6;
  ResetEvent(Handles[0]);
  if ( !a3 )
    goto LABEL_18;
  while ( 1 )
  {
    v9 = sub_10009960(*(_DWORD *)(a1 + 1176));
    if ( v9 )
    {
      if ( v9 > v8 )
        v9 = v8;
      v10 = sub_10008EC0(v7, v9);
      v7 += v10;
      v8 -= v10;
      if ( a4 )
        *a4 = v7 - a2;
      goto LABEL_15;
    }
    v11 = sub_10009960(*(_DWORD *)(a1 + 1176));
    v12 = v8 == a3 ? a5 + *(_DWORD *)(*(_DWORD *)(a1 + 4) + 20) : a5;
    *(_DWORD *)(*(_DWORD *)(a1 + 4) + 28) = v8;
    v13 = WaitForMultipleObjects(2u, Handles, 0, v12);
    if ( v13 != 258 )
      break;
    if ( v11 == sub_10009960(*(_DWORD *)(a1 + 1176)) )
      goto LABEL_17;
LABEL_15:
    if ( !v8 )
      goto LABEL_18;
  }
  if ( v13 == 1 )
    goto LABEL_15;
LABEL_17:
  v16 = -2147467259;
LABEL_18:
  ReleaseMutex(*(HANDLE *)(a1 + 5280));
  return v16;
}


/* ==== 10008C70  sub_10008C70  ()  size=321 ==== */
int __stdcall sub_10008C70(int a1, int a2, int a3, _DWORD *a4, DWORD dwMilliseconds)
{
  void *v6; // ecx
  void *v7; // edx
  int v8; // ebp
  int v10; // ebx
  int v11; // eax
  int v12; // edi
  DWORD v13; // eax
  HANDLE Handles[3]; // [esp+4h] [ebp-Ch] BYREF
  int v16; // [esp+14h] [ebp+4h]
  int v17; // [esp+1Ch] [ebp+Ch]

  if ( WaitForSingleObject(*(HANDLE *)(a1 + 5284), 0x3E8u) )
    return -2147467259;
  v6 = *(void **)(a1 + 32);
  v7 = *(void **)(a1 + 104);
  v8 = a2;
  v17 = 0;
  v10 = a3;
  v16 = a2;
  Handles[0] = *(HANDLE *)(a1 + 5288);
  Handles[1] = v6;
  Handles[2] = v7;
  ResetEvent(Handles[0]);
  if ( a3 )
  {
    while ( 1 )
    {
      v11 = sub_10008EF0(v16, v10);
      v16 += v11;
      v10 -= v11;
      if ( !sub_10008F20(v11) )
        break;
      while ( !sub_10009920(*(_DWORD *)(a1 + 148)) )
      {
        v12 = sub_10009960(*(_DWORD *)(a1 + 148));
        v13 = WaitForMultipleObjects(3u, Handles, 0, dwMilliseconds);
        if ( !v13 || v13 > 2 && (v13 != 258 || v12 == sub_10009960(*(_DWORD *)(a1 + 148))) )
        {
          v17 = -2147467259;
          v10 = 0;
        }
      }
      if ( !v10 )
        goto LABEL_14;
    }
    v17 = -2147467259;
LABEL_14:
    v8 = v16;
  }
  if ( a4 )
    *a4 = v8 - a2;
  ReleaseMutex(*(HANDLE *)(a1 + 5284));
  return v17;
}


/* ==== 10008DC0  sub_10008DC0  ()  size=16 ==== */
int __stdcall sub_10008DC0(int a1, int a2)
{
  *(_DWORD *)(a1 + 20) = a2;
  return 0;
}


/* ==== 10008DD0  sub_10008DD0  ()  size=16 ==== */
int __stdcall sub_10008DD0(int a1, int a2)
{
  *(_DWORD *)(a1 + 24) = a2;
  return 0;
}


/* ==== 10008DE0  sub_10008DE0  ()  size=57 ==== */
int (__cdecl *__thiscall sub_10008DE0(int this, int a2))(int, _DWORD)
{
  int (__cdecl *result)(int, _DWORD); // eax

  SetEvent(*(HANDLE *)(this + 5288));
  result = *(int (__cdecl **)(int, _DWORD))(this + 5276);
  if ( result )
  {
    result = *(int (__cdecl **)(int, _DWORD))(*(_DWORD *)(this + 4) + 8);
    if ( result )
      return (int (__cdecl *)(int, _DWORD))result(a2, *(_DWORD *)(*(_DWORD *)(this + 8) + 32));
  }
  return result;
}


/* ==== 10008E20  ?StartThread@E8A_USB@@IAEXPAU_MONCTL@@P6GKPAX@ZI1@Z  (E8A_USB::StartThread(_MONCTL *,ulong (*)(void *),uint,void *))  size=91 ==== */
void __thiscall E8A_USB::StartThread(
        E8A_USB *this,
        DWORD *a2,
        LPTHREAD_START_ROUTINE lpStartAddress,
        SIZE_T dwStackSize,
        void *lpParameter)
{
  _DWORD *v5; // esi
  int v6; // edi
  HANDLE EventA; // eax

  v5 = a2 + 7;
  v6 = 7;
  do
  {
    EventA = CreateEventA(0, 0, 0, 0);
    *v5 = EventA;
    if ( !EventA )
      *v5 = -1;
    --v6;
    --v5;
  }
  while ( v6 );
  *a2 = (DWORD)CreateThread(0, dwStackSize, lpStartAddress, lpParameter, 0, a2 + 8);
}


/* ==== 10008E80  sub_10008E80  ()  size=55 ==== */
DWORD __thiscall sub_10008E80(HANDLE *this)
{
  SetEvent(this[12]);
  WaitForSingleObject(this[15], 0x9C4u);
  SetEvent(this[26]);
  return WaitForSingleObject(this[29], 0x9C4u);
}


/* ==== 10008EC0  sub_10008EC0  ()  size=48 ==== */
int __thiscall sub_10008EC0(int this, int a2, int a3)
{
  int v4; // edi

  v4 = a3 - sub_10009BE0(*(_DWORD *)(this + 1176), a2, a3);
  SetEvent(*(HANDLE *)(this + 56));
  return v4;
}


/* ==== 10008EF0  sub_10008EF0  ()  size=48 ==== */
int __thiscall sub_10008EF0(int this, int a2, int a3)
{
  int v4; // edi

  v4 = a3 - sub_10009C20(*(_DWORD *)(this + 148), a2, a3);
  SetEvent(*(HANDLE *)(this + 100));
  return v4;
}


/* ==== 10008F20  sub_10008F20  ()  size=59 ==== */
BOOL __thiscall sub_10008F20(int this, int a2)
{
  DWORD v3; // eax

  v3 = (*(int (__thiscall **)(_DWORD, int))(**(_DWORD **)(*(_DWORD *)(this + 4) + 4) + 48))(
         *(_DWORD *)(*(_DWORD *)(this + 4) + 4),
         a2);
  return !v3 || WaitForSingleObject(*(HANDLE *)(this + 5288), v3) == 258;
}


/* ==== 10008F60  sub_10008F60  ()  size=123 ==== */
int __cdecl sub_10008F60(int a1, int a2, int a3)
{
  DWORD v5; // eax
  DWORD v6; // eax
  int v7; // eax

  while ( 1 )
  {
    v5 = WaitForMultipleObjects(5u, (const HANDLE *)(a1 + 40), 0, 0xFFFFFFFF);
    if ( !v5 )
      return 0;
    v6 = v5 - 2;
    if ( !v6 )
      return 2;
    if ( v6 != 2 )
    {
      sub_10008DE0(a1, 8193);
      return 2;
    }
    v7 = sub_10009C20(*(_DWORD *)(a1 + 1176), a2, a3);
    if ( !v7 )
      break;
    a2 += a3 - v7;
    a3 = v7;
  }
  return 1;
}


/* ==== 10008FE0  sub_10008FE0  ()  size=305 ==== */
int __cdecl sub_10008FE0(int a1, unsigned int *a2)
{
  int v2; // esi
  int v4; // edi
  void (__cdecl *v5)(int, _DWORD); // eax
  unsigned int v6; // eax
  int v7; // eax

  v2 = a1;
  if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 32))(
          *(_DWORD *)(*(_DWORD *)(a1 + 4) + 4),
          a1 + 72,
          &a1) )
  {
    sub_10008DE0(v2, 8193);
    return 2;
  }
  v4 = 0;
  if ( a1 == 1 )
  {
    if ( sub_10009900(*(_DWORD *)(v2 + 1176)) )
      v4 = 1;
    else
      sub_10009980(*(_DWORD *)(v2 + 1176), *(_BYTE *)(v2 + 1180));
  }
  else if ( a1 )
  {
    v4 = sub_10009C20(*(_DWORD *)(v2 + 1176), v2 + 1180, a1);
  }
  SetEvent(*(HANDLE *)(v2 + 28));
  v5 = *(void (__cdecl **)(int, _DWORD))(v2 + 12);
  if ( v5 && a1 )
    v5(a1, *(_DWORD *)(*(_DWORD *)(v2 + 8) + 32));
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(v2 + 4) + 4) + 12))(*(_DWORD *)(*(_DWORD *)(v2 + 4) + 4)) != 2 )
    goto LABEL_18;
  v6 = *(_DWORD *)(*(_DWORD *)(v2 + 4) + 28);
  if ( v6 )
  {
    if ( v6 >= 0x1000 )
      *a2 = 4096;
    else
      *a2 = v6;
    *(_DWORD *)(*(_DWORD *)(v2 + 4) + 28) = 0;
LABEL_18:
    v7 = a1;
    goto LABEL_19;
  }
  v7 = a1;
  *a2 = a1 != 0 ? 4096 : 1;
LABEL_19:
  if ( v4 )
    return sub_10008F60(v2, v7 - v4 + v2 + 1180, v4);
  else
    return 1;
}


/* ==== 10009120  sub_10009120  ()  size=178 ==== */
int __cdecl sub_10009120(int a1)
{
  DWORD v1; // eax
  DWORD v2; // eax
  int result; // eax
  unsigned int v4; // [esp+10h] [ebp-4h] BYREF

  v4 = 4096;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 12))(*(_DWORD *)(*(_DWORD *)(a1 + 4) + 4)) == 2 )
    v4 = 1;
  while ( 1 )
  {
    if ( (*(int (__thiscall **)(_DWORD, _DWORD, int, unsigned int, int))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 24))(
           *(_DWORD *)(*(_DWORD *)(a1 + 4) + 4),
           *(_DWORD *)(a1 + 8),
           a1 + 1180,
           v4,
           a1 + 72) != 1 )
      goto LABEL_7;
    v1 = WaitForMultipleObjects(4u, (const HANDLE *)(a1 + 40), 0, 0xFFFFFFFF);
    if ( !v1 )
      return 0;
    v2 = v1 - 2;
    if ( !v2 )
      goto LABEL_10;
    if ( v2 != 1 )
    {
      sub_10008DE0(a1, 8193);
LABEL_10:
      (*(void (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 36))(*(_DWORD *)(*(_DWORD *)(a1 + 4) + 4));
      return 2;
    }
LABEL_7:
    result = sub_10008FE0(a1, &v4);
    if ( result != 1 )
      return result;
  }
}


/* ==== 100091E0  StartAddress  ()  size=134 ==== */
int __stdcall StartAddress(LPVOID lpThreadParameter)
{
  int v1; // ecx
  DWORD v2; // eax
  DWORD v3; // eax
  int v4; // eax

  SetThreadPriority(*((HANDLE *)lpThreadParameter + 9), 15);
  v1 = *((_DWORD *)lpThreadParameter + 13);
  *((_DWORD *)lpThreadParameter + 20) = 0;
  *((_DWORD *)lpThreadParameter + 21) = 0;
  *((_DWORD *)lpThreadParameter + 22) = v1;
  while ( 1 )
  {
    v2 = WaitForMultipleObjects(3u, (const HANDLE *)lpThreadParameter + 10, 0, 0xFFFFFFFF);
    if ( !v2 )
      break;
    v3 = v2 - 1;
    if ( v3 )
    {
      if ( v3 == 1 )
        goto LABEL_7;
      sub_10008DE0((int)lpThreadParameter, 8193);
      SetEvent(*((HANDLE *)lpThreadParameter + 15));
    }
    else
    {
      v4 = sub_10009120((int)lpThreadParameter);
      if ( v4 == 2 )
      {
LABEL_7:
        SetEvent(*((HANDLE *)lpThreadParameter + 15));
      }
      else if ( !v4 )
      {
        break;
      }
    }
  }
  SetEvent(*((HANDLE *)lpThreadParameter + 16));
  return 0;
}


/* ==== 10009270  sub_10009270  ()  size=79 ==== */
int __cdecl sub_10009270(int a1, DWORD dwMilliseconds)
{
  void *v2; // edx
  DWORD v3; // eax
  HANDLE Handles[2]; // [esp+4h] [ebp-8h] BYREF

  v2 = *(void **)(a1 + 96);
  Handles[0] = *(HANDLE *)(a1 + 104);
  Handles[1] = v2;
  v3 = WaitForMultipleObjects(2u, Handles, 0, dwMilliseconds);
  if ( v3 )
    return v3 != 1;
  else
    return 2;
}


/* ==== 100092C0  sub_100092C0  ()  size=259 ==== */
int __cdecl sub_100092C0(int a1)
{
  int v1; // esi
  int (__cdecl *v3)(_DWORD, _DWORD); // eax
  int v4; // eax
  void (__cdecl *v5)(int, _DWORD); // eax

  v1 = a1;
  if ( !(*(unsigned __int8 (__thiscall **)(_DWORD, int, int *))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 32))(
          *(_DWORD *)(*(_DWORD *)(a1 + 4) + 4),
          a1 + 128,
          &a1) )
    return 2;
  sub_10009A20(*(_DWORD *)(v1 + 148), a1);
  if ( a1 )
    SetEvent(*(HANDLE *)(v1 + 32));
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(v1 + 4) + 4) + 12))(*(_DWORD *)(*(_DWORD *)(v1 + 4) + 4)) == 2 )
  {
    if ( *(_DWORD *)(*(_DWORD *)(v1 + 4) + 12) )
      sub_10009270(v1, *(_DWORD *)(*(_DWORD *)(v1 + 4) + 12));
    if ( *(_DWORD *)(*(_DWORD *)(v1 + 4) + 24) )
    {
      v3 = *(int (__cdecl **)(_DWORD, _DWORD))(v1 + 24);
      if ( v3 )
      {
        v4 = v3(*(_DWORD *)(v1 + 104), *(_DWORD *)(v1 + 96)) - 1;
        if ( !v4 )
          return 2;
        if ( v4 == 1 )
          return 0;
      }
    }
  }
  v5 = *(void (__cdecl **)(int, _DWORD))(v1 + 16);
  if ( v5 )
    v5(a1, *(_DWORD *)(*(_DWORD *)(v1 + 8) + 32));
  if ( sub_10009920(*(_DWORD *)(v1 + 148)) )
  {
    sub_10009960(*(_DWORD *)(v1 + 148));
    return 2;
  }
  else
  {
    sub_10009960(*(_DWORD *)(v1 + 148));
    return 1;
  }
}


/* ==== 100093D0  sub_100093D0  ()  size=260 ==== */
int __cdecl sub_100093D0(unsigned int a1)
{
  int v1; // esi
  unsigned int v2; // eax
  int v3; // ecx
  int v4; // ecx
  unsigned int v5; // eax
  int (__cdecl *v6)(_DWORD, _DWORD, unsigned int *); // eax
  int v7; // eax
  int v8; // eax
  int v9; // eax
  int result; // eax

  v1 = a1;
  while ( 1 )
  {
    v2 = sub_10009960(*(_DWORD *)(v1 + 148));
    v3 = *(_DWORD *)(v1 + 4);
    a1 = v2;
    if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(v3 + 4) + 12))(*(_DWORD *)(v3 + 4)) == 2 )
    {
      v4 = *(_DWORD *)(v1 + 4);
      v5 = *(_DWORD *)(v4 + 16);
      if ( v5 && a1 > v5 )
        a1 = *(_DWORD *)(v4 + 16);
      if ( *(_DWORD *)(v4 + 24) )
      {
        v6 = *(int (__cdecl **)(_DWORD, _DWORD, unsigned int *))(v1 + 20);
        if ( v6 )
        {
          v7 = v6(*(_DWORD *)(v1 + 104), *(_DWORD *)(v1 + 96), &a1) - 1;
          if ( !v7 )
            return 2;
          if ( v7 == 1 )
            return 0;
        }
      }
    }
    v8 = a1;
    if ( a1 > 0x400 )
    {
      v8 = 1024;
      a1 = 1024;
    }
    sub_100099A0(*(_DWORD *)(v1 + 148), v8, v1 + 152);
    v9 = (*(int (__thiscall **)(_DWORD, _DWORD, int, unsigned int, int))(**(_DWORD **)(*(_DWORD *)(v1 + 4) + 4) + 28))(
           *(_DWORD *)(*(_DWORD *)(v1 + 4) + 4),
           *(_DWORD *)(v1 + 8),
           v1 + 152,
           a1,
           v1 + 128);
    if ( v9 == 1 )
    {
      while ( 2 )
      {
        switch ( WaitForMultipleObjects(4u, (const HANDLE *)(v1 + 96), 0, 0xFFFFFFFF) )
        {
          case 0u:
            return 0;
          case 1u:
            continue;
          case 2u:
            return 2;
          case 3u:
            goto LABEL_15;
          default:
            sub_10008DE0(v1, 8194);
            return 2;
        }
      }
    }
    if ( v9 )
      return 2;
LABEL_15:
    result = sub_100092C0(v1);
    if ( result != 1 )
      return result;
  }
}


/* ==== 100094F0  sub_100094F0  ()  size=162 ==== */
int __stdcall sub_100094F0(LPVOID lpThreadParameter)
{
  int v1; // ecx
  DWORD v2; // eax
  DWORD v3; // eax
  int v4; // eax

  SetThreadPriority(*((HANDLE *)lpThreadParameter + 23), 15);
  v1 = *((_DWORD *)lpThreadParameter + 27);
  *((_DWORD *)lpThreadParameter + 34) = 0;
  *((_DWORD *)lpThreadParameter + 35) = 0;
  *((_DWORD *)lpThreadParameter + 36) = v1;
  while ( 1 )
  {
    v2 = WaitForMultipleObjects(3u, (const HANDLE *)lpThreadParameter + 24, 0, 0xFFFFFFFF);
    if ( !v2 )
      break;
    v3 = v2 - 1;
    if ( v3 )
    {
      if ( v3 == 1 )
        goto LABEL_8;
      sub_10008DE0((int)lpThreadParameter, 8194);
      SetEvent(*((HANDLE *)lpThreadParameter + 29));
    }
    else if ( sub_10009920(*((_DWORD *)lpThreadParameter + 37))
           || (v4 = sub_100093D0((unsigned int)lpThreadParameter), v4 == 2) )
    {
LABEL_8:
      SetEvent(*((HANDLE *)lpThreadParameter + 29));
    }
    else if ( !v4 )
    {
      break;
    }
  }
  SetEvent(*((HANDLE *)lpThreadParameter + 30));
  return 0;
}


/* ==== 100095A0  sub_100095A0  ()  size=80 ==== */
_DWORD *__thiscall sub_100095A0(_DWORD *this, int a2, int a3)
{
  HANDLE MutexA; // eax
  int v5; // edx

  this[11] = 0;
  *this = &off_1001DE6C;
  this[1] = a2;
  this[2] = a3;
  *((_BYTE *)this + 12) = 0;
  this[4] = CreateEventA(0, 0, 0, 0);
  MutexA = CreateMutexA(0, 0, aMutextoprotect_1);
  v5 = this[4];
  this[5] = MutexA;
  this[8] = 0;
  this[9] = 0;
  this[10] = v5;
  return this;
}


/* ==== 100095F0  sub_100095F0  ()  size=31 ==== */
BOOL __thiscall sub_100095F0(void *this)
{
  void *v2; // eax

  v2 = (void *)*((_DWORD *)this + 4);
  *(_DWORD *)this = &off_1001DE6C;
  CloseHandle(v2);
  return CloseHandle(*((HANDLE *)this + 5));
}


/* ==== 10009610  sub_10009610  ()  size=114 ==== */
int __stdcall sub_10009610(int a1, const void *a2, _DWORD *a3)
{
  *a3 = 0;
  if ( memcmp(a2, &unk_1001E3C0, 0x10u)
    && memcmp(a2, &unk_1001DEC8, 0x10u)
    && memcmp(a2, &unk_1001DEF8, 0x10u)
    && memcmp(a2, &unk_1001DF28, 0x10u) )
  {
    return -2147467262;
  }
  *a3 = a1;
  return 0;
}


/* ==== 10009690  sub_10009690  ()  size=16 ==== */
int __stdcall sub_10009690(int a1)
{
  ++*(_DWORD *)(a1 + 44);
  return 0;
}


/* ==== 100096A0  sub_100096A0  ()  size=59 ==== */
int __stdcall sub_100096A0(_DWORD *a1)
{
  int v1; // edx

  v1 = a1[11] - 1;
  a1[11] = v1;
  if ( v1 == -1 )
    a1[11] = 0;
  if ( (int)a1[11] <= 0 && a1 )
  {
    sub_100095F0(a1);
    operator delete(a1);
  }
  return 0;
}


/* ==== 100096E0  sub_100096E0  ()  size=20 ==== */
int __stdcall sub_100096E0(int a1)
{
  if ( !*(_DWORD *)(a1 + 16) )
    return _ThemeHelper::CloseThemeDataFail((void *)a1);
  *(_BYTE *)(a1 + 12) = 1;
  return 0;
}


/* ==== 100096F4  ?CloseThemeDataFail@_ThemeHelper@@SGJPAX@Z  (_ThemeHelper::CloseThemeDataFail(void *))  size=8 ==== */
int __stdcall _ThemeHelper::CloseThemeDataFail(void *a1)
{
  return -2147467259;
}


/* ==== 10009700  sub_10009700  ()  size=13 ==== */
int __stdcall sub_10009700(int a1)
{
  *(_BYTE *)(a1 + 12) = 0;
  return 0;
}


/* ==== 10009710  sub_10009710  ()  size=79 ==== */
int __stdcall sub_10009710(int a1)
{
  int v1; // edi

  v1 = -2147467259;
  if ( *(_DWORD *)(a1 + 16) && !WaitForSingleObject(*(HANDLE *)(a1 + 20), 0x3E8u) )
  {
    if ( (*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, int))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4) + 40))(
           *(_DWORD *)(*(_DWORD *)(a1 + 4) + 4),
           *(_DWORD *)(a1 + 8),
           a1 + 24) )
    {
      v1 = 0;
    }
    ReleaseMutex(*(HANDLE *)(a1 + 20));
  }
  return v1;
}


/* ==== 10009760  sub_10009760  ()  size=137 ==== */
int __stdcall sub_10009760(int a1, int a2, int a3, int a4, int a5, _DWORD *a6)
{
  _DWORD *v6; // edi
  int v7; // ebx

  v6 = a6;
  v7 = -2147467259;
  *a6 = 0;
  if ( !*(_BYTE *)(a1 + 12) )
    return -2147467259;
  if ( !WaitForSingleObject(*(HANDLE *)(a1 + 20), 0x3E8u) )
  {
    if ( (*(unsigned __int8 (__thiscall **)(_DWORD, _DWORD, int, int, int, int *, int))(**(_DWORD **)(*(_DWORD *)(a1 + 4) + 4)
                                                                                      + 44))(
           *(_DWORD *)(*(_DWORD *)(a1 + 4) + 4),
           *(_DWORD *)(a1 + 8),
           a2,
           a3,
           a4,
           &a5,
           a1 + 24) )
    {
      if ( v6 )
        *v6 = a5;
      v7 = 0;
    }
    ReleaseMutex(*(HANDLE *)(a1 + 20));
  }
  return v7;
}


/* ==== 100097F0  sub_100097F0  ()  size=146 ==== */
int __stdcall sub_100097F0(DWORD ModemStat, int a2, _DWORD *dwFunc)
{
  DWORD v3; // esi
  void *v4; // eax
  void *v6; // eax

  v3 = ModemStat;
  if ( (*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(ModemStat + 4) + 4) + 12))(*(_DWORD *)(*(_DWORD *)(ModemStat + 4) + 4)) == 2 )
  {
    if ( a2 == 4096 )
    {
      v6 = (void *)(*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(v3 + 4) + 4) + 4))(*(_DWORD *)(*(_DWORD *)(v3 + 4) + 4));
      if ( v6 != (void *)-1 && EscapeCommFunction(v6, (DWORD)dwFunc) )
        return 0;
      return -2147467259;
    }
    if ( a2 == 4097 )
    {
      v4 = (void *)(*(int (__thiscall **)(_DWORD))(**(_DWORD **)(*(_DWORD *)(v3 + 4) + 4) + 4))(*(_DWORD *)(*(_DWORD *)(v3 + 4) + 4));
      if ( v4 != (void *)-1 && GetCommModemStatus(v4, &ModemStat) )
      {
        *dwFunc = ModemStat;
        return 0;
      }
      return -2147467259;
    }
  }
  return -2147024809;
}


/* ==== 10009890  sub_10009890  ()  size=45 ==== */
char *__cdecl sub_10009890(int a1)
{
  char *v1; // eax
  char *v2; // esi

  v1 = (char *)malloc(a1 + 21);
  v2 = v1;
  if ( v1 )
    sub_100098D0(v1, v1 + 16, a1 + 1);
  return v2;
}


/* ==== 100098C0  sub_100098C0  ()  size=13 ==== */
void __cdecl sub_100098C0(void *Block)
{
  free(Block);
}


/* ==== 100098D0  sub_100098D0  ()  size=25 ==== */
int __cdecl sub_100098D0(_DWORD *a1, int a2, int a3)
{
  *a1 = a2;
  a1[3] = a3;
  return sub_100098F0(a1);
}


/* ==== 100098F0  sub_100098F0  ()  size=13 ==== */
int __cdecl sub_100098F0(int a1)
{
  int result; // eax

  result = a1;
  *(_DWORD *)(a1 + 4) = 0;
  *(_DWORD *)(a1 + 8) = 0;
  return result;
}


/* ==== 10009900  sub_10009900  ()  size=32 ==== */
BOOL __cdecl sub_10009900(_DWORD *a1)
{
  unsigned int v1; // eax

  v1 = a1[1] + 1;
  if ( v1 >= a1[3] )
    v1 = 0;
  return v1 == a1[2];
}


/* ==== 10009920  sub_10009920  ()  size=22 ==== */
BOOL __cdecl sub_10009920(int a1)
{
  return *(_DWORD *)(a1 + 4) == *(_DWORD *)(a1 + 8);
}


/* ==== 10009940  sub_10009940  ()  size=24 ==== */
int __cdecl sub_10009940(int a1)
{
  return *(_DWORD *)(a1 + 12) - (sub_10009960(a1) + 1);
}


/* ==== 10009960  sub_10009960  ()  size=27 ==== */
unsigned int __cdecl sub_10009960(_DWORD *a1)
{
  unsigned int v1; // ecx
  unsigned int v2; // edx

  v1 = a1[1];
  v2 = a1[2];
  if ( v1 >= v2 )
    return v1 - v2;
  else
    return v1 + a1[3] - v2;
}


/* ==== 10009980  sub_10009980  ()  size=32 ==== */
_DWORD *__cdecl sub_10009980(_DWORD *a1, char a2)
{
  _DWORD *result; // eax
  int v3; // ecx
  unsigned int v4; // ecx

  result = a1;
  v3 = a1[1];
  *(_BYTE *)(*a1 + v3) = a2;
  v4 = v3 + 1;
  if ( v4 >= a1[3] )
    v4 = 0;
  a1[1] = v4;
  return result;
}


/* ==== 100099A0  sub_100099A0  ()  size=121 ==== */
char *__cdecl sub_100099A0(int a1, unsigned int a2, char *a3)
{
  const void *v3; // esi
  unsigned int v4; // eax
  unsigned int v5; // ebx
  char *result; // eax
  const void *v7; // esi

  v3 = (const void *)sub_10009B70(a1);
  v4 = sub_10009B40(a1);
  v5 = v4;
  if ( v4 < a2 )
  {
    qmemcpy(a3, v3, v4);
    v7 = (const void *)sub_10009BD0(a1);
    result = a3;
    qmemcpy(&a3[v5], v7, a2 - v5);
  }
  else
  {
    result = (char *)a2;
    qmemcpy(a3, v3, a2);
  }
  return result;
}


/* ==== 10009A20  sub_10009A20  ()  size=63 ==== */
int __cdecl sub_10009A20(int a1, unsigned int a2)
{
  unsigned int v2; // eax
  unsigned int v3; // edi

  v2 = sub_10009B40(a1);
  v3 = v2;
  if ( v2 >= a2 )
    return sub_10009BB0(a1, a2);
  sub_10009BB0(a1, v2);
  return sub_10009BB0(a1, a2 - v3);
}


/* ==== 10009A60  sub_10009A60  ()  size=104 ==== */
unsigned int __cdecl sub_10009A60(int a1, unsigned int a2, char *a3)
{
  unsigned int v3; // ebx
  char *v4; // eax
  unsigned int v5; // ecx
  char *v6; // esi
  char *v7; // edi
  unsigned int result; // eax

  v3 = sub_10009B10(a1);
  v4 = (char *)sub_10009B80(a1);
  v5 = a2;
  if ( v3 < a2 )
  {
    qmemcpy(v4, a3, v3);
    v4 = (char *)sub_10009BD0(a1);
    v5 = a2 - v3;
    v6 = &a3[v3];
  }
  else
  {
    v6 = a3;
  }
  v7 = v4;
  result = v5;
  qmemcpy(v7, v6, v5);
  return result;
}


/* ==== 10009AD0  sub_10009AD0  ()  size=63 ==== */
int __cdecl sub_10009AD0(int a1, unsigned int a2)
{
  unsigned int v2; // eax
  unsigned int v3; // edi

  v2 = sub_10009B10(a1);
  v3 = v2;
  if ( v2 >= a2 )
    return sub_10009B90(a1, a2);
  sub_10009B90(a1, v2);
  return sub_10009B90(a1, a2 - v3);
}


/* ==== 10009B10  sub_10009B10  ()  size=48 ==== */
int __cdecl sub_10009B10(_DWORD *a1)
{
  unsigned int v1; // ecx
  unsigned int v2; // eax
  bool v4; // zf

  if ( sub_10009900(a1) )
    return 0;
  v1 = a1[1];
  v2 = a1[2];
  if ( v1 < v2 )
    return v2 - v1 - 1;
  v4 = v2 == 0;
  v2 = a1[3];
  if ( v4 )
    return v2 - v1 - 1;
  else
    return v2 - v1;
}


/* ==== 10009B40  sub_10009B40  ()  size=39 ==== */
unsigned int __cdecl sub_10009B40(_DWORD *a1)
{
  unsigned int v2; // eax
  unsigned int v3; // ecx

  if ( sub_10009920((int)a1) )
    return 0;
  v2 = a1[1];
  v3 = a1[2];
  if ( v3 > v2 )
    v2 = a1[3];
  return v2 - v3;
}


/* ==== 10009B70  sub_10009B70  ()  size=12 ==== */
int __cdecl sub_10009B70(_DWORD *a1)
{
  return *a1 + a1[2];
}


/* ==== 10009B80  sub_10009B80  ()  size=12 ==== */
int __cdecl sub_10009B80(_DWORD *a1)
{
  return *a1 + a1[1];
}


/* ==== 10009B90  sub_10009B90  ()  size=26 ==== */
unsigned int __cdecl sub_10009B90(int a1, int a2)
{
  unsigned int result; // eax
  unsigned int v3; // edx

  result = *(_DWORD *)(a1 + 4) + a2;
  v3 = *(_DWORD *)(a1 + 12);
  if ( result >= v3 )
    result -= v3;
  *(_DWORD *)(a1 + 4) = result;
  return result;
}


/* ==== 10009BB0  sub_10009BB0  ()  size=26 ==== */
unsigned int __cdecl sub_10009BB0(int a1, int a2)
{
  unsigned int result; // eax
  unsigned int v3; // edx

  result = *(_DWORD *)(a1 + 8) + a2;
  v3 = *(_DWORD *)(a1 + 12);
  if ( result >= v3 )
    result -= v3;
  *(_DWORD *)(a1 + 8) = result;
  return result;
}


/* ==== 10009BD0  sub_10009BD0  ()  size=7 ==== */
int __cdecl sub_10009BD0(int a1)
{
  return *(_DWORD *)a1;
}


/* ==== 10009BE0  sub_10009BE0  ()  size=62 ==== */
unsigned int __cdecl sub_10009BE0(_DWORD *a1, char *a2, unsigned int a3)
{
  unsigned int v3; // esi

  v3 = sub_10009960(a1);
  if ( v3 > a3 )
    v3 = a3;
  if ( v3 )
  {
    sub_100099A0((int)a1, v3, a2);
    sub_10009A20((int)a1, v3);
  }
  return a3 - v3;
}


/* ==== 10009C20  sub_10009C20  ()  size=58 ==== */
unsigned int __cdecl sub_10009C20(int a1, char *a2, unsigned int a3)
{
  unsigned int v3; // esi

  v3 = sub_10009940(a1);
  if ( v3 > a3 )
    v3 = a3;
  sub_10009A60(a1, v3, a2);
  sub_10009AD0(a1, v3);
  return a3 - v3;
}


/* ==== 10009C60  sub_10009C60  ()  size=182 ==== */
unsigned __int8 *__cdecl sub_10009C60(HANDLE hDevice, unsigned __int8 *Dest, size_t BufferCount, int a4)
{
  DWORD v4; // eax
  char *v5; // eax
  char *v6; // ecx
  char v7; // dl
  char Buffer[512]; // [esp+8h] [ebp-A00h] BYREF
  _BYTE OutBuffer[2048]; // [esp+208h] [ebp-800h] BYREF

  memset(OutBuffer, 0, sizeof(OutBuffer));
  v4 = snprintf(Buffer, BufferCount, "VID_%.4X&PID_%.4X", *(unsigned __int16 *)(a4 + 8), *(unsigned __int16 *)(a4 + 10));
  LOBYTE(v4) = *(_BYTE *)(a4 + 15);
  if ( (_BYTE)v4 && sub_10009E50(hDevice, v4, OutBuffer, 0x800u) )
  {
    v5 = OutBuffer;
    v6 = Buffer;
    do
    {
      if ( !*(_WORD *)v5 )
        break;
      v7 = *v5;
      v5 += 2;
      *v6++ = v7;
    }
    while ( v5 < &OutBuffer[1022] );
    *v6 = 0;
  }
  return mbsnbcpy(Dest, (const unsigned __int8 *)Buffer, BufferCount);
}


/* ==== 10009D20  sub_10009D20  ()  size=289 ==== */
unsigned __int8 *__cdecl sub_10009D20(HANDLE hDevice, int a2, char *a3, size_t BufferCount, DWORD a5)
{
  DWORD v5; // eax
  char *v6; // esi
  char *v7; // edi
  char v8; // bl
  char v10; // [esp+7h] [ebp-A01h]
  char Buffer[512]; // [esp+8h] [ebp-A00h] BYREF
  _BYTE OutBuffer[2048]; // [esp+208h] [ebp-800h] BYREF

  memset(OutBuffer, 0, sizeof(OutBuffer));
  snprintf(Buffer, BufferCount, "%lu", a2);
  v5 = a5;
  LOBYTE(v5) = *(_BYTE *)(a5 + 16);
  if ( !(_BYTE)v5 || !sub_10009E50(hDevice, v5, OutBuffer, 0x800u) )
    return mbsnbcpy((unsigned __int8 *)a3, (const unsigned __int8 *)Buffer, BufferCount);
  v6 = OutBuffer;
  v7 = Buffer;
  v10 = 0;
  do
  {
    if ( !*(_WORD *)v6 )
      break;
    v8 = *v6;
    if ( ismbcalpha(*v6) )
      v10 = 1;
    if ( v8 == 32 )
      v8 = 95;
    *v7 = v8;
    v6 += 2;
    ++v7;
  }
  while ( v6 < &OutBuffer[1022] );
  *v7 = 0;
  if ( !v10 )
    return (unsigned __int8 *)snprintf(a3, BufferCount, "%s%s", aSn, Buffer);
  else
    return mbsnbcpy((unsigned __int8 *)a3, (const unsigned __int8 *)Buffer, BufferCount);
}


/* ==== 10009E50  sub_10009E50  ()  size=76 ==== */
DWORD __cdecl sub_10009E50(HANDLE hDevice, DWORD BytesReturned, LPVOID lpOutBuffer, DWORD nOutBufferSize)
{
  int v4; // eax
  __int16 InBuffer; // [esp+0h] [ebp-8h] BYREF
  int v7; // [esp+4h] [ebp-4h]

  v7 = (unsigned __int8)BytesReturned;
  InBuffer = 1033;
  v4 = sub_1000A240(hDevice, 0x80002014, &InBuffer, 8u, lpOutBuffer, nOutBufferSize, &BytesReturned);
  return v4 != 0 ? BytesReturned : 0;
}


/* ==== 10009EA0  sub_10009EA0  ()  size=52 ==== */
bool __cdecl sub_10009EA0(HANDLE hDevice, LPVOID lpOutBuffer)
{
  return sub_1000A240(hDevice, 0x80002000, 0, 0, lpOutBuffer, 0x12u, (LPDWORD)&lpOutBuffer)
      && (unsigned int)lpOutBuffer >= 0x12;
}


/* ==== 10009EE0  sub_10009EE0  ()  size=45 ==== */
bool __cdecl sub_10009EE0(HANDLE hDevice, LPVOID lpOutBuffer)
{
  return sub_1000A240(hDevice, 0x80002004, 0, 0, lpOutBuffer, 0x400u, (LPDWORD)&lpOutBuffer) != 0;
}


/* ==== 10009F10  sub_10009F10  ()  size=93 ==== */
char __cdecl sub_10009F10(unsigned __int8 *String)
{
  const unsigned __int8 *v1; // esi
  int i; // ebp
  size_t v4; // eax
  const unsigned __int8 *v5; // eax
  const unsigned __int8 *v6; // esi

  v1 = String;
  if ( !String )
    return 0;
  for ( i = 2; ; --i )
  {
    v4 = mbslen(v1);
    v5 = (const unsigned __int8 *)memchr(v1, 38, v4);
    v6 = v5;
    if ( !v5 )
      break;
    if ( !i )
      return 1;
    if ( mbslen(v5) <= 2 )
      break;
    v1 = v6 + 2;
  }
  return 0;
}


/* ==== 10009F70  sub_10009F70  ()  size=189 ==== */
int __cdecl sub_10009F70(char *Buffer, int a2, CString *a3)
{
  CString *v3; // esi
  int v4; // eax
  int v5; // eax
  int v7; // [esp+8h] [ebp-8h] BYREF
  int v8; // [esp+Ch] [ebp-4h] BYREF

  v3 = (CString *)Buffer;
  v8 = 1115;
  v7 = 13;
  v4 = CString::Find((CString *)Buffer, aVid);
  if ( v4 != -1 )
  {
    CString::Mid(v3, &Buffer, v4 + 4);
    sscanf(Buffer, "%lx", &v8);
    CString::~CString((CString *)&Buffer);
  }
  v5 = CString::Find(v3, aPid);
  if ( v5 != -1 )
  {
    CString::Mid(v3, &Buffer, v5 + 4);
    sscanf(Buffer, "%lx", &v7);
    CString::~CString((CString *)&Buffer);
  }
  return sub_1000A030(v8, v7, a2, a3);
}


/* ==== 1000A030  sub_1000A030  ()  size=34 ==== */
void __cdecl sub_1000A030(int a1, int a2, const char *a3, CString *a4)
{
  CString::Format(a4, "\\\\?\\USB#Vid_%.4x&Pid_%.4x#%s#{a5dcbf10-6530-11d2-901f-00c04fb951ed}", a1, a2, a3);
}


/* ==== 1000A060  sub_1000A060  ()  size=194 ==== */
char __cdecl sub_1000A060(int a1)
{
  char v1; // bl
  HKEY phkResult; // [esp+4h] [ebp-410h] BYREF
  DWORD cbData; // [esp+8h] [ebp-40Ch] BYREF
  BYTE Data[4]; // [esp+Ch] [ebp-408h] BYREF
  DWORD Type; // [esp+10h] [ebp-404h] BYREF
  BYTE v7[22]; // [esp+14h] [ebp-400h] BYREF
  _BYTE v8[1002]; // [esp+2Ah] [ebp-3EAh] BYREF

  v1 = 0;
  phkResult = 0;
  if ( RegOpenKeyExA(HKEY_LOCAL_MACHINE, SubKey, 0, 1u, &phkResult) )
    return 0;
  *(_DWORD *)Data = 0;
  cbData = 4;
  if ( !RegQueryValueExA(phkResult, ValueName, 0, &Type, Data, &cbData) && *(_DWORD *)Data == 1 )
  {
    cbData = 1024;
    if ( !RegQueryValueExA(phkResult, a0, 0, &Type, v7, &cbData) )
    {
      CString::operator=(a1, v8);
      v1 = 1;
    }
  }
  RegCloseKey(phkResult);
  return v1;
}


/* ==== 1000A130  sub_1000A130  ()  size=260 ==== */
char __cdecl sub_1000A130(unsigned int a1, size_t BufferCount, char *a3)
{
  char v3; // bl
  HKEY phkResult; // [esp+10h] [ebp-418h] BYREF
  DWORD cbData; // [esp+14h] [ebp-414h] BYREF
  BYTE Data[4]; // [esp+18h] [ebp-410h] BYREF
  DWORD Type; // [esp+1Ch] [ebp-40Ch] BYREF
  char Buffer[8]; // [esp+20h] [ebp-408h] BYREF
  BYTE v10[22]; // [esp+28h] [ebp-400h] BYREF
  char v11[1002]; // [esp+3Eh] [ebp-3EAh] BYREF

  v3 = 0;
  phkResult = 0;
  if ( RegOpenKeyExA(HKEY_LOCAL_MACHINE, SubKey, 0, 1u, &phkResult) )
    goto LABEL_7;
  *(_DWORD *)Data = 0;
  cbData = 4;
  if ( !RegQueryValueExA(phkResult, ValueName, 0, &Type, Data, &cbData) && *(_DWORD *)Data > a1 )
  {
    cbData = 1024;
    snprintf(Buffer, 8u, "%d", a1);
    if ( !RegQueryValueExA(phkResult, Buffer, 0, &Type, v10, &cbData) )
    {
      snprintf(a3, BufferCount, "%s", v11);
      v3 = 1;
    }
  }
  RegCloseKey(phkResult);
  if ( !v3 )
LABEL_7:
    snprintf(a3, BufferCount, aSorryYourDevic);
  return v3;
}


/* ==== 1000A240  sub_1000A240  ()  size=233 ==== */
int __cdecl sub_1000A240(
        HANDLE hDevice,
        DWORD dwIoControlCode,
        LPVOID lpInBuffer,
        DWORD nInBufferSize,
        LPVOID lpOutBuffer,
        DWORD nOutBufferSize,
        LPDWORD lpBytesReturned)
{
  int v7; // edi
  BOOL v8; // esi
  LPDWORD v9; // ebx
  _OVERLAPPED Overlapped; // [esp+8h] [ebp-14h] BYREF

  memset(&Overlapped, 0, 16);
  v7 = 0;
  v8 = 0;
  Overlapped.hEvent = CreateEventA(0, 0, 0, 0);
  if ( Overlapped.hEvent )
  {
    v9 = lpBytesReturned;
    if ( !DeviceIoControl(
            hDevice,
            dwIoControlCode,
            lpInBuffer,
            nInBufferSize,
            lpOutBuffer,
            nOutBufferSize,
            lpBytesReturned,
            &Overlapped) )
    {
      if ( GetLastError() != 997 || WaitForSingleObject(Overlapped.hEvent, 0x3E8u) )
        goto LABEL_11;
      if ( GetVersion() < 0x80000000 )
      {
        SetEvent(Overlapped.hEvent);
        v8 = 1;
      }
      if ( !GetOverlappedResult(hDevice, &Overlapped, (LPDWORD)&lpBytesReturned, v8) )
        goto LABEL_11;
      if ( v9 )
        *v9 = (DWORD)lpBytesReturned;
    }
    v7 = 1;
LABEL_11:
    CloseHandle(Overlapped.hEvent);
    return v7;
  }
  return 0;
}


/* ==== 1000A330  sub_1000A330  ()  size=35 ==== */
int __cdecl sub_1000A330(char *a1)
{
  char *v1; // ecx
  char v2; // al

  v1 = a1;
  v2 = *a1;
  if ( !*a1 )
    return 1;
  while ( v2 >= 48 && v2 <= 57 )
  {
    v2 = *++v1;
    if ( !v2 )
      return 1;
  }
  return 0;
}


/* ==== 1000A360  ?Read@E8A_USB@@QAEHPAEKPAU_OVERLAPPED@@@Z  (E8A_USB::Read(uchar *,ulong,_OVERLAPPED *))  size=33 ==== */
BOOL __thiscall E8A_USB::Read(
        HANDLE *this,
        unsigned __int8 *lpBuffer,
        DWORD nNumberOfBytesToRead,
        struct _OVERLAPPED *lpOverlapped)
{
  return ReadFile(this[20736], lpBuffer, nNumberOfBytesToRead, 0, lpOverlapped);
}


/* ==== 1000A390  ?Write@E8A_USB@@QAEHPAEKPAU_OVERLAPPED@@@Z  (E8A_USB::Write(uchar *,ulong,_OVERLAPPED *))  size=33 ==== */
BOOL __thiscall E8A_USB::Write(
        HANDLE *this,
        LPCVOID lpBuffer,
        DWORD nNumberOfBytesToWrite,
        struct _OVERLAPPED *lpOverlapped)
{
  return WriteFile(this[20736], lpBuffer, nNumberOfBytesToWrite, 0, lpOverlapped);
}


/* ==== 1000A3C0  ?GetLenWritten@E8A_USB@@QAEHPAU_OVERLAPPED@@H@Z  (E8A_USB::GetLenWritten(_OVERLAPPED *,int))  size=45 ==== */
DWORD __thiscall E8A_USB::GetLenWritten(HANDLE *this, LPOVERLAPPED lpOverlapped, DWORD NumberOfBytesTransferred)
{
  if ( GetOverlappedResult(this[20736], lpOverlapped, &NumberOfBytesTransferred, NumberOfBytesTransferred) )
    return NumberOfBytesTransferred;
  else
    return -1;
}


/* ==== 1000A3F0  ??4E8A_USB@@QAEAAV0@ABV0@@Z  (E8A_USB::operator=(E8A_USB const &))  size=22 ==== */
void *__thiscall E8A_USB::operator=(void *this, const void *a2)
{
  void *result; // eax

  result = this;
  qmemcpy(this, a2, 0x15444u);
  return result;
}


/* ==== 1000A410  ??_FE8A_USB@@QAEXXZ  (E8A_USB::`default constructor closure'(void))  size=8 ==== */
void __thiscall E8A_USB::`default constructor closure'(E8A_USB *this)
{
  E8A_USB::E8A_USB(this, 0);
}


/* ==== 1000A420  ??0E8A_USB@@QAE@H@Z  (E8A_USB::E8A_USB(int))  size=159 ==== */
E8A_USB *__thiscall E8A_USB::E8A_USB(E8A_USB *this, int a2)
{
  *((_WORD *)this + 41270) = 8;
  *((_DWORD *)this + 20634) = 0;
  *((_WORD *)this + 41271) = 0;
  *((_BYTE *)this + 82674) = 0;
  *((_BYTE *)this + 82675) = 0;
  *((_DWORD *)this + 2151) = 0;
  *((_DWORD *)this + 2152) = 0;
  *((_DWORD *)this + 2153) = 0;
  *((_DWORD *)this + 20733) = 0;
  *((_DWORD *)this + 20734) = 0;
  *((_DWORD *)this + 20735) = -1;
  *((_DWORD *)this + 20736) = -1;
  *(_DWORD *)this = -1;
  *((_DWORD *)this + 12) = CreateEventA(0, 0, 0, 0);
  *((_DWORD *)this + 6) = CreateEventA(0, 0, 0, 0);
  E8A_USB::StartThread(this, (DWORD *)this + 20738, (LPTHREAD_START_ROUTINE)sub_1000B600, 0, this);
  dword_1002338C = sub_10009890(0x2000);
  return this;
}


/* ==== 1000A4C0  ??1E8A_USB@@QAE@XZ  (E8A_USB::~E8A_USB(void))  size=58 ==== */
void __thiscall E8A_USB::~E8A_USB(HANDLE *this)
{
  E8A_USB::Release((E8A_USB *)this);
  CloseHandle(this[12]);
  CloseHandle(this[6]);
  E8A_USB::StopThread((E8A_USB *)this, (struct _MONCTL *)(this + 20738));
  sub_100098C0(dword_1002338C);
}


/* ==== 1000A500  ?SetTimeout@E8A_USB@@QAEHH@Z  (E8A_USB::SetTimeout(int))  size=11 ==== */
int __thiscall E8A_USB::SetTimeout(E8A_USB *this, int a2)
{
  int result; // eax

  result = *(_DWORD *)this;
  *(_DWORD *)this = a2;
  return result;
}


/* ==== 1000A510  ?SetE1Timeout@E8A_USB@@QAEHH@Z  (E8A_USB::SetE1Timeout(int))  size=13 ==== */
int __thiscall E8A_USB::SetE1Timeout(E8A_USB *this, int a2)
{
  return E8A_USB::SetTimeout(this, a2);
}


/* ==== 1000A520  ?GetDeviceId@E8A_USB@@QAEHXZ  (E8A_USB::GetDeviceId(void))  size=20 ==== */
int __thiscall E8A_USB::GetDeviceId(E8A_USB *this)
{
  if ( *((_DWORD *)this + 20736) == -1 )
    return 0;
  else
    return *((_DWORD *)this + 20735) + 1;
}


/* ==== 1000A540  ?ScanBus@E8A_USB@@QAEFPAPADPAHFI@Z  (E8A_USB::ScanBus(char * *,int *,short,uint))  size=285 ==== */
__int16 __thiscall E8A_USB::ScanBus(E8A_USB *this, char **a2, int *a3, __int16 a4, size_t BufferCount)
{
  __int16 v6; // si
  int v7; // ebx
  _DWORD *v8; // ebp
  int v9; // esi
  void *v10; // eax
  int v11; // esi
  USHORT idProduct; // dx
  int idVendor; // ecx
  int v15; // [esp+10h] [ebp-1Ch]
  HANDLE hObject; // [esp+14h] [ebp-18h]
  _USB_DEVICE_DESCRIPTOR v17; // [esp+18h] [ebp-14h] BYREF

  v6 = 0;
  v15 = 0;
  v7 = 0;
  v8 = (_DWORD *)((char *)this + 8564);
  do
  {
    if ( *((_DWORD *)this + 20736) == -1 || v7 != *((_DWORD *)this + 20735) )
    {
      v10 = E8A_USB::OpenInstance(this, v7);
      hObject = v10;
      if ( v10 != (void *)-1 )
      {
        if ( E8A_USB::GetDeviceDescriptor(this, v10, &v17) && E8A_USB::IsSupportedDevice(this, v17.idProduct) )
        {
          v11 = v6;
          E8A_USB::GetName(this, hObject, &v17, v7, BufferCount, a2[v11], 1);
          idProduct = v17.idProduct;
          idVendor = v17.idVendor;
          a3[v11] = v7;
          *(v8 - 10) = idVendor;
          *v8 = idProduct;
          v6 = ++v15;
        }
        CloseHandle(hObject);
      }
    }
    else
    {
      v9 = v6;
      E8A_USB::GetName(this, a2[v9]);
      a3[v9] = v7;
      *(v8 - 10) = *((unsigned __int16 *)this + 4126);
      *v8 = *((unsigned __int16 *)this + 4127);
      v6 = ++v15;
    }
    if ( v6 >= a4 )
      break;
    ++v7;
    ++v8;
  }
  while ( v7 < 10 );
  return v6;
}


/* ==== 1000A660  ?ScanPorts@E8A_USB@@QAEFPAPADPAHFI@Z  (E8A_USB::ScanPorts(char * *,int *,short,uint))  size=80 ==== */
__int16 __thiscall E8A_USB::ScanPorts(E8A_USB *this, char **a2, int *a3, __int16 a4, size_t BufferCount)
{
  signed int v5; // edi
  _DWORD *v7; // esi

  v5 = 0;
  if ( a4 > 0 )
  {
    v7 = (_DWORD *)((char *)this + 8564);
    do
    {
      if ( !sub_1000A130(v5, BufferCount, *a2) )
        break;
      *(v7 - 10) = 1115;
      *v7 = 33334;
      ++v5;
      ++a2;
      ++v7;
    }
    while ( v5 < a4 );
  }
  return v5;
}


/* ==== 1000A6B0  ?Connect@E8A_USB@@QAEHH@Z  (E8A_USB::Connect(int))  size=184 ==== */
int __thiscall E8A_USB::Connect(HANDLE *this, HANDLE a2)
{
  int DeviceId; // edi
  void *v5; // eax
  HANDLE v6; // eax

  DeviceId = 0;
  if ( this[20736] != (HANDLE)-1 )
  {
    if ( a2 == this[20735] )
      return E8A_USB::GetDeviceId((E8A_USB *)this);
    E8A_USB::Release((E8A_USB *)this);
  }
  v5 = E8A_USB::OpenDevice((E8A_USB *)this, (int *)&a2);
  this[20736] = v5;
  if ( v5 != (void *)-1 )
  {
    this[20735] = a2;
    if ( !E8A_USB::GetDeviceDetails((E8A_USB *)this)
      || !E8A_USB::SetProtocol((E8A_USB *)this, 0)
      || (v6 = this[20740], this[21776] = 0, SetEvent(v6), (DeviceId = E8A_USB::GetDeviceId((E8A_USB *)this)) == 0) )
    {
      if ( this[20736] != (HANDLE)-1 )
        CloseHandle(this[20736]);
      this[20735] = (HANDLE)-1;
      this[20736] = (HANDLE)-1;
    }
  }
  return DeviceId;
}


/* ==== 1000A770  ?ConnectToPort@E8A_USB@@QAEHQBD@Z  (E8A_USB::ConnectToPort(char const * const))  size=263 ==== */
int __thiscall E8A_USB::ConnectToPort(HANDLE *this, const char *a2)
{
  int v2; // ebx
  const char **v4; // eax
  char **v5; // ebp
  void *v6; // eax
  char *v7; // ecx
  HANDLE v9; // ecx
  int DeviceId; // esi

  v2 = 0;
  if ( !E8A_USB::ScanPorts((E8A_USB *)this, &String, &dword_10023614, 10, 0x40u) || !String )
    return 0;
  v4 = (const char **)&String;
  v5 = &String;
  while ( 1 )
  {
    if ( !strcmp(a2, *v4) )
    {
      v6 = E8A_USB::OpenPortID((E8A_USB *)this, v2, *v5);
      this[20736] = v6;
      if ( v6 != (void *)-1 )
        break;
    }
    v7 = v5[1];
    ++v5;
    ++v2;
    v4 = (const char **)v5;
    if ( !v7 )
      return 0;
  }
  this[20735] = (HANDLE)v2;
  if ( !E8A_USB::GetDeviceDetails((E8A_USB *)this) || !E8A_USB::SetProtocol((E8A_USB *)this, 0) )
  {
    DeviceId = 0;
LABEL_13:
    if ( this[20736] != (HANDLE)-1 )
      CloseHandle(this[20736]);
    this[20735] = (HANDLE)-1;
    this[20736] = (HANDLE)-1;
    return DeviceId;
  }
  v9 = this[20740];
  this[21776] = 0;
  SetEvent(v9);
  DeviceId = E8A_USB::GetDeviceId((E8A_USB *)this);
  if ( !DeviceId )
    goto LABEL_13;
  return DeviceId;
}


/* ==== 1000A880  ?Release@E8A_USB@@QAEHXZ  (E8A_USB::Release(void))  size=89 ==== */
int __thiscall E8A_USB::Release(HANDLE *this)
{
  SetEvent(this[20741]);
  Sleep(0xAu);
  WaitForSingleObject(this[20744], 0x9C4u);
  Sleep(0xAu);
  if ( this[20736] != (HANDLE)-1 )
    CloseHandle(this[20736]);
  this[20736] = (HANDLE)-1;
  this[20735] = (HANDLE)-1;
  return 1;
}


/* ==== 1000A8E0  ?SendCommand@E8A_USB@@QAEHPBEHPAX@Z  (E8A_USB::SendCommand(uchar const *,int,void *))  size=6 ==== */
int __thiscall E8A_USB::SendCommand(E8A_USB *this, const unsigned __int8 *a2, int a3, void *a4)
{
  return -1;
}


/* ==== 1000A8F0  ?Read@E8A_USB@@QAEHPAEKPAX@Z  (E8A_USB::Read(uchar *,ulong,void *))  size=313 ==== */
unsigned int __thiscall E8A_USB::Read(E8A_USB *this, unsigned __int8 *a2, DWORD NumberOfBytesRead, void *a4)
{
  DWORD v4; // ebx
  unsigned int DataFromBuffer; // eax
  unsigned int v7; // ebp
  unsigned int v8; // ebx
  int v9; // ecx
  DWORD v10; // ecx
  char *v11; // esi

  v4 = NumberOfBytesRead;
  DataFromBuffer = E8A_USB::GetDataFromBuffer(this, &a2, NumberOfBytesRead);
  v7 = DataFromBuffer;
  if ( v4 > DataFromBuffer )
  {
    v8 = v4 - DataFromBuffer;
    *((_DWORD *)this + 11) = *((_DWORD *)this + 12);
    v9 = *((unsigned __int16 *)this + 4259);
    *((_DWORD *)this + 9) = 0;
    *((_DWORD *)this + 10) = 0;
    if ( v8 % (unsigned __int16)v9 )
      v10 = v8 + v9 - v8 % (unsigned __int16)v9;
    else
      v10 = v8;
    v11 = (char *)this + 52;
    if ( !ReadFile(
            *((HANDLE *)this + 20736),
            (char *)this + 52,
            v10,
            &NumberOfBytesRead,
            (LPOVERLAPPED)((char *)this + 28))
      && (GetLastError() != 997 || WaitForSingleObject(*((HANDLE *)this + 12), 1000 * *(_DWORD *)this))
      || !GetOverlappedResult(*((HANDLE *)this + 20736), (LPOVERLAPPED)((char *)this + 28), &NumberOfBytesRead, 0) )
    {
      CancelIo(*((HANDLE *)this + 20736));
      return -1;
    }
    if ( NumberOfBytesRead > v8 )
    {
      sub_10009C20((int)dword_1002338C, (char *)this + v8 + 52, NumberOfBytesRead - v8);
      qmemcpy(a2, v11, v8);
      return v8 + v7;
    }
    qmemcpy(a2, v11, NumberOfBytesRead);
    v7 += NumberOfBytesRead;
  }
  return v7;
}


/* ==== 1000AA30  ?Write@E8A_USB@@QAEHPAEKPAX@Z  (E8A_USB::Write(uchar *,ulong,void *))  size=190 ==== */
DWORD __thiscall E8A_USB::Write(E8A_USB *this, LPCVOID lpBuffer, DWORD nNumberOfBytesToWrite, void *a4)
{
  struct _OVERLAPPED *v5; // edi
  void *v7; // [esp-14h] [ebp-20h]
  DWORD NumberOfBytesWritten; // [esp+8h] [ebp-4h] BYREF

  NumberOfBytesWritten = 0;
  v5 = (struct _OVERLAPPED *)((char *)this + 4);
  *((_DWORD *)this + 5) = *((_DWORD *)this + 6);
  v7 = (void *)*((_DWORD *)this + 20736);
  *((_DWORD *)this + 3) = 0;
  *((_DWORD *)this + 4) = 0;
  if ( (WriteFile(v7, lpBuffer, nNumberOfBytesToWrite, &NumberOfBytesWritten, (LPOVERLAPPED)((char *)this + 4))
     || GetLastError() == 997 && !WaitForSingleObject(*((HANDLE *)this + 6), 1000 * *(_DWORD *)this))
    && GetOverlappedResult(*((HANDLE *)this + 20736), v5, &NumberOfBytesWritten, 0) )
  {
    return NumberOfBytesWritten;
  }
  CancelIo(*((HANDLE *)this + 20736));
  return -1;
}


/* ==== 1000AAF0  ?GetStatus@E8A_USB@@QAEHPAEH@Z  (E8A_USB::GetStatus(uchar *,int))  size=5 ==== */
int __thiscall E8A_USB::GetStatus(E8A_USB *this, unsigned __int8 *a2, int a3)
{
  return 0;
}


/* ==== 1000AB00  ?Cancel@E8A_USB@@QAEHXZ  (E8A_USB::Cancel(void))  size=16 ==== */
int __thiscall E8A_USB::Cancel(HANDLE *this)
{
  CancelIo(this[20736]);
  return 0;
}


/* ==== 1000AB10  ?GetName@E8A_USB@@QAEHPAD@Z  (E8A_USB::GetName(char *))  size=38 ==== */
int __thiscall E8A_USB::GetName(E8A_USB *this, char *Buffer)
{
  return E8A_USB::GetName(
           this,
           *((HANDLE *)this + 20736),
           (struct _USB_DEVICE_DESCRIPTOR *)this + 458,
           *((_DWORD *)this + 20735),
           0x40u,
           Buffer,
           1);
}


/* ==== 1000AB40  ?IsSupportedDevice@E8A_USB@@IAEHG@Z  (E8A_USB::IsSupportedDevice(ushort))  size=41 ==== */
int __thiscall E8A_USB::IsSupportedDevice(E8A_USB *this, unsigned __int16 a2)
{
  _WORD *i; // eax
  void *v3; // edx

  for ( i = &unk_1001DE92; a2 != *i; i -= 3 )
  {
    v3 = i;
    if ( v3 == &unk_1001DE8C )
      return 0;
  }
  return 1;
}


/* ==== 1000AB70  ?OpenFirstDevice@E8A_USB@@IAEPAXPAH@Z  (E8A_USB::OpenFirstDevice(int *))  size=116 ==== */
int __thiscall E8A_USB::OpenFirstDevice(struct _USB_DEVICE_DESCRIPTOR *this, int *a2)
{
  __int16 v3; // bx
  int v4; // ebp
  void *v5; // eax
  void *v6; // esi

  v3 = 0;
  v4 = 19;
  while ( 1 )
  {
    v5 = E8A_USB::OpenInstance((E8A_USB *)this, v3);
    v6 = v5;
    if ( v5 != (void *)-1 )
      break;
LABEL_6:
    ++v3;
    if ( !v4-- )
      return -1;
  }
  if ( !E8A_USB::GetDeviceDescriptor((E8A_USB *)this, v5, this + 458)
    || !E8A_USB::IsSupportedDevice((E8A_USB *)this, this[458].idProduct) )
  {
    CloseHandle(v6);
    goto LABEL_6;
  }
  if ( a2 )
    *a2 = v3;
  return (int)v6;
}


/* ==== 1000ABF0  ?OpenInstance@E8A_USB@@IAEPAXH@Z  (E8A_USB::OpenInstance(int))  size=68 ==== */
HANDLE __thiscall E8A_USB::OpenInstance(E8A_USB *this, int a2)
{
  char Buffer[256]; // [esp+0h] [ebp-100h] BYREF

  sprintf(Buffer, "\\\\.\\HmseUsb%d", a2);
  return CreateFileA(Buffer, 0xC0000000, 0, 0, 3u, 0x60000080u, 0);
}


/* ==== 1000AC40  ?OpenPortID@E8A_USB@@IAEPAXHPAD@Z  (E8A_USB::OpenPortID(int,char *))  size=148 ==== */
HANDLE __thiscall E8A_USB::OpenPortID(E8A_USB *this, int a2, char *a3)
{
  HANDLE FileA; // esi
  LPCSTR lpFileName; // [esp+4h] [ebp-10h] BYREF
  int v7; // [esp+10h] [ebp-4h]

  CString::CString((CString *)&lpFileName);
  v7 = 0;
  sub_1000A030(*((_DWORD *)this + a2 + 2131), *((_DWORD *)this + a2 + 2141), a3, (CString *)&lpFileName);
  FileA = CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x60000080u, 0);
  v7 = -1;
  CString::~CString((CString *)&lpFileName);
  return FileA;
}


/* ==== 1000ACE0  ?OpenDevice@E8A_USB@@IAEPAXPAH@Z  (E8A_USB::OpenDevice(int *))  size=117 ==== */
HANDLE __thiscall E8A_USB::OpenDevice(struct _USB_DEVICE_DESCRIPTOR *this, int a2)
{
  int *v2; // edi
  int v4; // eax
  bool v5; // zf
  HANDLE result; // eax

  v2 = (int *)a2;
  v4 = *(_DWORD *)a2;
  a2 = *(_DWORD *)a2;
  if ( a2 >= 10 || (v5 = sub_10009F10((unsigned __int8 *)(&String)[v4]) == 0, v4 = a2, v5) )
  {
    if ( v4 == -1 )
      result = (HANDLE)E8A_USB::OpenFirstDevice(this, &a2);
    else
      result = E8A_USB::OpenInstance((E8A_USB *)this, v4);
    *v2 = a2;
  }
  else
  {
    result = E8A_USB::OpenPortID((E8A_USB *)this, a2, (&String)[a2]);
    *v2 = a2;
  }
  return result;
}


/* ==== 1000AD60  ?GetName@E8A_USB@@IAEHPAXPAU_USB_DEVICE_DESCRIPTOR@@HIPADH@Z  (E8A_USB::GetName(void *,_USB_DEVICE_DESCRIPTOR *,int,uint,char *,int))  size=320 ==== */
int __thiscall E8A_USB::GetName(
        E8A_USB *this,
        HANDLE hDevice,
        struct _USB_DEVICE_DESCRIPTOR *a3,
        int a4,
        size_t BufferCount,
        char *Buffer,
        int a7)
{
  signed int i; // esi
  unsigned __int8 Dest[512]; // [esp+10h] [ebp-400h] BYREF
  char v10[512]; // [esp+210h] [ebp-200h] BYREF

  memset(Dest, 0, sizeof(Dest));
  if ( !a3->iManufacturer && !a3->iProduct && !a3->iSerialNumber )
  {
    for ( i = 0; i < 10; ++i )
    {
      if ( !sub_1000A130(i, BufferCount, Buffer) )
        break;
      if ( sub_10009F10((unsigned __int8 *)Buffer) )
        return 1;
    }
    return 0;
  }
  sub_10009C60(hDevice, Dest, 0x200u, (int)a3);
  if ( !a3->iSerialNumber )
    return 0;
  sub_10009D20(hDevice, a4, v10, 0x200u, (DWORD)a3);
  if ( a7 )
  {
    snprintf(Buffer, BufferCount, "%s%s%s", (const char *)Dest, asc_10022070, v10);
    return 1;
  }
  else
  {
    snprintf(Buffer, BufferCount, "%s", v10);
    return 1;
  }
}


/* ==== 1000AEA0  ?GetDeviceDetails@E8A_USB@@IAEHXZ  (E8A_USB::GetDeviceDetails(void))  size=216 ==== */
BOOL __thiscall E8A_USB::GetDeviceDetails(HANDLE *this)
{
  int v2; // ecx
  _WORD *v3; // eax
  void *v4; // edi
  _BYTE InBuffer[2]; // [esp+Ah] [ebp-Ah] BYREF
  DWORD BytesReturned; // [esp+Ch] [ebp-8h] BYREF
  DWORD v8; // [esp+10h] [ebp-4h] BYREF

  if ( !E8A_USB::GetDeviceDescriptor((E8A_USB *)this) || !E8A_USB::GetConfigDescriptor((E8A_USB *)this) )
    return 0;
  v2 = 1;
  v3 = &unk_1001DE92;
  while ( *((_WORD *)this + 4127) != *v3 )
  {
    v4 = v3;
    --v2;
    v3 -= 3;
    if ( v4 == &unk_1001DE8C )
      goto LABEL_9;
  }
  if ( !E8A_USB::GetPipeReAssignment(
          (E8A_USB *)this,
          (struct _VPIPE *)((char *)&unk_1001DE8C + 6 * v2),
          (struct st_assigned_pipes *)InBuffer)
    || !sub_1000A240(this[20736], 0x80002008, InBuffer, 2u, 0, 0, &BytesReturned) )
  {
    return 0;
  }
LABEL_9:
  if ( !sub_1000A240(this[20736], 0x80002008, 0, 0, InBuffer, 2u, &v8) )
    return 0;
  return E8A_USB::GetEndpointPacketSizes((E8A_USB *)this, (struct st_assigned_pipes *)InBuffer) != 0;
}


/* ==== 1000AF80  ?SetProtocol@E8A_USB@@IAEHG@Z  (E8A_USB::SetProtocol(ushort))  size=542 ==== */
int __thiscall E8A_USB::SetProtocol(E8A_USB *this, unsigned __int16 a2)
{
  void *v3; // eax
  void *v4; // ecx
  void *v7; // [esp-18h] [ebp-458h]
  int v8; // [esp-10h] [ebp-450h]
  int v9; // [esp-10h] [ebp-450h]
  int v10; // [esp-Ch] [ebp-44Ch]
  void *v11; // [esp-4h] [ebp-444h]
  HANDLE v12; // [esp-4h] [ebp-444h]
  char OutBuffer; // [esp+13h] [ebp-42Dh] BYREF
  LPCSTR lpFileName; // [esp+14h] [ebp-42Ch] BYREF
  int v15; // [esp+18h] [ebp-428h] BYREF
  int InBuffer; // [esp+1Ch] [ebp-424h] BYREF
  int v17; // [esp+20h] [ebp-420h]
  int v18; // [esp+24h] [ebp-41Ch]
  BOOL v19; // [esp+28h] [ebp-418h]
  HANDLE hObject; // [esp+2Ch] [ebp-414h]
  DWORD BytesReturned; // [esp+30h] [ebp-410h] BYREF
  char Buffer[1024]; // [esp+34h] [ebp-40Ch] BYREF
  int v23; // [esp+43Ch] [ebp-4h]

  if ( *((_WORD *)this + 4127) == 0x8236 )
  {
    v8 = *((_DWORD *)this + 20735);
    v7 = (void *)*((_DWORD *)this + 20736);
    OutBuffer = 0;
    v19 = E8A_USB::GetName(this, v7, (struct _USB_DEVICE_DESCRIPTOR *)this + 458, v8, 0x400u, Buffer, 0) != 0;
    InBuffer = 0;
    v17 = 0;
    v3 = (void *)*((_DWORD *)this + 20736);
    HIWORD(InBuffer) = a2;
    LOBYTE(InBuffer) = 64;
    HIWORD(v17) = 1;
    if ( !sub_1000A240(v3, 0x80002010, &InBuffer, 8u, &OutBuffer, 1u, &BytesReturned) )
      return 0;
    if ( OutBuffer == 2 )
    {
      v4 = (void *)*((_DWORD *)this + 20736);
      v11 = (void *)*((_DWORD *)this + 20740);
      v15 = -1;
      hObject = v4;
      SetEvent(v11);
      ResetEvent(*((HANDLE *)this + 20742));
      WaitForSingleObject(*((HANDLE *)this + 20742), 0x3E8u);
      v18 = 49;
      while ( 1 )
      {
        Sleep(0x64u);
        if ( v19 )
        {
          CString::CString((CString *)&lpFileName);
          v10 = *((unsigned __int16 *)this + 4127);
          v9 = *((unsigned __int16 *)this + 4126);
          v23 = 0;
          sub_1000A030(v9, v10, Buffer, (CString *)&lpFileName);
          *((_DWORD *)this + 20736) = CreateFileA(lpFileName, 0xC0000000, 0, 0, 3u, 0x60000080u, 0);
          v15 = 0;
          v23 = -1;
          CString::~CString((CString *)&lpFileName);
        }
        else
        {
          *((_DWORD *)this + 20736) = E8A_USB::OpenDevice((struct _USB_DEVICE_DESCRIPTOR *)this, (int)&v15);
        }
        if ( *((_DWORD *)this + 20736) != -1 && E8A_USB::GetDeviceDetails((HANDLE *)this) )
          break;
        if ( v18-- == 0 )
        {
          CloseHandle(hObject);
          return 0;
        }
      }
      v12 = hObject;
      *((_DWORD *)this + 20735) = v15;
      CloseHandle(v12);
      return 1;
    }
    if ( !OutBuffer )
      return 0;
    Sleep(0x96u);
  }
  return 1;
}


/* ==== 1000B1A0  ?GetDeviceDescriptor@E8A_USB@@IAEHPAXPAU_USB_DEVICE_DESCRIPTOR@@@Z  (E8A_USB::GetDeviceDescriptor(void *,_USB_DEVICE_DESCRIPTOR *))  size=54 ==== */
int __thiscall E8A_USB::GetDeviceDescriptor(E8A_USB *this, HANDLE hDevice, struct _USB_DEVICE_DESCRIPTOR *lpOutBuffer)
{
  int result; // eax

  result = sub_1000A240(hDevice, 0x80002000, 0, 0, lpOutBuffer, 0x12u, (LPDWORD)&lpOutBuffer);
  if ( result )
    return (unsigned int)lpOutBuffer >= 0x12;
  return result;
}


/* ==== 1000B1E0  ?GetDeviceDescriptor@E8A_USB@@IAEHXZ  (E8A_USB::GetDeviceDescriptor(void))  size=41 ==== */
int __thiscall E8A_USB::GetDeviceDescriptor(E8A_USB *this)
{
  *((_DWORD *)this + 2061) = 0;
  *((_DWORD *)this + 2062) = 0;
  *((_DWORD *)this + 2063) = 0;
  *((_DWORD *)this + 2064) = 0;
  *((_WORD *)this + 4130) = 0;
  return E8A_USB::GetDeviceDescriptor(this, *((HANDLE *)this + 20736), (struct _USB_DEVICE_DESCRIPTOR *)this + 458);
}


/* ==== 1000B210  ?GetConfigDescriptor@E8A_USB@@IAEHXZ  (E8A_USB::GetConfigDescriptor(void))  size=57 ==== */
BOOL __thiscall E8A_USB::GetConfigDescriptor(E8A_USB *this)
{
  DWORD BytesReturned; // [esp+0h] [ebp-4h] BYREF

  BytesReturned = (DWORD)this;
  *(_DWORD *)((char *)this + 8262) = 0;
  return sub_1000A240(*((HANDLE *)this + 20736), 0x80002004, 0, 0, (char *)this + 8262, 0xFFu, &BytesReturned) != 0;
}


/* ==== 1000B250  ?GetDataFromBuffer@E8A_USB@@IAEKPAPAEK@Z  (E8A_USB::GetDataFromBuffer(uchar * *,ulong))  size=74 ==== */
unsigned int __thiscall E8A_USB::GetDataFromBuffer(E8A_USB *this, unsigned __int8 **a2, unsigned int a3)
{
  unsigned int v3; // esi
  char *v4; // edi

  v3 = sub_10009960(dword_1002338C);
  if ( !v3 )
    return 0;
  v4 = (char *)*a2;
  if ( v3 > a3 )
    v3 = a3;
  sub_10009BE0(dword_1002338C, v4, v3);
  *a2 = (unsigned __int8 *)&v4[v3];
  return v3;
}


/* ==== 1000B2A0  ?GetPipeReAssignment@E8A_USB@@IAEHPAU_VPIPE@@PAUst_assigned_pipes@@@Z  (E8A_USB::GetPipeReAssignment(_VPIPE *,st_assigned_pipes *))  size=244 ==== */
BOOL __thiscall E8A_USB::GetPipeReAssignment(E8A_USB *this, struct _VPIPE *a2, struct st_assigned_pipes *a3)
{
  int v3; // edx
  unsigned __int8 *v4; // esi
  int v5; // edi
  int v6; // eax
  unsigned __int8 v7; // dl
  int v9; // [esp+10h] [ebp-8h]
  unsigned __int8 *v10; // [esp+14h] [ebp-4h]

  v3 = *((unsigned __int8 *)this + 8262);
  v4 = (unsigned __int8 *)this + v3 + *((unsigned __int8 *)this + v3 + 8262) * *((unsigned __int8 *)this + 8266) + 8262;
  v10 = (unsigned __int8 *)this + v3 + 8266;
  if ( *v10 < 2u )
    return 0;
  v5 = 0;
  v6 = 0;
  v7 = 0;
  v9 = 0;
  do
  {
    if ( *((_BYTE *)a2 + 2) == v4[2] && !v5 )
    {
      *(_BYTE *)a3 = v7;
      v5 = 1;
    }
    if ( *((_BYTE *)a2 + 3) == v4[2] && !v6 )
    {
      *((_BYTE *)a3 + 1) = v7;
      v6 = 1;
    }
    if ( *((_BYTE *)a2 + 4) == v4[2] && !v9 )
    {
      *((_BYTE *)this + 82948) = v7;
      v9 = 1;
    }
    v4 += *v4;
    ++v7;
  }
  while ( v7 < *v10 );
  return v5 == 1 && v6 == 1 && v9 == 1;
}


/* ==== 1000B3A0  ?GetEndpointPacketSizes@E8A_USB@@IAEHPAUst_assigned_pipes@@@Z  (E8A_USB::GetEndpointPacketSizes(st_assigned_pipes *))  size=173 ==== */
BOOL __thiscall E8A_USB::GetEndpointPacketSizes(E8A_USB *this, struct st_assigned_pipes *a2)
{
  int v2; // edx
  int v3; // edi
  unsigned __int8 *v4; // esi
  int v5; // ebp
  unsigned __int8 v6; // bl

  v2 = *((unsigned __int8 *)this + 8262);
  v3 = 0;
  v4 = (unsigned __int8 *)this + v2 + *((unsigned __int8 *)this + v2 + 8262) * *((unsigned __int8 *)this + 8266) + 8262;
  if ( *((_BYTE *)this + v2 + 8266) < 2u )
    return 0;
  v5 = 0;
  v6 = 0;
  do
  {
    if ( *(_BYTE *)a2 == v6 && !v3 )
    {
      *((_WORD *)this + 4259) = *((_WORD *)v4 + 2);
      v3 = 1;
    }
    if ( *((_BYTE *)a2 + 1) == v6 && !v5 )
    {
      v5 = 1;
      *((_WORD *)this + 4260) = *((_WORD *)v4 + 2);
    }
    v4 += *v4;
    ++v6;
  }
  while ( v6 < *((_BYTE *)this + v2 + 8266) );
  return v3 == 1 && v5 == 1;
}


/* ==== 1000B450  ?StopThread@E8A_USB@@IAEXPAU_MONCTL@@@Z  (E8A_USB::StopThread(_MONCTL *))  size=70 ==== */
void __thiscall E8A_USB::StopThread(E8A_USB *this, HANDLE *a2)
{
  HANDLE *v2; // edi
  int v3; // esi

  SetEvent(a2[1]);
  v2 = a2 + 7;
  WaitForSingleObject(a2[7], 0x9C4u);
  CloseHandle(*a2);
  v3 = 7;
  do
  {
    CloseHandle(*v2);
    --v3;
    --v2;
  }
  while ( v3 );
}


/* ==== 1000B4A0  sub_1000B4A0  ()  size=131 ==== */
int __cdecl sub_1000B4A0(DWORD NumberOfBytesTransferred)
{
  DWORD v1; // esi
  void *v3; // [esp-8h] [ebp-Ch]

  v1 = NumberOfBytesTransferred;
  if ( GetOverlappedResult(
         *(HANDLE *)(NumberOfBytesTransferred + 82944),
         (LPOVERLAPPED)(NumberOfBytesTransferred + 82988),
         &NumberOfBytesTransferred,
         0) )
  {
    SetEvent(*(HANDLE *)(v1 + 82972));
    return 1;
  }
  else
  {
    v3 = *(void **)(v1 + 82968);
    *(_DWORD *)(v1 + 87104) = 1;
    SetEvent(v3);
    CancelIo(*(HANDLE *)(v1 + 82944));
    CloseHandle(*(HANDLE *)(v1 + 82944));
    *(_DWORD *)(v1 + 82944) = -1;
    *(_DWORD *)(v1 + 82940) = -1;
    return 2;
  }
}


/* ==== 1000B530  sub_1000B530  ()  size=202 ==== */
int __cdecl sub_1000B530(DWORD BytesReturned)
{
  DWORD v1; // esi
  struct _OVERLAPPED *v2; // ebp
  DWORD v3; // eax
  int result; // eax
  void *v5; // [esp-20h] [ebp-30h]
  DWORD v6; // [esp-1Ch] [ebp-2Ch]

  v1 = BytesReturned;
  v2 = (struct _OVERLAPPED *)(BytesReturned + 82988);
  while ( 1 )
  {
    do
    {
      *(_DWORD *)(v1 + 83004) = *(_DWORD *)(v1 + 82968);
      v6 = (4 * *(unsigned __int8 *)(v1 + 82948) + 8216) | 0x80000000;
      v5 = *(void **)(v1 + 82944);
      *(_DWORD *)(v1 + 82996) = 0;
      *(_DWORD *)(v1 + 83000) = 0;
      if ( DeviceIoControl(v5, v6, 0, 0, (LPVOID)(v1 + 83008), 0x1000u, &BytesReturned, v2) )
        goto LABEL_6;
    }
    while ( GetLastError() != 997 );
    v3 = WaitForMultipleObjects(4u, (const HANDLE *)(v1 + 82956), 0, 0xFFFFFFFF);
    if ( !v3 )
      break;
    if ( v3 != 3 )
    {
      CancelIo(*(HANDLE *)(v1 + 82944));
      return 2;
    }
LABEL_6:
    result = sub_1000B4A0(v1);
    if ( result != 1 )
      return result;
  }
  CancelIo(*(HANDLE *)(v1 + 82944));
  return 0;
}


/* ==== 1000B600  sub_1000B600  ()  size=103 ==== */
int __stdcall sub_1000B600(LPVOID lpThreadParameter)
{
  DWORD v1; // eax
  int v2; // eax

  SetThreadPriority(*((HANDLE *)lpThreadParameter + 20738), 15);
  while ( 1 )
  {
    v1 = WaitForMultipleObjects(3u, (const HANDLE *)lpThreadParameter + 20739, 0, 0xFFFFFFFF);
    if ( !v1 )
      break;
    if ( v1 == 1 && (v2 = sub_1000B530((DWORD)lpThreadParameter), v2 != 2) )
    {
      if ( !v2 )
        break;
    }
    else
    {
      SetEvent(*((HANDLE *)lpThreadParameter + 20744));
    }
  }
  SetEvent(*((HANDLE *)lpThreadParameter + 20745));
  return 0;
}


/* ==== 1000B670  ULE_Identify  ()  size=6 ==== */
char *ULE_Identify()
{
  return aUsbInterface;
}


/* ==== 1000B680  ULE_Initialise  ()  size=160 ==== */
int __cdecl ULE_Initialise(const char *a1, _DWORD *a2)
{
  __int16 v2; // ax
  int result; // eax

  if ( !strcmp(a1, aUsbInterface) )
  {
    sub_1000C430(-1);
    sub_1000BA90();
    v2 = sub_1000C5D0(&String, &dword_10023614, 10, 0x40u);
    if ( v2 )
    {
      (&String)[v2] = 0;
      *a2 = &String;
      return 0;
    }
    else
    {
      result = 16;
      *a2 = 0;
    }
  }
  else
  {
    *a2 = 0;
    return 11;
  }
  return result;
}


/* ==== 1000B720  ULE_ConnectDevice  ()  size=93 ==== */
int __cdecl ULE_ConnectDevice(const char *a1, char *a2)
{
  if ( !strcmp(a1, aUsbInterface) && (sub_1000BA90(), sub_1000C4D0(a2)) )
    return 0;
  else
    return 11;
}


/* ==== 1000B780  ULE_Select  ()  size=30 ==== */
int __cdecl ULE_Select(int a1)
{
  int v1; // eax

  v1 = -(sub_1000C430(dword_10023614[a1]) != 0);
  LOBYTE(v1) = v1 & 0xFB;
  return v1 + 5;
}


/* ==== 1000B7A0  ULE_Terminate  ()  size=40 ==== */
int ULE_Terminate()
{
  int v1; // eax

  if ( !dword_10023744 && sub_1000C100() == -1 )
    return 11;
  v1 = -(sub_1000C580() != 0);
  LOBYTE(v1) = v1 & 0xF5;
  return v1 + 11;
}


/* ==== 1000B7D0  ULE_GetConfiguration  ()  size=6 ==== */
char *ULE_GetConfiguration()
{
  return byte_10023388;
}


/* ==== 1000B7E0  ULE_SetDriverConfiguration  ()  size=348 ==== */
int __cdecl ULE_SetDriverConfiguration(const char *a1)
{
  if ( !strcmp(a1, aNotimeoutcheck) )
    sub_10018030(1);
  if ( !strcmp(a1, aNoovercurrent) )
  {
    dword_10023740 = 1;
    dword_10023744 = 0;
  }
  if ( !strcmp(a1, aNoterminate) )
  {
    dword_10023740 = 0;
    dword_10023744 = 1;
  }
  if ( !strcmp(a1, aNoovercurrentN) )
  {
    dword_10023740 = 1;
    dword_10023744 = 1;
  }
  if ( !strcmp(a1, byte_10023388) )
  {
    dword_10023740 = 0;
    dword_10023744 = 0;
    sub_10018030(0);
  }
  return 0;
}


/* ==== 1000B940  ULE_SetControllerConfiguration  ()  size=4 ==== */
__int16 ULE_SetControllerConfiguration()
{
  return 0;
}


/* ==== 1000B950  ULE_Poll  ()  size=15 ==== */
int ULE_Poll()
{
  int v0; // eax

  v0 = -(sub_10001CE0() != 0);
  LOBYTE(v0) = v0 & 0xFB;
  return v0 + 5;
}


/* ==== 1000B960  ULE_DLLError  ()  size=66 ==== */
char *__cdecl ULE_DLLError(unsigned int a1)
{
  char *result; // eax

  if ( a1 <= 0x12 )
    return off_10022938[a1];
  switch ( a1 )
  {
    case 0x13u:
      result = aCannotLocateUs;
      break;
    case 0x14u:
      result = aEmulatorIsSwit;
      break;
    case 0x15u:
      result = aEmulatorIsOver;
      break;
    case 0x16u:
      result = aUsbDriverInter;
      break;
    default:
      result = aUsbDriverInter_0;
      break;
  }
  return result;
}


/* ==== 1000B9C0  LibraryName  ()  size=54 ==== */
int __cdecl LibraryName(_DWORD *a1)
{
  int result; // eax

  strcpy(byte_100236BC, aRenesasCommuni);
  result = 0;
  *a1 = byte_100236BC;
  return result;
}


/* ==== 1000BA00  LibraryType  ()  size=54 ==== */
int __cdecl LibraryType(_DWORD *a1)
{
  int result; // eax

  strcpy(byte_1002363C, aDriver);
  result = 0;
  *a1 = byte_1002363C;
  return result;
}


/* ==== 1000BA40  LibraryVersion  ()  size=21 ==== */
int __cdecl LibraryVersion(_WORD *a1)
{
  word_1002373C = 1000;
  *a1 = 1000;
  return 0;
}


/* ==== 1000BA60  ULE_ConnectCheck  ()  size=37 ==== */
int ULE_ConnectCheck()
{
  int v0; // eax
  int v1; // eax

  v0 = sub_1000BAD0();
  if ( !v0 )
    return 0;
  v1 = v0 - 1;
  if ( !v1 )
    return 20;
  if ( v1 == 1 )
    return 21;
  return 11;
}


/* ==== 1000BA90  sub_1000BA90  ()  size=56 ==== */
void *sub_1000BA90()
{
  _DWORD *v0; // esi
  char *v1; // edx
  void *result; // eax

  v0 = &off_100229A8;
  v1 = (char *)&unk_100235D4;
  do
  {
    *v0 = v1;
    memset(&unk_10023394, 0, 0x40u);
    result = v1;
    v1 -= 64;
    --v0;
  }
  while ( result != &unk_10023394 );
  off_100229AC = 0;
  return result;
}


/* ==== 1000BAD0  sub_1000BAD0  ()  size=1569 ==== */
char sub_1000BAD0()
{
  char v0; // bl
  unsigned __int16 v1; // ax
  HANDLE EventA; // esi
  DWORD v4; // eax
  int Status; // eax
  char v7; // cl
  char v8; // bl
  unsigned int v9; // eax
  char v10; // cl
  int v11; // eax
  __int16 v12; // ax
  char *v13; // edi
  bool v14; // zf
  int v15; // ecx
  _WORD *v16; // esi
  _WORD *v17; // esi
  int v18; // ecx
  char *v19; // edi
  bool v20; // zf
  unsigned __int8 v21[3]; // [esp+10h] [ebp-88h] BYREF
  unsigned __int8 v22; // [esp+13h] [ebp-85h]
  unsigned __int8 v23; // [esp+14h] [ebp-84h]
  char v24; // [esp+15h] [ebp-83h]
  _DWORD v25[5]; // [esp+18h] [ebp-80h] BYREF
  char v26[20]; // [esp+2Ch] [ebp-6Ch] BYREF
  char v27[20]; // [esp+40h] [ebp-58h] BYREF
  __int16 Buffer; // [esp+54h] [ebp-44h] BYREF
  __int16 v29; // [esp+56h] [ebp-42h]
  _BYTE v30[4]; // [esp+58h] [ebp-40h] BYREF
  _BYTE v31[4]; // [esp+5Ch] [ebp-3Ch] BYREF
  _BYTE v32[4]; // [esp+60h] [ebp-38h] BYREF
  int v33; // [esp+64h] [ebp-34h]
  int v34; // [esp+68h] [ebp-30h]
  int v35; // [esp+6Ch] [ebp-2Ch]
  int v36; // [esp+70h] [ebp-28h]
  _BYTE v37[32]; // [esp+74h] [ebp-24h] BYREF
  _BYTE v38[4]; // [esp+94h] [ebp-4h] BYREF

  strcpy((char *)v25, "USB START BY E10");
  strcpy(v27, "USB CONNECTION OK");
  strcpy(v26, "ERROR OVERCURRENT");
  v0 = 5;
  while ( 1 )
  {
    v1 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v1 + 1;
    if ( v1 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    Buffer = *((_WORD *)dword_10023774 + 41271);
    v29 = 64;
    sub_10014050(v30, -1510974961, 4);
    sub_10014050(v31, 32, 4);
    sub_10014050(v32, 0x80000000, 4);
    v33 = v25[0];
    v35 = v25[2];
    v34 = v25[1];
    v36 = v25[3];
    v37[0] = v25[4];
    sub_10014050(v37, -257618086, 4);
    memset(&v37[4], 0, 0x1Cu);
    sub_10014050(v38, -1510974961, 4);
    E8A_USB::SetE1Timeout(dword_10023774, 3);
    if ( !v0-- )
      return -1;
    EventA = CreateEventA(0, 1, 0, 0);
    v4 = E8A_USB::Write(dword_10023774, &Buffer, 0x40u, EventA);
    if ( v4 == 64 )
      goto LABEL_31;
    if ( v4 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_10:
      *((_DWORD *)dword_10023774 + 2152) = 0;
      goto LABEL_11;
    }
    if ( !v4 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_31;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  dword_1002374C = GetTickCount();
  do
    dword_10023748 = GetTickCount();
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
  Status = E8A_USB::GetStatus(dword_10023774, v21, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( Status <= 0 )
  {
    CancelIo(EventA);
    goto LABEL_10;
  }
  if ( v24 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  if ( (!v21[0] || v22 != *((_WORD *)dword_10023774 + 41271)) && (!v21[1] || v23 != *((_WORD *)dword_10023774 + 41271)) )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_31:
  CloseHandle(EventA);
  v7 = v0;
  v8 = v0 - 1;
  v29 = 64;
  if ( !v7 )
    return -1;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v9 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
    if ( v9 == 64 )
      goto LABEL_52;
    if ( v9 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_12;
    }
    if ( !v9 )
      break;
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v10 = v8--;
    v29 = 64;
    if ( !v10 )
      return -1;
  }
  dword_1002376C = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_52;
    dword_10023768 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xEA60 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
LABEL_42:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  dword_10023764 = GetTickCount();
  do
    dword_10023760 = GetTickCount();
  while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
  v11 = E8A_USB::GetStatus(dword_10023774, v21, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( v11 <= 0 || v24 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_11:
    CloseHandle(EventA);
LABEL_12:
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  if ( v21[2] <= 1u )
    goto LABEL_42;
  v12 = *((_WORD *)dword_10023774 + 41271);
  if ( v22 != v12 && v23 != v12 )
    goto LABEL_42;
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_52:
  CloseHandle(EventA);
  E8A_USB::SetE1Timeout(dword_10023774, 30);
  v13 = v26;
  v14 = 1;
  v15 = 9;
  v16 = (_WORD *)((char *)dword_10023774 + 78392);
  do
  {
    if ( !v15 )
      break;
    v14 = *v16++ == *(_WORD *)v13;
    v13 += 2;
    --v15;
  }
  while ( v14 );
  if ( v14 )
    return 2;
  v17 = (_WORD *)((char *)dword_10023774 + 78392);
  v18 = 9;
  v19 = v27;
  v20 = 1;
  do
  {
    if ( !v18 )
      break;
    v20 = *v17++ == *(_WORD *)v19;
    v19 += 2;
    --v18;
  }
  while ( v20 );
  return !v20;
}


/* ==== 1000C100  sub_1000C100  ()  size=814 ==== */
int sub_1000C100()
{
  int v0; // ebp
  char v1; // bl
  unsigned __int16 v2; // ax
  HANDLE EventA; // esi
  DWORD v5; // eax
  int result; // eax
  int Status; // eax
  unsigned __int8 v8[12]; // [esp+10h] [ebp-54h] BYREF
  int v9; // [esp+1Ch] [ebp-48h]
  _WORD Buffer[2]; // [esp+20h] [ebp-44h] BYREF
  _BYTE v11[4]; // [esp+24h] [ebp-40h] BYREF
  _BYTE v12[4]; // [esp+28h] [ebp-3Ch] BYREF
  _BYTE v13[4]; // [esp+2Ch] [ebp-38h] BYREF
  int v14; // [esp+30h] [ebp-34h]
  int v15; // [esp+34h] [ebp-30h]
  _BYTE v16[40]; // [esp+38h] [ebp-2Ch] BYREF
  _BYTE v17[4]; // [esp+60h] [ebp-4h] BYREF

  v0 = dword_10022E10;
  v1 = 5;
  v9 = dword_10022E14;
  while ( 1 )
  {
    v2 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v2 + 1;
    if ( v2 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    Buffer[0] = *((_WORD *)dword_10023774 + 41271);
    Buffer[1] = 64;
    sub_10014050(v11, -1510974961, 4);
    sub_10014050(v12, 24, 4);
    sub_10014050(v13, -2147418112, 4);
    v14 = v0;
    v15 = v9;
    sub_10014050(v16, -257618086, 4);
    memset(&v16[4], 0, 0x24u);
    sub_10014050(v17, -1510974961, 4);
    if ( !v1-- )
      return -1;
    EventA = CreateEventA(0, 1, 0, 0);
    v5 = E8A_USB::Write(dword_10023774, Buffer, 0x40u, EventA);
    switch ( v5 )
    {
      case 0x40u:
        goto LABEL_25;
      case 0xFFFFFFFF:
        CancelIo(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
        *((_DWORD *)dword_10023774 + 2152) = 0;
        CloseHandle(EventA);
        *((_WORD *)dword_10023774 + 41270) = 8;
        return -1;
      case 0u:
        dword_10023754 = GetTickCount();
        while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
        {
          dword_10023750 = GetTickCount();
          if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
          {
            if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              *((_WORD *)dword_10023774 + 41270) = 8;
              CloseHandle(EventA);
              return -1;
            }
            dword_1002374C = GetTickCount();
            do
              dword_10023748 = GetTickCount();
            while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
            Status = E8A_USB::GetStatus(dword_10023774, v8, 1);
            *((_DWORD *)dword_10023774 + 2153) = 0;
            if ( Status <= 0 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
            if ( v8[5] )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              *((_WORD *)dword_10023774 + 41270) = 8;
              CloseHandle(EventA);
              return -1;
            }
            if ( v8[0] && v8[3] == *((_WORD *)dword_10023774 + 41271)
              || v8[1] && v8[4] == *((_WORD *)dword_10023774 + 41271) )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              break;
            }
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            result = -1;
            *((_WORD *)dword_10023774 + 41270) = 8;
            return result;
          }
        }
LABEL_25:
        CloseHandle(EventA);
        return 0;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
  }
}


/* ==== 1000C430  sub_1000C430  ()  size=159 ==== */
E8A_USB *__cdecl sub_1000C430(void *a1)
{
  E8A_USB *v1; // eax
  E8A_USB *result; // eax

  if ( dword_10023774 )
  {
    E8A_USB::Connect((HANDLE *)dword_10023774, a1);
LABEL_8:
    dword_10023770 = E8A_USB::GetDeviceId(dword_10023774);
    return (E8A_USB *)(dword_10023770 != 0);
  }
  v1 = (E8A_USB *)operator new(0x15444u);
  if ( v1 )
    result = E8A_USB::E8A_USB(v1, (int)a1);
  else
    result = 0;
  dword_10023774 = result;
  if ( result )
    goto LABEL_8;
  return result;
}


/* ==== 1000C4D0  sub_1000C4D0  ()  size=165 ==== */
E8A_USB *__cdecl sub_1000C4D0(char *a1)
{
  E8A_USB *v1; // eax
  E8A_USB *result; // eax
  int v3; // eax

  if ( dword_10023774 )
  {
    E8A_USB::Release((HANDLE *)dword_10023774);
    v3 = E8A_USB::ConnectToPort((HANDLE *)dword_10023774, a1);
    goto LABEL_8;
  }
  v1 = (E8A_USB *)operator new(0x15444u);
  if ( v1 )
    result = E8A_USB::E8A_USB(v1, -1);
  else
    result = 0;
  dword_10023774 = result;
  if ( result )
  {
    v3 = E8A_USB::ConnectToPort((HANDLE *)result, a1);
LABEL_8:
    dword_10023770 = v3;
    return (E8A_USB *)(v3 != 0);
  }
  return result;
}


/* ==== 1000C580  sub_1000C580  ()  size=65 ==== */
int sub_1000C580()
{
  E8A_USB *v0; // esi

  if ( !dword_10023774 )
    return 1;
  E8A_USB::Release((HANDLE *)dword_10023774);
  v0 = dword_10023774;
  if ( dword_10023774 )
  {
    E8A_USB::~E8A_USB((HANDLE *)dword_10023774);
    operator delete(v0);
  }
  dword_10023774 = 0;
  return 1;
}


/* ==== 1000C5D0  sub_1000C5D0  ()  size=32 ==== */
__int16 __cdecl sub_1000C5D0(char **a1, int *a2, __int16 a3, size_t BufferCount)
{
  return E8A_USB::ScanBus(dword_10023774, a1, a2, a3, BufferCount);
}


/* ==== 1000C5F0  ULE_ReadMemory  ()  size=2609 ==== */
int __cdecl ULE_ReadMemory(unsigned __int16 a1, char *a2, int a3, unsigned __int8 a4)
{
  int result; // eax
  unsigned __int16 v5; // ax
  bool v6; // zf
  HANDLE EventA; // esi
  DWORD v8; // eax
  int Status; // eax
  unsigned __int16 v10; // di
  DWORD v11; // edi
  DWORD v12; // eax
  int v13; // eax
  unsigned int v14; // eax
  int v15; // eax
  __int16 v16; // ax
  unsigned __int16 v17; // di
  DWORD v18; // edi
  unsigned int v19; // eax
  int v20; // eax
  __int16 v21; // ax
  char v22; // [esp+12h] [ebp-4Eh]
  char v23; // [esp+13h] [ebp-4Dh]
  unsigned __int8 v24; // [esp+14h] [ebp-4Ch] BYREF
  unsigned __int8 v25; // [esp+15h] [ebp-4Bh]
  unsigned __int8 v26; // [esp+16h] [ebp-4Ah]
  unsigned __int8 v27; // [esp+17h] [ebp-49h]
  unsigned __int8 v28; // [esp+18h] [ebp-48h]
  char v29; // [esp+19h] [ebp-47h]
  _BYTE v30[64]; // [esp+1Ch] [ebp-44h] BYREF
  _BYTE v31[4]; // [esp+5Ch] [ebp-4h] BYREF

  v22 = 0;
  v23 = 5;
  if ( *((_DWORD *)dword_10023774 + 20734) )
  {
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = 64;
  sub_10014050(v30, -1510974961, 4);
  sub_10014050(&v30[4], 24, 4);
  sub_10014050(&v30[8], -2147024896, 4);
  sub_10014050(&v30[12], a3, 4);
  sub_10014050(&v30[16], a1, 2);
  sub_10014050(&v30[18], a4, 2);
  sub_10014050(&v30[20], -257618086, 4);
  memset(&v30[24], 0, 0x28u);
  sub_10014050(v31, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v30, 0x18u);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v5 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v5 + 1;
  if ( v5 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v22 )
      {
        v6 = v23-- == 0;
        if ( v6 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return -1;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v22 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v8 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v8 )
      {
        case 0x40u:
          goto LABEL_26;
        case 0xFFFFFFFF:
          *((_DWORD *)dword_10023774 + 20734) = 1;
          CancelIo(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_26;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
LABEL_34:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v24, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_102;
          }
          if ( v29 )
            goto LABEL_34;
          if ( (v24 <= 1u || v27 != *((_WORD *)dword_10023774 + 41271))
            && (v25 <= 1u || v28 != *((_WORD *)dword_10023774 + 41271)) )
          {
LABEL_42:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_26:
          CloseHandle(EventA);
          goto LABEL_27;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v22 = 1;
    }
LABEL_27:
    v10 = *((_WORD *)dword_10023774 + 41270);
    if ( v10 <= 0x40u )
    {
      while ( 1 )
      {
        while ( 1 )
        {
LABEL_55:
          if ( (unsigned __int8)v22 > 2u )
          {
            v6 = v23-- == 0;
            if ( v6 )
            {
              result = -1;
              *((_WORD *)dword_10023774 + 41270) = 8;
              *((_DWORD *)dword_10023774 + 20634) = 0;
              return result;
            }
          }
          if ( (unsigned __int8)v22 < 4u )
            break;
LABEL_75:
          v17 = *((_WORD *)dword_10023774 + 39189);
          if ( v17 <= 0x40u )
            goto LABEL_100;
          EventA = CreateEventA(0, 1, 0, 0);
          v18 = (unsigned __int16)(v17 - 64);
          v19 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v18, EventA);
          if ( v19 == v18 )
            goto LABEL_99;
          if ( v19 == -1 )
          {
            *((_DWORD *)dword_10023774 + 20734) = 1;
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_94:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( !v19 )
          {
            dword_10023764 = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023760 = GetTickCount();
              if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                  goto LABEL_88;
                dword_1002376C = GetTickCount();
                do
                  dword_10023768 = GetTickCount();
                while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
                v20 = E8A_USB::GetStatus(dword_10023774, &v24, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v20 <= 0 || v29 )
                  goto LABEL_93;
                if ( v26 == 3 )
                {
                  v21 = *((_WORD *)dword_10023774 + 41271);
                  if ( v27 == v21 || v28 == v21 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                goto LABEL_101;
              }
            }
LABEL_99:
            CloseHandle(EventA);
LABEL_100:
            qmemcpy(a2, (char *)dword_10023774 + 78392, a1);
            result = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            return result;
          }
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(EventA);
          CloseHandle(EventA);
          v22 = 4;
        }
        EventA = CreateEventA(0, 1, 0, 0);
        v14 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
        if ( v14 == 64 )
          goto LABEL_74;
        if ( v14 == -1 )
        {
          *((_DWORD *)dword_10023774 + 20734) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          goto LABEL_103;
        }
        if ( !v14 )
          break;
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CancelIo(EventA);
        CloseHandle(EventA);
        v22 = 3;
      }
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_93;
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v15 = E8A_USB::GetStatus(dword_10023774, &v24, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v15 <= 0 )
          {
LABEL_93:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            goto LABEL_94;
          }
          if ( v29 )
          {
LABEL_88:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v26 > 1u )
          {
            v16 = *((_WORD *)dword_10023774 + 41271);
            if ( v27 == v16 || v28 == v16 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
LABEL_101:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_102;
        }
      }
LABEL_74:
      CloseHandle(EventA);
      goto LABEL_75;
    }
    EventA = CreateEventA(0, 1, 0, 0);
    v11 = (unsigned __int16)(v10 - (*((_WORD *)dword_10023774 + 41270) & 0x3F));
    v12 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8680, v11, EventA);
    if ( v12 == v11 )
    {
LABEL_54:
      CloseHandle(EventA);
      goto LABEL_55;
    }
    if ( v12 == -1 )
      break;
    if ( !v12 )
    {
      dword_1002374C = GetTickCount();
      do
      {
        if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
          goto LABEL_54;
        dword_10023748 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v13 = E8A_USB::GetStatus(dword_10023774, &v24, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v13 > 0
          && !v29
          && (v24 == 3 && v27 == *((_WORD *)dword_10023774 + 41271)
           || v25 == 3 && v28 == *((_WORD *)dword_10023774 + 41271)) )
        {
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          goto LABEL_55;
        }
      }
      goto LABEL_42;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v22 = 2;
  }
  *((_DWORD *)dword_10023774 + 20734) = 1;
  CancelIo(EventA);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_102:
  CloseHandle(EventA);
LABEL_103:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 1000D030  ULE_WriteMemory  ()  size=2853 ==== */
int __cdecl ULE_WriteMemory(int a1, const void *a2, int a3, unsigned __int8 a4)
{
  unsigned __int16 v4; // bp
  E8A_USB *v5; // eax
  unsigned __int16 v6; // ax
  unsigned __int16 v7; // ax
  unsigned __int16 v8; // ax
  void (__stdcall *v9)(HANDLE); // edi
  bool v10; // zf
  HANDLE EventA; // esi
  DWORD v12; // eax
  int Status; // eax
  unsigned __int16 v14; // ax
  DWORD v15; // eax
  int v16; // eax
  unsigned int v17; // eax
  int v18; // eax
  __int16 v19; // ax
  unsigned __int16 v20; // di
  HANDLE v21; // esi
  DWORD v22; // edi
  unsigned int v23; // eax
  int v24; // eax
  __int16 v25; // ax
  int result; // eax
  char v27; // [esp+11h] [ebp-93h]
  char v28; // [esp+12h] [ebp-92h]
  char v29; // [esp+13h] [ebp-91h]
  unsigned __int8 v30; // [esp+14h] [ebp-90h] BYREF
  unsigned __int8 v31; // [esp+15h] [ebp-8Fh]
  unsigned __int8 v32; // [esp+16h] [ebp-8Eh]
  unsigned __int8 v33; // [esp+17h] [ebp-8Dh]
  unsigned __int8 v34; // [esp+18h] [ebp-8Ch]
  char v35; // [esp+19h] [ebp-8Bh]
  int v36; // [esp+1Ch] [ebp-88h]
  _BYTE v37[4]; // [esp+20h] [ebp-84h] BYREF
  _BYTE v38[4]; // [esp+24h] [ebp-80h] BYREF
  _BYTE v39[4]; // [esp+28h] [ebp-7Ch] BYREF
  _BYTE v40[4]; // [esp+2Ch] [ebp-78h] BYREF
  _BYTE v41[2]; // [esp+30h] [ebp-74h] BYREF
  _BYTE v42[2]; // [esp+32h] [ebp-72h] BYREF
  _BYTE v43[100]; // [esp+34h] [ebp-70h] BYREF
  int v44; // [esp+98h] [ebp-Ch]
  int v45; // [esp+9Ch] [ebp-8h]
  _BYTE v46[4]; // [esp+A0h] [ebp-4h] BYREF

  v4 = a1;
  v27 = 0;
  v28 = 5;
  v29 = 0;
  v36 = 0;
  if ( (unsigned __int16)a1 > 0x800u )
  {
    v29 = 1;
    v36 = a1 - 2048;
    v4 = 2048;
  }
  v5 = dword_10023774;
  if ( *((_DWORD *)dword_10023774 + 20734) )
    goto LABEL_104;
LABEL_4:
  *((_WORD *)v5 + 41270) = v4 + 28;
  v6 = *((_WORD *)dword_10023774 + 41270);
  if ( v6 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v6 + 4;
  sub_10014050(v37, -1510974961, 4);
  sub_10014050(v38, v4 + 24, 4);
  sub_10014050(v39, -2146959360, 4);
  sub_10014050(v40, a3, 4);
  sub_10014050(v41, v4, 2);
  sub_10014050(v42, a4, 2);
  memset(v43, 0, 0x60u);
  qmemcpy(v43, a2, v4);
  sub_10014050(&v43[v4], -257618086, 4);
  v44 = 0;
  v45 = 0;
  sub_10014050(v46, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v37, v4 + 24);
  v7 = *((_WORD *)dword_10023774 + 41270);
  if ( v7 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v7;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v8 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v8 + 1;
  if ( v8 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v9 = (void (__stdcall *)(HANDLE))CloseHandle;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v27 )
      {
        v10 = v28-- == 0;
        if ( v10 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          result = -1;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v27 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v12 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v12 )
      {
        case 0x40u:
          goto LABEL_30;
        case 0xFFFFFFFF:
          *((_DWORD *)dword_10023774 + 20734) = 1;
          CancelIo(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          goto LABEL_112;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_30;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_95;
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v30, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
            goto LABEL_95;
          if ( v35 )
            goto LABEL_96;
          if ( (v30 <= 1u || v33 != *((_WORD *)dword_10023774 + 41271))
            && (v31 <= 1u || v34 != *((_WORD *)dword_10023774 + 41271)) )
          {
            goto LABEL_97;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_30:
          CloseHandle(EventA);
          goto LABEL_31;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v27 = 1;
    }
LABEL_31:
    if ( *((_WORD *)dword_10023774 + 41270) <= 0x40u )
      break;
    EventA = CreateEventA(0, 1, 0, 0);
    *((_WORD *)dword_10023774 + 41270) -= 64;
    v14 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v14 + 1;
    if ( v14 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    *((_WORD *)dword_10023774 + 4338) = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 4339) = *((_WORD *)dword_10023774 + 41270);
    v15 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8676,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v15 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_51;
    if ( v15 == -1 )
    {
      *((_DWORD *)dword_10023774 + 20734) = 1;
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      goto LABEL_106;
    }
    if ( !v15 )
    {
      dword_1002374C = GetTickCount();
      do
      {
        if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
          goto LABEL_51;
        dword_10023748 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v16 = E8A_USB::GetStatus(dword_10023774, &v30, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v16 > 0 )
        {
          if ( !v35 )
          {
            if ( v30 == 3 && v33 == *((_WORD *)dword_10023774 + 41271)
              || v31 == 3 && v34 == *((_WORD *)dword_10023774 + 41271) )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_51:
              CloseHandle(EventA);
              goto LABEL_52;
            }
LABEL_96:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_106:
            v9(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
LABEL_95:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_103:
          v9(EventA);
          v5 = dword_10023774;
LABEL_104:
          *((_WORD *)v5 + 41270) = 8;
          return -1;
        }
      }
LABEL_97:
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
LABEL_112:
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v27 = 2;
  }
  while ( 1 )
  {
    while ( 1 )
    {
LABEL_52:
      if ( (unsigned __int8)v27 > 2u )
      {
        v10 = v28-- == 0;
        if ( v10 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return -1;
        }
      }
      if ( (unsigned __int8)v27 >= 4u )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v17 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      switch ( v17 )
      {
        case 0x40u:
          goto LABEL_71;
        case 0xFFFFFFFF:
          *((_DWORD *)dword_10023774 + 20734) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v9(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_105;
              dword_10023764 = GetTickCount();
              do
                dword_10023760 = GetTickCount();
              while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
              v18 = E8A_USB::GetStatus(dword_10023774, &v30, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v18 <= 0 )
              {
LABEL_105:
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_106;
              }
              if ( v35 )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                v9(EventA);
                goto LABEL_112;
              }
              if ( v32 > 1u )
              {
                v19 = *((_WORD *)dword_10023774 + 41271);
                if ( v33 == v19 || v34 == v19 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  break;
                }
              }
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_103;
            }
          }
LABEL_71:
          v9(EventA);
          goto LABEL_72;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CancelIo(EventA);
      v9(EventA);
      v27 = 3;
    }
LABEL_72:
    v20 = *((_WORD *)dword_10023774 + 39189);
    if ( v20 <= 0x40u )
      goto LABEL_90;
    v21 = CreateEventA(0, 1, 0, 0);
    v22 = (unsigned __int16)(v20 - 64);
    v23 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v22, v21);
    if ( v23 == v22 )
      goto LABEL_89;
    if ( v23 == -1 )
      break;
    if ( !v23 )
    {
      dword_10023764 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023760 = GetTickCount();
        if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_111;
          dword_1002376C = GetTickCount();
          do
            dword_10023768 = GetTickCount();
          while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
          v24 = E8A_USB::GetStatus(dword_10023774, &v30, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v24 <= 0 )
          {
LABEL_111:
            CancelIo(v21);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v21);
            goto LABEL_112;
          }
          if ( v35 )
          {
            CancelIo(v21);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v21);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v32 == 3 )
          {
            v25 = *((_WORD *)dword_10023774 + 41271);
            if ( v33 == v25 || v34 == v25 )
            {
              CancelIo(v21);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
          CancelIo(v21);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(v21);
          goto LABEL_110;
        }
      }
LABEL_89:
      CloseHandle(v21);
LABEL_90:
      *((_WORD *)dword_10023774 + 41270) = 8;
      *((_DWORD *)dword_10023774 + 20634) = 0;
      if ( !v29 )
        return 0;
      v5 = dword_10023774;
      v4 = v36;
      a3 += 2048;
      v29 = 0;
      if ( *((_DWORD *)dword_10023774 + 20734) )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        return -1;
      }
      goto LABEL_4;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(v21);
    CloseHandle(v21);
    v9 = (void (__stdcall *)(HANDLE))CloseHandle;
    v27 = 4;
  }
  *((_DWORD *)dword_10023774 + 20734) = 1;
  CancelIo(v21);
  *((_DWORD *)dword_10023774 + 2151) = 0;
  CloseHandle(v21);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_110:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 1000DB60  E7_ReadMemory  ()  size=2490 ==== */
int __cdecl E7_ReadMemory(unsigned __int16 a1, char *a2, int a3, unsigned __int8 a4)
{
  unsigned __int16 v4; // ax
  bool v5; // zf
  HANDLE EventA; // esi
  DWORD v7; // eax
  int Status; // eax
  unsigned __int16 v9; // di
  DWORD v10; // edi
  DWORD v11; // eax
  int result; // eax
  int v13; // eax
  void (__stdcall *v14)(HANDLE); // edi
  HANDLE v15; // esi
  unsigned int v16; // eax
  int v17; // eax
  __int16 v18; // ax
  unsigned __int16 v19; // di
  DWORD v20; // edi
  unsigned int v21; // eax
  int v22; // eax
  __int16 v23; // ax
  char v24; // [esp+12h] [ebp-4Eh]
  char v25; // [esp+13h] [ebp-4Dh]
  unsigned __int8 v26; // [esp+14h] [ebp-4Ch] BYREF
  unsigned __int8 v27; // [esp+15h] [ebp-4Bh]
  unsigned __int8 v28; // [esp+16h] [ebp-4Ah]
  unsigned __int8 v29; // [esp+17h] [ebp-49h]
  unsigned __int8 v30; // [esp+18h] [ebp-48h]
  char v31; // [esp+19h] [ebp-47h]
  _BYTE v32[64]; // [esp+1Ch] [ebp-44h] BYREF
  _BYTE v33[4]; // [esp+5Ch] [ebp-4h] BYREF

  v24 = 0;
  v25 = 5;
  *((_WORD *)dword_10023774 + 41270) = 64;
  sub_10014050(v32, -1510974961, 4);
  sub_10014050(&v32[4], 24, 4);
  sub_10014050(&v32[8], -2147155968, 4);
  sub_10014050(&v32[12], a3, 4);
  sub_10014050(&v32[16], a1, 2);
  sub_10014050(&v32[18], a4, 2);
  sub_10014050(&v32[20], -257618086, 4);
  memset(&v32[24], 0, 0x28u);
  sub_10014050(v33, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v32, 0x18u);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v4 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v4 + 1;
  if ( v4 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v24 )
      {
        v5 = v25-- == 0;
        if ( v5 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return -1;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v24 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v7 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v7 )
      {
        case 0x40u:
          goto LABEL_24;
        case 0xFFFFFFFF:
          CancelIo(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_32:
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
LABEL_33:
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_24;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
LABEL_34:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v26, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
            goto LABEL_51;
          if ( v31 )
            goto LABEL_34;
          if ( (v26 <= 1u || v29 != *((_WORD *)dword_10023774 + 41271))
            && (v27 <= 1u || v30 != *((_WORD *)dword_10023774 + 41271)) )
          {
            goto LABEL_41;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_24:
          CloseHandle(EventA);
          goto LABEL_25;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v24 = 1;
    }
LABEL_25:
    v9 = *((_WORD *)dword_10023774 + 41270);
    if ( v9 <= 0x40u )
      goto LABEL_54;
    EventA = CreateEventA(0, 1, 0, 0);
    v10 = (unsigned __int16)(v9 - (*((_WORD *)dword_10023774 + 41270) & 0x3F));
    v11 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8680, v10, EventA);
    if ( v11 == v10 )
      goto LABEL_53;
    if ( v11 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      goto LABEL_96;
    }
    if ( !v11 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v24 = 2;
  }
  dword_1002374C = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_53;
    dword_10023748 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
LABEL_41:
    CancelIo(EventA);
    goto LABEL_32;
  }
  dword_10023754 = GetTickCount();
  do
    dword_10023750 = GetTickCount();
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
  v13 = E8A_USB::GetStatus(dword_10023774, &v26, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( v13 <= 0 || v31 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    goto LABEL_96;
  }
  if ( (v26 != 3 || v29 != *((_WORD *)dword_10023774 + 41271))
    && (v27 != 3 || v30 != *((_WORD *)dword_10023774 + 41271)) )
  {
LABEL_51:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_53:
  v14 = (void (__stdcall *)(HANDLE))CloseHandle;
  CloseHandle(EventA);
  while ( 1 )
  {
    if ( (unsigned __int8)v24 > 2u )
    {
      v5 = v25-- == 0;
      if ( v5 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
    }
    if ( (unsigned __int8)v24 < 4u )
    {
      v15 = CreateEventA(0, 1, 0, 0);
      v16 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, v15);
      if ( v16 != 64 )
      {
        if ( v16 == -1 )
        {
          CancelIo(v15);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v14(v15);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
        if ( v16 )
        {
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(v15);
          v14(v15);
          v24 = 3;
          continue;
        }
        dword_1002376C = GetTickCount();
        do
        {
          if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
            goto LABEL_74;
          dword_10023768 = GetTickCount();
        }
        while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xEA60 );
        if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          goto LABEL_82;
        dword_10023764 = GetTickCount();
        do
          dword_10023760 = GetTickCount();
        while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
        v17 = E8A_USB::GetStatus(dword_10023774, &v26, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v17 <= 0 )
        {
LABEL_82:
          CancelIo(v15);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v14(v15);
          goto LABEL_97;
        }
        if ( v31 )
        {
          CancelIo(v15);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v14(v15);
          goto LABEL_33;
        }
        if ( v28 <= 1u || (v18 = *((_WORD *)dword_10023774 + 41271), v29 != v18) && v30 != v18 )
        {
          CancelIo(v15);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v14(v15);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
        CancelIo(v15);
        *((_DWORD *)dword_10023774 + 2151) = 0;
      }
LABEL_74:
      v14(v15);
    }
    v19 = *((_WORD *)dword_10023774 + 39189);
    if ( v19 <= 0x40u )
      goto LABEL_103;
    EventA = CreateEventA(0, 1, 0, 0);
    v20 = (unsigned __int16)(v19 - 64);
    v21 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v20, EventA);
    if ( v21 == v20 )
      goto LABEL_102;
    if ( v21 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v21 )
      break;
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v24 = 4;
LABEL_54:
    v14 = (void (__stdcall *)(HANDLE))CloseHandle;
  }
  dword_10023764 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_102;
    dword_10023760 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xEA60 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
LABEL_90:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  dword_1002376C = GetTickCount();
  do
    dword_10023768 = GetTickCount();
  while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
  v22 = E8A_USB::GetStatus(dword_10023774, &v26, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( v22 <= 0 || v31 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_96:
    CloseHandle(EventA);
LABEL_97:
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  else
  {
    if ( v28 != 3 )
      goto LABEL_90;
    v23 = *((_WORD *)dword_10023774 + 41271);
    if ( v29 != v23 && v30 != v23 )
      goto LABEL_90;
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_102:
    CloseHandle(EventA);
LABEL_103:
    qmemcpy(a2, (char *)dword_10023774 + 78392, a1);
    result = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    *((_DWORD *)dword_10023774 + 20634) = 0;
  }
  return result;
}


/* ==== 1000E520  E7_WriteMemory  ()  size=2310 ==== */
int __cdecl E7_WriteMemory(int a1, const void *a2, int a3, unsigned __int8 a4, char a5)
{
  unsigned __int16 v5; // bp
  unsigned __int16 v6; // ax
  unsigned __int16 v7; // ax
  unsigned __int16 v8; // ax
  char v9; // bl
  void (__stdcall *v10)(HANDLE); // edi
  bool v11; // zf
  HANDLE EventA; // esi
  DWORD v13; // eax
  int Status; // eax
  unsigned int v15; // eax
  int v16; // eax
  __int16 v17; // ax
  unsigned __int16 v18; // di
  HANDLE v19; // esi
  DWORD v20; // edi
  unsigned int v21; // eax
  int v22; // eax
  __int16 v23; // ax
  int result; // eax
  char v25; // [esp+11h] [ebp-93h]
  char v26; // [esp+12h] [ebp-92h]
  char v27; // [esp+13h] [ebp-91h]
  unsigned __int8 v28[2]; // [esp+14h] [ebp-90h] BYREF
  unsigned __int8 v29; // [esp+16h] [ebp-8Eh]
  unsigned __int8 v30; // [esp+17h] [ebp-8Dh]
  unsigned __int8 v31; // [esp+18h] [ebp-8Ch]
  char v32; // [esp+19h] [ebp-8Bh]
  int v33; // [esp+1Ch] [ebp-88h]
  _BYTE v34[4]; // [esp+20h] [ebp-84h] BYREF
  _BYTE v35[4]; // [esp+24h] [ebp-80h] BYREF
  _BYTE v36[4]; // [esp+28h] [ebp-7Ch] BYREF
  _BYTE v37[4]; // [esp+2Ch] [ebp-78h] BYREF
  _BYTE v38[2]; // [esp+30h] [ebp-74h] BYREF
  _BYTE v39[2]; // [esp+32h] [ebp-72h] BYREF
  _BYTE v40[100]; // [esp+34h] [ebp-70h] BYREF
  int v41; // [esp+98h] [ebp-Ch]
  int v42; // [esp+9Ch] [ebp-8h]
  _BYTE v43[4]; // [esp+A0h] [ebp-4h] BYREF

  v5 = a1;
  v26 = 0;
  v25 = 5;
  v27 = 0;
  v33 = 0;
  if ( (unsigned __int16)a1 > 0x800u )
  {
    v27 = 1;
    v33 = a1 - 2048;
    v5 = 2048;
  }
LABEL_3:
  *((_WORD *)dword_10023774 + 41270) = v5 + 28;
  v6 = *((_WORD *)dword_10023774 + 41270);
  if ( v6 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v6 + 4;
  sub_10014050(v34, -1510974961, 4);
  sub_10014050(v35, v5 + 24, 4);
  if ( a5 )
    sub_10014050(v36, -2147090431, 4);
  else
    sub_10014050(v36, -2147090432, 4);
  sub_10014050(v37, a3, 4);
  sub_10014050(v38, v5, 2);
  sub_10014050(v39, a4, 2);
  memset(v40, 0, 0x60u);
  qmemcpy(v40, a2, v5);
  sub_10014050(&v40[v5], -257618086, 4);
  v41 = 0;
  v42 = 0;
  sub_10014050(v43, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v34, v5 + 24);
  v7 = *((_WORD *)dword_10023774 + 41270);
  if ( v7 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v7;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v8 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v8 + 1;
  if ( v8 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v9 = v26;
  v10 = (void (__stdcall *)(HANDLE))CancelIo;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v9 )
    {
      v11 = v25-- == 0;
      if ( v11 )
      {
LABEL_76:
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v13 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8616,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v13 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_31;
    if ( v13 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      goto LABEL_79;
    }
    if ( !v13 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v9 = 1;
    v26 = 1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_31;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
  {
    dword_1002374C = GetTickCount();
    do
      dword_10023748 = GetTickCount();
    while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
    Status = E8A_USB::GetStatus(dword_10023774, v28, 1);
    *((_DWORD *)dword_10023774 + 2153) = 0;
    if ( Status > 0
      && !v32
      && (v28[0] > 1u && v30 == *((_WORD *)dword_10023774 + 41271)
       || v28[1] > 1u && v31 == *((_WORD *)dword_10023774 + 41271)) )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_31:
      CloseHandle(EventA);
      while ( 1 )
      {
        if ( (unsigned __int8)v9 > 2u )
        {
          v11 = v25-- == 0;
          if ( v11 )
            goto LABEL_76;
        }
        if ( (unsigned __int8)v9 < 4u )
        {
          EventA = CreateEventA(0, 1, 0, 0);
          v15 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
          if ( v15 != 64 )
          {
            if ( v15 == -1 )
            {
              v10(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(EventA);
              E8A_USB::Cancel((HANDLE *)dword_10023774);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
            if ( v15 )
            {
              *((_DWORD *)dword_10023774 + 2151) = 0;
              v10(EventA);
              CloseHandle(EventA);
              v9 = 3;
              v26 = 3;
              continue;
            }
            dword_1002376C = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023768 = GetTickCount();
              if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
                {
                  dword_10023764 = GetTickCount();
                  do
                    dword_10023760 = GetTickCount();
                  while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                  v16 = E8A_USB::GetStatus(dword_10023774, v28, 1);
                  *((_DWORD *)dword_10023774 + 2153) = 0;
                  if ( v16 > 0 && !v32 && v29 > 1u )
                  {
                    v17 = *((_WORD *)dword_10023774 + 41271);
                    if ( v30 == v17 || v31 == v17 )
                    {
                      v10(EventA);
                      *((_DWORD *)dword_10023774 + 2151) = 0;
                      break;
                    }
                  }
                }
                v10(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_79;
              }
            }
          }
          CloseHandle(EventA);
        }
        v18 = *((_WORD *)dword_10023774 + 39189);
        if ( v18 <= 0x40u )
          goto LABEL_70;
        v19 = CreateEventA(0, 1, 0, 0);
        v20 = (unsigned __int16)(v18 - 64);
        v21 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v20, v19);
        if ( v21 == v20 )
          goto LABEL_69;
        if ( v21 == -1 )
        {
          CancelIo(v19);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(v19);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
        if ( !v21 )
        {
          dword_10023764 = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023760 = GetTickCount();
            if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_83;
              dword_1002376C = GetTickCount();
              do
                dword_10023768 = GetTickCount();
              while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
              v22 = E8A_USB::GetStatus(dword_10023774, v28, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v22 <= 0 )
              {
LABEL_83:
                CancelIo(v19);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(v19);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
              if ( !v32 && v29 == 3 )
              {
                v23 = *((_WORD *)dword_10023774 + 41271);
                if ( v30 == v23 || v31 == v23 )
                {
                  CancelIo(v19);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  break;
                }
              }
              CancelIo(v19);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(v19);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
          }
LABEL_69:
          CloseHandle(v19);
LABEL_70:
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          if ( v27 )
          {
            v5 = v33;
            v27 = 0;
            a3 += 2048;
            goto LABEL_3;
          }
          return 0;
        }
        v10 = (void (__stdcall *)(HANDLE))CancelIo;
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CancelIo(v19);
        CloseHandle(v19);
        v9 = 4;
        v26 = 4;
      }
    }
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_79:
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 1000EE30  H_UDI_TX  ()  size=1025 ==== */
int __cdecl H_UDI_TX(unsigned __int16 a1, _BYTE *a2)
{
  char v2; // bl
  int result; // eax
  char v4; // al
  unsigned int v5; // ecx
  unsigned __int16 v6; // ax
  unsigned __int16 v7; // ax
  HANDLE EventA; // esi
  DWORD v10; // eax
  int Status; // eax
  char v12; // [esp+13h] [ebp-9h]
  unsigned __int8 v13[8]; // [esp+14h] [ebp-8h] BYREF

  v2 = 0;
  v12 = 5;
  dword_10023780 = 0;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = a1 + 4;
  if ( a2[7] == 20 && ((v4 = a2[8], v4 == -1) && a2[9] == 0xFF || !v4 && !a2[9]) )
  {
    *((_WORD *)dword_10023774 + 41270) += 4;
    v5 = a1 + 4;
  }
  else
  {
    v5 = a1;
  }
  qmemcpy((char *)dword_10023774 + 8620, a2, v5);
  v6 = *((_WORD *)dword_10023774 + 41270);
  if ( v6 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v6;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v7 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v7 + 1;
  if ( v7 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v2 )
    {
      if ( v12-- == 0 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v10 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8616,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v10 == *((unsigned __int16 *)dword_10023774 + 41270) )
    {
LABEL_34:
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      result = 0;
      *((_DWORD *)dword_10023774 + 20634) = 0;
      return result;
    }
    if ( v10 == -1 )
    {
      *((_DWORD *)dword_10023774 + 20733) = 1;
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v10 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_34;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_41:
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  dword_1002374C = GetTickCount();
  do
    dword_10023748 = GetTickCount();
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
  Status = E8A_USB::GetStatus(dword_10023774, v13, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( Status <= 0 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    goto LABEL_41;
  }
  if ( !v13[5]
    && (v13[0] > 1u && v13[3] == *((_WORD *)dword_10023774 + 41271)
     || v13[1] > 1u && v13[4] == *((_WORD *)dword_10023774 + 41271)) )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    goto LABEL_34;
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 1000F240  H_UDI_RX  ()  size=1358 ==== */
int __cdecl H_UDI_RX(int a1, void *a2)
{
  char v2; // al
  int result; // eax
  HANDLE EventA; // esi
  unsigned int v6; // eax
  int Status; // eax
  __int16 v8; // ax
  unsigned int v9; // ebp
  unsigned __int16 v10; // di
  DWORD v11; // edi
  unsigned int v12; // eax
  int LenWritten; // edi
  int v14; // eax
  __int16 v15; // ax
  char v16; // [esp+13h] [ebp-9h]
  unsigned __int8 v17[2]; // [esp+14h] [ebp-8h] BYREF
  unsigned __int8 v18; // [esp+16h] [ebp-6h]
  unsigned __int8 v19; // [esp+17h] [ebp-5h]
  unsigned __int8 v20; // [esp+18h] [ebp-4h]
  char v21; // [esp+19h] [ebp-3h]

  v2 = 0;
  v16 = 5;
  if ( dword_10023780 )
    goto LABEL_51;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  while ( 1 )
  {
    while ( 1 )
    {
      if ( (unsigned __int8)v2 > 2u && v16-- == 0 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
      if ( (unsigned __int8)v2 >= 4u )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v6 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      switch ( v6 )
      {
        case 0x40u:
          goto LABEL_24;
        case 0xFFFFFFFF:
          goto LABEL_31;
        case 0u:
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
              {
                dword_10023764 = GetTickCount();
                do
                  dword_10023760 = GetTickCount();
                while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                Status = E8A_USB::GetStatus(dword_10023774, v17, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( Status > 0 && !v21 && v18 > 1u )
                {
                  v8 = *((_WORD *)dword_10023774 + 41271);
                  if ( v19 == v8 || v20 == v8 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
              }
              goto LABEL_38;
            }
          }
LABEL_24:
          CloseHandle(EventA);
          goto LABEL_25;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v2 = 3;
    }
LABEL_25:
    v9 = 60;
    v10 = *((_WORD *)dword_10023774 + 39189);
    if ( v10 <= 0x40u )
      goto LABEL_50;
    EventA = CreateEventA(0, 1, 0, 0);
    v11 = (unsigned __int16)(v10 - 64);
    v12 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v11, EventA);
    if ( v12 == v11 )
      break;
    if ( v12 == -1 )
    {
LABEL_31:
      *((_DWORD *)dword_10023774 + 20733) = 1;
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v12 )
    {
      dword_10023764 = GetTickCount();
      do
      {
        LenWritten = E8A_USB::GetLenWritten(dword_10023774, 0);
        if ( LenWritten != -1 )
          goto LABEL_48;
        dword_10023760 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xEA60 );
      LenWritten = E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0);
      if ( LenWritten != 1 )
      {
        dword_1002376C = GetTickCount();
        do
          dword_10023768 = GetTickCount();
        while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
        v14 = E8A_USB::GetStatus(dword_10023774, v17, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v14 > 0 && !v21 && v18 == 3 )
        {
          v15 = *((_WORD *)dword_10023774 + 41271);
          if ( v19 == v15 || v20 == v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_48:
            v9 = LenWritten + 60;
            goto LABEL_49;
          }
        }
      }
LABEL_38:
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 4;
  }
  v9 = v12 + 60;
LABEL_49:
  CloseHandle(EventA);
LABEL_50:
  dword_10023780 = 1;
  dword_10023784 = v9;
  dword_10023788 = (int)&byte_1002378C;
  qmemcpy(&byte_1002378C, (char *)dword_10023774 + 78380, v9);
  if ( !dword_10023780 )
    return -1;
LABEL_51:
  if ( dword_10023784 < (unsigned int)(unsigned __int16)a1 )
  {
    dword_10023780 = 0;
    return -1;
  }
  else
  {
    qmemcpy(a2, (const void *)dword_10023788, (unsigned __int16)a1);
    sub_10014090(a2, a1, 4);
    dword_10023788 += (unsigned __int16)a1;
    dword_10023784 -= (unsigned __int16)a1;
    *((_WORD *)dword_10023774 + 41270) = 8;
    *((_DWORD *)dword_10023774 + 20634) = 0;
    return 0;
  }
}


/* ==== 1000F790  H_SCI_RX  ()  size=1323 ==== */
int __cdecl H_SCI_RX(unsigned __int16 a1, void *a2)
{
  char v2; // al
  HANDLE EventA; // esi
  unsigned int v5; // eax
  int Status; // eax
  __int16 v7; // ax
  unsigned int v8; // ebp
  unsigned __int16 v9; // di
  DWORD v10; // edi
  unsigned int v11; // eax
  int result; // eax
  int LenWritten; // edi
  int v14; // eax
  __int16 v15; // ax
  __int16 v16; // cx
  char v17; // [esp+13h] [ebp-9h]
  unsigned __int8 v18[2]; // [esp+14h] [ebp-8h] BYREF
  unsigned __int8 v19; // [esp+16h] [ebp-6h]
  unsigned __int8 v20; // [esp+17h] [ebp-5h]
  unsigned __int8 v21; // [esp+18h] [ebp-4h]
  char v22; // [esp+19h] [ebp-3h]

  v2 = 0;
  v17 = 5;
  if ( dword_10023780 )
    goto LABEL_49;
  while ( 1 )
  {
    while ( 1 )
    {
      if ( (unsigned __int8)v2 > 2u && v17-- == 0 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
      if ( (unsigned __int8)v2 >= 4u )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v5 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      switch ( v5 )
      {
        case 0x40u:
          goto LABEL_21;
        case 0xFFFFFFFF:
          goto LABEL_28;
        case 0u:
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
              {
                dword_10023764 = GetTickCount();
                do
                  dword_10023760 = GetTickCount();
                while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                Status = E8A_USB::GetStatus(dword_10023774, v18, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( Status > 0 && !v22 && v19 > 1u )
                {
                  v7 = *((_WORD *)dword_10023774 + 41271);
                  if ( v20 == v7 || v21 == v7 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
              }
              goto LABEL_41;
            }
          }
LABEL_21:
          CloseHandle(EventA);
          goto LABEL_22;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v2 = 3;
    }
LABEL_22:
    v8 = 60;
    v9 = *((_WORD *)dword_10023774 + 39189);
    if ( v9 <= 0x40u )
      goto LABEL_48;
    EventA = CreateEventA(0, 1, 0, 0);
    v10 = (unsigned __int16)(v9 - 64);
    v11 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v10, EventA);
    if ( v11 == v10 )
      break;
    if ( v11 == -1 )
    {
LABEL_28:
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v11 )
    {
      dword_10023764 = GetTickCount();
      do
      {
        LenWritten = E8A_USB::GetLenWritten(dword_10023774, 0);
        if ( LenWritten != -1 )
          goto LABEL_46;
        dword_10023760 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xEA60 );
      LenWritten = E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0);
      if ( LenWritten != 1 )
      {
        dword_1002376C = GetTickCount();
        do
          dword_10023768 = GetTickCount();
        while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
        v14 = E8A_USB::GetStatus(dword_10023774, v18, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v14 > 0 && !v22 && v19 == 3 )
        {
          v15 = *((_WORD *)dword_10023774 + 41271);
          if ( v20 == v15 || v21 == v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_46:
            v8 = LenWritten + 60;
            goto LABEL_47;
          }
        }
      }
LABEL_41:
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 4;
  }
  v8 = v11 + 60;
LABEL_47:
  CloseHandle(EventA);
LABEL_48:
  dword_10023780 = 1;
  dword_10023784 = v8;
  dword_10023788 = (int)&byte_1002378C;
  qmemcpy(&byte_1002378C, (char *)dword_10023774 + 78380, v8);
  if ( !dword_10023780 )
    return -1;
LABEL_49:
  if ( !a1 )
  {
    LOBYTE(v16) = 0;
    HIBYTE(v16) = byte_1002378C;
    qmemcpy(a2, (const void *)dword_10023788, (unsigned __int16)(((unsigned __int8)byte_1002378D | v16) + 2));
    dword_10023780 = 0;
    goto LABEL_53;
  }
  if ( dword_10023784 < (unsigned int)a1 )
  {
    dword_10023780 = 0;
    return -1;
  }
  else
  {
    qmemcpy(a2, (const void *)dword_10023788, a1);
    dword_10023788 += a1;
    dword_10023784 -= a1;
LABEL_53:
    *((_WORD *)dword_10023774 + 41270) = 8;
    result = 0;
    *((_DWORD *)dword_10023774 + 20634) = 0;
  }
  return result;
}


/* ==== 1000FCC0  CPU_StatusRead  ()  size=1274 ==== */
int __cdecl CPU_StatusRead(char *a1)
{
  unsigned __int16 v1; // ax
  bool v2; // zf
  HANDLE EventA; // esi
  DWORD v4; // eax
  int result; // eax
  int Status; // eax
  unsigned int v7; // eax
  int v8; // eax
  __int16 v9; // ax
  char v10; // [esp+13h] [ebp-4Dh]
  char v11; // [esp+13h] [ebp-4Dh]
  unsigned __int8 v12[3]; // [esp+14h] [ebp-4Ch] BYREF
  unsigned __int8 v13; // [esp+17h] [ebp-49h]
  unsigned __int8 v14; // [esp+18h] [ebp-48h]
  char v15; // [esp+19h] [ebp-47h]
  __int16 Buffer; // [esp+1Ch] [ebp-44h] BYREF
  __int16 v17; // [esp+1Eh] [ebp-42h]
  _BYTE v18[4]; // [esp+20h] [ebp-40h] BYREF
  _BYTE v19[4]; // [esp+24h] [ebp-3Ch] BYREF
  _BYTE v20[4]; // [esp+28h] [ebp-38h] BYREF
  _BYTE v21[4]; // [esp+2Ch] [ebp-34h] BYREF
  _BYTE v22[44]; // [esp+30h] [ebp-30h] BYREF
  _BYTE v23[4]; // [esp+5Ch] [ebp-4h] BYREF

  v10 = 5;
  while ( 1 )
  {
    v1 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v1 + 1;
    if ( v1 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    Buffer = *((_WORD *)dword_10023774 + 41271);
    v17 = 64;
    sub_10014050(v18, -1510974961, 4);
    sub_10014050(v19, 16, 4);
    sub_10014050(v20, -2147221504, 4);
    sub_10014050(v21, -257618086, 4);
    memset(v22, 0, sizeof(v22));
    sub_10014050(v23, -1510974961, 4);
    v2 = v10-- == 0;
    if ( v2 )
      return -1;
    EventA = CreateEventA(0, 1, 0, 0);
    v4 = E8A_USB::Write(dword_10023774, &Buffer, 0x40u, EventA);
    if ( v4 == 64 )
      break;
    if ( v4 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v4 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_44:
            CloseHandle(EventA);
LABEL_45:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( v12[0] && v13 == *((_WORD *)dword_10023774 + 41271)
            || v12[1] && v14 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_27;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_53:
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
  }
LABEL_27:
  CloseHandle(EventA);
  v17 = 64;
  memset(v22, 0, sizeof(v22));
  v2 = v10 == 0;
  v11 = v10 - 1;
  if ( v2 )
    return -1;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v7 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
    if ( v7 == 64 )
      break;
    if ( v7 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_45;
    }
    if ( !v7 )
    {
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v8 = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v8 <= 0 || v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_44;
          }
          if ( v12[2] > 1u )
          {
            v9 = *((_WORD *)dword_10023774 + 41271);
            if ( v13 == v9 || v14 == v9 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_51;
            }
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_53;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v17 = 64;
    memset(v22, 0, sizeof(v22));
    v2 = v11-- == 0;
    if ( v2 )
      return -1;
  }
LABEL_51:
  CloseHandle(EventA);
  result = 0;
  qmemcpy(a1, (char *)dword_10023774 + 78380, 0x18u);
  return result;
}


/* ==== 100101C0  Version_Check  ()  size=1445 ==== */
int __cdecl Version_Check(char *a1)
{
  char v1; // bl
  unsigned __int16 v2; // ax
  char v3; // dl
  HANDLE EventA; // esi
  DWORD v5; // eax
  int result; // eax
  int Status; // eax
  char v8; // cl
  char v9; // bl
  HANDLE v10; // esi
  unsigned int v11; // eax
  int v13; // eax
  __int16 v14; // ax
  unsigned __int8 v15[3]; // [esp+10h] [ebp-60h] BYREF
  unsigned __int8 v16; // [esp+13h] [ebp-5Dh]
  unsigned __int8 v17; // [esp+14h] [ebp-5Ch]
  char v18; // [esp+15h] [ebp-5Bh]
  _DWORD v19[5]; // [esp+18h] [ebp-58h] BYREF
  __int16 Buffer; // [esp+2Ch] [ebp-44h] BYREF
  __int16 v21; // [esp+2Eh] [ebp-42h]
  _BYTE v22[4]; // [esp+30h] [ebp-40h] BYREF
  _BYTE v23[4]; // [esp+34h] [ebp-3Ch] BYREF
  _BYTE v24[4]; // [esp+38h] [ebp-38h] BYREF
  int v25; // [esp+3Ch] [ebp-34h]
  int v26; // [esp+40h] [ebp-30h]
  int v27; // [esp+44h] [ebp-2Ch]
  int v28; // [esp+48h] [ebp-28h]
  _BYTE v29[4]; // [esp+4Ch] [ebp-24h] BYREF
  _BYTE v30[28]; // [esp+50h] [ebp-20h] BYREF
  _BYTE v31[4]; // [esp+6Ch] [ebp-4h] BYREF

  strcpy((char *)v19, "USB START BY E10");
  v1 = 5;
  while ( 1 )
  {
    v2 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v2 + 1;
    if ( v2 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    Buffer = *((_WORD *)dword_10023774 + 41271);
    v21 = 64;
    sub_10014050(v22, -1510974961, 4);
    sub_10014050(v23, 32, 4);
    sub_10014050(v24, 0x80000000, 4);
    v25 = v19[0];
    v27 = v19[2];
    v26 = v19[1];
    v28 = v19[3];
    v29[0] = v19[4];
    sub_10014050(v29, -257618086, 4);
    sub_10014050(v31, -1510974961, 4);
    v3 = v1--;
    memset(v30, 0, sizeof(v30));
    if ( !v3 )
      return -1;
    EventA = CreateEventA(0, 1, 0, 0);
    v5 = E8A_USB::Write(dword_10023774, &Buffer, 0x40u, EventA);
    if ( v5 == 64 )
      goto LABEL_26;
    if ( v5 == -1 )
      break;
    if ( !v5 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, v15, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            goto LABEL_10;
          }
          if ( v18 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( v15[0] && v16 == *((_WORD *)dword_10023774 + 41271)
            || v15[1] && v17 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            break;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
LABEL_26:
      CloseHandle(EventA);
      v21 = 64;
      memset(v30, 0, sizeof(v30));
      v8 = v1;
      v9 = v1 - 1;
      if ( !v8 )
        return -1;
      while ( 1 )
      {
        v10 = CreateEventA(0, 1, 0, 0);
        v11 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, v10);
        if ( v11 == 64 )
          break;
        if ( v11 == -1 )
        {
          CancelIo(v10);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(v10);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          goto LABEL_35;
        }
        if ( !v11 )
        {
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_40;
              dword_10023764 = GetTickCount();
              do
                dword_10023760 = GetTickCount();
              while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
              v13 = E8A_USB::GetStatus(dword_10023774, v15, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v13 <= 0 || v18 )
              {
LABEL_40:
                CancelIo(v10);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(v10);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
              if ( v15[2] > 1u )
              {
                v14 = *((_WORD *)dword_10023774 + 41271);
                if ( v16 == v14 || v17 == v14 )
                {
                  CancelIo(v10);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  goto LABEL_50;
                }
              }
              CancelIo(v10);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(v10);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
          }
          break;
        }
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CancelIo(v10);
        CloseHandle(v10);
        v21 = 64;
        memset(v30, 0, sizeof(v30));
        if ( !v9-- )
          return -1;
      }
LABEL_50:
      CloseHandle(v10);
      result = 0;
      qmemcpy(a1, (char *)dword_10023774 + 78380, 0x28u);
      return result;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
  }
  CancelIo(EventA);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_10:
  *((_DWORD *)dword_10023774 + 2152) = 0;
  CloseHandle(EventA);
LABEL_35:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 10010770  SumCheck  ()  size=1232 ==== */
int __cdecl SumCheck(_WORD *a1)
{
  unsigned __int16 v1; // ax
  HANDLE EventA; // esi
  DWORD v3; // eax
  bool v4; // zf
  int result; // eax
  int Status; // eax
  unsigned int v7; // eax
  int v8; // eax
  __int16 v9; // ax
  char v10; // [esp+3h] [ebp-4Dh]
  char v11; // [esp+3h] [ebp-4Dh]
  unsigned __int8 v12[3]; // [esp+4h] [ebp-4Ch] BYREF
  unsigned __int8 v13; // [esp+7h] [ebp-49h]
  unsigned __int8 v14; // [esp+8h] [ebp-48h]
  char v15; // [esp+9h] [ebp-47h]
  _WORD Buffer[2]; // [esp+Ch] [ebp-44h] BYREF
  _BYTE v17[4]; // [esp+10h] [ebp-40h] BYREF
  _BYTE v18[4]; // [esp+14h] [ebp-3Ch] BYREF
  _BYTE v19[4]; // [esp+18h] [ebp-38h] BYREF
  _BYTE v20[52]; // [esp+1Ch] [ebp-34h] BYREF

  v1 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v1 + 1;
  if ( v1 > 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  Buffer[0] = *((_WORD *)dword_10023774 + 41271);
  Buffer[1] = 64;
  sub_10014050(v17, -1510974961, 4);
  sub_10014050(v18, 16, 4);
  sub_10014050(v19, -2146893824, 4);
  sub_10014050(v20, -257618086, 4);
  memset(&v20[4], 0, 0x2Cu);
  v10 = 4;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v3 = E8A_USB::Write(dword_10023774, Buffer, 0x40u, EventA);
    if ( v3 == 64 )
      break;
    if ( v3 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v3 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_44:
            CloseHandle(EventA);
LABEL_45:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( v12[0] && v13 == *((_WORD *)dword_10023774 + 41271)
            || v12[1] && v14 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_27;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_53:
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v4 = v10-- == 0;
    if ( v4 )
      return -1;
  }
LABEL_27:
  CloseHandle(EventA);
  v4 = v10 == 0;
  v11 = v10 - 1;
  if ( v4 )
    return -1;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v7 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
    if ( v7 == 64 )
      break;
    if ( v7 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_45;
    }
    if ( !v7 )
    {
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v8 = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v8 <= 0 || v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_44;
          }
          if ( v12[2] > 1u )
          {
            v9 = *((_WORD *)dword_10023774 + 41271);
            if ( v13 == v9 || v14 == v9 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_51;
            }
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_53;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v4 = v11-- == 0;
    if ( v4 )
      return -1;
  }
LABEL_51:
  CloseHandle(EventA);
  *a1 = *((_WORD *)dword_10023774 + 39195);
  result = 0;
  *((_WORD *)dword_10023774 + 41270) = 8;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return result;
}


/* ==== 10010C40  MonpOpen  ()  size=1251 ==== */
int __cdecl MonpOpen(_WORD *a1)
{
  unsigned __int16 v1; // ax
  HANDLE EventA; // esi
  DWORD v3; // eax
  bool v4; // zf
  int result; // eax
  int Status; // eax
  unsigned int v7; // eax
  int v8; // eax
  __int16 v9; // ax
  char v10; // [esp+3h] [ebp-4Dh]
  char v11; // [esp+3h] [ebp-4Dh]
  unsigned __int8 v12[3]; // [esp+4h] [ebp-4Ch] BYREF
  unsigned __int8 v13; // [esp+7h] [ebp-49h]
  unsigned __int8 v14; // [esp+8h] [ebp-48h]
  char v15; // [esp+9h] [ebp-47h]
  _WORD Buffer[2]; // [esp+Ch] [ebp-44h] BYREF
  _BYTE v17[4]; // [esp+10h] [ebp-40h] BYREF
  _BYTE v18[4]; // [esp+14h] [ebp-3Ch] BYREF
  _BYTE v19[4]; // [esp+18h] [ebp-38h] BYREF
  _BYTE v20[48]; // [esp+1Ch] [ebp-34h] BYREF
  _BYTE v21[4]; // [esp+4Ch] [ebp-4h] BYREF

  v1 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v1 + 1;
  if ( v1 > 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  Buffer[0] = *((_WORD *)dword_10023774 + 41271);
  Buffer[1] = 64;
  sub_10014050(v17, -1510974961, 4);
  sub_10014050(v18, 16, 4);
  sub_10014050(v19, -2146828288, 4);
  sub_10014050(v20, -257618086, 4);
  memset(&v20[4], 0, 0x2Cu);
  sub_10014050(v21, -1510974961, 4);
  v10 = 4;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v3 = E8A_USB::Write(dword_10023774, Buffer, 0x40u, EventA);
    if ( v3 == 64 )
      break;
    if ( v3 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v3 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_44:
            CloseHandle(EventA);
LABEL_45:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( v12[0] && v13 == *((_WORD *)dword_10023774 + 41271)
            || v12[1] && v14 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_27;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_53:
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v4 = v10-- == 0;
    if ( v4 )
      return -1;
  }
LABEL_27:
  CloseHandle(EventA);
  v4 = v10 == 0;
  v11 = v10 - 1;
  if ( v4 )
    return -1;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v7 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
    if ( v7 == 64 )
      break;
    if ( v7 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_45;
    }
    if ( !v7 )
    {
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v8 = E8A_USB::GetStatus(dword_10023774, v12, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v8 <= 0 || v15 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_44;
          }
          if ( v12[2] > 1u )
          {
            v9 = *((_WORD *)dword_10023774 + 41271);
            if ( v13 == v9 || v14 == v9 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_51;
            }
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_53;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v4 = v11-- == 0;
    if ( v4 )
      return -1;
  }
LABEL_51:
  CloseHandle(EventA);
  *a1 = *((_WORD *)dword_10023774 + 39195);
  result = 0;
  *((_WORD *)dword_10023774 + 41270) = 8;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return result;
}


/* ==== 10011130  ProgDownload  ()  size=1904 ==== */
int __cdecl ProgDownload(int a1, _WORD *a2, unsigned __int8 a3)
{
  unsigned __int16 v3; // bp
  unsigned __int16 v4; // cx
  HANDLE EventA; // esi
  DWORD v6; // eax
  int v7; // eax
  int v8; // edi
  DWORD v9; // eax
  int Status; // eax
  bool v11; // zf
  int result; // eax
  unsigned int v13; // eax
  int v14; // eax
  __int16 v15; // ax
  unsigned __int8 v16; // [esp+10h] [ebp-48h] BYREF
  char v17; // [esp+11h] [ebp-47h]
  unsigned __int8 v18; // [esp+12h] [ebp-46h]
  unsigned __int8 v19; // [esp+13h] [ebp-45h]
  unsigned __int8 v20; // [esp+14h] [ebp-44h]
  char v21; // [esp+15h] [ebp-43h]
  _WORD v22[32]; // [esp+18h] [ebp-40h] BYREF
  char v23; // [esp+64h] [ebp+Ch]
  char v24; // [esp+64h] [ebp+Ch]

  v3 = 64 - ((unsigned __int16)a1 + 8) % 64;
  *((_WORD *)dword_10023774 + 41270) = a1 + v3 + 8;
  v4 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v4 + 1;
  if ( v4 > 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  HIBYTE(v22[0]) = a1;
  *((_WORD *)dword_10023774 + 6388) = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 6389) = *((_WORD *)dword_10023774 + 41270);
  LOBYTE(v22[0]) = BYTE1(a1);
  *((_WORD *)dword_10023774 + 6390) = v22[0];
  qmemcpy((char *)dword_10023774 + 12782, a2, (unsigned __int16)a1);
  v22[0] = a3;
  *(_WORD *)((char *)dword_10023774 + (unsigned __int16)a1 + 12782) = a3;
  v23 = 4;
  memset(v22, 0, v3);
  qmemcpy((char *)dword_10023774 + (unsigned __int16)a1 + 12784, v22, v3);
  LOWORD(a1) = *((_WORD *)dword_10023774 + 41270);
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v6 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 12776, 0x40u, EventA);
    if ( v6 == 64 )
    {
LABEL_20:
      CloseHandle(EventA);
      v8 = 0;
      a1 += 65472;
      while ( (_WORD)a1 )
      {
        v8 += 64;
        EventA = CreateEventA(0, 1, 0, 0);
        a1 += 65472;
        v9 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + v8 + 12776, 0x40u, EventA);
        if ( v9 != 64 )
        {
          if ( v9 == -1 )
          {
            CancelIo(EventA);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_76:
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v9 )
            goto LABEL_39;
          dword_1002374C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023748 = GetTickCount();
            if ( (unsigned int)(dword_10023748 - dword_1002374C) > 0xBB8 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_45;
              dword_10023754 = GetTickCount();
              do
                dword_10023750 = GetTickCount();
              while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
              Status = E8A_USB::GetStatus(dword_10023774, &v16, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( Status <= 0 )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                goto LABEL_67;
              }
              if ( v21 )
                goto LABEL_46;
              if ( v16 == 3 && v19 == *((_WORD *)dword_10023774 + 41271)
                || v17 == 3 && v20 == *((_WORD *)dword_10023774 + 41271) )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                break;
              }
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              goto LABEL_76;
            }
          }
        }
        CloseHandle(EventA);
      }
      v11 = v23 == 0;
      v24 = v23 - 1;
      if ( !v11 )
      {
        while ( 1 )
        {
          EventA = CreateEventA(0, 1, 0, 0);
          v13 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
          if ( v13 == 64 )
            goto LABEL_74;
          if ( v13 == -1 )
            break;
          if ( !v13 )
          {
            dword_1002376C = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023768 = GetTickCount();
              if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  CloseHandle(EventA);
                  *((_WORD *)dword_10023774 + 41270) = 8;
                  return -1;
                }
                dword_10023764 = GetTickCount();
                do
                  dword_10023760 = GetTickCount();
                while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                v14 = E8A_USB::GetStatus(dword_10023774, &v16, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v14 <= 0 || v21 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_67:
                  CloseHandle(EventA);
                  goto LABEL_68;
                }
                if ( v18 > 1u )
                {
                  v15 = *((_WORD *)dword_10023774 + 41271);
                  if ( v19 == v15 || v20 == v15 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_76;
              }
            }
LABEL_74:
            CloseHandle(EventA);
            *a2 = *((_WORD *)dword_10023774 + 39190);
            result = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            return result;
          }
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(EventA);
          CloseHandle(EventA);
          v11 = v24-- == 0;
          if ( v11 )
            return -1;
        }
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_68:
        *((_WORD *)dword_10023774 + 41270) = 8;
      }
      return -1;
    }
    if ( v6 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_42;
    }
    if ( !v6 )
      break;
LABEL_39:
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    LOWORD(a1) = *((_WORD *)dword_10023774 + 41270);
    v11 = v23-- == 0;
    if ( v11 )
      return -1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_20;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
    goto LABEL_43;
  dword_1002374C = GetTickCount();
  do
    dword_10023748 = GetTickCount();
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
  v7 = E8A_USB::GetStatus(dword_10023774, &v16, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( v7 <= 0 )
  {
LABEL_46:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  if ( v21 )
  {
LABEL_43:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  if ( v16 && v19 == *((_WORD *)dword_10023774 + 41271) || v17 && v20 == *((_WORD *)dword_10023774 + 41271) )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    goto LABEL_20;
  }
LABEL_45:
  CancelIo(EventA);
LABEL_42:
  *((_DWORD *)dword_10023774 + 2152) = 0;
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 100118A0  PreEraseWrite_Erase  ()  size=1205 ==== */
int __cdecl PreEraseWrite_Erase(char a1, _WORD *a2)
{
  unsigned __int16 v2; // ax
  HANDLE EventA; // esi
  DWORD v4; // eax
  bool v5; // zf
  int result; // eax
  int Status; // eax
  unsigned int v8; // eax
  int v9; // eax
  __int16 v10; // ax
  unsigned __int8 v11[3]; // [esp+0h] [ebp-48h] BYREF
  unsigned __int8 v12; // [esp+3h] [ebp-45h]
  unsigned __int8 v13; // [esp+4h] [ebp-44h]
  char v14; // [esp+5h] [ebp-43h]
  _WORD Buffer[2]; // [esp+8h] [ebp-40h] BYREF
  _BYTE v16[58]; // [esp+Ch] [ebp-3Ch] BYREF
  __int16 v17; // [esp+46h] [ebp-2h]
  char v18; // [esp+4Ch] [ebp+4h]
  char v19; // [esp+4Ch] [ebp+4h]

  v2 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v2 + 1;
  if ( v2 > 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  Buffer[0] = *((_WORD *)dword_10023774 + 41271);
  Buffer[1] = 64;
  if ( a1 )
    sub_10014050(v16, 18432, 2);
  else
    sub_10014050(v16, 22528, 2);
  memset(&v16[2], 0, 0x38u);
  v18 = 4;
  v17 = 0;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v4 = E8A_USB::Write(dword_10023774, Buffer, 0x40u, EventA);
    if ( v4 == 64 )
      break;
    if ( v4 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v4 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, v11, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_47:
            CloseHandle(EventA);
LABEL_48:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v14 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( v11[0] && v12 == *((_WORD *)dword_10023774 + 41271)
            || v11[1] && v13 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_30;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_56:
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v5 = v18-- == 0;
    if ( v5 )
      return -1;
  }
LABEL_30:
  CloseHandle(EventA);
  v5 = v18 == 0;
  v19 = v18 - 1;
  if ( v5 )
    return -1;
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v8 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
    if ( v8 == 64 )
      break;
    if ( v8 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_48;
    }
    if ( !v8 )
    {
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v9 = E8A_USB::GetStatus(dword_10023774, v11, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v9 <= 0 || v14 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_47;
          }
          if ( v11[2] > 1u )
          {
            v10 = *((_WORD *)dword_10023774 + 41271);
            if ( v12 == v10 || v13 == v10 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_54;
            }
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_56;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v5 = v19-- == 0;
    if ( v5 )
      return -1;
  }
LABEL_54:
  CloseHandle(EventA);
  *a2 = *((_WORD *)dword_10023774 + 39191);
  result = 0;
  *((_WORD *)dword_10023774 + 41270) = 8;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return result;
}


/* ==== 10011D60  AdapterProgramDownload  ()  size=1944 ==== */
int __cdecl AdapterProgramDownload(int a1, _WORD *a2, unsigned __int8 a3)
{
  unsigned __int16 v3; // cx
  __int16 v4; // dx
  char *v5; // edi
  HANDLE EventA; // esi
  DWORD v7; // eax
  int v8; // eax
  int v9; // edi
  DWORD v10; // eax
  int Status; // eax
  bool v12; // zf
  int result; // eax
  unsigned int v14; // eax
  int v15; // eax
  __int16 v16; // ax
  unsigned __int8 v17; // [esp+0h] [ebp-48h] BYREF
  char v18; // [esp+1h] [ebp-47h]
  unsigned __int8 v19; // [esp+2h] [ebp-46h]
  unsigned __int8 v20; // [esp+3h] [ebp-45h]
  unsigned __int8 v21; // [esp+4h] [ebp-44h]
  char v22; // [esp+5h] [ebp-43h]
  _DWORD v23[13]; // [esp+8h] [ebp-40h] BYREF
  char v24; // [esp+54h] [ebp+Ch]
  char v25; // [esp+54h] [ebp+Ch]

  if ( a1 == -1 )
    *((_WORD *)dword_10023774 + 41270) = 64;
  else
    *((_WORD *)dword_10023774 + 41270) = 1088;
  v3 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v3 + 1;
  if ( v3 > 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  LOWORD(v23[0]) = 80;
  v4 = *((_WORD *)dword_10023774 + 41271);
  HIBYTE(v23[0]) = a1;
  *((_WORD *)dword_10023774 + 4308) = v4;
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  *((_WORD *)dword_10023774 + 4310) = v23[0];
  LOBYTE(v23[0]) = HIBYTE(a1);
  BYTE1(v23[0]) = BYTE2(a1);
  BYTE2(v23[0]) = BYTE1(a1);
  *(_DWORD *)((char *)dword_10023774 + 8622) = v23[0];
  if ( a1 == -1 )
  {
    memset(v23, 0, sizeof(v23));
    v5 = (char *)dword_10023774 + 8626;
  }
  else
  {
    qmemcpy((char *)dword_10023774 + 8626, a2, 0x400u);
    *((_WORD *)dword_10023774 + 4825) = a3;
    memset(v23, 0, sizeof(v23));
    v5 = (char *)dword_10023774 + 9652;
  }
  v24 = 4;
  qmemcpy(v5, v23, 0x34u);
  LOWORD(a1) = *((_WORD *)dword_10023774 + 41270);
  while ( 1 )
  {
    EventA = CreateEventA(0, 1, 0, 0);
    v7 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
    if ( v7 == 64 )
    {
LABEL_26:
      CloseHandle(EventA);
      v9 = 0;
      a1 += 65472;
      while ( (_WORD)a1 )
      {
        v9 += 64;
        EventA = CreateEventA(0, 1, 0, 0);
        a1 += 65472;
        v10 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + v9 + 8616, 0x40u, EventA);
        if ( v10 != 64 )
        {
          if ( v10 == -1 )
          {
            CancelIo(EventA);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_82:
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v10 )
            goto LABEL_45;
          dword_1002374C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023748 = GetTickCount();
            if ( (unsigned int)(dword_10023748 - dword_1002374C) > 0xBB8 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_51;
              dword_10023754 = GetTickCount();
              do
                dword_10023750 = GetTickCount();
              while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
              Status = E8A_USB::GetStatus(dword_10023774, &v17, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( Status <= 0 )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                goto LABEL_73;
              }
              if ( v22 )
                goto LABEL_52;
              if ( v17 == 3 && v20 == *((_WORD *)dword_10023774 + 41271)
                || v18 == 3 && v21 == *((_WORD *)dword_10023774 + 41271) )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                break;
              }
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              goto LABEL_82;
            }
          }
        }
        CloseHandle(EventA);
      }
      v12 = v24 == 0;
      v25 = v24 - 1;
      if ( !v12 )
      {
        while ( 1 )
        {
          EventA = CreateEventA(0, 1, 0, 0);
          v14 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
          if ( v14 == 64 )
            goto LABEL_80;
          if ( v14 == -1 )
            break;
          if ( !v14 )
          {
            dword_1002376C = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023768 = GetTickCount();
              if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  CloseHandle(EventA);
                  *((_WORD *)dword_10023774 + 41270) = 8;
                  return -1;
                }
                dword_10023764 = GetTickCount();
                do
                  dword_10023760 = GetTickCount();
                while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                v15 = E8A_USB::GetStatus(dword_10023774, &v17, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v15 <= 0 || v22 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
LABEL_73:
                  CloseHandle(EventA);
                  goto LABEL_74;
                }
                if ( v19 > 1u )
                {
                  v16 = *((_WORD *)dword_10023774 + 41271);
                  if ( v20 == v16 || v21 == v16 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_82;
              }
            }
LABEL_80:
            CloseHandle(EventA);
            *a2 = *((_WORD *)dword_10023774 + 39191);
            result = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            return result;
          }
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(EventA);
          CloseHandle(EventA);
          v12 = v25-- == 0;
          if ( v12 )
            return -1;
        }
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_74:
        *((_WORD *)dword_10023774 + 41270) = 8;
      }
      return -1;
    }
    if ( v7 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_48;
    }
    if ( !v7 )
      break;
LABEL_45:
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    LOWORD(a1) = *((_WORD *)dword_10023774 + 41270);
    v12 = v24-- == 0;
    if ( v12 )
      return -1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_26;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
    goto LABEL_49;
  dword_1002374C = GetTickCount();
  do
    dword_10023748 = GetTickCount();
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
  v8 = E8A_USB::GetStatus(dword_10023774, &v17, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( v8 <= 0 )
  {
LABEL_52:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  if ( v22 )
  {
LABEL_49:
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  if ( v17 && v20 == *((_WORD *)dword_10023774 + 41271) || v18 && v21 == *((_WORD *)dword_10023774 + 41271) )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    goto LABEL_26;
  }
LABEL_51:
  CancelIo(EventA);
LABEL_48:
  *((_DWORD *)dword_10023774 + 2152) = 0;
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 10012500  FPGA_Download  ()  size=2398 ==== */
int __cdecl FPGA_Download(unsigned int a1, _DWORD *a2, int a3, int a4, int a5)
{
  char v5; // bl
  unsigned __int16 v6; // ax
  void (__stdcall *v7)(HANDLE); // edi
  bool v8; // zf
  HANDLE EventA; // esi
  DWORD v10; // eax
  int result; // eax
  int Status; // eax
  unsigned int v13; // ecx
  unsigned __int16 v14; // ax
  unsigned __int16 v15; // bx
  __int16 v16; // ax
  unsigned __int16 v17; // bx
  DWORD v18; // eax
  int v19; // eax
  unsigned int v20; // eax
  int v21; // eax
  __int16 v22; // ax
  _DWORD *v23; // edx
  char v24; // [esp+12h] [ebp-4Eh]
  char v25; // [esp+13h] [ebp-4Dh]
  unsigned __int8 v26; // [esp+14h] [ebp-4Ch] BYREF
  unsigned __int8 v27; // [esp+15h] [ebp-4Bh]
  unsigned __int8 v28; // [esp+16h] [ebp-4Ah]
  unsigned __int8 v29; // [esp+17h] [ebp-49h]
  unsigned __int8 v30; // [esp+18h] [ebp-48h]
  char v31; // [esp+19h] [ebp-47h]
  _BYTE v32[64]; // [esp+1Ch] [ebp-44h] BYREF
  _BYTE v33[4]; // [esp+5Ch] [ebp-4h] BYREF

  v5 = 0;
  v24 = 0;
  v25 = 5;
  *((_WORD *)dword_10023774 + 41270) = 64;
  sub_10014050(v32, -1510974961, 4);
  sub_10014050(&v32[4], 24, 4);
  sub_10014050(&v32[8], -2147352576, 4);
  sub_10014050(&v32[12], a1, 4);
  sub_10014050(&v32[16], a5, 4);
  sub_10014050(&v32[20], -257618086, 4);
  memset(&v32[24], 0, 0x28u);
  sub_10014050(v33, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v32, 0x18u);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v6 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v6 + 1;
  if ( v6 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v7 = (void (__stdcall *)(HANDLE))CancelIo;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v5 )
    {
      v8 = v25-- == 0;
      if ( v8 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return -1;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v10 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
    if ( v10 == 64 )
      break;
    if ( v10 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_89:
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v10 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v26, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
LABEL_67:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v31 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( (v26 <= 1u || v29 != *((_WORD *)dword_10023774 + 41271))
            && (v27 <= 1u || v30 != *((_WORD *)dword_10023774 + 41271)) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_81;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          goto LABEL_29;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v24 = 1;
    v5 = 1;
  }
LABEL_29:
  CloseHandle(EventA);
  if ( a1 )
  {
LABEL_30:
    v13 = 4092;
    if ( a1 <= 0xFFC )
    {
      v13 = a1;
      a1 = 0;
    }
    else
    {
      a1 -= 4092;
    }
    *((_WORD *)dword_10023774 + 41270) = v13;
    v14 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v14 + 1;
    if ( v14 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
    qmemcpy((char *)dword_10023774 + 8620, a2, v13);
    a2 += 1023;
    while ( 1 )
    {
      v15 = *((_WORD *)dword_10023774 + 41270);
      if ( v15 <= 0x40u )
      {
        v17 = 64;
        EventA = CreateEventA(0, 1, 0, 0);
        *((_BYTE *)dword_10023774 + 8618) = 64;
        *((_BYTE *)dword_10023774 + 8619) = 0;
        v18 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      }
      else
      {
        EventA = CreateEventA(0, 1, 0, 0);
        *((_WORD *)dword_10023774 + 4309) = v15;
        v16 = *((_WORD *)dword_10023774 + 41270) & 0x3F;
        v17 = v15 - v16;
        if ( v16 )
          v17 += 64;
        v18 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, v17, EventA);
      }
      if ( v18 == v17 )
        goto LABEL_58;
      if ( v18 == -1 )
        break;
      if ( !v18 )
      {
        dword_1002374C = GetTickCount();
        while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
        {
          dword_10023748 = GetTickCount();
          if ( (unsigned int)(dword_10023748 - dword_1002374C) > 0xBB8 )
          {
            if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
            {
              dword_10023754 = GetTickCount();
              do
                dword_10023750 = GetTickCount();
              while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
              v19 = E8A_USB::GetStatus(dword_10023774, &v26, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v19 > 0
                && !v31
                && (v26 == 3 && v29 == *((_WORD *)dword_10023774 + 41271)
                 || v27 == 3 && v30 == *((_WORD *)dword_10023774 + 41271)) )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                break;
              }
            }
            goto LABEL_67;
          }
        }
LABEL_58:
        CloseHandle(EventA);
        if ( !a1 )
        {
          v5 = v24;
          v7 = (void (__stdcall *)(HANDLE))CancelIo;
          goto LABEL_60;
        }
        goto LABEL_30;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v24 = 2;
    }
    CancelIo(EventA);
    E8A_USB::Cancel((HANDLE *)dword_10023774);
    *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_81:
    CloseHandle(EventA);
LABEL_82:
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  else
  {
    while ( 1 )
    {
LABEL_60:
      if ( (unsigned __int8)v5 > 2u )
      {
        v8 = v25-- == 0;
        if ( v8 )
        {
          result = -1;
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      EventA = CreateEventA(0, 1, 0, 0);
      v20 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      if ( v20 == 64 )
        break;
      if ( v20 == -1 )
      {
        v7(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
        goto LABEL_82;
      }
      if ( !v20 )
      {
        dword_1002376C = GetTickCount();
        while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
        {
          dword_10023768 = GetTickCount();
          if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
          {
            if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            {
              v7(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
            dword_10023764 = GetTickCount();
            do
              dword_10023760 = GetTickCount();
            while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
            v21 = E8A_USB::GetStatus(dword_10023774, &v26, 1);
            *((_DWORD *)dword_10023774 + 2153) = 0;
            if ( v21 <= 0 || v31 )
            {
              v7(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_81;
            }
            if ( v28 > 1u )
            {
              v22 = *((_WORD *)dword_10023774 + 41271);
              if ( v29 == v22 || v30 == v22 )
              {
                v7(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_87;
              }
            }
            v7(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_89;
          }
        }
        break;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      v7(EventA);
      CloseHandle(EventA);
      v5 = 3;
    }
LABEL_87:
    CloseHandle(EventA);
    v23 = (_DWORD *)((char *)dword_10023774 + 78380);
    *a2 = *((_DWORD *)dword_10023774 + 19595);
    a2[1] = v23[1];
    a2[2] = v23[2];
    a2[3] = v23[3];
    *((_WORD *)dword_10023774 + 41270) = 8;
    result = 0;
    *((_DWORD *)dword_10023774 + 20634) = 0;
  }
  return result;
}


/* ==== 10012E60  AUD_TraceRead  ()  size=2200 ==== */
int __cdecl AUD_TraceRead(int a1, int a2)
{
  char v2; // bl
  _DWORD *v3; // eax
  bool v4; // zf
  HANDLE EventA; // esi
  DWORD v6; // eax
  int result; // eax
  int Status; // eax
  void (__stdcall *v9)(HANDLE); // edi
  unsigned int v10; // eax
  int v11; // eax
  __int16 v12; // ax
  __int16 v13; // ax
  unsigned __int16 v14; // di
  HANDLE v15; // esi
  unsigned int v16; // eax
  int v17; // eax
  __int16 v18; // ax
  int i; // eax
  unsigned __int16 v21; // cx
  int v22; // edx
  char v23; // [esp+13h] [ebp-51h]
  unsigned __int8 v24[2]; // [esp+18h] [ebp-4Ch] BYREF
  unsigned __int8 v25; // [esp+1Ah] [ebp-4Ah]
  unsigned __int8 v26; // [esp+1Bh] [ebp-49h]
  unsigned __int8 v27; // [esp+1Ch] [ebp-48h]
  char v28; // [esp+1Dh] [ebp-47h]
  int v29; // [esp+20h] [ebp-44h] BYREF
  int v30; // [esp+24h] [ebp-40h] BYREF
  int v31; // [esp+28h] [ebp-3Ch] BYREF
  _DWORD v32[13]; // [esp+2Ch] [ebp-38h] BYREF
  _BYTE v33[4]; // [esp+60h] [ebp-4h] BYREF

  v2 = 0;
  v23 = 5;
  *((_WORD *)dword_10023774 + 41270) = 64;
  sub_10014050(&v29, -1510974961, 4);
  sub_10014050(&v30, 16, 4);
  sub_10014050(&v31, -2147287040, 4);
  sub_10014050(v32, -257618086, 4);
  memset(&v32[1], 0, 0x30u);
  sub_10014050(v33, -1510974961, 4);
  v3 = (_DWORD *)((char *)dword_10023774 + 8620);
  *((_DWORD *)dword_10023774 + 2155) = v29;
  v3[1] = v30;
  v3[2] = v31;
  v3[3] = v32[0];
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  LOWORD(v3) = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = (_WORD)v3 + 1;
  if ( (unsigned __int16)v3 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v2 )
    {
      v4 = v23-- == 0;
      if ( v4 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return -1;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v6 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
    if ( v6 == 64 )
      goto LABEL_28;
    if ( v6 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
LABEL_65:
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v6 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_28;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  dword_1002374C = GetTickCount();
  do
    dword_10023748 = GetTickCount();
  while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
  Status = E8A_USB::GetStatus(dword_10023774, v24, 1);
  *((_DWORD *)dword_10023774 + 2153) = 0;
  if ( Status <= 0 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_31:
    CloseHandle(EventA);
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  if ( v28 )
  {
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
    *((_WORD *)dword_10023774 + 41270) = 8;
    CloseHandle(EventA);
    return -1;
  }
  if ( v24[0] <= 1u || v26 != *((_WORD *)dword_10023774 + 41271) )
  {
    if ( v24[1] <= 1u || v27 != *((_WORD *)dword_10023774 + 41271) )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    CancelIo(EventA);
    *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_28:
    v9 = (void (__stdcall *)(HANDLE))CancelIo;
    CloseHandle(EventA);
    goto LABEL_32;
  }
  v9 = (void (__stdcall *)(HANDLE))CancelIo;
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
  CloseHandle(EventA);
  while ( 1 )
  {
    while ( 1 )
    {
LABEL_32:
      if ( (unsigned __int8)v2 > 2u )
      {
        v4 = v23-- == 0;
        if ( v4 )
        {
          result = -1;
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      if ( (unsigned __int8)v2 >= 4u )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v10 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      switch ( v10 )
      {
        case 0x40u:
          goto LABEL_51;
        case 0xFFFFFFFF:
          v9(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
              {
                v9(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_31;
              }
              dword_10023764 = GetTickCount();
              do
                dword_10023760 = GetTickCount();
              while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
              v11 = E8A_USB::GetStatus(dword_10023774, v24, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v11 > 0 )
              {
                if ( v28 )
                {
                  v9(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  CloseHandle(EventA);
                  goto LABEL_65;
                }
                if ( v25 > 1u )
                {
                  v12 = *((_WORD *)dword_10023774 + 41271);
                  if ( v26 == v12 || v27 == v12 )
                  {
                    v9(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
              }
              v9(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
          }
LABEL_51:
          CloseHandle(EventA);
          goto LABEL_52;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      v9(EventA);
      CloseHandle(EventA);
      v2 = 3;
    }
LABEL_52:
    LOBYTE(v13) = 0;
    HIBYTE(v13) = BYTE2(*((_DWORD *)dword_10023774 + 19598));
    v14 = (unsigned __int8)HIBYTE(*((_DWORD *)dword_10023774 + 19598)) | v13;
    v15 = CreateEventA(0, 1, 0, 0);
    if ( v14 <= 0x40u )
    {
      v14 = 64;
      v16 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, v15);
    }
    else
    {
      v16 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, v14, v15);
    }
    if ( v16 == v14 )
      goto LABEL_80;
    if ( v16 == -1 )
    {
      CancelIo(v15);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(v15);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      goto LABEL_65;
    }
    if ( !v16 )
      break;
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(v15);
    CloseHandle(v15);
    v2 = 4;
    v9 = (void (__stdcall *)(HANDLE))CancelIo;
  }
  dword_10023764 = GetTickCount();
  while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
  {
    dword_10023760 = GetTickCount();
    if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
    {
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
        goto LABEL_75;
      dword_1002376C = GetTickCount();
      do
        dword_10023768 = GetTickCount();
      while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
      v17 = E8A_USB::GetStatus(dword_10023774, v24, 1);
      *((_DWORD *)dword_10023774 + 2153) = 0;
      if ( v17 <= 0 || v28 || v25 != 3 || (v18 = *((_WORD *)dword_10023774 + 41271), v26 != v18) && v27 != v18 )
      {
LABEL_75:
        CancelIo(v15);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(v15);
        *((_WORD *)dword_10023774 + 41270) = 8;
        return -1;
      }
      CancelIo(v15);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      break;
    }
  }
LABEL_80:
  CloseHandle(v15);
  for ( i = 0; i < 4096; *(_DWORD *)(a2 - 4) = *((unsigned __int8 *)dword_10023774 + i + 78373)
                                             | ((v22 | (v21 << 8)) << 8) )
  {
    a2 += 4;
    HIBYTE(v21) = *((_BYTE *)dword_10023774 + i + 78378);
    v22 = *((unsigned __int8 *)dword_10023774 + i + 78376);
    LOBYTE(v21) = *((_BYTE *)dword_10023774 + i + 78379);
    i += 4;
  }
  *((_WORD *)dword_10023774 + 41270) = 8;
  result = 0;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return result;
}


/* ==== 10013700  FIRM_Download  ()  size=2378 ==== */
int __cdecl FIRM_Download(unsigned int a1, _DWORD *a2)
{
  char v2; // bl
  unsigned __int16 v3; // ax
  void (__stdcall *v4)(HANDLE); // edi
  bool v5; // zf
  HANDLE EventA; // esi
  DWORD v7; // eax
  int result; // eax
  int Status; // eax
  unsigned int v10; // ecx
  unsigned __int16 v11; // ax
  unsigned __int16 v12; // bx
  __int16 v13; // ax
  unsigned __int16 v14; // bx
  DWORD v15; // eax
  int v16; // eax
  unsigned int v17; // eax
  int v18; // eax
  __int16 v19; // ax
  _DWORD *v20; // edx
  char v21; // [esp+12h] [ebp-4Eh]
  char v22; // [esp+13h] [ebp-4Dh]
  unsigned __int8 v23; // [esp+14h] [ebp-4Ch] BYREF
  unsigned __int8 v24; // [esp+15h] [ebp-4Bh]
  unsigned __int8 v25; // [esp+16h] [ebp-4Ah]
  unsigned __int8 v26; // [esp+17h] [ebp-49h]
  unsigned __int8 v27; // [esp+18h] [ebp-48h]
  char v28; // [esp+19h] [ebp-47h]
  _BYTE v29[64]; // [esp+1Ch] [ebp-44h] BYREF
  _BYTE v30[4]; // [esp+5Ch] [ebp-4h] BYREF

  v2 = 0;
  v21 = 0;
  v22 = 5;
  *((_WORD *)dword_10023774 + 41270) = 64;
  sub_10014050(v29, -1510974961, 4);
  sub_10014050(&v29[4], 20, 4);
  sub_10014050(&v29[8], -2146893824, 4);
  sub_10014050(&v29[12], a1, 4);
  sub_10014050(&v29[16], -257618086, 4);
  memset(&v29[20], 0, 0x2Cu);
  sub_10014050(v30, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v29, 0x14u);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v3 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v3 + 1;
  if ( v3 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v4 = (void (__stdcall *)(HANDLE))CancelIo;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v2 )
    {
      v5 = v22-- == 0;
      if ( v5 )
      {
        *((_WORD *)dword_10023774 + 41270) = 8;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return -1;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v7 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
    if ( v7 == 64 )
      break;
    if ( v7 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_89:
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v7 )
    {
      dword_10023754 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023750 = GetTickCount();
        if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v23, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
LABEL_67:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v28 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          if ( (v23 <= 1u || v26 != *((_WORD *)dword_10023774 + 41271))
            && (v24 <= 1u || v27 != *((_WORD *)dword_10023774 + 41271)) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_81;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          goto LABEL_29;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v21 = 1;
    v2 = 1;
  }
LABEL_29:
  CloseHandle(EventA);
  if ( a1 )
  {
LABEL_30:
    v10 = 4092;
    if ( a1 <= 0xFFC )
    {
      v10 = a1;
      a1 = 0;
    }
    else
    {
      a1 -= 4092;
    }
    *((_WORD *)dword_10023774 + 41270) = v10;
    v11 = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 41271) = v11 + 1;
    if ( v11 >= 0xC8u )
      *((_WORD *)dword_10023774 + 41271) = 1;
    *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
    *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
    qmemcpy((char *)dword_10023774 + 8620, a2, v10);
    a2 += 1023;
    while ( 1 )
    {
      v12 = *((_WORD *)dword_10023774 + 41270);
      if ( v12 <= 0x40u )
      {
        v14 = 64;
        EventA = CreateEventA(0, 1, 0, 0);
        *((_BYTE *)dword_10023774 + 8618) = 64;
        *((_BYTE *)dword_10023774 + 8619) = 0;
        v15 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      }
      else
      {
        EventA = CreateEventA(0, 1, 0, 0);
        *((_WORD *)dword_10023774 + 4309) = v12;
        v13 = *((_WORD *)dword_10023774 + 41270) & 0x3F;
        v14 = v12 - v13;
        if ( v13 )
          v14 += 64;
        v15 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, v14, EventA);
      }
      if ( v15 == v14 )
        goto LABEL_58;
      if ( v15 == -1 )
        break;
      if ( !v15 )
      {
        dword_1002374C = GetTickCount();
        while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
        {
          dword_10023748 = GetTickCount();
          if ( (unsigned int)(dword_10023748 - dword_1002374C) > 0xBB8 )
          {
            if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
            {
              dword_10023754 = GetTickCount();
              do
                dword_10023750 = GetTickCount();
              while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
              v16 = E8A_USB::GetStatus(dword_10023774, &v23, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v16 > 0
                && !v28
                && (v23 == 3 && v26 == *((_WORD *)dword_10023774 + 41271)
                 || v24 == 3 && v27 == *((_WORD *)dword_10023774 + 41271)) )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2152) = 0;
                break;
              }
            }
            goto LABEL_67;
          }
        }
LABEL_58:
        CloseHandle(EventA);
        if ( !a1 )
        {
          v2 = v21;
          v4 = (void (__stdcall *)(HANDLE))CancelIo;
          goto LABEL_60;
        }
        goto LABEL_30;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v21 = 2;
    }
    CancelIo(EventA);
    E8A_USB::Cancel((HANDLE *)dword_10023774);
    *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_81:
    CloseHandle(EventA);
LABEL_82:
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  else
  {
    while ( 1 )
    {
LABEL_60:
      if ( (unsigned __int8)v2 > 2u )
      {
        v5 = v22-- == 0;
        if ( v5 )
        {
          result = -1;
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      EventA = CreateEventA(0, 1, 0, 0);
      v17 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      if ( v17 == 64 )
        break;
      if ( v17 == -1 )
      {
        v4(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
        goto LABEL_82;
      }
      if ( !v17 )
      {
        dword_1002376C = GetTickCount();
        while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
        {
          dword_10023768 = GetTickCount();
          if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
          {
            if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            {
              v4(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
            dword_10023764 = GetTickCount();
            do
              dword_10023760 = GetTickCount();
            while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
            v18 = E8A_USB::GetStatus(dword_10023774, &v23, 1);
            *((_DWORD *)dword_10023774 + 2153) = 0;
            if ( v18 <= 0 || v28 )
            {
              v4(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              goto LABEL_81;
            }
            if ( v25 > 1u )
            {
              v19 = *((_WORD *)dword_10023774 + 41271);
              if ( v26 == v19 || v27 == v19 )
              {
                v4(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_87;
              }
            }
            v4(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_89;
          }
        }
        break;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      v4(EventA);
      CloseHandle(EventA);
      v2 = 3;
    }
LABEL_87:
    CloseHandle(EventA);
    v20 = (_DWORD *)((char *)dword_10023774 + 78380);
    *a2 = *((_DWORD *)dword_10023774 + 19595);
    a2[1] = v20[1];
    a2[2] = v20[2];
    a2[3] = v20[3];
    *((_WORD *)dword_10023774 + 41270) = 8;
    result = 0;
    *((_DWORD *)dword_10023774 + 20634) = 0;
  }
  return result;
}


/* ==== 10014050  sub_10014050  ()  size=56 ==== */
int __cdecl sub_10014050(_BYTE *a1, int a2, char a3)
{
  int result; // eax

  result = a2;
  if ( a3 == 4 )
  {
    *a1 = HIBYTE(a2);
    a1[1] = BYTE2(a2);
    a1[2] = BYTE1(a2);
    a1[3] = a2;
  }
  else
  {
    *a1 = BYTE1(a2);
    a1[1] = a2;
  }
  return result;
}


/* ==== 10014090  sub_10014090  ()  size=121 ==== */
char *__cdecl sub_10014090(char *a1, int a2, __int16 a3)
{
  int v3; // ecx
  char *result; // eax
  char v6; // dl
  char v7; // dl
  char v8; // [esp+15h] [ebp+Dh]

  v3 = a2;
  result = a1;
  while ( (_WORD)v3 )
  {
    if ( a3 == 2 )
    {
      v6 = *result;
      *result = result[1];
      result[1] = v6;
      if ( (unsigned __int16)v3 > 2u )
        v3 += 65534;
      else
        v3 = 0;
      result += 2;
    }
    else
    {
      if ( a3 != 4 )
        return result;
      v7 = *result;
      v8 = result[1];
      *result = result[3];
      result[1] = result[2];
      result[2] = v8;
      result[3] = v7;
      if ( (unsigned __int16)v3 > 4u )
        v3 += 65532;
      else
        v3 = 0;
      result += 4;
    }
  }
  return result;
}


/* ==== 10014110  HUDI_SINGLEREAD  ()  size=2721 ==== */
int __cdecl HUDI_SINGLEREAD(unsigned __int16 a1, char *a2, int a3, unsigned __int8 a4)
{
  int result; // eax
  unsigned __int16 v5; // ax
  unsigned __int16 v6; // ax
  bool v7; // zf
  HANDLE EventA; // esi
  DWORD v9; // eax
  int Status; // eax
  unsigned __int16 v11; // di
  DWORD v12; // edi
  DWORD v13; // eax
  int v14; // eax
  unsigned int v15; // eax
  int v16; // eax
  __int16 v17; // ax
  unsigned __int16 v18; // di
  DWORD v19; // edi
  unsigned int v20; // eax
  int v21; // eax
  __int16 v22; // ax
  char v23; // al
  char *v24; // esi
  unsigned int v25; // ecx
  char *v26; // edi
  char *v27; // esi
  unsigned int v28; // ecx
  char v29; // [esp+12h] [ebp-1052h]
  char v30; // [esp+13h] [ebp-1051h]
  unsigned __int8 v31; // [esp+14h] [ebp-1050h] BYREF
  unsigned __int8 v32; // [esp+15h] [ebp-104Fh]
  unsigned __int8 v33; // [esp+16h] [ebp-104Eh]
  unsigned __int8 v34; // [esp+17h] [ebp-104Dh]
  unsigned __int8 v35; // [esp+18h] [ebp-104Ch]
  char v36; // [esp+19h] [ebp-104Bh]
  unsigned int v37; // [esp+1Ch] [ebp-1048h]
  char v38[4]; // [esp+20h] [ebp-1044h] BYREF
  char v39[4]; // [esp+24h] [ebp-1040h] BYREF
  char v40[4]; // [esp+28h] [ebp-103Ch] BYREF
  char v41[4]; // [esp+2Ch] [ebp-1038h] BYREF
  _BYTE v42[4144]; // [esp+30h] [ebp-1034h] BYREF
  char v43[4]; // [esp+1060h] [ebp-4h] BYREF

  v29 = 0;
  v30 = 5;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = a1 + 24;
  v5 = *((_WORD *)dword_10023774 + 41270);
  if ( v5 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v5 + 4;
  sub_10014050(v38, -1510974961, 4);
  v37 = a1;
  sub_10014050(v39, a1 + 20, 4);
  sub_10014050(v40, -2146369536, 4);
  sub_10014050(v41, a4, 4);
  memset(v42, 0, 0x204u);
  qmemcpy(v42, a2, a1);
  sub_10014050(&v42[a1], -257618086, 4);
  memset(&v42[520], 0, 0xE28u);
  sub_10014050(v43, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v38, a1 + 20);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v6 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v6 + 1;
  if ( v6 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v29 )
      {
        v7 = v30-- == 0;
        if ( v7 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return -1;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v29 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v9 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v9 )
      {
        case 0x40u:
          goto LABEL_29;
        case 0xFFFFFFFF:
          *((_DWORD *)dword_10023774 + 20733) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_29;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
LABEL_37:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v31, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_105;
          }
          if ( v36 )
            goto LABEL_37;
          if ( (v31 <= 1u || v34 != *((_WORD *)dword_10023774 + 41271))
            && (v32 <= 1u || v35 != *((_WORD *)dword_10023774 + 41271)) )
          {
LABEL_45:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_29:
          CloseHandle(EventA);
          goto LABEL_30;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v29 = 1;
    }
LABEL_30:
    v11 = *((_WORD *)dword_10023774 + 41270);
    if ( v11 <= 0x40u )
    {
      while ( 1 )
      {
        while ( 1 )
        {
LABEL_58:
          if ( (unsigned __int8)v29 > 2u )
          {
            v7 = v30-- == 0;
            if ( v7 )
            {
              result = -1;
              *((_WORD *)dword_10023774 + 41270) = 8;
              *((_DWORD *)dword_10023774 + 20634) = 0;
              return result;
            }
          }
          if ( (unsigned __int8)v29 < 4u )
            break;
LABEL_78:
          v18 = *((_WORD *)dword_10023774 + 39189);
          if ( v18 <= 0x40u )
            goto LABEL_103;
          EventA = CreateEventA(0, 1, 0, 0);
          v19 = (unsigned __int16)(v18 - 64);
          v20 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v19, EventA);
          if ( v20 == v19 )
            goto LABEL_102;
          if ( v20 == -1 )
          {
            *((_DWORD *)dword_10023774 + 20733) = 1;
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_97:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( !v20 )
          {
            dword_10023764 = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023760 = GetTickCount();
              if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                  goto LABEL_91;
                dword_1002376C = GetTickCount();
                do
                  dword_10023768 = GetTickCount();
                while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
                v21 = E8A_USB::GetStatus(dword_10023774, &v31, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v21 <= 0 || v36 )
                  goto LABEL_96;
                if ( v33 == 3 )
                {
                  v22 = *((_WORD *)dword_10023774 + 41271);
                  if ( v34 == v22 || v35 == v22 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                goto LABEL_104;
              }
            }
LABEL_102:
            CloseHandle(EventA);
LABEL_103:
            v23 = v37;
            v24 = (char *)dword_10023774 + 78392;
            v25 = v37 >> 2;
            qmemcpy(a2, (char *)dword_10023774 + 78392, 4 * (v37 >> 2));
            v27 = &v24[4 * v25];
            v26 = &a2[4 * v25];
            v28 = v23 & 3;
            result = 0;
            qmemcpy(v26, v27, v28);
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            return result;
          }
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(EventA);
          CloseHandle(EventA);
          v29 = 4;
        }
        EventA = CreateEventA(0, 1, 0, 0);
        v15 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
        if ( v15 == 64 )
          goto LABEL_77;
        if ( v15 == -1 )
        {
          *((_DWORD *)dword_10023774 + 20733) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          goto LABEL_106;
        }
        if ( !v15 )
          break;
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CancelIo(EventA);
        CloseHandle(EventA);
        v29 = 3;
      }
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_96;
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v16 = E8A_USB::GetStatus(dword_10023774, &v31, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v16 <= 0 )
          {
LABEL_96:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            goto LABEL_97;
          }
          if ( v36 )
          {
LABEL_91:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v33 > 1u )
          {
            v17 = *((_WORD *)dword_10023774 + 41271);
            if ( v34 == v17 || v35 == v17 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
LABEL_104:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_105;
        }
      }
LABEL_77:
      CloseHandle(EventA);
      goto LABEL_78;
    }
    EventA = CreateEventA(0, 1, 0, 0);
    v12 = (unsigned __int16)(v11 - (*((_WORD *)dword_10023774 + 41270) & 0x3F));
    v13 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8680, v12, EventA);
    if ( v13 == v12 )
    {
LABEL_57:
      CloseHandle(EventA);
      goto LABEL_58;
    }
    if ( v13 == -1 )
      break;
    if ( !v13 )
    {
      dword_1002374C = GetTickCount();
      do
      {
        if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
          goto LABEL_57;
        dword_10023748 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v14 = E8A_USB::GetStatus(dword_10023774, &v31, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v14 > 0
          && !v36
          && (v31 == 3 && v34 == *((_WORD *)dword_10023774 + 41271)
           || v32 == 3 && v35 == *((_WORD *)dword_10023774 + 41271)) )
        {
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          goto LABEL_58;
        }
      }
      goto LABEL_45;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v29 = 2;
  }
  *((_DWORD *)dword_10023774 + 20733) = 1;
  CancelIo(EventA);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_105:
  CloseHandle(EventA);
LABEL_106:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 10014BC0  HUDI_SINGLEWRITE  ()  size=2329 ==== */
int __cdecl HUDI_SINGLEWRITE(int a1, const void *a2, int a3, unsigned __int8 a4)
{
  unsigned __int16 v4; // bp
  E8A_USB *v5; // eax
  unsigned __int16 v6; // ax
  unsigned __int16 v7; // ax
  unsigned __int16 v8; // ax
  char v9; // bl
  void (__stdcall *v10)(HANDLE); // edi
  bool v11; // zf
  HANDLE EventA; // esi
  DWORD v13; // eax
  int Status; // eax
  unsigned int v15; // eax
  int v16; // eax
  __int16 v17; // ax
  unsigned __int16 v18; // di
  HANDLE v19; // esi
  DWORD v20; // edi
  unsigned int v21; // eax
  int v22; // eax
  __int16 v23; // ax
  int result; // eax
  char v25; // [esp+11h] [ebp-1053h]
  char v26; // [esp+12h] [ebp-1052h]
  char v27; // [esp+13h] [ebp-1051h]
  unsigned __int8 v28[2]; // [esp+14h] [ebp-1050h] BYREF
  unsigned __int8 v29; // [esp+16h] [ebp-104Eh]
  unsigned __int8 v30; // [esp+17h] [ebp-104Dh]
  unsigned __int8 v31; // [esp+18h] [ebp-104Ch]
  char v32; // [esp+19h] [ebp-104Bh]
  int v33; // [esp+1Ch] [ebp-1048h]
  _BYTE v34[4]; // [esp+20h] [ebp-1044h] BYREF
  _BYTE v35[4]; // [esp+24h] [ebp-1040h] BYREF
  _BYTE v36[4]; // [esp+28h] [ebp-103Ch] BYREF
  _BYTE v37[4]; // [esp+2Ch] [ebp-1038h] BYREF
  _BYTE v38[4144]; // [esp+30h] [ebp-1034h] BYREF
  _BYTE v39[4]; // [esp+1060h] [ebp-4h] BYREF

  v4 = a1;
  v26 = 0;
  v25 = 5;
  v27 = 0;
  v33 = 0;
  if ( (unsigned __int16)a1 > 0x800u )
  {
    v27 = 1;
    v33 = a1 - 2048;
    v4 = 2048;
  }
LABEL_3:
  v5 = dword_10023774;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
LABEL_81:
    *((_WORD *)v5 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = v4 + 24;
  v6 = *((_WORD *)dword_10023774 + 41270);
  if ( v6 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v6 + 4;
  sub_10014050(v34, -1510974961, 4);
  sub_10014050(v35, v4 + 20, 4);
  sub_10014050(v36, -2146304000, 4);
  sub_10014050(v37, a4, 4);
  memset(v38, 0, 0x204u);
  qmemcpy(v38, a2, v4);
  sub_10014050(&v38[v4], -257618086, 4);
  memset(&v38[520], 0, 0xE28u);
  sub_10014050(v39, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v34, v4 + 20);
  v7 = *((_WORD *)dword_10023774 + 41270);
  if ( v7 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v7;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v8 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v8 + 1;
  if ( v8 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v9 = v26;
  v10 = (void (__stdcall *)(HANDLE))CancelIo;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v9 )
    {
      v11 = v25-- == 0;
      if ( v11 )
      {
LABEL_74:
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v13 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8616,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v13 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_30;
    if ( v13 == -1 )
    {
      *((_DWORD *)dword_10023774 + 20733) = 1;
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v13 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v9 = 1;
    v26 = 1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_30;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
  {
    dword_1002374C = GetTickCount();
    do
      dword_10023748 = GetTickCount();
    while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
    Status = E8A_USB::GetStatus(dword_10023774, v28, 1);
    *((_DWORD *)dword_10023774 + 2153) = 0;
    if ( Status > 0 && !v32 )
    {
      if ( v28[0] > 1u && v30 == *((_WORD *)dword_10023774 + 41271)
        || v28[1] > 1u && v31 == *((_WORD *)dword_10023774 + 41271) )
      {
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_30:
        CloseHandle(EventA);
        while ( 1 )
        {
          if ( (unsigned __int8)v9 > 2u )
          {
            v11 = v25-- == 0;
            if ( v11 )
              goto LABEL_74;
          }
          if ( (unsigned __int8)v9 < 4u )
          {
            EventA = CreateEventA(0, 1, 0, 0);
            v15 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
            if ( v15 != 64 )
            {
              if ( v15 == -1 )
              {
                *((_DWORD *)dword_10023774 + 20733) = 1;
                v10(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(EventA);
                E8A_USB::Cancel((HANDLE *)dword_10023774);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
              if ( v15 )
              {
                *((_DWORD *)dword_10023774 + 2151) = 0;
                v10(EventA);
                CloseHandle(EventA);
                v9 = 3;
                v26 = 3;
                continue;
              }
              dword_1002376C = GetTickCount();
              while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
              {
                dword_10023768 = GetTickCount();
                if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
                {
                  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                    goto LABEL_79;
                  dword_10023764 = GetTickCount();
                  do
                    dword_10023760 = GetTickCount();
                  while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                  v16 = E8A_USB::GetStatus(dword_10023774, v28, 1);
                  *((_DWORD *)dword_10023774 + 2153) = 0;
                  if ( v16 <= 0 )
                  {
LABEL_79:
                    v10(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    goto LABEL_80;
                  }
                  if ( !v32 && v29 > 1u )
                  {
                    v17 = *((_WORD *)dword_10023774 + 41271);
                    if ( v30 == v17 || v31 == v17 )
                    {
                      v10(EventA);
                      *((_DWORD *)dword_10023774 + 2151) = 0;
                      break;
                    }
                  }
                  v10(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  goto LABEL_77;
                }
              }
            }
            CloseHandle(EventA);
          }
          v18 = *((_WORD *)dword_10023774 + 39189);
          if ( v18 <= 0x40u )
            goto LABEL_69;
          v19 = CreateEventA(0, 1, 0, 0);
          v20 = (unsigned __int16)(v18 - 64);
          v21 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v20, v19);
          if ( v21 == v20 )
            goto LABEL_68;
          if ( v21 == -1 )
          {
            *((_DWORD *)dword_10023774 + 20733) = 1;
            CancelIo(v19);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v19);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( !v21 )
          {
            dword_10023764 = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023760 = GetTickCount();
              if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                  goto LABEL_85;
                dword_1002376C = GetTickCount();
                do
                  dword_10023768 = GetTickCount();
                while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
                v22 = E8A_USB::GetStatus(dword_10023774, v28, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v22 <= 0 )
                {
LABEL_85:
                  CancelIo(v19);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  CloseHandle(v19);
                  *((_WORD *)dword_10023774 + 41270) = 8;
                  return -1;
                }
                if ( !v32 && v29 == 3 )
                {
                  v23 = *((_WORD *)dword_10023774 + 41271);
                  if ( v30 == v23 || v31 == v23 )
                  {
                    CancelIo(v19);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                CancelIo(v19);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(v19);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
            }
LABEL_68:
            CloseHandle(v19);
LABEL_69:
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            if ( v27 )
            {
              v4 = v33;
              v27 = 0;
              goto LABEL_3;
            }
            return 0;
          }
          v10 = (void (__stdcall *)(HANDLE))CancelIo;
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(v19);
          CloseHandle(v19);
          v9 = 4;
          v26 = 4;
        }
      }
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_80:
      CloseHandle(EventA);
      v5 = dword_10023774;
      goto LABEL_81;
    }
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_77:
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 100154E0  HUDI_SERIALREAD  ()  size=2764 ==== */
int __cdecl HUDI_SERIALREAD(unsigned __int16 a1, _DWORD *a2, int a3, unsigned __int8 a4)
{
  int result; // eax
  unsigned __int16 v5; // ax
  int v6; // edx
  int v7; // eax
  unsigned __int16 v8; // ax
  unsigned __int16 v9; // cx
  unsigned __int16 v10; // ax
  bool v11; // zf
  HANDLE EventA; // esi
  DWORD v13; // eax
  int Status; // eax
  unsigned __int16 v15; // di
  DWORD v16; // edi
  DWORD v17; // eax
  int v18; // eax
  unsigned int v19; // eax
  int v20; // eax
  __int16 v21; // ax
  unsigned __int16 v22; // di
  DWORD v23; // edi
  unsigned int v24; // eax
  int v25; // eax
  __int16 v26; // ax
  char v27; // al
  char *v28; // esi
  unsigned int v29; // ecx
  char *v30; // edi
  char *v31; // esi
  unsigned int v32; // ecx
  char v33; // [esp+12h] [ebp-1052h]
  char v34; // [esp+13h] [ebp-1051h]
  unsigned __int8 v35; // [esp+14h] [ebp-1050h] BYREF
  unsigned __int8 v36; // [esp+15h] [ebp-104Fh]
  unsigned __int8 v37; // [esp+16h] [ebp-104Eh]
  unsigned __int8 v38; // [esp+17h] [ebp-104Dh]
  unsigned __int8 v39; // [esp+18h] [ebp-104Ch]
  char v40; // [esp+19h] [ebp-104Bh]
  unsigned int v41; // [esp+1Ch] [ebp-1048h]
  _DWORD v42[1040]; // [esp+20h] [ebp-1044h] BYREF
  _BYTE v43[4]; // [esp+1060h] [ebp-4h] BYREF

  v33 = 0;
  v34 = 5;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
    *((_WORD *)dword_10023774 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = 32;
  v5 = *((_WORD *)dword_10023774 + 41270);
  if ( v5 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v5 + 4;
  sub_10014050(v42, -1510974961, 4);
  sub_10014050(&v42[1], a1 + 28, 4);
  sub_10014050(&v42[2], -2146238464, 4);
  sub_10014050(&v42[3], a4, 4);
  v6 = *a2;
  memset(&v42[4], 0, 0x20Cu);
  v7 = a2[1];
  v42[4] = v6;
  v42[5] = v7;
  sub_10014050(&v42[6], -257618086, 4);
  memset(&v42[136], 0, 0xE20u);
  sub_10014050(v43, -1510974961, 4);
  HIBYTE(v8) = *((_BYTE *)a2 + 4);
  LOBYTE(v8) = *((_BYTE *)a2 + 5);
  HIBYTE(v9) = *(_BYTE *)a2;
  LOBYTE(v9) = *((_BYTE *)a2 + 1);
  v41 = a4
      + (*((unsigned __int8 *)a2 + 7) | ((*((unsigned __int8 *)a2 + 6) | (v8 << 8)) << 8))
      - (*((unsigned __int8 *)a2 + 3) | ((*((unsigned __int8 *)a2 + 2) | (v9 << 8)) << 8));
  qmemcpy((char *)dword_10023774 + 8620, v42, 0x1Cu);
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  v10 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v10 + 1;
  if ( v10 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v33 )
      {
        v11 = v34-- == 0;
        if ( v11 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return -1;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v33 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v13 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v13 )
      {
        case 0x40u:
          goto LABEL_29;
        case 0xFFFFFFFF:
          *((_DWORD *)dword_10023774 + 20733) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_29;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
LABEL_37:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            *((_WORD *)dword_10023774 + 41270) = 8;
            CloseHandle(EventA);
            return -1;
          }
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v35, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            goto LABEL_105;
          }
          if ( v40 )
            goto LABEL_37;
          if ( (v35 <= 1u || v38 != *((_WORD *)dword_10023774 + 41271))
            && (v36 <= 1u || v39 != *((_WORD *)dword_10023774 + 41271)) )
          {
LABEL_45:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_29:
          CloseHandle(EventA);
          goto LABEL_30;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v33 = 1;
    }
LABEL_30:
    v15 = *((_WORD *)dword_10023774 + 41270);
    if ( v15 <= 0x40u )
    {
      while ( 1 )
      {
        while ( 1 )
        {
LABEL_58:
          if ( (unsigned __int8)v33 > 2u )
          {
            v11 = v34-- == 0;
            if ( v11 )
            {
              result = -1;
              *((_WORD *)dword_10023774 + 41270) = 8;
              *((_DWORD *)dword_10023774 + 20634) = 0;
              return result;
            }
          }
          if ( (unsigned __int8)v33 < 4u )
            break;
LABEL_78:
          v22 = *((_WORD *)dword_10023774 + 39189);
          if ( v22 <= 0x40u )
            goto LABEL_103;
          EventA = CreateEventA(0, 1, 0, 0);
          v23 = (unsigned __int16)(v22 - 64);
          v24 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v23, EventA);
          if ( v24 == v23 )
            goto LABEL_102;
          if ( v24 == -1 )
          {
            *((_DWORD *)dword_10023774 + 20733) = 1;
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_97:
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( !v24 )
          {
            dword_10023764 = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023760 = GetTickCount();
              if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                  goto LABEL_91;
                dword_1002376C = GetTickCount();
                do
                  dword_10023768 = GetTickCount();
                while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
                v25 = E8A_USB::GetStatus(dword_10023774, &v35, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v25 <= 0 || v40 )
                  goto LABEL_96;
                if ( v37 == 3 )
                {
                  v26 = *((_WORD *)dword_10023774 + 41271);
                  if ( v38 == v26 || v39 == v26 )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                goto LABEL_104;
              }
            }
LABEL_102:
            CloseHandle(EventA);
LABEL_103:
            v27 = v41;
            v28 = (char *)dword_10023774 + 78392;
            v29 = v41 >> 2;
            qmemcpy(a2, (char *)dword_10023774 + 78392, 4 * (v41 >> 2));
            v31 = &v28[4 * v29];
            v30 = (char *)&a2[v29];
            v32 = v27 & 3;
            result = 0;
            qmemcpy(v30, v31, v32);
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            return result;
          }
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(EventA);
          CloseHandle(EventA);
          v33 = 4;
        }
        EventA = CreateEventA(0, 1, 0, 0);
        v19 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
        if ( v19 == 64 )
          goto LABEL_77;
        if ( v19 == -1 )
        {
          *((_DWORD *)dword_10023774 + 20733) = 1;
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          goto LABEL_106;
        }
        if ( !v19 )
          break;
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CancelIo(EventA);
        CloseHandle(EventA);
        v33 = 3;
      }
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_96;
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v20 = E8A_USB::GetStatus(dword_10023774, &v35, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v20 <= 0 )
          {
LABEL_96:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            goto LABEL_97;
          }
          if ( v40 )
          {
LABEL_91:
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(EventA);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v37 > 1u )
          {
            v21 = *((_WORD *)dword_10023774 + 41271);
            if ( v38 == v21 || v39 == v21 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
LABEL_104:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          goto LABEL_105;
        }
      }
LABEL_77:
      CloseHandle(EventA);
      goto LABEL_78;
    }
    EventA = CreateEventA(0, 1, 0, 0);
    v16 = (unsigned __int16)(v15 - (*((_WORD *)dword_10023774 + 41270) & 0x3F));
    v17 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8680, v16, EventA);
    if ( v17 == v16 )
    {
LABEL_57:
      CloseHandle(EventA);
      goto LABEL_58;
    }
    if ( v17 == -1 )
      break;
    if ( !v17 )
    {
      dword_1002374C = GetTickCount();
      do
      {
        if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
          goto LABEL_57;
        dword_10023748 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v18 = E8A_USB::GetStatus(dword_10023774, &v35, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v18 > 0
          && !v40
          && (v35 == 3 && v38 == *((_WORD *)dword_10023774 + 41271)
           || v36 == 3 && v39 == *((_WORD *)dword_10023774 + 41271)) )
        {
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          goto LABEL_58;
        }
      }
      goto LABEL_45;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v33 = 2;
  }
  *((_DWORD *)dword_10023774 + 20733) = 1;
  CancelIo(EventA);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_105:
  CloseHandle(EventA);
LABEL_106:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 10015FB0  HUDI_SERIALWRITE  ()  size=2330 ==== */
int __cdecl HUDI_SERIALWRITE(int a1, const void *a2, int a3, unsigned __int8 a4)
{
  unsigned __int16 v4; // bp
  E8A_USB *v5; // eax
  unsigned __int16 v6; // ax
  unsigned __int16 v7; // ax
  unsigned __int16 v8; // ax
  char v9; // bl
  void (__stdcall *v10)(HANDLE); // edi
  bool v11; // zf
  HANDLE EventA; // esi
  DWORD v13; // eax
  int Status; // eax
  unsigned int v15; // eax
  int v16; // eax
  __int16 v17; // ax
  unsigned __int16 v18; // di
  HANDLE v19; // esi
  DWORD v20; // edi
  unsigned int v21; // eax
  int v22; // eax
  __int16 v23; // ax
  int result; // eax
  char v25; // [esp+11h] [ebp-1053h]
  char v26; // [esp+12h] [ebp-1052h]
  char v27; // [esp+13h] [ebp-1051h]
  unsigned __int8 v28[2]; // [esp+14h] [ebp-1050h] BYREF
  unsigned __int8 v29; // [esp+16h] [ebp-104Eh]
  unsigned __int8 v30; // [esp+17h] [ebp-104Dh]
  unsigned __int8 v31; // [esp+18h] [ebp-104Ch]
  char v32; // [esp+19h] [ebp-104Bh]
  int v33; // [esp+1Ch] [ebp-1048h]
  _BYTE v34[4]; // [esp+20h] [ebp-1044h] BYREF
  _BYTE v35[4]; // [esp+24h] [ebp-1040h] BYREF
  _BYTE v36[4]; // [esp+28h] [ebp-103Ch] BYREF
  _BYTE v37[4]; // [esp+2Ch] [ebp-1038h] BYREF
  _BYTE v38[4144]; // [esp+30h] [ebp-1034h] BYREF
  _BYTE v39[4]; // [esp+1060h] [ebp-4h] BYREF

  v4 = a1;
  v26 = 0;
  v25 = 5;
  v27 = 0;
  v33 = 0;
  if ( (unsigned __int16)a1 > 0x800u )
  {
    v27 = 1;
    v33 = a1 - 2048;
    v4 = 2048;
  }
LABEL_3:
  v5 = dword_10023774;
  if ( !dword_10023A8C && *((_DWORD *)dword_10023774 + 20733) )
  {
LABEL_81:
    *((_WORD *)v5 + 41270) = 8;
    return -1;
  }
  *((_WORD *)dword_10023774 + 41270) = v4 + 32;
  v6 = *((_WORD *)dword_10023774 + 41270);
  if ( v6 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v6 + 4;
  sub_10014050(v34, -1510974961, 4);
  sub_10014050(v35, v4 + 28, 4);
  sub_10014050(v36, -2146172928, 4);
  sub_10014050(v37, a4, 4);
  memset(v38, 0, 0x20Cu);
  qmemcpy(v38, a2, v4 + 8);
  sub_10014050(&v38[v4 + 8], -257618086, 4);
  memset(&v38[528], 0, 0xE20u);
  sub_10014050(v39, -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v34, v4 + 28);
  v7 = *((_WORD *)dword_10023774 + 41270);
  if ( v7 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v7;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v8 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v8 + 1;
  if ( v8 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  v9 = v26;
  v10 = (void (__stdcall *)(HANDLE))CancelIo;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  while ( 1 )
  {
    if ( v9 )
    {
      v11 = v25-- == 0;
      if ( v11 )
      {
LABEL_74:
        *((_WORD *)dword_10023774 + 41270) = 8;
        result = -1;
        *((_DWORD *)dword_10023774 + 20634) = 0;
        return result;
      }
    }
    E8A_USB::GetDeviceId(dword_10023774);
    EventA = CreateEventA(0, 1, 0, 0);
    v13 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8616,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v13 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_30;
    if ( v13 == -1 )
    {
      *((_DWORD *)dword_10023774 + 20733) = 1;
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v13 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v9 = 1;
    v26 = 1;
  }
  dword_10023754 = GetTickCount();
  do
  {
    if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
      goto LABEL_30;
    dword_10023750 = GetTickCount();
  }
  while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
  {
    dword_1002374C = GetTickCount();
    do
      dword_10023748 = GetTickCount();
    while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
    Status = E8A_USB::GetStatus(dword_10023774, v28, 1);
    *((_DWORD *)dword_10023774 + 2153) = 0;
    if ( Status > 0 && !v32 )
    {
      if ( v28[0] > 1u && v30 == *((_WORD *)dword_10023774 + 41271)
        || v28[1] > 1u && v31 == *((_WORD *)dword_10023774 + 41271) )
      {
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_30:
        CloseHandle(EventA);
        while ( 1 )
        {
          if ( (unsigned __int8)v9 > 2u )
          {
            v11 = v25-- == 0;
            if ( v11 )
              goto LABEL_74;
          }
          if ( (unsigned __int8)v9 < 4u )
          {
            EventA = CreateEventA(0, 1, 0, 0);
            v15 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
            if ( v15 != 64 )
            {
              if ( v15 == -1 )
              {
                *((_DWORD *)dword_10023774 + 20733) = 1;
                v10(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(EventA);
                E8A_USB::Cancel((HANDLE *)dword_10023774);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
              if ( v15 )
              {
                *((_DWORD *)dword_10023774 + 2151) = 0;
                v10(EventA);
                CloseHandle(EventA);
                v9 = 3;
                v26 = 3;
                continue;
              }
              dword_1002376C = GetTickCount();
              while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
              {
                dword_10023768 = GetTickCount();
                if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
                {
                  if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                    goto LABEL_79;
                  dword_10023764 = GetTickCount();
                  do
                    dword_10023760 = GetTickCount();
                  while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
                  v16 = E8A_USB::GetStatus(dword_10023774, v28, 1);
                  *((_DWORD *)dword_10023774 + 2153) = 0;
                  if ( v16 <= 0 )
                  {
LABEL_79:
                    v10(EventA);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    goto LABEL_80;
                  }
                  if ( !v32 && v29 > 1u )
                  {
                    v17 = *((_WORD *)dword_10023774 + 41271);
                    if ( v30 == v17 || v31 == v17 )
                    {
                      v10(EventA);
                      *((_DWORD *)dword_10023774 + 2151) = 0;
                      break;
                    }
                  }
                  v10(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  goto LABEL_77;
                }
              }
            }
            CloseHandle(EventA);
          }
          v18 = *((_WORD *)dword_10023774 + 39189);
          if ( v18 <= 0x40u )
            goto LABEL_69;
          v19 = CreateEventA(0, 1, 0, 0);
          v20 = (unsigned __int16)(v18 - 64);
          v21 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v20, v19);
          if ( v21 == v20 )
            goto LABEL_68;
          if ( v21 == -1 )
          {
            *((_DWORD *)dword_10023774 + 20733) = 1;
            CancelIo(v19);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v19);
            E8A_USB::Cancel((HANDLE *)dword_10023774);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( !v21 )
          {
            dword_10023764 = GetTickCount();
            while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
            {
              dword_10023760 = GetTickCount();
              if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
              {
                if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                  goto LABEL_85;
                dword_1002376C = GetTickCount();
                do
                  dword_10023768 = GetTickCount();
                while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
                v22 = E8A_USB::GetStatus(dword_10023774, v28, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( v22 <= 0 )
                {
LABEL_85:
                  CancelIo(v19);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  CloseHandle(v19);
                  *((_WORD *)dword_10023774 + 41270) = 8;
                  return -1;
                }
                if ( !v32 && v29 == 3 )
                {
                  v23 = *((_WORD *)dword_10023774 + 41271);
                  if ( v30 == v23 || v31 == v23 )
                  {
                    CancelIo(v19);
                    *((_DWORD *)dword_10023774 + 2151) = 0;
                    break;
                  }
                }
                CancelIo(v19);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                CloseHandle(v19);
                *((_WORD *)dword_10023774 + 41270) = 8;
                return -1;
              }
            }
LABEL_68:
            CloseHandle(v19);
LABEL_69:
            *((_WORD *)dword_10023774 + 41270) = 8;
            *((_DWORD *)dword_10023774 + 20634) = 0;
            if ( v27 )
            {
              v4 = v33;
              v27 = 0;
              goto LABEL_3;
            }
            return 0;
          }
          v10 = (void (__stdcall *)(HANDLE))CancelIo;
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CancelIo(v19);
          CloseHandle(v19);
          v9 = 4;
          v26 = 4;
        }
      }
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_80:
      CloseHandle(EventA);
      v5 = dword_10023774;
      goto LABEL_81;
    }
  }
  CancelIo(EventA);
  *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_77:
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 100168D0  Set_Timeout  ()  size=19 ==== */
int __cdecl Set_Timeout(int a1)
{
  E8A_USB::SetE1Timeout(dword_10023774, a1);
  return 0;
}


/* ==== 100168F0  AUD_EventSetCh  ()  size=2659 ==== */
int __cdecl AUD_EventSetCh(int a1, const void *a2, int a3)
{
  unsigned __int16 v3; // bp
  unsigned __int16 v4; // ax
  unsigned __int16 v5; // ax
  E8A_USB *v6; // eax
  void (__stdcall *v7)(HANDLE); // edi
  bool v8; // zf
  HANDLE EventA; // esi
  DWORD v10; // eax
  int Status; // eax
  E8A_USB *v12; // eax
  DWORD v13; // eax
  int v14; // eax
  unsigned int v15; // eax
  int v16; // eax
  __int16 v17; // ax
  unsigned __int16 v18; // di
  HANDLE v19; // esi
  DWORD v20; // edi
  unsigned int v21; // eax
  int v22; // eax
  __int16 v23; // ax
  int result; // eax
  char v25; // [esp+11h] [ebp-93h]
  char v26; // [esp+12h] [ebp-92h]
  char v27; // [esp+13h] [ebp-91h]
  unsigned __int8 v28; // [esp+14h] [ebp-90h] BYREF
  unsigned __int8 v29; // [esp+15h] [ebp-8Fh]
  unsigned __int8 v30; // [esp+16h] [ebp-8Eh]
  unsigned __int8 v31; // [esp+17h] [ebp-8Dh]
  unsigned __int8 v32; // [esp+18h] [ebp-8Ch]
  char v33; // [esp+19h] [ebp-8Bh]
  int v34; // [esp+1Ch] [ebp-88h]
  _BYTE v35[4]; // [esp+20h] [ebp-84h] BYREF
  _BYTE v36[4]; // [esp+24h] [ebp-80h] BYREF
  _BYTE v37[4]; // [esp+28h] [ebp-7Ch] BYREF
  int v38; // [esp+2Ch] [ebp-78h]
  _DWORD v39[29]; // [esp+30h] [ebp-74h] BYREF

  v3 = a1;
  v25 = 0;
  v26 = 5;
  v27 = 0;
  v34 = 0;
  if ( (unsigned __int16)a1 > 0x800u )
  {
    v27 = 1;
    v34 = a1 - 2048;
    v3 = 2048;
  }
LABEL_3:
  *((_WORD *)dword_10023774 + 41270) = v3 + 28;
  v4 = *((_WORD *)dword_10023774 + 41270);
  if ( v4 > 0x40u )
    *((_WORD *)dword_10023774 + 41270) = v4 + 4;
  sub_10014050(v35, -1510974961, 4);
  sub_10014050(v36, v3 + 24, 4);
  sub_10014050(v37, -2145386496, 4);
  v38 = a3;
  memset(v39, 0, 0x24u);
  qmemcpy(v39, a2, v3);
  sub_10014050(&v39[v3], -257618086, 4);
  memset(&v39[10], 0, 0x4Cu);
  sub_10014050(&v39[28], -1510974961, 4);
  qmemcpy((char *)dword_10023774 + 8620, v35, v3 + 24);
  v5 = *((_WORD *)dword_10023774 + 41270);
  if ( v5 > 0x1040u )
    return -1;
  *((_WORD *)dword_10023774 + 4309) = v5;
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  ++*((_WORD *)dword_10023774 + 41271);
  v6 = dword_10023774;
  if ( *((_WORD *)dword_10023774 + 41271) > 0xC8u )
  {
    *((_WORD *)dword_10023774 + 41271) = 1;
    v6 = dword_10023774;
  }
  v7 = (void (__stdcall *)(HANDLE))CloseHandle;
  *((_WORD *)v6 + 4308) = *((_WORD *)v6 + 41271);
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v25 )
      {
        v8 = v26-- == 0;
        if ( v8 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          result = -1;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v25 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v10 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v10 )
      {
        case 0x40u:
          goto LABEL_29;
        case 0xFFFFFFFF:
          CancelIo(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          goto LABEL_100;
        case 0u:
          dword_10023754 = GetTickCount();
          do
          {
            if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
              goto LABEL_29;
            dword_10023750 = GetTickCount();
          }
          while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xBB8 );
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_93;
          dword_1002374C = GetTickCount();
          do
            dword_10023748 = GetTickCount();
          while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
          Status = E8A_USB::GetStatus(dword_10023774, &v28, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( Status <= 0 )
            goto LABEL_93;
          if ( v33 )
            goto LABEL_94;
          if ( (v28 <= 1u || v31 != *((_WORD *)dword_10023774 + 41271))
            && (v29 <= 1u || v32 != *((_WORD *)dword_10023774 + 41271)) )
          {
            goto LABEL_93;
          }
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_29:
          CloseHandle(EventA);
          goto LABEL_30;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v25 = 1;
    }
LABEL_30:
    if ( *((_WORD *)dword_10023774 + 41270) <= 0x40u )
      break;
    EventA = CreateEventA(0, 1, 0, 0);
    *((_WORD *)dword_10023774 + 41270) -= 64;
    ++*((_WORD *)dword_10023774 + 41271);
    v12 = dword_10023774;
    if ( *((_WORD *)dword_10023774 + 41271) > 0xC8u )
    {
      *((_WORD *)dword_10023774 + 41271) = 1;
      v12 = dword_10023774;
    }
    *((_WORD *)v12 + 4338) = *((_WORD *)v12 + 41271);
    *((_WORD *)dword_10023774 + 4339) = *((_WORD *)dword_10023774 + 41270);
    v13 = E8A_USB::Write(
            dword_10023774,
            (char *)dword_10023774 + 8676,
            *((unsigned __int16 *)dword_10023774 + 41270),
            EventA);
    if ( v13 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_50;
    if ( v13 == -1 )
    {
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
LABEL_108:
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v13 )
    {
      dword_1002374C = GetTickCount();
      do
      {
        if ( E8A_USB::GetLenWritten(dword_10023774, 0) != -1 )
          goto LABEL_50;
        dword_10023748 = GetTickCount();
      }
      while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xBB8 );
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v14 = E8A_USB::GetStatus(dword_10023774, &v28, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v14 > 0 && !v33 )
        {
          if ( v28 == 3 && v31 == *((_WORD *)dword_10023774 + 41271)
            || v29 == 3 && v32 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_50:
            CloseHandle(EventA);
            goto LABEL_51;
          }
LABEL_94:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          goto LABEL_108;
        }
      }
LABEL_93:
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_100:
      v7(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v25 = 2;
  }
  while ( 1 )
  {
    while ( 1 )
    {
LABEL_51:
      if ( (unsigned __int8)v25 > 2u )
      {
        v8 = v26-- == 0;
        if ( v8 )
        {
          result = -1;
          *((_WORD *)dword_10023774 + 41270) = 8;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      if ( (unsigned __int8)v25 >= 4u )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v15 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      switch ( v15 )
      {
        case 0x40u:
          goto LABEL_70;
        case 0xFFFFFFFF:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          v7(EventA);
          E8A_USB::Cancel((HANDLE *)dword_10023774);
          goto LABEL_108;
        case 0u:
          dword_1002376C = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023768 = GetTickCount();
            if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
                goto LABEL_99;
              dword_10023764 = GetTickCount();
              do
                dword_10023760 = GetTickCount();
              while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
              v16 = E8A_USB::GetStatus(dword_10023774, &v28, 1);
              *((_DWORD *)dword_10023774 + 2153) = 0;
              if ( v16 <= 0 || v33 )
              {
LABEL_99:
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_100;
              }
              if ( v30 > 1u )
              {
                v17 = *((_WORD *)dword_10023774 + 41271);
                if ( v31 == v17 || v32 == v17 )
                {
                  CancelIo(EventA);
                  *((_DWORD *)dword_10023774 + 2151) = 0;
                  break;
                }
              }
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              v7(EventA);
              goto LABEL_108;
            }
          }
LABEL_70:
          v7(EventA);
          goto LABEL_71;
      }
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CancelIo(EventA);
      v7(EventA);
      v25 = 3;
    }
LABEL_71:
    v18 = *((_WORD *)dword_10023774 + 39189);
    if ( v18 <= 0x40u )
      goto LABEL_89;
    v19 = CreateEventA(0, 1, 0, 0);
    v20 = (unsigned __int16)(v18 - 64);
    v21 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78440, v20, v19);
    if ( v21 == v20 )
      goto LABEL_88;
    if ( v21 == -1 )
      break;
    if ( !v21 )
    {
      dword_10023764 = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023760 = GetTickCount();
        if ( (unsigned int)(dword_10023760 - dword_10023764) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
            goto LABEL_107;
          dword_1002376C = GetTickCount();
          do
            dword_10023768 = GetTickCount();
          while ( (unsigned int)(dword_10023768 - dword_1002376C) <= 0xC8 );
          v22 = E8A_USB::GetStatus(dword_10023774, &v28, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v22 <= 0 )
          {
LABEL_107:
            CancelIo(v19);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v19);
            goto LABEL_108;
          }
          if ( v33 )
          {
            CancelIo(v19);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            CloseHandle(v19);
            *((_WORD *)dword_10023774 + 41270) = 8;
            return -1;
          }
          if ( v30 == 3 )
          {
            v23 = *((_WORD *)dword_10023774 + 41271);
            if ( v31 == v23 || v32 == v23 )
            {
              CancelIo(v19);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
          CancelIo(v19);
          *((_DWORD *)dword_10023774 + 2151) = 0;
          CloseHandle(v19);
          goto LABEL_106;
        }
      }
LABEL_88:
      CloseHandle(v19);
LABEL_89:
      *((_WORD *)dword_10023774 + 41270) = 8;
      *((_DWORD *)dword_10023774 + 20634) = 0;
      if ( !v27 )
        return 0;
      v3 = v34;
      v27 = 0;
      a3 += 2048;
      goto LABEL_3;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(v19);
    CloseHandle(v19);
    v7 = (void (__stdcall *)(HANDLE))CloseHandle;
    v25 = 4;
  }
  CancelIo(v19);
  *((_DWORD *)dword_10023774 + 2151) = 0;
  CloseHandle(v19);
  E8A_USB::Cancel((HANDLE *)dword_10023774);
LABEL_106:
  *((_WORD *)dword_10023774 + 41270) = 8;
  return -1;
}


/* ==== 10017360  ULE_TestConfiguration  ()  size=3 ==== */
int ULE_TestConfiguration()
{
  return 0;
}


/* ==== 10017370  ULE_FillMemory  ()  size=1401 ==== */
int __cdecl ULE_FillMemory(int a1, int a2, int a3, unsigned __int8 a4)
{
  char *v4; // edi
  unsigned __int16 v5; // ax
  HANDLE EventA; // esi
  DWORD v7; // eax
  int Status; // eax
  unsigned int v10; // eax
  int v11; // eax
  __int16 v12; // ax
  unsigned __int8 v13[3]; // [esp+10h] [ebp-90h] BYREF
  unsigned __int8 v14; // [esp+13h] [ebp-8Dh]
  unsigned __int8 v15; // [esp+14h] [ebp-8Ch]
  char v16; // [esp+15h] [ebp-8Bh]
  _BYTE v17[20]; // [esp+18h] [ebp-88h] BYREF
  __int16 v18; // [esp+2Ch] [ebp-74h] BYREF
  int v19; // [esp+30h] [ebp-70h] BYREF
  _DWORD v20[25]; // [esp+34h] [ebp-6Ch] BYREF
  __int16 v21; // [esp+98h] [ebp-8h]
  _BYTE v22[4]; // [esp+9Ch] [ebp-4h] BYREF

  sub_10014050(v17, -1510974961, 4);
  sub_10014050(&v17[4], 30, 4);
  sub_10014050(&v17[8], -2145189888, 4);
  sub_10014050(&v17[12], a3, 4);
  sub_10014050(&v17[16], a1, 4);
  sub_10014050(&v18, a4, 2);
  sub_10014050(&v19, a2, 4);
  sub_10014050(v20, -257618086, 4);
  memset(&v20[1], 0, 0x60u);
  v21 = 0;
  sub_10014050(v22, -1510974961, 4);
  v4 = (char *)dword_10023774 + 8620;
  qmemcpy((char *)dword_10023774 + 8620, v17, 0x14u);
  *((_WORD *)v4 + 10) = v18;
  *(_DWORD *)((char *)dword_10023774 + 8642) = v19;
  *(_DWORD *)((char *)dword_10023774 + 8646) = v20[0];
  *((_WORD *)dword_10023774 + 4309) = *((_WORD *)dword_10023774 + 41270);
  *((_WORD *)dword_10023774 + 41270) = (unsigned __int16)((*((unsigned __int16 *)dword_10023774 + 41270) + 63) / 64) << 6;
  v5 = *((_WORD *)dword_10023774 + 41271);
  *((_WORD *)dword_10023774 + 41271) = v5 + 1;
  if ( v5 >= 0xC8u )
    *((_WORD *)dword_10023774 + 41271) = 1;
  *((_WORD *)dword_10023774 + 4308) = *((_WORD *)dword_10023774 + 41271);
  E8A_USB::GetDeviceId(dword_10023774);
  EventA = CreateEventA(0, 1, 0, 0);
  v7 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
  if ( v7 != 64 )
  {
    while ( 1 )
    {
      if ( v7 == -1 )
      {
        CancelIo(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
        *((_DWORD *)dword_10023774 + 2152) = 0;
LABEL_39:
        CloseHandle(EventA);
LABEL_40:
        *((_WORD *)dword_10023774 + 41270) = 8;
        return -1;
      }
      if ( !v7 )
        break;
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      E8A_USB::GetDeviceId(dword_10023774);
      EventA = CreateEventA(0, 1, 0, 0);
      v7 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      if ( v7 == 64 )
        goto LABEL_24;
    }
    dword_10023754 = GetTickCount();
    while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
    {
      dword_10023750 = GetTickCount();
      if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
      {
        if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          goto LABEL_13;
        dword_1002374C = GetTickCount();
        do
          dword_10023748 = GetTickCount();
        while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
        Status = E8A_USB::GetStatus(dword_10023774, v13, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( Status <= 0 )
        {
LABEL_13:
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
        if ( v16
          || (v13[0] <= 1u || v14 != *((_WORD *)dword_10023774 + 41271))
          && (v13[1] <= 1u || v15 != *((_WORD *)dword_10023774 + 41271)) )
        {
          CancelIo(EventA);
          *((_DWORD *)dword_10023774 + 2152) = 0;
          goto LABEL_39;
        }
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2152) = 0;
        break;
      }
    }
  }
LABEL_24:
  CloseHandle(EventA);
  EventA = CreateEventA(0, 1, 0, 0);
  v10 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
  if ( v10 != 64 )
  {
    while ( 1 )
    {
      if ( v10 == -1 )
      {
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        E8A_USB::Cancel((HANDLE *)dword_10023774);
        goto LABEL_40;
      }
      if ( !v10 )
        break;
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      EventA = CreateEventA(0, 1, 0, 0);
      v10 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, 0x40u, EventA);
      if ( v10 == 64 )
        goto LABEL_28;
    }
    dword_1002376C = GetTickCount();
    while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
    {
      dword_10023768 = GetTickCount();
      if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
      {
        if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
        {
          dword_10023764 = GetTickCount();
          do
            dword_10023760 = GetTickCount();
          while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
          v11 = E8A_USB::GetStatus(dword_10023774, v13, 1);
          *((_DWORD *)dword_10023774 + 2153) = 0;
          if ( v11 <= 0 || v16 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
            goto LABEL_39;
          }
          if ( v13[2] > 1u )
          {
            v12 = *((_WORD *)dword_10023774 + 41271);
            if ( v14 == v12 || v15 == v12 )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              break;
            }
          }
        }
        CancelIo(EventA);
        *((_DWORD *)dword_10023774 + 2151) = 0;
        CloseHandle(EventA);
        *((_WORD *)dword_10023774 + 41270) = 8;
        return -1;
      }
    }
  }
LABEL_28:
  CloseHandle(EventA);
  *((_WORD *)dword_10023774 + 41270) = 8;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return 0;
}


/* ==== 100178F0  ULE_ReciveData  ()  size=670 ==== */
int __cdecl ULE_ReciveData(unsigned __int16 a1, char *a2)
{
  char v2; // al
  HANDLE EventA; // esi
  unsigned int v5; // eax
  int result; // eax
  int Status; // eax
  __int16 v8; // ax
  char v9; // [esp+13h] [ebp-9h]
  unsigned __int8 v10[8]; // [esp+14h] [ebp-8h] BYREF

  v2 = 0;
  v9 = 5;
  *((_WORD *)dword_10023774 + 41270) = a1;
  while ( 1 )
  {
    if ( (unsigned __int8)v2 > 2u && v9-- == 0 )
    {
      *((_WORD *)dword_10023774 + 41270) = 8;
      *((_DWORD *)dword_10023774 + 20634) = 0;
      return -1;
    }
    EventA = CreateEventA(0, 1, 0, 0);
    v5 = E8A_USB::Read(dword_10023774, (unsigned __int8 *)dword_10023774 + 78376, a1, EventA);
    if ( v5 == a1 )
      break;
    if ( v5 == -1 )
    {
      CancelIo(EventA);
      *((_DWORD *)dword_10023774 + 2151) = 0;
      CloseHandle(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v5 )
    {
      dword_1002376C = GetTickCount();
      while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
      {
        dword_10023768 = GetTickCount();
        if ( (unsigned int)(dword_10023768 - dword_1002376C) > 0xEA60 )
        {
          if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) == 1 )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
          }
          else
          {
            dword_10023764 = GetTickCount();
            do
              dword_10023760 = GetTickCount();
            while ( (unsigned int)(dword_10023760 - dword_10023764) <= 0xC8 );
            Status = E8A_USB::GetStatus(dword_10023774, v10, 1);
            *((_DWORD *)dword_10023774 + 2153) = 0;
            if ( Status <= 0 || v10[5] )
            {
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2151) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
            if ( v10[2] > 1u )
            {
              v8 = *((_WORD *)dword_10023774 + 41271);
              if ( v10[3] == v8 || v10[4] == v8 )
              {
                CancelIo(EventA);
                *((_DWORD *)dword_10023774 + 2151) = 0;
                goto LABEL_24;
              }
            }
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2151) = 0;
          }
          CloseHandle(EventA);
          *((_WORD *)dword_10023774 + 41270) = 8;
          return -1;
        }
      }
      break;
    }
    *((_DWORD *)dword_10023774 + 2151) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 3;
  }
LABEL_24:
  CloseHandle(EventA);
  qmemcpy(a2, (char *)dword_10023774 + 78376, a1);
  result = 0;
  *((_WORD *)dword_10023774 + 41270) = 8;
  *((_DWORD *)dword_10023774 + 20634) = 0;
  return result;
}


/* ==== 10017B90  ULE_SendData  ()  size=1181 ==== */
int __cdecl ULE_SendData(unsigned __int16 a1, const void *a2)
{
  char v2; // bl
  int result; // eax
  HANDLE EventA; // esi
  DWORD v6; // eax
  int Status; // eax
  DWORD v8; // eax
  int v9; // eax
  char v10; // [esp+13h] [ebp-9h]
  unsigned __int8 v11; // [esp+14h] [ebp-8h] BYREF
  unsigned __int8 v12; // [esp+15h] [ebp-7h]
  unsigned __int8 v13; // [esp+17h] [ebp-5h]
  unsigned __int8 v14; // [esp+18h] [ebp-4h]
  char v15; // [esp+19h] [ebp-3h]

  *((_WORD *)dword_10023774 + 41270) = a1;
  qmemcpy((char *)dword_10023774 + 8616, a2, a1);
  v2 = 0;
  v10 = 5;
  if ( *((_WORD *)dword_10023774 + 41270) > 0x1040u )
    return -1;
  while ( 1 )
  {
    while ( 1 )
    {
      if ( v2 )
      {
        if ( v10-- == 0 )
        {
          *((_WORD *)dword_10023774 + 41270) = 8;
          result = -1;
          *((_DWORD *)dword_10023774 + 20634) = 0;
          return result;
        }
      }
      E8A_USB::GetDeviceId(dword_10023774);
      if ( v2 == 2 )
        break;
      EventA = CreateEventA(0, 1, 0, 0);
      v6 = E8A_USB::Write(dword_10023774, (char *)dword_10023774 + 8616, 0x40u, EventA);
      switch ( v6 )
      {
        case 0x40u:
          goto LABEL_24;
        case 0xFFFFFFFF:
          goto LABEL_31;
        case 0u:
          dword_10023754 = GetTickCount();
          while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
          {
            dword_10023750 = GetTickCount();
            if ( (unsigned int)(dword_10023750 - dword_10023754) > 0xBB8 )
            {
              if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
              {
                dword_1002374C = GetTickCount();
                do
                  dword_10023748 = GetTickCount();
                while ( (unsigned int)(dword_10023748 - dword_1002374C) <= 0xC8 );
                Status = E8A_USB::GetStatus(dword_10023774, &v11, 1);
                *((_DWORD *)dword_10023774 + 2153) = 0;
                if ( Status > 0 && !v15 )
                {
                  if ( v11 > 1u && v13 == *((_WORD *)dword_10023774 + 41271) )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2152) = 0;
                    CloseHandle(EventA);
                    goto LABEL_25;
                  }
                  if ( v12 > 1u && v14 == *((_WORD *)dword_10023774 + 41271) )
                  {
                    CancelIo(EventA);
                    *((_DWORD *)dword_10023774 + 2152) = 0;
                    break;
                  }
                }
              }
LABEL_38:
              CancelIo(EventA);
              *((_DWORD *)dword_10023774 + 2152) = 0;
              CloseHandle(EventA);
              *((_WORD *)dword_10023774 + 41270) = 8;
              return -1;
            }
          }
LABEL_24:
          CloseHandle(EventA);
          goto LABEL_25;
      }
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CancelIo(EventA);
      CloseHandle(EventA);
      v2 = 1;
    }
LABEL_25:
    if ( *((_WORD *)dword_10023774 + 41270) <= 0x40u )
      return 0;
    EventA = CreateEventA(0, 1, 0, 0);
    *((_WORD *)dword_10023774 + 41270) -= 64;
    v8 = E8A_USB::Write(
           dword_10023774,
           (char *)dword_10023774 + 8680,
           *((unsigned __int16 *)dword_10023774 + 41270),
           EventA);
    if ( v8 == *((unsigned __int16 *)dword_10023774 + 41270) )
      goto LABEL_50;
    if ( v8 == -1 )
    {
LABEL_31:
      CancelIo(EventA);
      E8A_USB::Cancel((HANDLE *)dword_10023774);
      *((_DWORD *)dword_10023774 + 2152) = 0;
      CloseHandle(EventA);
      *((_WORD *)dword_10023774 + 41270) = 8;
      return -1;
    }
    if ( !v8 )
      break;
    *((_DWORD *)dword_10023774 + 2152) = 0;
    CancelIo(EventA);
    CloseHandle(EventA);
    v2 = 2;
  }
  dword_1002374C = GetTickCount();
  while ( E8A_USB::GetLenWritten(dword_10023774, 0) == -1 )
  {
    dword_10023748 = GetTickCount();
    if ( (unsigned int)(dword_10023748 - dword_1002374C) > 0xBB8 )
    {
      if ( E8A_USB::SendCommand(dword_10023774, &byte_10023778, 8, 0) != 1 )
      {
        dword_10023754 = GetTickCount();
        do
          dword_10023750 = GetTickCount();
        while ( (unsigned int)(dword_10023750 - dword_10023754) <= 0xC8 );
        v9 = E8A_USB::GetStatus(dword_10023774, &v11, 1);
        *((_DWORD *)dword_10023774 + 2153) = 0;
        if ( v9 > 0 && !v15 )
        {
          if ( v11 == 3 && v13 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            CloseHandle(EventA);
            return 0;
          }
          if ( v12 == 3 && v14 == *((_WORD *)dword_10023774 + 41271) )
          {
            CancelIo(EventA);
            *((_DWORD *)dword_10023774 + 2152) = 0;
            break;
          }
        }
      }
      goto LABEL_38;
    }
  }
LABEL_50:
  CloseHandle(EventA);
  return 0;
}


/* ==== 10018030  sub_10018030  ()  size=10 ==== */
int __cdecl sub_10018030(int a1)
{
  int result; // eax

  result = a1;
  dword_10023A8C = a1;
  return result;
}


/* ==== 10018040  sub_10018040  ()  size=6 ==== */
int (**sub_10018040())()
{
  return &off_1001E080;
}


/* ==== 10018050  sub_10018050  ()  size=6 ==== */
int (**sub_10018050())()
{
  return &off_1001DFB8;
}


/* ==== 10018060  sub_10018060  ()  size=10 ==== */
int sub_10018060()
{
  unknown_libname_1();
  return atexit(unknown_libname_2);
}


/* ==== 10018070  unknown_libname_1  ()  size=10 ==== */
// Microsoft VisualC 2-14/net runtime
_DWORD *unknown_libname_1()
{
  return sub_10006600(dword_10023B68);
}


/* ==== 10018090  unknown_libname_2  ()  size=10 ==== */
// Microsoft VisualC 2-14/net runtime
void __cdecl unknown_libname_2()
{
  sub_10006730(dword_10023B68);
}


/* ==== 100180C0  sub_100180C0  ()  size=30 ==== */
void *__thiscall sub_100180C0(void *this, char a2)
{
  sub_100180E0();
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 100180E0  sub_100180E0  ()  size=5 ==== */
// attributes: thunk
int sub_100180E0(void)
{
  return sub_100181C1();
}


/* ==== 100180F0  sub_100180F0  ()  size=10 ==== */
int sub_100180F0()
{
  unknown_libname_3();
  return atexit(unknown_libname_4);
}


/* ==== 10018100  unknown_libname_3  ()  size=10 ==== */
// Microsoft VisualC 2-14/net runtime
_DWORD *__usercall unknown_libname_3@<eax>(const char *a1@<esi>)
{
  std::_Locinfo::_Locinfo((std::_Locinfo *)dword_10023A90, (int)&off_10022E18, a1);
  dword_10023A90[0] = &off_1001DFD8;
  return dword_10023A90;
}


/* ==== 10018120  unknown_libname_4  ()  size=10 ==== */
// Microsoft VisualC 2-14/net runtime
void __cdecl unknown_libname_4()
{
  sub_100180E0(dword_10023A90);
}


/* ==== 10018130  sub_10018130  ()  size=10 ==== */
int sub_10018130()
{
  return CWinApp::messageMap;
}


/* ==== 1001813A  sub_1001813A  ()  size=16 ==== */
int (**sub_1001813A())()
{
  return &off_1001E080;
}


/* ==== 1001814A  ??0_Locinfo@std@@QAE@HPBD@Z  (std::_Locinfo::_Locinfo(int,char const *))  size=119 ==== */
std::_Locinfo *__userpurge std::_Locinfo::_Locinfo@<eax>(std::_Locinfo *this@<ecx>, int a2, const char *a3)
{
  CWinApp::CWinApp(this, 0);
  sub_1001A730(a2);
  *((_DWORD *)this + 52) = 0;
  *(_DWORD *)this = &CComponentApp::`vftable';
  dword_1002473C = (int)this;
  return this;
}


/* ==== 100181C1  sub_100181C1  ()  size=176 ==== */
void __thiscall sub_100181C1(CWinApp *this)
{
  int v1; // [esp+0h] [ebp-1Ch]

  *(_DWORD *)this = &CComponentApp::`vftable';
  dword_1002473C = 0;
  if ( *((_DWORD *)this + 52) )
  {
    v1 = (***((int (__thiscall ****)(_DWORD, int))this + 52))(*((_DWORD *)this + 52), 1);
    *((_DWORD *)this + 52) = 0;
  }
  sub_1001A75C((char *)this + 196, v1);
  CWinApp::~CWinApp(this);
}


/* ==== 10018271  sub_10018271  ()  size=183 ==== */
int __thiscall sub_10018271(_DWORD *this, int a2)
{
  int v3; // [esp+0h] [ebp-20h]
  int v4; // [esp+4h] [ebp-1Ch]

  if ( !a2 || this[52] )
  {
    v3 = this[52];
  }
  else
  {
    if ( operator new(0x13Cu) )
      v4 = sub_100183D0(a2);
    else
      v4 = 0;
    this[52] = v4;
    v3 = v4;
  }
  this[52] = v3;
  return this[52];
}


/* ==== 10018328  sub_10018328  ()  size=44 ==== */
int __thiscall sub_10018328(const char **this)
{
  strrchr(this[36], 92)[1] = 0;
  return CWinApp::InitInstance((CWinApp *)this);
}


/* ==== 10018354  LibraryRegister  ()  size=29 ==== */
int __stdcall LibraryRegister(int a1)
{
  return sub_1001A770(dword_1002473C + 196, a1);
}


/* ==== 10018371  QueryInterface  ()  size=33 ==== */
int __stdcall QueryInterface(int a1, int a2)
{
  return sub_1001A7F2(dword_1002473C + 196, a1, a2);
}


/* ==== 100183A0  sub_100183A0  ()  size=43 ==== */
CWinApp *__thiscall sub_100183A0(CWinApp *this, char a2)
{
  sub_100181C1(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 100183D0  sub_100183D0  ()  size=279 ==== */
_DWORD *__thiscall sub_100183D0(_DWORD *this, int a2)
{
  sub_100184F0(10);
  sub_100186D0(10);
  sub_100188B0(10);
  sub_10018A90(10);
  sub_10018C70(10);
  sub_10018E70(10);
  sub_10019050(10);
  sub_10019230(10);
  sub_10019410(10);
  sub_100195F0(10);
  sub_100197F0(10);
  this[78] = a2;
  *this = &CUiAddinHelper::`vftable';
  return this;
}


/* ==== 100184F0  sub_100184F0  ()  size=92 ==== */
_DWORD *__thiscall sub_100184F0(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,WINDOW_STRCT *,WINDOW_STRCT *> *,CMap<HWND__ *,HWND__ *,WINDOW_STRCT *,WINDOW_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018550  sub_10018550  ()  size=81 ==== */
void __thiscall sub_10018550(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,WINDOW_STRCT *,WINDOW_STRCT *> *,CMap<HWND__ *,HWND__ *,WINDOW_STRCT *,WINDOW_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 100185B0  sub_100185B0  ()  size=249 ==== */
_DWORD *__thiscall sub_100185B0(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_100186B0(v6, v5);
    }
  }
  return result;
}


/* ==== 100186B0  sub_100186B0  ()  size=30 ==== */
_DWORD *__stdcall sub_100186B0(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019C30(a1);
  *result = a2;
  return result;
}


/* ==== 100186D0  sub_100186D0  ()  size=92 ==== */
_DWORD *__thiscall sub_100186D0(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,POPUP_STRCT *,POPUP_STRCT *> *,CMap<HWND__ *,HWND__ *,POPUP_STRCT *,POPUP_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018730  sub_10018730  ()  size=81 ==== */
void __thiscall sub_10018730(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,POPUP_STRCT *,POPUP_STRCT *> *,CMap<HWND__ *,HWND__ *,POPUP_STRCT *,POPUP_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10018790  sub_10018790  ()  size=249 ==== */
_DWORD *__thiscall sub_10018790(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10018890(v6, v5);
    }
  }
  return result;
}


/* ==== 10018890  sub_10018890  ()  size=30 ==== */
_DWORD *__stdcall sub_10018890(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 100188B0  sub_100188B0  ()  size=92 ==== */
_DWORD *__thiscall sub_100188B0(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,REGISTERPOPUP_STRCT *,REGISTERPOPUP_STRCT *> *,CMap<HWND__ *,HWND__ *,REGISTERPOPUP_STRCT *,REGISTERPOPUP_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018910  sub_10018910  ()  size=81 ==== */
void __thiscall sub_10018910(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,REGISTERPOPUP_STRCT *,REGISTERPOPUP_STRCT *> *,CMap<HWND__ *,HWND__ *,REGISTERPOPUP_STRCT *,REGISTERPOPUP_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10018970  sub_10018970  ()  size=249 ==== */
_DWORD *__thiscall sub_10018970(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10018A70(v6, v5);
    }
  }
  return result;
}


/* ==== 10018A70  sub_10018A70  ()  size=30 ==== */
_DWORD *__stdcall sub_10018A70(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10018A90  sub_10018A90  ()  size=92 ==== */
_DWORD *__thiscall sub_10018A90(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,MENURESOURCEID_STRCT *,MENURESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,MENURESOURCEID_STRCT *,MENURESOURCEID_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018AF0  sub_10018AF0  ()  size=81 ==== */
void __thiscall sub_10018AF0(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,MENURESOURCEID_STRCT *,MENURESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,MENURESOURCEID_STRCT *,MENURESOURCEID_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10018B50  sub_10018B50  ()  size=249 ==== */
_DWORD *__thiscall sub_10018B50(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10018C50(v6, v5);
    }
  }
  return result;
}


/* ==== 10018C50  sub_10018C50  ()  size=30 ==== */
_DWORD *__stdcall sub_10018C50(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10018C70  sub_10018C70  ()  size=92 ==== */
_DWORD *__thiscall sub_10018C70(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<CString,char const *,POPUPRESOURCEID_STRCT *,POPUPRESOURCEID_STRCT *> *,CMap<CString,char const *,POPUPRESOURCEID_STRCT *,POPUPRESOURCEID_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018CD0  sub_10018CD0  ()  size=81 ==== */
void __thiscall sub_10018CD0(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<CString,char const *,POPUPRESOURCEID_STRCT *,POPUPRESOURCEID_STRCT *> *,CMap<CString,char const *,POPUPRESOURCEID_STRCT *,POPUPRESOURCEID_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10018D30  sub_10018D30  ()  size=249 ==== */
_DWORD *__thiscall sub_10018D30(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10018E30(v6, v5);
    }
  }
  return result;
}


/* ==== 10018E30  sub_10018E30  ()  size=30 ==== */
_DWORD *__stdcall sub_10018E30(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10018E50  sub_10018E50  ()  size=23 ==== */
_DWORD *__thiscall sub_10018E50(_DWORD *this)
{
  *this = &CObject::`vftable';
  return this;
}


/* ==== 10018E70  sub_10018E70  ()  size=92 ==== */
_DWORD *__thiscall sub_10018E70(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,TOOLBARRESOURCEID_STRCT *,TOOLBARRESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,TOOLBARRESOURCEID_STRCT *,TOOLBARRESOURCEID_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10018ED0  sub_10018ED0  ()  size=81 ==== */
void __thiscall sub_10018ED0(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,TOOLBARRESOURCEID_STRCT *,TOOLBARRESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,TOOLBARRESOURCEID_STRCT *,TOOLBARRESOURCEID_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10018F30  sub_10018F30  ()  size=249 ==== */
_DWORD *__thiscall sub_10018F30(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10019030(v6, v5);
    }
  }
  return result;
}


/* ==== 10019030  sub_10019030  ()  size=30 ==== */
_DWORD *__stdcall sub_10019030(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10019050  sub_10019050  ()  size=92 ==== */
_DWORD *__thiscall sub_10019050(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,ACCELRESOURCEID_STRCT *,ACCELRESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,ACCELRESOURCEID_STRCT *,ACCELRESOURCEID_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 100190B0  sub_100190B0  ()  size=81 ==== */
void __thiscall sub_100190B0(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<unsigned int,unsigned int,ACCELRESOURCEID_STRCT *,ACCELRESOURCEID_STRCT *> *,CMap<unsigned int,unsigned int,ACCELRESOURCEID_STRCT *,ACCELRESOURCEID_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 10019110  sub_10019110  ()  size=249 ==== */
_DWORD *__thiscall sub_10019110(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_10019210(v6, v5);
    }
  }
  return result;
}


/* ==== 10019210  sub_10019210  ()  size=30 ==== */
_DWORD *__stdcall sub_10019210(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10019230  sub_10019230  ()  size=92 ==== */
_DWORD *__thiscall sub_10019230(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,COMMANDSINK_STRCT *,COMMANDSINK_STRCT *> *,CMap<HWND__ *,HWND__ *,COMMANDSINK_STRCT *,COMMANDSINK_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10019290  sub_10019290  ()  size=81 ==== */
void __thiscall sub_10019290(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<HWND__ *,HWND__ *,COMMANDSINK_STRCT *,COMMANDSINK_STRCT *> *,CMap<HWND__ *,HWND__ *,COMMANDSINK_STRCT *,COMMANDSINK_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 100192F0  sub_100192F0  ()  size=249 ==== */
_DWORD *__thiscall sub_100192F0(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_100193F0(v6, v5);
    }
  }
  return result;
}


/* ==== 100193F0  sub_100193F0  ()  size=30 ==== */
_DWORD *__stdcall sub_100193F0(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 10019410  sub_10019410  ()  size=92 ==== */
_DWORD *__thiscall sub_10019410(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<HINSTANCE__ *,HINSTANCE__ *,RESOURCEHANDLE_STRCT *,RESOURCEHANDLE_STRCT *> *,CMap<HINSTANCE__ *,HINSTANCE__ *,RESOURCEHANDLE_STRCT *,RESOURCEHANDLE_STRCT *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10019470  sub_10019470  ()  size=81 ==== */
void __thiscall sub_10019470(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<HINSTANCE__ *,HINSTANCE__ *,RESOURCEHANDLE_STRCT *,RESOURCEHANDLE_STRCT *> *,CMap<HINSTANCE__ *,HINSTANCE__ *,RESOURCEHANDLE_STRCT *,RESOURCEHANDLE_STRCT *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 100194D0  sub_100194D0  ()  size=249 ==== */
_DWORD *__thiscall sub_100194D0(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_100195D0(v6, v5);
    }
  }
  return result;
}


/* ==== 100195D0  sub_100195D0  ()  size=30 ==== */
_DWORD *__stdcall sub_100195D0(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 100195F0  sub_100195F0  ()  size=92 ==== */
_DWORD *__thiscall sub_100195F0(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<void *,void *,CMap<CString,char const *,CString *,CString *> *,CMap<CString,char const *,CString *,CString *> *>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10019650  sub_10019650  ()  size=81 ==== */
void __thiscall sub_10019650(_DWORD *this)
{
  *this = &CMap<void *,void *,CMap<CString,char const *,CString *,CString *> *,CMap<CString,char const *,CString *,CString *> *>::`vftable';
  sub_10019E20(this);
  sub_10008140(this);
}


/* ==== 100196B0  sub_100196B0  ()  size=249 ==== */
_DWORD *__thiscall sub_100196B0(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  int v5; // [esp+4h] [ebp-14h] BYREF
  int v6; // [esp+8h] [ebp-10h] BYREF
  unsigned int Count; // [esp+Ch] [ebp-Ch]
  _DWORD *j; // [esp+10h] [ebp-8h]
  unsigned int i; // [esp+14h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_10019DE0(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      sub_10019DE0(a2, &v6, 1);
      sub_10019DE0(a2, &v5, 1);
      sub_100197B0(v6, v5);
    }
  }
  return result;
}


/* ==== 100197B0  sub_100197B0  ()  size=30 ==== */
_DWORD *__stdcall sub_100197B0(int a1, int a2)
{
  _DWORD *result; // eax

  result = (_DWORD *)sub_10019D50(a1);
  *result = a2;
  return result;
}


/* ==== 100197D0  sub_100197D0  ()  size=25 ==== */
BOOL __thiscall sub_100197D0(_DWORD *this)
{
  return (this[5] & 1) == 0;
}


/* ==== 100197F0  sub_100197F0  ()  size=92 ==== */
_DWORD *__thiscall sub_100197F0(_DWORD *this, int a2)
{
  sub_10018E50(this);
  *this = &CMap<unsigned int,unsigned int,DYNAMICRESOURCE_STRCT,DYNAMICRESOURCE_STRCT &>::`vftable';
  this[1] = 0;
  this[2] = 17;
  this[3] = 0;
  this[4] = 0;
  this[5] = 0;
  this[6] = a2;
  return this;
}


/* ==== 10019850  sub_10019850  ()  size=310 ==== */
_DWORD *__thiscall sub_10019850(_DWORD *this, CArchive *a2)
{
  _DWORD *result; // eax
  unsigned int v3; // edx
  _BYTE v5[68]; // [esp+4h] [ebp-60h] BYREF
  int v6; // [esp+48h] [ebp-1Ch] BYREF
  unsigned int Count; // [esp+4Ch] [ebp-18h]
  _DWORD *j; // [esp+50h] [ebp-14h]
  unsigned int i; // [esp+54h] [ebp-10h]
  int v10; // [esp+60h] [ebp-4h]

  nullsub_1((int)a2);
  if ( sub_100197D0(a2) )
  {
    CArchive::WriteCount(a2, this[3]);
    result = this;
    if ( this[3] )
    {
      for ( i = 0; ; ++i )
      {
        result = (_DWORD *)i;
        if ( i >= this[2] )
          break;
        for ( j = *(_DWORD **)(this[1] + 4 * i); j; j = (_DWORD *)*j )
        {
          sub_10019DE0(a2, j + 2, 1);
          sub_1001A030(a2, j + 3, 1);
        }
      }
    }
  }
  else
  {
    Count = CArchive::ReadCount(a2);
    while ( 1 )
    {
      v3 = Count;
      result = (_DWORD *)--Count;
      if ( !v3 )
        break;
      CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(v5);
      v10 = 0;
      sub_10019DE0(a2, &v6, 1);
      sub_1001A030(a2, v5, 1);
      sub_10019990(v6, v5);
      v10 = -1;
      sub_1001A6E0(v5);
    }
  }
  return result;
}


/* ==== 10019990  sub_10019990  ()  size=36 ==== */
int __stdcall sub_10019990(int a1, int a2)
{
  sub_10019EE0(a1);
  return sub_1001A540(a2);
}


/* ==== 100199C0  sub_100199C0  ()  size=43 ==== */
_DWORD *__thiscall sub_100199C0(_DWORD *this, char a2)
{
  sub_10018550(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 100199F0  sub_100199F0  ()  size=43 ==== */
_DWORD *__thiscall sub_100199F0(_DWORD *this, char a2)
{
  sub_10018730(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019A20  sub_10019A20  ()  size=43 ==== */
_DWORD *__thiscall sub_10019A20(_DWORD *this, char a2)
{
  sub_10018910(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019A50  sub_10019A50  ()  size=43 ==== */
_DWORD *__thiscall sub_10019A50(_DWORD *this, char a2)
{
  sub_10018AF0(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019A80  sub_10019A80  ()  size=43 ==== */
_DWORD *__thiscall sub_10019A80(_DWORD *this, char a2)
{
  sub_10018CD0(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019AB0  sub_10019AB0  ()  size=43 ==== */
_DWORD *__thiscall sub_10019AB0(_DWORD *this, char a2)
{
  sub_10018ED0(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019AE0  sub_10019AE0  ()  size=43 ==== */
_DWORD *__thiscall sub_10019AE0(_DWORD *this, char a2)
{
  sub_100190B0(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019B10  sub_10019B10  ()  size=43 ==== */
_DWORD *__thiscall sub_10019B10(_DWORD *this, char a2)
{
  sub_10019290(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019B40  sub_10019B40  ()  size=43 ==== */
_DWORD *__thiscall sub_10019B40(_DWORD *this, char a2)
{
  sub_10019470(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019B70  sub_10019B70  ()  size=43 ==== */
_DWORD *__thiscall sub_10019B70(_DWORD *this, char a2)
{
  sub_10019650(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019BA0  sub_10019BA0  ()  size=43 ==== */
void *__thiscall sub_10019BA0(void *this, char a2)
{
  sub_10019BD0(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 10019BD0  sub_10019BD0  ()  size=81 ==== */
void __thiscall sub_10019BD0(_DWORD *this)
{
  *this = &CMap<unsigned int,unsigned int,DYNAMICRESOURCE_STRCT,DYNAMICRESOURCE_STRCT &>::`vftable';
  sub_10019F70(this);
  sub_10008140(this);
}


/* ==== 10019C30  sub_10019C30  ()  size=133 ==== */
_DWORD *__thiscall sub_10019C30(_DWORD *this, int a2)
{
  int v4; // [esp+4h] [ebp-8h] BYREF
  _DWORD *v5; // [esp+8h] [ebp-4h]

  v5 = (_DWORD *)sub_10019CE0(a2, &v4);
  if ( !v5 )
  {
    if ( !this[1] )
      sub_1001A080(this[2], 1);
    v5 = (_DWORD *)sub_1001A100(this);
    v5[1] = v4;
    v5[2] = a2;
    *v5 = *(_DWORD *)(this[1] + 4 * v4);
    *(_DWORD *)(this[1] + 4 * v4) = v5;
  }
  return v5 + 3;
}


/* ==== 10019CC0  sub_10019CC0  ()  size=22 ==== */
BOOL __stdcall sub_10019CC0(_DWORD *a1, _DWORD *a2)
{
  return *a1 == *a2;
}


/* ==== 10019CE0  sub_10019CE0  ()  size=112 ==== */
_DWORD *__thiscall sub_10019CE0(_DWORD *this, int a2, int *a3)
{
  unsigned int v3; // eax
  _DWORD *i; // [esp+4h] [ebp-4h]

  v3 = unknown_libname_15(a2);
  *a3 = v3 % this[2];
  if ( !this[1] )
    return 0;
  for ( i = *(_DWORD **)(this[1] + 4 * *a3); i; i = (_DWORD *)*i )
  {
    if ( sub_10019CC0(i + 2, &a2) )
      return i;
  }
  return 0;
}


/* ==== 10019D50  sub_10019D50  ()  size=133 ==== */
_DWORD *__thiscall sub_10019D50(_DWORD *this, int a2)
{
  int v4; // [esp+4h] [ebp-8h] BYREF
  _DWORD *v5; // [esp+8h] [ebp-4h]

  v5 = sub_10019CE0(this, a2, &v4);
  if ( !v5 )
  {
    if ( !this[1] )
      sub_1001A200(this[2], 1);
    v5 = (_DWORD *)sub_1001A100(this);
    v5[1] = v4;
    v5[2] = a2;
    *v5 = *(_DWORD *)(this[1] + 4 * v4);
    *(_DWORD *)(this[1] + 4 * v4) = v5;
  }
  return v5 + 3;
}


/* ==== 10019DE0  sub_10019DE0  ()  size=59 ==== */
void __stdcall sub_10019DE0(CArchive *a1, void *a2, int a3)
{
  if ( sub_100197D0(a1) )
    CArchive::Write(a1, a2, 4 * a3);
  else
    CArchive::Read(a1, a2, 4 * a3);
}


/* ==== 10019E20  sub_10019E20  ()  size=186 ==== */
void __thiscall sub_10019E20(int this)
{
  _DWORD *j; // [esp+8h] [ebp-8h]
  unsigned int i; // [esp+Ch] [ebp-4h]

  if ( *(_DWORD *)(this + 4) )
  {
    for ( i = 0; i < *(_DWORD *)(this + 8); ++i )
    {
      for ( j = *(_DWORD **)(*(_DWORD *)(this + 4) + 4 * i); j; j = (_DWORD *)*j )
      {
        sub_1001A1D0(j + 3, 1);
        sub_1001A1D0(j + 2, 1);
      }
    }
  }
  operator delete(*(void **)(this + 4));
  *(_DWORD *)(this + 4) = 0;
  *(_DWORD *)(this + 12) = 0;
  *(_DWORD *)(this + 16) = 0;
  CPlex::FreeDataChain(*(CPlex **)(this + 20));
  *(_DWORD *)(this + 20) = 0;
}


/* ==== 10019EE0  sub_10019EE0  ()  size=133 ==== */
_DWORD *__thiscall sub_10019EE0(_DWORD *this, int a2)
{
  int v4; // [esp+4h] [ebp-8h] BYREF
  _DWORD *v5; // [esp+8h] [ebp-4h]

  v5 = sub_10019CE0(this, a2, &v4);
  if ( !v5 )
  {
    if ( !this[1] )
      sub_1001A200(this[2], 1);
    v5 = (_DWORD *)sub_1001A280(this);
    v5[1] = v4;
    v5[2] = a2;
    *v5 = *(_DWORD *)(this[1] + 4 * v4);
    *(_DWORD *)(this[1] + 4 * v4) = v5;
  }
  return v5 + 3;
}


/* ==== 10019F70  sub_10019F70  ()  size=186 ==== */
void __thiscall sub_10019F70(int this)
{
  _DWORD *j; // [esp+8h] [ebp-8h]
  unsigned int i; // [esp+Ch] [ebp-4h]

  if ( *(_DWORD *)(this + 4) )
  {
    for ( i = 0; i < *(_DWORD *)(this + 8); ++i )
    {
      for ( j = *(_DWORD **)(*(_DWORD *)(this + 4) + 4 * i); j; j = (_DWORD *)*j )
      {
        sub_1001A350(j + 3, 1);
        sub_1001A1D0(j + 2, 1);
      }
    }
  }
  operator delete(*(void **)(this + 4));
  *(_DWORD *)(this + 4) = 0;
  *(_DWORD *)(this + 12) = 0;
  *(_DWORD *)(this + 16) = 0;
  CPlex::FreeDataChain(*(CPlex **)(this + 20));
  *(_DWORD *)(this + 20) = 0;
}


/* ==== 1001A030  sub_1001A030  ()  size=59 ==== */
void __stdcall sub_1001A030(CArchive *a1, void *a2, int a3)
{
  if ( sub_100197D0(a1) )
    CArchive::Write(a1, a2, 68 * a3);
  else
    CArchive::Read(a1, a2, 68 * a3);
}


/* ==== 1001A070  unknown_libname_15  ()  size=13 ==== */
// MFC 3.1-14.0 32bit
unsigned int __stdcall unknown_libname_15(unsigned int a1)
{
  return a1 >> 4;
}


/* ==== 1001A080  sub_1001A080  ()  size=121 ==== */
int __thiscall sub_1001A080(int this, int a2, int a3)
{
  int result; // eax

  if ( *(_DWORD *)(this + 4) )
  {
    operator delete(*(void **)(this + 4));
    *(_DWORD *)(this + 4) = 0;
  }
  if ( a3 )
  {
    *(_DWORD *)(this + 4) = operator new(4 * a2);
    memset(*(void **)(this + 4), 0, 4 * a2);
  }
  result = a2;
  *(_DWORD *)(this + 8) = a2;
  return result;
}


/* ==== 1001A100  sub_1001A100  ()  size=206 ==== */
_DWORD *__thiscall sub_1001A100(int this)
{
  _DWORD *v3; // [esp+4h] [ebp-10h]
  int i; // [esp+8h] [ebp-Ch]
  struct CPlex *v5; // [esp+Ch] [ebp-8h]
  _DWORD *v6; // [esp+10h] [ebp-4h]

  if ( !*(_DWORD *)(this + 16) )
  {
    v5 = CPlex::Create((struct CPlex **)(this + 20), *(_DWORD *)(this + 24), 0x10u);
    v3 = (_DWORD *)(16 * (*(_DWORD *)(this + 24) - 1) + unknown_libname_17(v5));
    for ( i = *(_DWORD *)(this + 24) - 1; i >= 0; --i )
    {
      *v3 = *(_DWORD *)(this + 16);
      *(_DWORD *)(this + 16) = v3;
      v3 -= 4;
    }
  }
  v6 = *(_DWORD **)(this + 16);
  *(_DWORD *)(this + 16) = *v6;
  ++*(_DWORD *)(this + 12);
  sub_1001A3B0(v6 + 2, 1);
  sub_1001A3B0(v6 + 3, 1);
  return v6;
}


/* ==== 1001A1D0  sub_1001A1D0  ()  size=36 ==== */
int __stdcall sub_1001A1D0(int a1, int a2)
{
  int result; // eax

  while ( a2-- )
  {
    result = a1 + 4;
    a1 += 4;
  }
  return result;
}


/* ==== 1001A200  sub_1001A200  ()  size=121 ==== */
int __thiscall sub_1001A200(int this, int a2, int a3)
{
  int result; // eax

  if ( *(_DWORD *)(this + 4) )
  {
    operator delete(*(void **)(this + 4));
    *(_DWORD *)(this + 4) = 0;
  }
  if ( a3 )
  {
    *(_DWORD *)(this + 4) = operator new(4 * a2);
    memset(*(void **)(this + 4), 0, 4 * a2);
  }
  result = a2;
  *(_DWORD *)(this + 8) = a2;
  return result;
}


/* ==== 1001A280  sub_1001A280  ()  size=206 ==== */
_DWORD *__thiscall sub_1001A280(int this)
{
  _DWORD *v3; // [esp+4h] [ebp-10h]
  int i; // [esp+8h] [ebp-Ch]
  struct CPlex *v5; // [esp+Ch] [ebp-8h]
  _DWORD *v6; // [esp+10h] [ebp-4h]

  if ( !*(_DWORD *)(this + 16) )
  {
    v5 = CPlex::Create((struct CPlex **)(this + 20), *(_DWORD *)(this + 24), 0x50u);
    v3 = (_DWORD *)(80 * (*(_DWORD *)(this + 24) - 1) + unknown_libname_17(v5));
    for ( i = *(_DWORD *)(this + 24) - 1; i >= 0; --i )
    {
      *v3 = *(_DWORD *)(this + 16);
      *(_DWORD *)(this + 16) = v3;
      v3 -= 20;
    }
  }
  v6 = *(_DWORD **)(this + 16);
  *(_DWORD *)(this + 16) = *v6;
  ++*(_DWORD *)(this + 12);
  sub_1001A3B0(v6 + 2, 1);
  sub_1001A400(v6 + 3, 1);
  return v6;
}


/* ==== 1001A350  sub_1001A350  ()  size=46 ==== */
int __stdcall sub_1001A350(int a1, int a2)
{
  int result; // eax

  while ( a2-- )
  {
    sub_1001A380(0);
    result = a1 + 68;
    a1 += 68;
  }
  return result;
}


/* ==== 1001A380  sub_1001A380  ()  size=46 ==== */
void *__thiscall sub_1001A380(void *this, char a2)
{
  sub_1001A6E0(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 1001A3B0  sub_1001A3B0  ()  size=77 ==== */
int __stdcall sub_1001A3B0(char *a1, int a2)
{
  int result; // eax

  memset(a1, 0, 4 * a2);
  while ( 1 )
  {
    result = a2--;
    if ( !result )
      break;
    operator new(4u, a1);
    a1 += 4;
  }
  return result;
}


/* ==== 1001A400  sub_1001A400  ()  size=156 ==== */
int __stdcall sub_1001A400(char *a1, int a2)
{
  int result; // eax
  void *v3; // [esp+4h] [ebp-14h]

  memset(a1, 0, 68 * a2);
  while ( 1 )
  {
    result = a2--;
    if ( !result )
      break;
    v3 = operator new(0x44u, a1);
    if ( v3 )
      CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(v3);
    a1 += 68;
  }
  return result;
}


/* ==== 1001A4A0  ??2@YAPAXIPAX@Z  (operator new(uint,void *))  size=8 ==== */
void *__cdecl operator new(unsigned int a1, void *a2)
{
  return a2;
}


/* ==== 1001A4B0  sub_1001A4B0  ()  size=5 ==== */
void sub_1001A4B0()
{
  ;
}


/* ==== 1001A4C0  ??1?$CMFCComObject@VCAccessibleProxy@ATL@@@@UAE@XZ  (CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(void))  size=114 ==== */
_DWORD *__thiscall CMFCComObject<ATL::CAccessibleProxy>::~CMFCComObject<ATL::CAccessibleProxy>(_DWORD *this)
{
  *this = 0;
  this[1] = 0;
  this[2] = 0;
  CStringList::CStringList((CStringList *)(this + 3), 10);
  CStringList::CStringList((CStringList *)(this + 10), 10);
  return this;
}


/* ==== 1001A540  sub_1001A540  ()  size=121 ==== */
_DWORD *__thiscall sub_1001A540(_DWORD *this, _DWORD *a2)
{
  if ( this != a2 )
  {
    *this = *a2;
    this[1] = a2[1];
    this[2] = a2[2];
    CStringList::RemoveAll((CStringList *)(this + 3));
    CStringList::AddTail((CStringList *)(this + 3), (struct CStringList *)(a2 + 3));
    CStringList::RemoveAll((CStringList *)(this + 10));
    CStringList::AddTail((CStringList *)(this + 10), (struct CStringList *)(a2 + 10));
  }
  return this;
}


/* ==== 1001A5C0  sub_1001A5C0  ()  size=46 ==== */
void *__thiscall sub_1001A5C0(void *this, char a2)
{
  sub_1001A5F0(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 1001A5F0  sub_1001A5F0  ()  size=240 ==== */
void __thiscall sub_1001A5F0(_DWORD *this)
{
  *this = &CUiAddinHelper::`vftable';
  sub_10019BD0(this + 71);
  sub_10019650(this + 64);
  sub_10019470(this + 57);
  sub_10019290(this + 50);
  sub_100190B0(this + 43);
  sub_10018ED0(this + 36);
  sub_10018CD0(this + 29);
  sub_10018AF0(this + 22);
  sub_10018910(this + 15);
  sub_10018730(this + 8);
  sub_10018550(this + 1);
}


/* ==== 1001A6E0  sub_1001A6E0  ()  size=78 ==== */
void __thiscall sub_1001A6E0(int this)
{
  CStringList::~CStringList((CStringList *)(this + 40));
  CStringList::~CStringList((CStringList *)(this + 12));
}


/* ==== 1001A730  sub_1001A730  ()  size=44 ==== */
_DWORD *__thiscall sub_1001A730(_DWORD *this, int a2)
{
  this[1] = a2;
  this[2] = 0;
  *this = &CComponentManager::`vftable';
  return this;
}


/* ==== 1001A75C  sub_1001A75C  ()  size=20 ==== */
_DWORD *__thiscall sub_1001A75C(_DWORD *this)
{
  _DWORD *result; // eax

  result = this;
  *this = &CComponentManager::`vftable';
  return result;
}


/* ==== 1001A770  sub_1001A770  ()  size=130 ==== */
int __stdcall sub_1001A770(int a1, int a2)
{
  int v3; // [esp+4h] [ebp-Ch] BYREF
  int v4; // [esp+8h] [ebp-8h]
  int v5; // [esp+Ch] [ebp-4h]

  v5 = 0;
  v4 = 0;
  while ( *(_DWORD *)(*(_DWORD *)(a1 + 4) + 8 * v5) )
  {
    if ( (***(int (__stdcall ****)(_DWORD, void *, int *))(*(_DWORD *)(a1 + 4) + 8 * v5 + 4))(
           *(_DWORD *)(*(_DWORD *)(a1 + 4) + 8 * v5 + 4),
           &unk_1001DFA8,
           &v3) )
    {
      v4 = -2147467262;
    }
    else
    {
      (*(void (__stdcall **)(int, int))(*(_DWORD *)v3 + 12))(v3, a2);
    }
    ++v5;
  }
  return v4;
}


/* ==== 1001A7F2  sub_1001A7F2  ()  size=112 ==== */
int __stdcall sub_1001A7F2(int a1, int a2, _DWORD *a3)
{
  int v4; // [esp+0h] [ebp-4h]

  v4 = 0;
  *a3 = 0;
  while ( *(_DWORD *)(*(_DWORD *)(a1 + 4) + 8 * v4) && !*a3 )
  {
    if ( !(***(int (__stdcall ****)(_DWORD, int, _DWORD *))(*(_DWORD *)(a1 + 4) + 8 * v4 + 4))(
            *(_DWORD *)(*(_DWORD *)(a1 + 4) + 8 * v4 + 4),
            a2,
            a3) )
      return 0;
    ++v4;
  }
  return -2147467262;
}


/* ==== 1001A870  sub_1001A870  ()  size=46 ==== */
_DWORD *__thiscall sub_1001A870(_DWORD *this, char a2)
{
  sub_1001A75C(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 1001A8A0  ??0scheduler_worker_creation_error@Concurrency@@QAE@PBDJ@Z  (Concurrency::scheduler_worker_creation_error::scheduler_worker_creation_error(char const *,long))  size=41 ==== */
Concurrency::scheduler_worker_creation_error *__thiscall Concurrency::scheduler_worker_creation_error::scheduler_worker_creation_error(
        Concurrency::scheduler_worker_creation_error *this,
        const char *a2,
        struct CWnd *a3)
{
  CDialog::CDialog(this, (unsigned int)a2, a3);
  *(_DWORD *)this = &CDlgWithHelpSupport::`vftable';
  return this;
}


/* ==== 1001A8C9  sub_1001A8C9  ()  size=25 ==== */
void __stdcall sub_1001A8C9(int a1)
{
  nullsub_1(a1);
}


/* ==== 1001A8E2  sub_1001A8E2  ()  size=10 ==== */
int sub_1001A8E2()
{
  return CDialog::messageMap;
}


/* ==== 1001A8EC  sub_1001A8EC  ()  size=16 ==== */
int (**sub_1001A8EC())()
{
  return &off_1001E278;
}


/* ==== 1001A8FC  sub_1001A8FC  ()  size=78 ==== */
int __thiscall sub_1001A8FC(void *this)
{
  if ( (byte_10024744 & 1) == 0 )
  {
    byte_10024744 |= 1u;
    CString::CString((CString *)&unk_10024740, aHdiChmF1helpwi);
    atexit(sub_1001A94A);
  }
  return unknown_libname_16(&unk_10024740, this);
}


/* ==== 1001A94A  sub_1001A94A  ()  size=15 ==== */
void __cdecl sub_1001A94A()
{
  CString::~CString((CString *)&unk_10024740);
}


/* ==== 1001A960  ??_GCDialog@@UAEPAXI@Z  (CDialog::`scalar deleting destructor'(uint))  size=43 ==== */
CDialog *__thiscall CDialog::`scalar deleting destructor'(CDialog *this, char a2)
{
  CDialog::~CDialog(this);
  if ( (a2 & 1) != 0 )
    sub_10002C90(this);
  return this;
}


/* ==== 1001A990  unknown_libname_16  ()  size=16 ==== */
// Microsoft VisualC 2-14/net runtime
// MFC 3.1-14.0 32bit
int __thiscall unknown_libname_16(void *this)
{
  return *(_DWORD *)this;
}


/* ==== 1001A9A0  ??3@YAXPAX@Z  (operator delete(void *))  size=6 ==== */
// attributes: thunk
void __cdecl operator delete(void *a1)
{
  __imp_??3@YAXPAX@Z(a1);
}


/* ==== 1001A9A6  ??4CString@@QAEABV0@PBD@Z  (CString::operator=(char const *))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator=(void *this, int a2)
{
  return __imp_??4CString@@QAEABV0@PBD@Z(this, a2);
}


/* ==== 1001A9AC  ??2@YAPAXI@Z  (operator new(uint))  size=6 ==== */
// attributes: thunk
void *__cdecl operator new(unsigned int a1)
{
  return __imp_??2@YAPAXI@Z(a1);
}


/* ==== 1001A9B2  ??1CString@@QAE@XZ  (CString::~CString(void))  size=6 ==== */
// attributes: thunk
void __thiscall CString::~CString(CString *this)
{
  __imp_??1CString@@QAE@XZ(this);
}


/* ==== 1001A9B8  ??0CString@@QAE@XZ  (CString::CString(void))  size=6 ==== */
// attributes: thunk
CString *__thiscall CString::CString(CString *this)
{
  return __imp_??0CString@@QAE@XZ(this);
}


/* ==== 1001A9C4  ??0CString@@QAE@ABV0@@Z  (CString::CString(CString const &))  size=6 ==== */
// attributes: thunk
CString *__thiscall CString::CString(CString *this, const struct CString *a2)
{
  return __imp_??0CString@@QAE@ABV0@@Z(this, a2);
}


/* ==== 1001A9CA  ?AddTail@CStringList@@QAEPAU__POSITION@@ABVCString@@@Z  (CStringList::AddTail(CString const &))  size=6 ==== */
// attributes: thunk
struct __POSITION *__thiscall CStringList::AddTail(CStringList *this, const struct CString *a2)
{
  return __imp_?AddTail@CStringList@@QAEPAU__POSITION@@ABVCString@@@Z(this, a2);
}


/* ==== 1001A9D0  ??H@YG?AVCString@@ABV0@0@Z  (operator+(CString const &,CString const &))  size=6 ==== */
// attributes: thunk
int __stdcall operator+(int a1, int a2, int a3)
{
  return __imp_??H@YG?AVCString@@ABV0@0@Z(a1, a2, a3);
}


/* ==== 1001A9D6  ??H@YG?AVCString@@ABV0@PBD@Z  (operator+(CString const &,char const *))  size=6 ==== */
// attributes: thunk
int __stdcall operator+(int a1, int a2, int a3)
{
  return __imp_??H@YG?AVCString@@ABV0@PBD@Z(a1, a2, a3);
}


/* ==== 1001A9DC  ?TrimLeft@CString@@QAEXPBD@Z  (CString::TrimLeft(char const *))  size=6 ==== */
// attributes: thunk
void __thiscall CString::TrimLeft(CString *this, const char *a2)
{
  __imp_?TrimLeft@CString@@QAEXPBD@Z(this, a2);
}


/* ==== 1001A9E2  ?TrimRight@CString@@QAEXPBD@Z  (CString::TrimRight(char const *))  size=6 ==== */
// attributes: thunk
void __thiscall CString::TrimRight(CString *this, const char *a2)
{
  __imp_?TrimRight@CString@@QAEXPBD@Z(this, a2);
}


/* ==== 1001A9E8  ??4CString@@QAEABV0@ABV0@@Z  (CString::operator=(CString const &))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator=(void *this, int a2)
{
  return __imp_??4CString@@QAEABV0@ABV0@@Z(this, a2);
}


/* ==== 1001A9EE  ?RemoveAll@CStringList@@QAEXXZ  (CStringList::RemoveAll(void))  size=6 ==== */
// attributes: thunk
void __thiscall CStringList::RemoveAll(CStringList *this)
{
  __imp_?RemoveAll@CStringList@@QAEXXZ(this);
}


/* ==== 1001A9F4  ?Mid@CString@@QBE?AV1@H@Z  (CString::Mid(int))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Mid(void *this, int a2, int a3)
{
  return __imp_?Mid@CString@@QBE?AV1@H@Z(this, a2, a3);
}


/* ==== 1001A9FA  ?Left@CString@@QBE?AV1@H@Z  (CString::Left(int))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Left(void *this, int a2, int a3)
{
  return __imp_?Left@CString@@QBE?AV1@H@Z(this, a2, a3);
}


/* ==== 1001AA00  ?Find@CString@@QBEHPBD@Z  (CString::Find(char const *))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Find(CString *this, const char *a2)
{
  return __imp_?Find@CString@@QBEHPBD@Z(this, a2);
}


/* ==== 1001AA06  ??0AFX_MAINTAIN_STATE2@@QAE@PAVAFX_MODULE_STATE@@@Z  (AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2(AFX_MODULE_STATE *))  size=6 ==== */
// attributes: thunk
AFX_MAINTAIN_STATE2 *__thiscall AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2(
        AFX_MAINTAIN_STATE2 *this,
        struct AFX_MODULE_STATE *a2)
{
  return __imp_??0AFX_MAINTAIN_STATE2@@QAE@PAVAFX_MODULE_STATE@@@Z(this, a2);
}


/* ==== 1001AA0C  ?FromHandle@CWnd@@SGPAV1@PAUHWND__@@@Z  (CWnd::FromHandle(HWND__ *))  size=6 ==== */
// attributes: thunk
struct CWnd *__stdcall CWnd::FromHandle(HWND a1)
{
  return __imp_?FromHandle@CWnd@@SGPAV1@PAUHWND__@@@Z(a1);
}


/* ==== 1001AA12  ??1CStringList@@UAE@XZ  (CStringList::~CStringList(void))  size=6 ==== */
// attributes: thunk
void __thiscall CStringList::~CStringList(CStringList *this)
{
  __imp_??1CStringList@@UAE@XZ(this);
}


/* ==== 1001AA18  ??0CStringList@@QAE@H@Z  (CStringList::CStringList(int))  size=6 ==== */
// attributes: thunk
CStringList *__thiscall CStringList::CStringList(CStringList *this, int a2)
{
  return __imp_??0CStringList@@QAE@H@Z(this, a2);
}


/* ==== 1001AA1E  ?AllocSysString@CString@@QBEPAGXZ  (CString::AllocSysString(void))  size=6 ==== */
// attributes: thunk
unsigned __int16 *__thiscall CString::AllocSysString(CString *this)
{
  return __imp_?AllocSysString@CString@@QBEPAGXZ(this);
}


/* ==== 1001AA24  ??0CString@@QAE@PBD@Z  (CString::CString(char const *))  size=6 ==== */
// attributes: thunk
CString *__thiscall CString::CString(CString *this, const char *a2)
{
  return __imp_??0CString@@QAE@PBD@Z(this, a2);
}


/* ==== 1001AA2A  ?PreInitDialog@CDialog@@MAEXXZ  (CDialog::PreInitDialog(void))  size=6 ==== */
// attributes: thunk
void __thiscall CDialog::PreInitDialog(CDialog *this)
{
  __imp_?PreInitDialog@CDialog@@MAEXXZ(this);
}


/* ==== 1001AA30  ?OnSetFont@CDialog@@UAEXPAVCFont@@@Z  (CDialog::OnSetFont(CFont *))  size=6 ==== */
// attributes: thunk
void __thiscall CDialog::OnSetFont(CDialog *this, struct CFont *a2)
{
  __imp_?OnSetFont@CDialog@@UAEXPAVCFont@@@Z(this, a2);
}


/* ==== 1001AA36  ?DoModal@CDialog@@UAEHXZ  (CDialog::DoModal(void))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::DoModal(CDialog *this)
{
  return __imp_?DoModal@CDialog@@UAEHXZ(this);
}


/* ==== 1001AA3C  ?SetOccDialogInfo@CDialog@@MAEHPAU_AFX_OCC_DIALOG_INFO@@@Z  (CDialog::SetOccDialogInfo(_AFX_OCC_DIALOG_INFO *))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::SetOccDialogInfo(CDialog *this, struct _AFX_OCC_DIALOG_INFO *a2)
{
  return __imp_?SetOccDialogInfo@CDialog@@MAEHPAU_AFX_OCC_DIALOG_INFO@@@Z(this, a2);
}


/* ==== 1001AA42  ?CheckAutoCenter@CDialog@@UAEHXZ  (CDialog::CheckAutoCenter(void))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::CheckAutoCenter(CDialog *this)
{
  return __imp_?CheckAutoCenter@CDialog@@UAEHXZ(this);
}


/* ==== 1001AA48  ?OnChildNotify@CWnd@@MAEHIIJPAJ@Z  (CWnd::OnChildNotify(uint,uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::OnChildNotify(CWnd *this, unsigned int a2, unsigned int a3, int a4, int *a5)
{
  return __imp_?OnChildNotify@CWnd@@MAEHIIJPAJ@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AA4E  ?PreTranslateMessage@CDialog@@UAEHPAUtagMSG@@@Z  (CDialog::PreTranslateMessage(tagMSG *))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::PreTranslateMessage(CDialog *this, struct tagMSG *a2)
{
  return __imp_?PreTranslateMessage@CDialog@@UAEHPAUtagMSG@@@Z(this, a2);
}


/* ==== 1001AA54  ?OnCmdMsg@CDialog@@UAEHIHPAXPAUAFX_CMDHANDLERINFO@@@Z  (CDialog::OnCmdMsg(uint,int,void *,AFX_CMDHANDLERINFO *))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::OnCmdMsg(CDialog *this, unsigned int a2, int a3, void *a4, struct AFX_CMDHANDLERINFO *a5)
{
  return __imp_?OnCmdMsg@CDialog@@UAEHIHPAXPAUAFX_CMDHANDLERINFO@@@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AA5A  ?GetRuntimeClass@CDialog@@UBEPAUCRuntimeClass@@XZ  (CDialog::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CDialog::GetRuntimeClass(CDialog *this)
{
  return __imp_?GetRuntimeClass@CDialog@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001AA60  ?CharToItem@CListBox@@UAEHII@Z  (CListBox::CharToItem(uint,uint))  size=6 ==== */
// attributes: thunk
int __thiscall CListBox::CharToItem(CListBox *this, unsigned int a2, unsigned int a3)
{
  return __imp_?CharToItem@CListBox@@UAEHII@Z(this, a2, a3);
}


/* ==== 1001AA66  ?VKeyToItem@CListBox@@UAEHII@Z  (CListBox::VKeyToItem(uint,uint))  size=6 ==== */
// attributes: thunk
int __thiscall CListBox::VKeyToItem(CListBox *this, unsigned int a2, unsigned int a3)
{
  return __imp_?VKeyToItem@CListBox@@UAEHII@Z(this, a2, a3);
}


/* ==== 1001AA6C  ?DeleteItem@CListBox@@UAEXPAUtagDELETEITEMSTRUCT@@@Z  (CListBox::DeleteItem(tagDELETEITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CListBox::DeleteItem(CListBox *this, struct tagDELETEITEMSTRUCT *a2)
{
  __imp_?DeleteItem@CListBox@@UAEXPAUtagDELETEITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AA72  ?CompareItem@CListBox@@UAEHPAUtagCOMPAREITEMSTRUCT@@@Z  (CListBox::CompareItem(tagCOMPAREITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
int __thiscall CListBox::CompareItem(CListBox *this, struct tagCOMPAREITEMSTRUCT *a2)
{
  return __imp_?CompareItem@CListBox@@UAEHPAUtagCOMPAREITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AA78  ?MeasureItem@CListBox@@UAEXPAUtagMEASUREITEMSTRUCT@@@Z  (CListBox::MeasureItem(tagMEASUREITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CListBox::MeasureItem(CListBox *this, struct tagMEASUREITEMSTRUCT *a2)
{
  __imp_?MeasureItem@CListBox@@UAEXPAUtagMEASUREITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AA7E  ?DrawItem@CListBox@@UAEXPAUtagDRAWITEMSTRUCT@@@Z  (CListBox::DrawItem(tagDRAWITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CListBox::DrawItem(CListBox *this, struct tagDRAWITEMSTRUCT *a2)
{
  __imp_?DrawItem@CListBox@@UAEXPAUtagDRAWITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AA84  ?OnChildNotify@CListBox@@MAEHIIJPAJ@Z  (CListBox::OnChildNotify(uint,uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CListBox::OnChildNotify(CListBox *this, unsigned int a2, unsigned int a3, int a4, int *a5)
{
  return __imp_?OnChildNotify@CListBox@@MAEHIIJPAJ@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AA8A  ?GetRuntimeClass@CListBox@@UBEPAUCRuntimeClass@@XZ  (CListBox::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CListBox::GetRuntimeClass(CListBox *this)
{
  return __imp_?GetRuntimeClass@CListBox@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001AA90  ?DrawItem@CButton@@UAEXPAUtagDRAWITEMSTRUCT@@@Z  (CButton::DrawItem(tagDRAWITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CButton::DrawItem(CButton *this, struct tagDRAWITEMSTRUCT *a2)
{
  __imp_?DrawItem@CButton@@UAEXPAUtagDRAWITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AA96  ?SetOccDialogInfo@CWnd@@MAEHPAU_AFX_OCC_DIALOG_INFO@@@Z  (CWnd::SetOccDialogInfo(_AFX_OCC_DIALOG_INFO *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::SetOccDialogInfo(CWnd *this, struct _AFX_OCC_DIALOG_INFO *a2)
{
  return __imp_?SetOccDialogInfo@CWnd@@MAEHPAU_AFX_OCC_DIALOG_INFO@@@Z(this, a2);
}


/* ==== 1001AA9C  ?IsFrameWnd@CWnd@@UBEHXZ  (CWnd::IsFrameWnd(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::IsFrameWnd(CWnd *this)
{
  return __imp_?IsFrameWnd@CWnd@@UBEHXZ(this);
}


/* ==== 1001AAA2  ?CheckAutoCenter@CWnd@@UAEHXZ  (CWnd::CheckAutoCenter(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::CheckAutoCenter(CWnd *this)
{
  return __imp_?CheckAutoCenter@CWnd@@UAEHXZ(this);
}


/* ==== 1001AAA8  ?OnChildNotify@CButton@@MAEHIIJPAJ@Z  (CButton::OnChildNotify(uint,uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CButton::OnChildNotify(CButton *this, unsigned int a2, unsigned int a3, int a4, int *a5)
{
  return __imp_?OnChildNotify@CButton@@MAEHIIJPAJ@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AAAE  ?PostNcDestroy@CWnd@@MAEXXZ  (CWnd::PostNcDestroy(void))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::PostNcDestroy(CWnd *this)
{
  __imp_?PostNcDestroy@CWnd@@MAEXXZ(this);
}


/* ==== 1001AAB4  ?DefWindowProcA@CWnd@@MAEJIIJ@Z  (CWnd::DefWindowProcA(uint,uint,long))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::DefWindowProcA(CWnd *this, unsigned int a2, unsigned int a3, int a4)
{
  return __imp_?DefWindowProcA@CWnd@@MAEJIIJ@Z(this, a2, a3, a4);
}


/* ==== 1001AABA  ?OnWndMsg@CWnd@@MAEHIIJPAJ@Z  (CWnd::OnWndMsg(uint,uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::OnWndMsg(CWnd *this, unsigned int a2, unsigned int a3, int a4, int *a5)
{
  return __imp_?OnWndMsg@CWnd@@MAEHIIJPAJ@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AAC0  ?WindowProc@CWnd@@MAEJIIJ@Z  (CWnd::WindowProc(uint,uint,long))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::WindowProc(CWnd *this, unsigned int a2, unsigned int a3, int a4)
{
  return __imp_?WindowProc@CWnd@@MAEJIIJ@Z(this, a2, a3, a4);
}


/* ==== 1001AAC6  ?OnAmbientProperty@CWnd@@UAEHPAVCOleControlSite@@JPAUtagVARIANT@@@Z  (CWnd::OnAmbientProperty(COleControlSite *,long,tagVARIANT *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::OnAmbientProperty(CWnd *this, struct COleControlSite *a2, int a3, struct tagVARIANT *a4)
{
  return __imp_?OnAmbientProperty@CWnd@@UAEHPAVCOleControlSite@@JPAUtagVARIANT@@@Z(this, a2, a3, a4);
}


/* ==== 1001AACC  ?PreTranslateMessage@CWnd@@UAEHPAUtagMSG@@@Z  (CWnd::PreTranslateMessage(tagMSG *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::PreTranslateMessage(CWnd *this, struct tagMSG *a2)
{
  return __imp_?PreTranslateMessage@CWnd@@UAEHPAUtagMSG@@@Z(this, a2);
}


/* ==== 1001AAD2  ?GetSuperWndProcAddr@CWnd@@MAEPAP6GJPAUHWND__@@IIJ@ZXZ  (CWnd::GetSuperWndProcAddr(void))  size=6 ==== */
// attributes: thunk
int (__stdcall **__thiscall CWnd::GetSuperWndProcAddr(CWnd *this))(HWND, unsigned int, unsigned int, int)
{
  return __imp_?GetSuperWndProcAddr@CWnd@@MAEPAP6GJPAUHWND__@@IIJ@ZXZ(this);
}


/* ==== 1001AAD8  ?OnNotify@CWnd@@MAEHIJPAJ@Z  (CWnd::OnNotify(uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::OnNotify(CWnd *this, unsigned int a2, int a3, int *a4)
{
  return __imp_?OnNotify@CWnd@@MAEHIJPAJ@Z(this, a2, a3, a4);
}


/* ==== 1001AADE  ?OnCommand@CWnd@@MAEHIJ@Z  (CWnd::OnCommand(uint,long))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::OnCommand(CWnd *this, unsigned int a2, int a3)
{
  return __imp_?OnCommand@CWnd@@MAEHIJ@Z(this, a2, a3);
}


/* ==== 1001AAE4  ?EndModalLoop@CWnd@@UAEXH@Z  (CWnd::EndModalLoop(int))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::EndModalLoop(CWnd *this, int a2)
{
  __imp_?EndModalLoop@CWnd@@UAEXH@Z(this, a2);
}


/* ==== 1001AAEA  ?ContinueModal@CWnd@@UAEHXZ  (CWnd::ContinueModal(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::ContinueModal(CWnd *this)
{
  return __imp_?ContinueModal@CWnd@@UAEHXZ(this);
}


/* ==== 1001AAF0  ?WinHelpA@CWnd@@UAEXKI@Z  (CWnd::WinHelpA(ulong,uint))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::WinHelpA(CWnd *this, unsigned int a2, unsigned int a3)
{
  __imp_?WinHelpA@CWnd@@UAEXKI@Z(this, a2, a3);
}


/* ==== 1001AAF6  ?GetScrollBarCtrl@CWnd@@UBEPAVCScrollBar@@H@Z  (CWnd::GetScrollBarCtrl(int))  size=6 ==== */
// attributes: thunk
struct CScrollBar *__thiscall CWnd::GetScrollBarCtrl(CWnd *this, int a2)
{
  return __imp_?GetScrollBarCtrl@CWnd@@UBEPAVCScrollBar@@H@Z(this, a2);
}


/* ==== 1001AAFC  ?OnToolHitTest@CWnd@@UBEHVCPoint@@PAUtagTOOLINFOA@@@Z  (CWnd::OnToolHitTest(CPoint,tagTOOLINFOA *))  size=6 ==== */
// attributes: thunk
int __stdcall CWnd::OnToolHitTest(int a1, int a2, int a3)
{
  return __imp_?OnToolHitTest@CWnd@@UBEHVCPoint@@PAUtagTOOLINFOA@@@Z(a1, a2, a3);
}


/* ==== 1001AB02  ?CalcWindowRect@CWnd@@UAEXPAUtagRECT@@I@Z  (CWnd::CalcWindowRect(tagRECT *,uint))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::CalcWindowRect(CWnd *this, struct tagRECT *a2, unsigned int a3)
{
  __imp_?CalcWindowRect@CWnd@@UAEXPAUtagRECT@@I@Z(this, a2, a3);
}


/* ==== 1001AB08  ?PreCreateWindow@CWnd@@UAEHAAUtagCREATESTRUCTA@@@Z  (CWnd::PreCreateWindow(tagCREATESTRUCTA &))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::PreCreateWindow(CWnd *this, struct tagCREATESTRUCTA *a2)
{
  return __imp_?PreCreateWindow@CWnd@@UAEHAAUtagCREATESTRUCTA@@@Z(this, a2);
}


/* ==== 1001AB0E  ?DestroyWindow@CWnd@@UAEHXZ  (CWnd::DestroyWindow(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::DestroyWindow(CWnd *this)
{
  return __imp_?DestroyWindow@CWnd@@UAEHXZ(this);
}


/* ==== 1001AB14  ?Create@CWnd@@UAEHPBD0KABUtagRECT@@PAV1@IPAUCCreateContext@@@Z  (CWnd::Create(char const *,char const *,ulong,tagRECT const &,CWnd *,uint,CCreateContext *))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::Create(
        CWnd *this,
        const char *a2,
        const char *a3,
        unsigned int a4,
        const struct tagRECT *a5,
        struct CWnd *a6,
        unsigned int a7,
        struct CCreateContext *a8)
{
  return __imp_?Create@CWnd@@UAEHPBD0KABUtagRECT@@PAV1@IPAUCCreateContext@@@Z(this, a2, a3, a4, a5, a6, a7, a8);
}


/* ==== 1001AB1A  ?PreSubclassWindow@CWnd@@UAEXXZ  (CWnd::PreSubclassWindow(void))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::PreSubclassWindow(CWnd *this)
{
  __imp_?PreSubclassWindow@CWnd@@UAEXXZ(this);
}


/* ==== 1001AB20  ?GetConnectionHook@CCmdTarget@@MAEPAUIConnectionPoint@@ABU_GUID@@@Z  (CCmdTarget::GetConnectionHook(_GUID const &))  size=6 ==== */
// attributes: thunk
struct IConnectionPoint *__thiscall CCmdTarget::GetConnectionHook(CCmdTarget *this, const struct _GUID *a2)
{
  return __imp_?GetConnectionHook@CCmdTarget@@MAEPAUIConnectionPoint@@ABU_GUID@@@Z(this, a2);
}


/* ==== 1001AB26  ?GetExtraConnectionPoints@CCmdTarget@@MAEHPAVCPtrArray@@@Z  (CCmdTarget::GetExtraConnectionPoints(CPtrArray *))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::GetExtraConnectionPoints(CCmdTarget *this, struct CPtrArray *a2)
{
  return __imp_?GetExtraConnectionPoints@CCmdTarget@@MAEHPAVCPtrArray@@@Z(this, a2);
}


/* ==== 1001AB2C  ?GetInterfaceHook@CCmdTarget@@UAEPAUIUnknown@@PBX@Z  (CCmdTarget::GetInterfaceHook(void const *))  size=6 ==== */
// attributes: thunk
struct IUnknown *__thiscall CCmdTarget::GetInterfaceHook(CCmdTarget *this, const void *a2)
{
  return __imp_?GetInterfaceHook@CCmdTarget@@UAEPAUIUnknown@@PBX@Z(this, a2);
}


/* ==== 1001AB32  ?OnCreateAggregates@CCmdTarget@@UAEHXZ  (CCmdTarget::OnCreateAggregates(void))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::OnCreateAggregates(CCmdTarget *this)
{
  return __imp_?OnCreateAggregates@CCmdTarget@@UAEHXZ(this);
}


/* ==== 1001AB38  ?GetEventSinkMap@CCmdTarget@@MBEPBUAFX_EVENTSINKMAP@@XZ  (CCmdTarget::GetEventSinkMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_EVENTSINKMAP *__thiscall CCmdTarget::GetEventSinkMap(CCmdTarget *this)
{
  return __imp_?GetEventSinkMap@CCmdTarget@@MBEPBUAFX_EVENTSINKMAP@@XZ(this);
}


/* ==== 1001AB3E  ?GetInterfaceMap@CCmdTarget@@MBEPBUAFX_INTERFACEMAP@@XZ  (CCmdTarget::GetInterfaceMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_INTERFACEMAP *__thiscall CCmdTarget::GetInterfaceMap(CCmdTarget *this)
{
  return __imp_?GetInterfaceMap@CCmdTarget@@MBEPBUAFX_INTERFACEMAP@@XZ(this);
}


/* ==== 1001AB44  ?GetConnectionMap@CCmdTarget@@MBEPBUAFX_CONNECTIONMAP@@XZ  (CCmdTarget::GetConnectionMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_CONNECTIONMAP *__thiscall CCmdTarget::GetConnectionMap(CCmdTarget *this)
{
  return __imp_?GetConnectionMap@CCmdTarget@@MBEPBUAFX_CONNECTIONMAP@@XZ(this);
}


/* ==== 1001AB4A  ?GetDispatchMap@CCmdTarget@@MBEPBUAFX_DISPMAP@@XZ  (CCmdTarget::GetDispatchMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_DISPMAP *__thiscall CCmdTarget::GetDispatchMap(CCmdTarget *this)
{
  return __imp_?GetDispatchMap@CCmdTarget@@MBEPBUAFX_DISPMAP@@XZ(this);
}


/* ==== 1001AB50  ?GetCommandMap@CCmdTarget@@MBEPBUAFX_OLECMDMAP@@XZ  (CCmdTarget::GetCommandMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_OLECMDMAP *__thiscall CCmdTarget::GetCommandMap(CCmdTarget *this)
{
  return __imp_?GetCommandMap@CCmdTarget@@MBEPBUAFX_OLECMDMAP@@XZ(this);
}


/* ==== 1001AB56  ?GetMessageMap@CWnd@@MBEPBUAFX_MSGMAP@@XZ  (CWnd::GetMessageMap(void))  size=6 ==== */
// attributes: thunk
const struct AFX_MSGMAP *__thiscall CWnd::GetMessageMap(CWnd *this)
{
  return __imp_?GetMessageMap@CWnd@@MBEPBUAFX_MSGMAP@@XZ(this);
}


/* ==== 1001AB5C  ?GetTypeLib@CCmdTarget@@UAEJKPAPAUITypeLib@@@Z  (CCmdTarget::GetTypeLib(ulong,ITypeLib * *))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::GetTypeLib(CCmdTarget *this, unsigned int a2, struct ITypeLib **a3)
{
  return __imp_?GetTypeLib@CCmdTarget@@UAEJKPAPAUITypeLib@@@Z(this, a2, a3);
}


/* ==== 1001AB62  ?GetTypeLibCache@CCmdTarget@@UAEPAVCTypeLibCache@@XZ  (CCmdTarget::GetTypeLibCache(void))  size=6 ==== */
// attributes: thunk
struct CTypeLibCache *__thiscall CCmdTarget::GetTypeLibCache(CCmdTarget *this)
{
  return __imp_?GetTypeLibCache@CCmdTarget@@UAEPAVCTypeLibCache@@XZ(this);
}


/* ==== 1001AB68  ?GetTypeInfoCount@CCmdTarget@@UAEIXZ  (CCmdTarget::GetTypeInfoCount(void))  size=6 ==== */
// attributes: thunk
unsigned int __thiscall CCmdTarget::GetTypeInfoCount(CCmdTarget *this)
{
  return __imp_?GetTypeInfoCount@CCmdTarget@@UAEIXZ(this);
}


/* ==== 1001AB6E  ?GetDispatchIID@CCmdTarget@@UAEHPAU_GUID@@@Z  (CCmdTarget::GetDispatchIID(_GUID *))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::GetDispatchIID(CCmdTarget *this, struct _GUID *a2)
{
  return __imp_?GetDispatchIID@CCmdTarget@@UAEHPAU_GUID@@@Z(this, a2);
}


/* ==== 1001AB74  ?IsInvokeAllowed@CCmdTarget@@UAEHJ@Z  (CCmdTarget::IsInvokeAllowed(long))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::IsInvokeAllowed(CCmdTarget *this, int a2)
{
  return __imp_?IsInvokeAllowed@CCmdTarget@@UAEHJ@Z(this, a2);
}


/* ==== 1001AB7A  ?OnFinalRelease@CWnd@@UAEXXZ  (CWnd::OnFinalRelease(void))  size=6 ==== */
// attributes: thunk
void __thiscall CWnd::OnFinalRelease(CWnd *this)
{
  __imp_?OnFinalRelease@CWnd@@UAEXXZ(this);
}


/* ==== 1001AB80  ?OnCmdMsg@CCmdTarget@@UAEHIHPAXPAUAFX_CMDHANDLERINFO@@@Z  (CCmdTarget::OnCmdMsg(uint,int,void *,AFX_CMDHANDLERINFO *))  size=6 ==== */
// attributes: thunk
int __thiscall CCmdTarget::OnCmdMsg(CCmdTarget *this, unsigned int a2, int a3, void *a4, struct AFX_CMDHANDLERINFO *a5)
{
  return __imp_?OnCmdMsg@CCmdTarget@@UAEHIHPAXPAUAFX_CMDHANDLERINFO@@@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AB86  ?GetRuntimeClass@CButton@@UBEPAUCRuntimeClass@@XZ  (CButton::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CButton::GetRuntimeClass(CButton *this)
{
  return __imp_?GetRuntimeClass@CButton@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001AB8C  ??1CListBox@@UAE@XZ  (CListBox::~CListBox(void))  size=6 ==== */
// attributes: thunk
void __thiscall CListBox::~CListBox(CListBox *this)
{
  __imp_??1CListBox@@UAE@XZ(this);
}


/* ==== 1001AB92  ??1CButton@@UAE@XZ  (CButton::~CButton(void))  size=6 ==== */
// attributes: thunk
void __thiscall CButton::~CButton(CButton *this)
{
  __imp_??1CButton@@UAE@XZ(this);
}


/* ==== 1001AB98  ??0CSingleLock@@QAE@PAVCSyncObject@@H@Z  (CSingleLock::CSingleLock(CSyncObject *,int))  size=6 ==== */
// attributes: thunk
CSingleLock *__thiscall CSingleLock::CSingleLock(CSingleLock *this, struct CSyncObject *a2, int a3)
{
  return __imp_??0CSingleLock@@QAE@PAVCSyncObject@@H@Z(this, a2, a3);
}


/* ==== 1001AB9E  ??0CMutex@@QAE@HPBDPAU_SECURITY_ATTRIBUTES@@@Z  (CMutex::CMutex(int,char const *,_SECURITY_ATTRIBUTES *))  size=6 ==== */
// attributes: thunk
CMutex *__thiscall CMutex::CMutex(CMutex *this, int a2, const char *a3, struct _SECURITY_ATTRIBUTES *a4)
{
  return __imp_??0CMutex@@QAE@HPBDPAU_SECURITY_ATTRIBUTES@@@Z(this, a2, a3, a4);
}


/* ==== 1001ABA4  ??0CWnd@@QAE@XZ  (CWnd::CWnd(void))  size=6 ==== */
// attributes: thunk
CWnd *__thiscall CWnd::CWnd(CWnd *this)
{
  return __imp_??0CWnd@@QAE@XZ(this);
}


/* ==== 1001ABAA  ??1CDialog@@UAE@XZ  (CDialog::~CDialog(void))  size=6 ==== */
// attributes: thunk
void __thiscall CDialog::~CDialog(CDialog *this)
{
  __imp_??1CDialog@@UAE@XZ(this);
}


/* ==== 1001ABB0  ?Unlock@CSingleLock@@QAEHXZ  (CSingleLock::Unlock(void))  size=6 ==== */
// attributes: thunk
int __thiscall CSingleLock::Unlock(CSingleLock *this)
{
  return __imp_?Unlock@CSingleLock@@QAEHXZ(this);
}


/* ==== 1001ABB6  ?DDX_Text@@YGXPAVCDataExchange@@HAAVCString@@@Z  (DDX_Text(CDataExchange *,int,CString &))  size=6 ==== */
// attributes: thunk
void __stdcall DDX_Text(struct CDataExchange *a1, int a2, struct CString *a3)
{
  __imp_?DDX_Text@@YGXPAVCDataExchange@@HAAVCString@@@Z(a1, a2, a3);
}


/* ==== 1001ABBC  ?DDX_Control@@YGXPAVCDataExchange@@HAAVCWnd@@@Z  (DDX_Control(CDataExchange *,int,CWnd &))  size=6 ==== */
// attributes: thunk
void __stdcall DDX_Control(struct CDataExchange *a1, int a2, struct CWnd *a3)
{
  __imp_?DDX_Control@@YGXPAVCDataExchange@@HAAVCWnd@@@Z(a1, a2, a3);
}


/* ==== 1001ABC2  ?ShowWindow@CWnd@@QAEHH@Z  (CWnd::ShowWindow(int))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::ShowWindow(CWnd *this, int a2)
{
  return __imp_?ShowWindow@CWnd@@QAEHH@Z(this, a2);
}


/* ==== 1001ABC8  ?OnInitDialog@CDialog@@UAEHXZ  (CDialog::OnInitDialog(void))  size=6 ==== */
// attributes: thunk
int __thiscall CDialog::OnInitDialog(CDialog *this)
{
  return __imp_?OnInitDialog@CDialog@@UAEHXZ(this);
}


/* ==== 1001ABCE  ?OnCancel@CDialog@@MAEXXZ  (CDialog::OnCancel(void))  size=6 ==== */
// attributes: thunk
void __thiscall CDialog::OnCancel(CDialog *this)
{
  __imp_?OnCancel@CDialog@@MAEXXZ(this);
}


/* ==== 1001ABD4  ?Empty@CString@@QAEXXZ  (CString::Empty(void))  size=6 ==== */
// attributes: thunk
void __thiscall CString::Empty(CString *this)
{
  __imp_?Empty@CString@@QAEXXZ(this);
}


/* ==== 1001ABDA  ?OnOK@CDialog@@MAEXXZ  (CDialog::OnOK(void))  size=6 ==== */
// attributes: thunk
void __thiscall CDialog::OnOK(CDialog *this)
{
  __imp_?OnOK@CDialog@@MAEXXZ(this);
}


/* ==== 1001ABE0  ?GetText@CListBox@@QBEXHAAVCString@@@Z  (CListBox::GetText(int,CString &))  size=6 ==== */
// attributes: thunk
void __thiscall CListBox::GetText(CListBox *this, int a2, struct CString *a3)
{
  __imp_?GetText@CListBox@@QBEXHAAVCString@@@Z(this, a2, a3);
}


/* ==== 1001ABE6  ?UpdateData@CWnd@@QAEHH@Z  (CWnd::UpdateData(int))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::UpdateData(CWnd *this, int a2)
{
  return __imp_?UpdateData@CWnd@@QAEHH@Z(this, a2);
}


/* ==== 1001ABEC  ?EnableWindow@CWnd@@QAEHH@Z  (CWnd::EnableWindow(int))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::EnableWindow(CWnd *this, int a2)
{
  return __imp_?EnableWindow@CWnd@@QAEHH@Z(this, a2);
}


/* ==== 1001ABF2  ?GetDlgItem@CWnd@@QBEPAV1@H@Z  (CWnd::GetDlgItem(int))  size=6 ==== */
// attributes: thunk
struct CWnd *__thiscall CWnd::GetDlgItem(CWnd *this, int a2)
{
  return __imp_?GetDlgItem@CWnd@@QBEPAV1@H@Z(this, a2);
}


/* ==== 1001ABF8  ?MessageBoxA@CWnd@@QAEHPBD0I@Z  (CWnd::MessageBoxA(char const *,char const *,uint))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::MessageBoxA(CWnd *this, const char *a2, const char *a3, unsigned int a4)
{
  return __imp_?MessageBoxA@CWnd@@QAEHPBD0I@Z(this, a2, a3, a4);
}


/* ==== 1001ABFE  ?Lock@CSingleLock@@QAEHK@Z  (CSingleLock::Lock(ulong))  size=6 ==== */
// attributes: thunk
int __thiscall CSingleLock::Lock(CSingleLock *this, unsigned int a2)
{
  return __imp_?Lock@CSingleLock@@QAEHK@Z(this, a2);
}


/* ==== 1001AC04  ?FromHandle@CDC@@SGPAV1@PAUHDC__@@@Z  (CDC::FromHandle(HDC__ *))  size=6 ==== */
// attributes: thunk
struct CDC *__stdcall CDC::FromHandle(HDC a1)
{
  return __imp_?FromHandle@CDC@@SGPAV1@PAUHDC__@@@Z(a1);
}


/* ==== 1001AC0A  ?Default@CWnd@@IAEJXZ  (CWnd::Default(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWnd::Default(CWnd *this)
{
  return __imp_?Default@CWnd@@IAEJXZ(this);
}


/* ==== 1001AC10  ?Right@CString@@QBE?AV1@H@Z  (CString::Right(int))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Right(void *this, int a2, int a3)
{
  return __imp_?Right@CString@@QBE?AV1@H@Z(this, a2, a3);
}


/* ==== 1001AC16  ?DeleteItem@CComboBox@@UAEXPAUtagDELETEITEMSTRUCT@@@Z  (CComboBox::DeleteItem(tagDELETEITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CComboBox::DeleteItem(CComboBox *this, struct tagDELETEITEMSTRUCT *a2)
{
  __imp_?DeleteItem@CComboBox@@UAEXPAUtagDELETEITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AC1C  ?CompareItem@CComboBox@@UAEHPAUtagCOMPAREITEMSTRUCT@@@Z  (CComboBox::CompareItem(tagCOMPAREITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
int __thiscall CComboBox::CompareItem(CComboBox *this, struct tagCOMPAREITEMSTRUCT *a2)
{
  return __imp_?CompareItem@CComboBox@@UAEHPAUtagCOMPAREITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AC22  ?MeasureItem@CComboBox@@UAEXPAUtagMEASUREITEMSTRUCT@@@Z  (CComboBox::MeasureItem(tagMEASUREITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CComboBox::MeasureItem(CComboBox *this, struct tagMEASUREITEMSTRUCT *a2)
{
  __imp_?MeasureItem@CComboBox@@UAEXPAUtagMEASUREITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AC28  ?DrawItem@CComboBox@@UAEXPAUtagDRAWITEMSTRUCT@@@Z  (CComboBox::DrawItem(tagDRAWITEMSTRUCT *))  size=6 ==== */
// attributes: thunk
void __thiscall CComboBox::DrawItem(CComboBox *this, struct tagDRAWITEMSTRUCT *a2)
{
  __imp_?DrawItem@CComboBox@@UAEXPAUtagDRAWITEMSTRUCT@@@Z(this, a2);
}


/* ==== 1001AC2E  ?OnChildNotify@CComboBox@@MAEHIIJPAJ@Z  (CComboBox::OnChildNotify(uint,uint,long,long *))  size=6 ==== */
// attributes: thunk
int __thiscall CComboBox::OnChildNotify(CComboBox *this, unsigned int a2, unsigned int a3, int a4, int *a5)
{
  return __imp_?OnChildNotify@CComboBox@@MAEHIIJPAJ@Z(this, a2, a3, a4, a5);
}


/* ==== 1001AC34  ?GetRuntimeClass@CComboBox@@UBEPAUCRuntimeClass@@XZ  (CComboBox::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CComboBox::GetRuntimeClass(CComboBox *this)
{
  return __imp_?GetRuntimeClass@CComboBox@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001AC3A  ??1CComboBox@@UAE@XZ  (CComboBox::~CComboBox(void))  size=6 ==== */
// attributes: thunk
void __thiscall CComboBox::~CComboBox(CComboBox *this)
{
  __imp_??1CComboBox@@UAE@XZ(this);
}


/* ==== 1001AC40  ?GetLBText@CComboBox@@QBEXHAAVCString@@@Z  (CComboBox::GetLBText(int,CString &))  size=6 ==== */
// attributes: thunk
void __thiscall CComboBox::GetLBText(CComboBox *this, int a2, struct CString *a3)
{
  __imp_?GetLBText@CComboBox@@QBEXHAAVCString@@@Z(this, a2, a3);
}


/* ==== 1001AC46  ??0CString@@QAE@PBG@Z  (CString::CString(ushort const *))  size=6 ==== */
// attributes: thunk
CString *__thiscall CString::CString(CString *this, const unsigned __int16 *a2)
{
  return __imp_??0CString@@QAE@PBG@Z(this, a2);
}


/* ==== 1001AC4C  ??4CString@@QAEABV0@PBG@Z  (CString::operator=(ushort const *))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator=(void *this, int a2)
{
  return __imp_??4CString@@QAEABV0@PBG@Z(this, a2);
}


/* ==== 1001AC52  ?GetRuntimeClass@CObject@@UBEPAUCRuntimeClass@@XZ  (CObject::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CObject::GetRuntimeClass(CObject *this)
{
  return __imp_?GetRuntimeClass@CObject@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001AC58  ??YCString@@QAEABV0@D@Z  (CString::operator+=(char))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator+=(void *this, int a2)
{
  return __imp_??YCString@@QAEABV0@D@Z(this, a2);
}


/* ==== 1001AC5E  ?Mid@CString@@QBE?AV1@HH@Z  (CString::Mid(int,int))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Mid(void *this, int a2, int a3, int a4)
{
  return __imp_?Mid@CString@@QBE?AV1@HH@Z(this, a2, a3, a4);
}


/* ==== 1001AC64  ?Find@CString@@QBEHDH@Z  (CString::Find(char,int))  size=6 ==== */
// attributes: thunk
int __thiscall CString::Find(CString *this, char a2, int a3)
{
  return __imp_?Find@CString@@QBEHDH@Z(this, a2, a3);
}


/* ==== 1001AC6A  ??YCString@@QAEABV0@PBD@Z  (CString::operator+=(char const *))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator+=(void *this, int a2)
{
  return __imp_??YCString@@QAEABV0@PBD@Z(this, a2);
}


/* ==== 1001AC70  ??YCString@@QAEABV0@ABV0@@Z  (CString::operator+=(CString const &))  size=6 ==== */
// attributes: thunk
int __thiscall CString::operator+=(void *this, int a2)
{
  return __imp_??YCString@@QAEABV0@ABV0@@Z(this, a2);
}


/* ==== 1001AC76  ?WinHelpA@CWinApp@@UAEXKI@Z  (CWinApp::WinHelpA(ulong,uint))  size=6 ==== */
// attributes: thunk
void __thiscall CWinApp::WinHelpA(CWinApp *this, unsigned int a2, unsigned int a3)
{
  __imp_?WinHelpA@CWinApp@@UAEXKI@Z(this, a2, a3);
}


/* ==== 1001AC7C  ?OnDDECommand@CWinApp@@UAEHPAD@Z  (CWinApp::OnDDECommand(char *))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::OnDDECommand(CWinApp *this, char *a2)
{
  return __imp_?OnDDECommand@CWinApp@@UAEHPAD@Z(this, a2);
}


/* ==== 1001AC82  ?DoWaitCursor@CWinApp@@UAEXH@Z  (CWinApp::DoWaitCursor(int))  size=6 ==== */
// attributes: thunk
void __thiscall CWinApp::DoWaitCursor(CWinApp *this, int a2)
{
  __imp_?DoWaitCursor@CWinApp@@UAEXH@Z(this, a2);
}


/* ==== 1001AC88  ?DoMessageBox@CWinApp@@UAEHPBDII@Z  (CWinApp::DoMessageBox(char const *,uint,uint))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::DoMessageBox(CWinApp *this, const char *a2, unsigned int a3, unsigned int a4)
{
  return __imp_?DoMessageBox@CWinApp@@UAEHPBDII@Z(this, a2, a3, a4);
}


/* ==== 1001AC8E  ?SaveAllModified@CWinApp@@UAEHXZ  (CWinApp::SaveAllModified(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::SaveAllModified(CWinApp *this)
{
  return __imp_?SaveAllModified@CWinApp@@UAEHXZ(this);
}


/* ==== 1001AC94  ?InitApplication@CWinApp@@UAEHXZ  (CWinApp::InitApplication(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::InitApplication(CWinApp *this)
{
  return __imp_?InitApplication@CWinApp@@UAEHXZ(this);
}


/* ==== 1001AC9A  ?AddToRecentFileList@CWinApp@@UAEXPBD@Z  (CWinApp::AddToRecentFileList(char const *))  size=6 ==== */
// attributes: thunk
void __thiscall CWinApp::AddToRecentFileList(CWinApp *this, const char *a2)
{
  __imp_?AddToRecentFileList@CWinApp@@UAEXPBD@Z(this, a2);
}


/* ==== 1001ACA0  ?OpenDocumentFile@CWinApp@@UAEPAVCDocument@@PBD@Z  (CWinApp::OpenDocumentFile(char const *))  size=6 ==== */
// attributes: thunk
struct CDocument *__thiscall CWinApp::OpenDocumentFile(CWinApp *this, const char *a2)
{
  return __imp_?OpenDocumentFile@CWinApp@@UAEPAVCDocument@@PBD@Z(this, a2);
}


/* ==== 1001ACA6  ?Delete@CWinThread@@UAEXXZ  (CWinThread::Delete(void))  size=6 ==== */
// attributes: thunk
void __thiscall CWinThread::Delete(CWinThread *this)
{
  __imp_?Delete@CWinThread@@UAEXXZ(this);
}


/* ==== 1001ACAC  ?GetMainWnd@CWinThread@@UAEPAVCWnd@@XZ  (CWinThread::GetMainWnd(void))  size=6 ==== */
// attributes: thunk
struct CWnd *__thiscall CWinThread::GetMainWnd(CWinThread *this)
{
  return __imp_?GetMainWnd@CWinThread@@UAEPAVCWnd@@XZ(this);
}


/* ==== 1001ACB2  ?ProcessMessageFilter@CWinThread@@UAEHHPAUtagMSG@@@Z  (CWinThread::ProcessMessageFilter(int,tagMSG *))  size=6 ==== */
// attributes: thunk
int __thiscall CWinThread::ProcessMessageFilter(CWinThread *this, int a2, struct tagMSG *a3)
{
  return __imp_?ProcessMessageFilter@CWinThread@@UAEHHPAUtagMSG@@@Z(this, a2, a3);
}


/* ==== 1001ACB8  ?ProcessWndProcException@CWinApp@@UAEJPAVCException@@PBUtagMSG@@@Z  (CWinApp::ProcessWndProcException(CException *,tagMSG const *))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::ProcessWndProcException(CWinApp *this, struct CException *a2, const struct tagMSG *a3)
{
  return __imp_?ProcessWndProcException@CWinApp@@UAEJPAVCException@@PBUtagMSG@@@Z(this, a2, a3);
}


/* ==== 1001ACBE  ?ExitInstance@CWinApp@@UAEHXZ  (CWinApp::ExitInstance(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::ExitInstance(CWinApp *this)
{
  return __imp_?ExitInstance@CWinApp@@UAEHXZ(this);
}


/* ==== 1001ACC4  ?IsIdleMessage@CWinThread@@UAEHPAUtagMSG@@@Z  (CWinThread::IsIdleMessage(tagMSG *))  size=6 ==== */
// attributes: thunk
int __thiscall CWinThread::IsIdleMessage(CWinThread *this, struct tagMSG *a2)
{
  return __imp_?IsIdleMessage@CWinThread@@UAEHPAUtagMSG@@@Z(this, a2);
}


/* ==== 1001ACCA  ?OnIdle@CWinApp@@UAEHJ@Z  (CWinApp::OnIdle(long))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::OnIdle(CWinApp *this, int a2)
{
  return __imp_?OnIdle@CWinApp@@UAEHJ@Z(this, a2);
}


/* ==== 1001ACD0  ?PumpMessage@CWinThread@@UAEHXZ  (CWinThread::PumpMessage(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinThread::PumpMessage(CWinThread *this)
{
  return __imp_?PumpMessage@CWinThread@@UAEHXZ(this);
}


/* ==== 1001ACD6  ?PreTranslateMessage@CWinThread@@UAEHPAUtagMSG@@@Z  (CWinThread::PreTranslateMessage(tagMSG *))  size=6 ==== */
// attributes: thunk
int __thiscall CWinThread::PreTranslateMessage(CWinThread *this, struct tagMSG *a2)
{
  return __imp_?PreTranslateMessage@CWinThread@@UAEHPAUtagMSG@@@Z(this, a2);
}


/* ==== 1001ACDC  ?Run@CWinApp@@UAEHXZ  (CWinApp::Run(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::Run(CWinApp *this)
{
  return __imp_?Run@CWinApp@@UAEHXZ(this);
}


/* ==== 1001ACE2  ?OnFinalRelease@CCmdTarget@@UAEXXZ  (CCmdTarget::OnFinalRelease(void))  size=6 ==== */
// attributes: thunk
void __thiscall CCmdTarget::OnFinalRelease(CCmdTarget *this)
{
  __imp_?OnFinalRelease@CCmdTarget@@UAEXXZ(this);
}


/* ==== 1001ACE8  ?GetRuntimeClass@CWinApp@@UBEPAUCRuntimeClass@@XZ  (CWinApp::GetRuntimeClass(void))  size=6 ==== */
// attributes: thunk
struct CRuntimeClass *__thiscall CWinApp::GetRuntimeClass(CWinApp *this)
{
  return __imp_?GetRuntimeClass@CWinApp@@UBEPAUCRuntimeClass@@XZ(this);
}


/* ==== 1001ACEE  ??1CWinApp@@UAE@XZ  (CWinApp::~CWinApp(void))  size=6 ==== */
// attributes: thunk
void __thiscall CWinApp::~CWinApp(CWinApp *this)
{
  __imp_??1CWinApp@@UAE@XZ(this);
}


/* ==== 1001ACF4  ??0CWinApp@@QAE@PBD@Z  (CWinApp::CWinApp(char const *))  size=6 ==== */
// attributes: thunk
CWinApp *__thiscall CWinApp::CWinApp(CWinApp *this, const char *a2)
{
  return __imp_??0CWinApp@@QAE@PBD@Z(this, a2);
}


/* ==== 1001ACFA  ?InitInstance@CWinApp@@UAEHXZ  (CWinApp::InitInstance(void))  size=6 ==== */
// attributes: thunk
int __thiscall CWinApp::InitInstance(CWinApp *this)
{
  return __imp_?InitInstance@CWinApp@@UAEHXZ(this);
}


/* ==== 1001AD00  ?ReadCount@CArchive@@QAEKXZ  (CArchive::ReadCount(void))  size=6 ==== */
// attributes: thunk
unsigned int __thiscall CArchive::ReadCount(CArchive *this)
{
  return __imp_?ReadCount@CArchive@@QAEKXZ(this);
}


/* ==== 1001AD06  ?WriteCount@CArchive@@QAEXK@Z  (CArchive::WriteCount(ulong))  size=6 ==== */
// attributes: thunk
void __thiscall CArchive::WriteCount(CArchive *this, unsigned int a2)
{
  __imp_?WriteCount@CArchive@@QAEXK@Z(this, a2);
}


/* ==== 1001AD0C  ?Read@CArchive@@QAEIPAXI@Z  (CArchive::Read(void *,uint))  size=6 ==== */
// attributes: thunk
unsigned int __thiscall CArchive::Read(CArchive *this, void *a2, unsigned int a3)
{
  return __imp_?Read@CArchive@@QAEIPAXI@Z(this, a2, a3);
}


/* ==== 1001AD12  ?Write@CArchive@@QAEXPBXI@Z  (CArchive::Write(void const *,uint))  size=6 ==== */
// attributes: thunk
void __thiscall CArchive::Write(CArchive *this, const void *a2, unsigned int a3)
{
  __imp_?Write@CArchive@@QAEXPBXI@Z(this, a2, a3);
}


/* ==== 1001AD18  ?FreeDataChain@CPlex@@QAEXXZ  (CPlex::FreeDataChain(void))  size=6 ==== */
// attributes: thunk
void __thiscall CPlex::FreeDataChain(CPlex *this)
{
  __imp_?FreeDataChain@CPlex@@QAEXXZ(this);
}


/* ==== 1001AD1E  ?Create@CPlex@@SGPAU1@AAPAU1@II@Z  (CPlex::Create(CPlex * &,uint,uint))  size=6 ==== */
// attributes: thunk
struct CPlex *__stdcall CPlex::Create(struct CPlex **a1, unsigned int a2, unsigned int a3)
{
  return __imp_?Create@CPlex@@SGPAU1@AAPAU1@II@Z(a1, a2, a3);
}


/* ==== 1001AD24  ?AddTail@CStringList@@QAEXPAV1@@Z  (CStringList::AddTail(CStringList *))  size=6 ==== */
// attributes: thunk
void __thiscall CStringList::AddTail(CStringList *this, struct CStringList *a2)
{
  __imp_?AddTail@CStringList@@QAEXPAV1@@Z(this, a2);
}


/* ==== 1001AD2A  ??0CDialog@@QAE@IPAVCWnd@@@Z  (CDialog::CDialog(uint,CWnd *))  size=6 ==== */
// attributes: thunk
CDialog *__thiscall CDialog::CDialog(CDialog *this, unsigned int a2, struct CWnd *a3)
{
  return __imp_??0CDialog@@QAE@IPAVCWnd@@@Z(this, a2, a3);
}


/* ==== 1001AD30  sub_1001AD30  ()  size=10 ==== */
int sub_1001AD30()
{
  sub_1001AD3A();
  return atexit(sub_1001AD8E);
}


/* ==== 1001AD3A  sub_1001AD3A  ()  size=40 ==== */
_DWORD *sub_1001AD3A()
{
  AFX_MODULE_STATE::AFX_MODULE_STATE((AFX_MODULE_STATE *)dword_10024750, 1, AfxWndProcDllStatic, 0x600u);
  dword_10024750[0] = &_AFX_DLL_MODULE_STATE::`vftable';
  return dword_10024750;
}


/* ==== 1001AD62  sub_1001AD62  ()  size=27 ==== */
AFX_MODULE_STATE *__thiscall sub_1001AD62(AFX_MODULE_STATE *this, char a2)
{
  AFX_MODULE_STATE::~AFX_MODULE_STATE(this);
  if ( (a2 & 1) != 0 )
    CNoTrackObject::operator delete(this);
  return this;
}


/* ==== 1001AD7D  j_??1AFX_MODULE_STATE@@UAE@XZ  (AFX_MODULE_STATE::~AFX_MODULE_STATE(void))  size=5 ==== */
// attributes: thunk
void __thiscall AFX_MODULE_STATE::~AFX_MODULE_STATE(AFX_MODULE_STATE *this)
{
  ??1AFX_MODULE_STATE@@UAE@XZ(this);
}


/* ==== 1001AD8E  sub_1001AD8E  ()  size=10 ==== */
void __cdecl sub_1001AD8E()
{
  AFX_MODULE_STATE::~AFX_MODULE_STATE((AFX_MODULE_STATE *)dword_10024750);
}


/* ==== 1001AD98  ?AfxWndProcDllStatic@@YGJPAUHWND__@@IIJ@Z  (AfxWndProcDllStatic(HWND__ *,uint,uint,long))  size=69 ==== */
int __stdcall AfxWndProcDllStatic(HWND a1, unsigned int a2, unsigned int a3, int a4)
{
  int result; // eax
  _DWORD v5[5]; // [esp+0h] [ebp-14h] BYREF

  AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)v5, (struct AFX_MODULE_STATE *)dword_10024750);
  v5[4] = 0;
  result = AfxWndProc(a1, a2, a3, a4);
  *(_DWORD *)(v5[1] + 4) = v5[0];
  return result;
}


/* ==== 1001ADDD  sub_1001ADDD  ()  size=6 ==== */
_DWORD *sub_1001ADDD()
{
  return dword_10024750;
}


/* ==== 1001ADE3  _DllMain@12  (DllMain(x,x,x))  size=295 ==== */
BOOL __stdcall DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  struct _AFX_THREAD_STATE *ThreadState; // esi
  int v4; // ebx
  int v5; // edi
  CDynLinkLibrary *v6; // eax
  struct _AFX_THREAD_STATE *v7; // eax
  struct AFX_MODULE_STATE *v9; // esi
  int v10; // eax
  _DWORD v11[2]; // [esp+4h] [ebp-8h] BYREF
  DWORD fdwReasona; // [esp+18h] [ebp+Ch]

  if ( fdwReason == 1 )
  {
    fdwReasona = 0;
    AfxCoreInitModule();
    ThreadState = AfxGetThreadState();
    v4 = *((_DWORD *)ThreadState + 2);
    if ( AfxWinInit(hinstDLL, 0, byte_10023388, 0) )
    {
      v5 = *((_DWORD *)AfxGetModuleState() + 1);
      if ( !v5 || (*(int (__thiscall **)(int))(*(_DWORD *)v5 + 88))(v5) )
      {
        *((_DWORD *)ThreadState + 2) = v4;
        AfxInitExtensionModule((struct AFX_EXTENSION_MODULE *)&unk_100257E0, hinstDLL);
        v6 = (CDynLinkLibrary *)operator new(0x40u);
        if ( v6 )
          CDynLinkLibrary::CDynLinkLibrary(v6, (struct AFX_EXTENSION_MODULE *)&unk_100257E0, 0);
        fdwReasona = 1;
        goto LABEL_10;
      }
      (*(void (__thiscall **)(int))(*(_DWORD *)v5 + 112))(v5);
    }
    AfxWinTerm();
LABEL_10:
    *((_DWORD *)ThreadState + 2) = v4;
    v7 = AfxGetThreadState();
    AfxSetModuleState(*((struct AFX_MODULE_STATE **)v7 + 2));
    return fdwReasona;
  }
  if ( fdwReason )
  {
    if ( fdwReason == 3 )
    {
      AFX_MAINTAIN_STATE2::AFX_MAINTAIN_STATE2((AFX_MAINTAIN_STATE2 *)v11, (struct AFX_MODULE_STATE *)dword_10024750);
      AfxLockTempMaps();
      AfxUnlockTempMaps(-1);
      AfxTermThread(hinstDLL);
      *(_DWORD *)(v11[1] + 4) = v11[0];
    }
  }
  else
  {
    v9 = AfxSetModuleState((struct AFX_MODULE_STATE *)dword_10024750);
    *((_DWORD *)AfxGetThreadState() + 2) = v9;
    v10 = *((_DWORD *)AfxGetModuleState() + 1);
    if ( v10 )
      (*(void (__thiscall **)(int))(*(_DWORD *)v10 + 112))(v10);
    AfxLockTempMaps();
    AfxUnlockTempMaps(-1);
    AfxWinTerm();
    AfxTermExtensionModule((struct AFX_EXTENSION_MODULE *)&unk_100257E0, 1);
  }
  return 1;
}


/* ==== 1001AF0A  _RawDllMain@12  (RawDllMain(x,x,x))  size=81 ==== */
int __stdcall RawDllMain(int a1, int a2, int a3)
{
  int result; // eax
  struct _AFX_THREAD_STATE *ThreadState; // esi
  struct _AFX_THREAD_STATE *v5; // eax

  if ( a2 == 1 )
  {
    result = (int)LocalAlloc(0, 0x2000u);
    if ( !result )
      return result;
    LocalFree((HLOCAL)result);
    ThreadState = AfxGetThreadState();
    *((_DWORD *)ThreadState + 2) = AfxSetModuleState((struct AFX_MODULE_STATE *)dword_10024750);
  }
  else if ( !a2 )
  {
    v5 = AfxGetThreadState();
    AfxSetModuleState(*((struct AFX_MODULE_STATE **)v5 + 2));
  }
  return 1;
}


/* ==== 1001AF60  __alloca_probe  ()  size=47 ==== */
void __usercall _alloca_probe(unsigned int a1@<eax>, char a2)
{
  char *i; // ecx

  for ( i = &a2; a1 >= 0x1000; a1 -= 4096 )
    i -= 4096;
  __asm { retn }
}


/* ==== 1001AF8F  ??_M@YGXPAXIHP6EX0@Z@Z  (`eh vector destructor iterator'(void *,uint,int,void (*)(void *)))  size=128 ==== */
void __stdcall `eh vector destructor iterator'(char *a1, unsigned int a2, int a3, void (__thiscall *a4)(void *))
{
  char *i; // [esp+30h] [ebp+8h]

  for ( i = &a1[a3 * a2]; --a3 >= 0; a4(i) )
    i -= a2;
}


/* ==== 1001B00F  ?__ArrayUnwind@@YGXPAXIHP6EX0@Z@Z  (__ArrayUnwind(void *,uint,int,void (*)(void *)))  size=94 ==== */
void __stdcall __ArrayUnwind(char *a1, unsigned int a2, int a3, void (*a4)(void))
{
  while ( --a3 >= 0 )
  {
    a1 -= a2;
    a4();
  }
}


/* ==== 1001B06D  unknown_libname_6  ()  size=22 ==== */
// Microsoft VisualC 2-14/net runtime
int __cdecl unknown_libname_6(_DWORD **a1)
{
  if ( **a1 == -529697949 )
    terminate();
  return 0;
}


/* ==== 1001B083  ??_L@YGXPAXIHP6EX0@Z1@Z  (`eh vector constructor iterator'(void *,uint,int,void (*)(void *),void (*)(void *)))  size=130 ==== */
void __stdcall `eh vector constructor iterator'(
        char *a1,
        unsigned int a2,
        int a3,
        void (__thiscall *a4)(void *),
        void (__thiscall *a5)(void *))
{
  int i; // [esp+10h] [ebp-1Ch]

  for ( i = 0; i < a3; ++i )
  {
    a4(a1);
    a1 += a2;
  }
}


/* ==== 1001B106  __CxxFrameHandler  ()  size=6 ==== */
// attributes: thunk
int _CxxFrameHandler()
{
  return __CxxFrameHandler();
}


/* ==== 1001B110  _ftol  ()  size=6 ==== */
// attributes: thunk
signed __int64 __usercall ftol@<edx:eax>(double a1@<st0>)
{
  return _ftol(a1);
}


/* ==== 1001B116  _purecall  ()  size=6 ==== */
// attributes: thunk
int purecall()
{
  return _purecall();
}


/* ==== 1001B11C  __onexit  ()  size=44 ==== */
_onexit_t __cdecl _onexit(_onexit_t Func)
{
  if ( Block == (void *)-1 )
    return onexit(Func);
  else
    return (_onexit_t)_dllonexit(Func, &Block, &dword_10025804);
}


/* ==== 1001B148  _atexit  ()  size=18 ==== */
int __cdecl atexit(void (__cdecl *Func)())
{
  return (_onexit((_onexit_t)Func) != 0) - 1;
}


/* ==== 1001B15A  __CRT_INIT@12  (_CRT_INIT(x,x,x))  size=171 ==== */
int __stdcall _CRT_INIT(int a1, int a2, int a3)
{
  _DWORD *v3; // eax
  void (**v5)(void); // eax
  void (**i)(void); // esi

  if ( !a2 )
  {
    if ( dword_100257FC <= 0 )
      return 0;
    --dword_100257FC;
  }
  dword_10025800 = adjust_fdiv;
  if ( a2 == 1 )
  {
    v3 = malloc(0x80u);
    Block = v3;
    if ( !v3 )
      return 0;
    *v3 = 0;
    dword_10025804 = (int)Block;
    initterm(&First, &Last);
    ++dword_100257FC;
  }
  else if ( !a2 )
  {
    v5 = (void (**)(void))Block;
    if ( Block )
    {
      for ( i = (void (**)(void))(dword_10025804 - 4); i >= v5; --i )
      {
        if ( *i )
        {
          (*i)();
          v5 = (void (**)(void))Block;
        }
      }
      free(v5);
      Block = 0;
    }
  }
  return 1;
}


/* ==== 1001B205  DllEntryPoint  ()  size=157 ==== */
BOOL __stdcall DllEntryPoint(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved)
{
  bool v4; // zf
  BOOL v6; // eax
  DWORD fdwReasona; // [esp+18h] [ebp+Ch]

  if ( fdwReason )
  {
    if ( fdwReason != 1 && fdwReason != 2 )
      goto LABEL_10;
    if ( off_100232FC && !off_100232FC((int)hinstDLL, fdwReason, (int)lpReserved) )
      return 0;
    v4 = _CRT_INIT((int)hinstDLL, fdwReason, (int)lpReserved) == 0;
  }
  else
  {
    v4 = dword_100257FC == 0;
  }
  if ( v4 )
    return 0;
LABEL_10:
  v6 = DllMain(hinstDLL, fdwReason, lpReserved);
  fdwReasona = v6;
  if ( fdwReason != 1 )
  {
LABEL_13:
    if ( !fdwReason || fdwReason == 3 )
    {
      if ( !_CRT_INIT((int)hinstDLL, fdwReason, (int)lpReserved) )
        fdwReasona = 0;
      if ( fdwReasona )
      {
        if ( off_100232FC )
          return off_100232FC((int)hinstDLL, fdwReason, (int)lpReserved);
      }
    }
    return fdwReasona;
  }
  if ( !v6 )
  {
    _CRT_INIT((int)hinstDLL, 0, (int)lpReserved);
    goto LABEL_13;
  }
  return fdwReasona;
}


/* ==== 1001B2A2  ??_Gtype_info@@UAEPAXI@Z  (type_info::`scalar deleting destructor'(uint))  size=28 ==== */
type_info *__thiscall type_info::`scalar deleting destructor'(type_info *this, char a2)
{
  type_info::~type_info(this);
  if ( (a2 & 1) != 0 )
    operator delete(this);
  return this;
}


/* ==== 1001B2BE  memset  ()  size=6 ==== */
// attributes: thunk
void *__cdecl memset(void *a1, int Val, size_t Size)
{
  return __imp_memset(a1, Val, Size);
}


/* ==== 1001B2C4  __EH_prolog  ()  size=31 ==== */
void _EH_prolog()
{
  __asm { retn }
}


/* ==== 1001B2E4  _except_handler3  ()  size=6 ==== */
// attributes: thunk
int except_handler3()
{
  return _except_handler3();
}


/* ==== 1001B2EA  ?terminate@@YAXXZ  (terminate(void))  size=6 ==== */
// attributes: thunk
void __cdecl __noreturn terminate()
{
  __imp_?terminate@@YAXXZ();
}


/* ==== 1001B2F0  __dllonexit  ()  size=6 ==== */
// attributes: thunk
int __cdecl _dllonexit(int a1, int a2, int a3)
{
  return __dllonexit(a1, a2, a3);
}


/* ==== 1001B2F6  _initterm  ()  size=6 ==== */
// attributes: thunk
void __cdecl initterm(_PVFV *First, _PVFV *Last)
{
  _initterm(First, Last);
}


/* ==== 1001B2FC  ??1type_info@@UAE@XZ  (type_info::~type_info(void))  size=6 ==== */
// attributes: thunk
void __thiscall type_info::~type_info(type_info *this)
{
  __imp_??1type_info@@UAE@XZ(this);
}


/* ==== 1001B302  ??0AFX_MODULE_STATE@@QAE@HP6GJPAUHWND__@@IIJ@ZK@Z  (AFX_MODULE_STATE::AFX_MODULE_STATE(int,long (*)(HWND__ *,uint,uint,long),ulong))  size=6 ==== */
// attributes: thunk
AFX_MODULE_STATE *__thiscall AFX_MODULE_STATE::AFX_MODULE_STATE(
        AFX_MODULE_STATE *this,
        int a2,
        int (__stdcall *a3)(HWND, unsigned int, unsigned int, int),
        unsigned int a4)
{
  return __imp_??0AFX_MODULE_STATE@@QAE@HP6GJPAUHWND__@@IIJ@ZK@Z(this, a2, a3, a4);
}


/* ==== 1001B308  ??3CNoTrackObject@@SGXPAX@Z  (CNoTrackObject::operator delete(void *))  size=6 ==== */
// attributes: thunk
void __stdcall CNoTrackObject::operator delete(void *a1)
{
  __imp_??3CNoTrackObject@@SGXPAX@Z(a1);
}


/* ==== 1001B30E  ??1AFX_MODULE_STATE@@UAE@XZ  (AFX_MODULE_STATE::~AFX_MODULE_STATE(void))  size=6 ==== */
// attributes: thunk
void __thiscall AFX_MODULE_STATE::~AFX_MODULE_STATE(AFX_MODULE_STATE *this)
{
  __imp_??1AFX_MODULE_STATE@@UAE@XZ(this);
}


/* ==== 1001B314  ?AfxWndProc@@YGJPAUHWND__@@IIJ@Z  (AfxWndProc(HWND__ *,uint,uint,long))  size=6 ==== */
// attributes: thunk
int __stdcall AfxWndProc(HWND a1, unsigned int a2, unsigned int a3, int a4)
{
  return __imp_?AfxWndProc@@YGJPAUHWND__@@IIJ@Z(a1, a2, a3, a4);
}


/* ==== 1001B31A  ?AfxTermThread@@YGXPAUHINSTANCE__@@@Z  (AfxTermThread(HINSTANCE__ *))  size=6 ==== */
// attributes: thunk
void __stdcall AfxTermThread(HINSTANCE a1)
{
  __imp_?AfxTermThread@@YGXPAUHINSTANCE__@@@Z(a1);
}


/* ==== 1001B320  ?AfxTermExtensionModule@@YGXAAUAFX_EXTENSION_MODULE@@H@Z  (AfxTermExtensionModule(AFX_EXTENSION_MODULE &,int))  size=6 ==== */
// attributes: thunk
void __stdcall AfxTermExtensionModule(struct AFX_EXTENSION_MODULE *a1, int a2)
{
  __imp_?AfxTermExtensionModule@@YGXAAUAFX_EXTENSION_MODULE@@H@Z(a1, a2);
}


/* ==== 1001B326  ?AfxUnlockTempMaps@@YGHH@Z  (AfxUnlockTempMaps(int))  size=6 ==== */
// attributes: thunk
int __stdcall AfxUnlockTempMaps(int a1)
{
  return __imp_?AfxUnlockTempMaps@@YGHH@Z(a1);
}


/* ==== 1001B32C  ?AfxLockTempMaps@@YGXXZ  (AfxLockTempMaps(void))  size=6 ==== */
// attributes: thunk
void __stdcall AfxLockTempMaps()
{
  __imp_?AfxLockTempMaps@@YGXXZ();
}


/* ==== 1001B332  ?AfxSetModuleState@@YGPAVAFX_MODULE_STATE@@PAV1@@Z  (AfxSetModuleState(AFX_MODULE_STATE *))  size=6 ==== */
// attributes: thunk
struct AFX_MODULE_STATE *__stdcall AfxSetModuleState(struct AFX_MODULE_STATE *a1)
{
  return __imp_?AfxSetModuleState@@YGPAVAFX_MODULE_STATE@@PAV1@@Z(a1);
}


/* ==== 1001B338  ??0CDynLinkLibrary@@QAE@AAUAFX_EXTENSION_MODULE@@H@Z  (CDynLinkLibrary::CDynLinkLibrary(AFX_EXTENSION_MODULE &,int))  size=6 ==== */
// attributes: thunk
CDynLinkLibrary *__thiscall CDynLinkLibrary::CDynLinkLibrary(
        CDynLinkLibrary *this,
        struct AFX_EXTENSION_MODULE *a2,
        int a3)
{
  return __imp_??0CDynLinkLibrary@@QAE@AAUAFX_EXTENSION_MODULE@@H@Z(this, a2, a3);
}


/* ==== 1001B33E  ?AfxInitExtensionModule@@YGHAAUAFX_EXTENSION_MODULE@@PAUHINSTANCE__@@@Z  (AfxInitExtensionModule(AFX_EXTENSION_MODULE &,HINSTANCE__ *))  size=6 ==== */
// attributes: thunk
int __stdcall AfxInitExtensionModule(struct AFX_EXTENSION_MODULE *a1, HINSTANCE a2)
{
  return __imp_?AfxInitExtensionModule@@YGHAAUAFX_EXTENSION_MODULE@@PAUHINSTANCE__@@@Z(a1, a2);
}


/* ==== 1001B344  ?AfxWinTerm@@YGXXZ  (AfxWinTerm(void))  size=6 ==== */
// attributes: thunk
void __stdcall AfxWinTerm()
{
  __imp_?AfxWinTerm@@YGXXZ();
}


/* ==== 1001B34A  ?AfxGetModuleState@@YGPAVAFX_MODULE_STATE@@XZ  (AfxGetModuleState(void))  size=6 ==== */
// attributes: thunk
struct AFX_MODULE_STATE *__stdcall AfxGetModuleState()
{
  return __imp_?AfxGetModuleState@@YGPAVAFX_MODULE_STATE@@XZ();
}


/* ==== 1001B350  ?AfxWinInit@@YGHPAUHINSTANCE__@@0PADH@Z  (AfxWinInit(HINSTANCE__ *,HINSTANCE__ *,char *,int))  size=6 ==== */
// attributes: thunk
int __stdcall AfxWinInit(HINSTANCE a1, HINSTANCE a2, char *a3, int a4)
{
  return __imp_?AfxWinInit@@YGHPAUHINSTANCE__@@0PADH@Z(a1, a2, a3, a4);
}


/* ==== 1001B356  ?AfxGetThreadState@@YGPAV_AFX_THREAD_STATE@@XZ  (AfxGetThreadState(void))  size=6 ==== */
// attributes: thunk
struct _AFX_THREAD_STATE *__stdcall AfxGetThreadState()
{
  return __imp_?AfxGetThreadState@@YGPAV_AFX_THREAD_STATE@@XZ();
}


/* ==== 1001B35C  ?AfxCoreInitModule@@YGXXZ  (AfxCoreInitModule(void))  size=6 ==== */
// attributes: thunk
void __stdcall AfxCoreInitModule()
{
  __imp_?AfxCoreInitModule@@YGXXZ();
}


/* ==== 1001B370  unknown_libname_17  ()  size=17 ==== */
// Microsoft VisualC 2-14/net runtime
// MFC 3.1-14.0 32bit
char *__thiscall unknown_libname_17(char *this)
{
  return this + 4;
}

