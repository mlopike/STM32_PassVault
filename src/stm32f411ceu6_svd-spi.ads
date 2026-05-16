pragma Style_Checks (Off);

--  STM32F411 SPI peripheral registers (minimal, для EEPROM)

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package stm32f411ceu6_SVD.SPI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  control register 1
   type CR1_Register is record
      BIDIMODE       : Boolean := False;
      BIDIOE         : Boolean := False;
      CRCEN          : Boolean := False;
      CRCNEXT        : Boolean := False;
      DFF            : Boolean := False;
      RXONLY         : Boolean := False;
      SSM            : Boolean := False;
      SSI            : Boolean := False;
      LSBFIRST       : Boolean := False;
      SPE            : Boolean := False;
      Reserved_10_10 : HAL.Bit := 16#0#;
      MSTR           : Boolean := False;
      CPOL           : Boolean := False;
      CPHA           : Boolean := False;
      BR             : HAL.UInt3 := 2#000#;
      MCKOE          : Boolean := False;
      Reserved_18_19 : HAL.UInt2 := 16#0#;
      TI             : Boolean := False;
      Reserved_21_31 : HAL.UInt11 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for CR1_Register use record
      BIDIMODE       at 0 range 0 .. 0;
      BIDIOE         at 0 range 1 .. 1;
      CRCEN          at 0 range 2 .. 2;
      CRCNEXT        at 0 range 3 .. 3;
      DFF            at 0 range 4 .. 4;
      RXONLY         at 0 range 5 .. 5;
      SSM            at 0 range 6 .. 6;
      SSI            at 0 range 7 .. 7;
      LSBFIRST       at 0 range 8 .. 8;
      SPE            at 0 range 9 .. 9;
      Reserved_10_10 at 0 range 10 .. 10;
      MSTR           at 0 range 11 .. 11;
      CPOL           at 0 range 12 .. 12;
      CPHA           at 0 range 13 .. 13;
      BR             at 0 range 14 .. 16;
      MCKOE          at 0 range 17 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      TI             at 0 range 20 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   --  status register
   type SR_Register is record
      RXNE           : Boolean := False;
      TXE            : Boolean := True;
      CHSIDE         : Boolean := False;
      UDR            : Boolean := False;
      CRCERR         : Boolean := False;
      MODF           : Boolean := False;
      OVR            : Boolean := False;
      BSY            : Boolean := False;
      FRE            : Boolean := False;
      FRLVL          : HAL.UInt2 := 16#0#;
      FTLVL          : HAL.UInt2 := 16#0#;
      Reserved_14_31 : HAL.UInt18 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for SR_Register use record
      RXNE           at 0 range 0 .. 0;
      TXE            at 0 range 1 .. 1;
      CHSIDE         at 0 range 2 .. 2;
      UDR            at 0 range 3 .. 3;
      CRCERR         at 0 range 4 .. 4;
      MODF           at 0 range 5 .. 5;
      OVR            at 0 range 6 .. 6;
      BSY            at 0 range 7 .. 7;
      FRE            at 0 range 8 .. 8;
      FRLVL          at 0 range 9 .. 10;
      FTLVL          at 0 range 11 .. 12;
      Reserved_14_31 at 0 range 13 .. 31;
   end record;

   --  data register
   type DR_Register is record
      DR : HAL.UInt16 := 16#0#;
   end record
     with Volatile_Full_Access, Object_Size => 32,
          Bit_Order => System.Low_Order_First;

   for DR_Register use record
      DR at 0 range 0 .. 15;
   end record;

   -----------------
   -- Peripherals --
   -----------------

   type SPI_Peripheral is record
      CR1    : aliased CR1_Register;
      CR2    : aliased HAL.UInt32;
      SR     : aliased SR_Register;
      DR     : aliased DR_Register;
      CRCR   : aliased HAL.UInt32;
      RXCRCR : aliased HAL.UInt32;
      TXCRCR : aliased HAL.UInt32;
      I2SCFGR : aliased HAL.UInt32;
      I2SPR  : aliased HAL.UInt32;
   end record
     with Volatile;

   for SPI_Peripheral use record
      CR1      at 16#0# range 0 .. 31;
      CR2      at 16#4# range 0 .. 31;
      SR       at 16#8# range 0 .. 31;
      DR       at 16#C# range 0 .. 31;
      CRCR     at 16#10# range 0 .. 31;
      RXCRCR   at 16#14# range 0 .. 31;
      TXCRCR   at 16#18# range 0 .. 31;
      I2SCFGR  at 16#1C# range 0 .. 31;
      I2SPR    at 16#20# range 0 .. 31;
   end record;

   SPI1_Periph : aliased SPI_Peripheral
     with Import, Address => SPI1_Base;

   SPI2_Periph : aliased SPI_Peripheral
     with Import, Address => SPI2_Base;

   SPI3_Periph : aliased SPI_Peripheral
     with Import, Address => SPI3_Base;

   SPI4_Periph : aliased SPI_Peripheral
     with Import, Address => SPI4_Base;

   SPI5_Periph : aliased SPI_Peripheral
     with Import, Address => SPI5_Base;

end stm32f411ceu6_SVD.SPI;
