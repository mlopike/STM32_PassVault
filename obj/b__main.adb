pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is



   procedure adainit is
   begin
      null;

   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\hal.o
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\stm32_svd.o
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\stm32_svd-gpio.o
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\stm32_svd-rcc.o
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\stm32_svd-usart.o
   --   E:\workspaces\microcontrollers_workspace\pass_vault2\obj\main.o
   --   -LE:\workspaces\microcontrollers_workspace\pass_vault2\obj\
   --   -LE:\workspaces\microcontrollers_workspace\pass_vault2\obj\
   --   -LC:\gnat\2021-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m4\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
