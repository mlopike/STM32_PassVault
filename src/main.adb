-- pass_vault2 v2.0 (Functional Release)
-- Полноценный интерфейс: Меню, ввод, Backspace, отмена 'c'.
-- Использует проверенные библиотеки STM32_SVD из lab5.

with HAL;
with STM32_SVD.RCC;   use STM32_SVD.RCC;
with STM32_SVD.GPIO;  use STM32_SVD.GPIO;
with STM32_SVD.USART; use STM32_SVD.USART;

procedure Main is

   MAX_ITEMS : constant := 10;
   MAX_LEN   : constant := 32;

   type Item is record
      Key : String (1 .. MAX_LEN) := (others => Character'Val (0));
      Val : String (1 .. MAX_LEN) := (others => Character'Val (0));
      K_Len : Natural := 0;
      V_Len : Natural := 0;
      Used  : Boolean := False;
   end record;

   Count : Natural := 0;
   DB    : array (1 .. MAX_ITEMS) of Item;

   -- Robust Delay
   procedure Wait (C : Natural := 300_000) is
      X : Natural := C;
   begin
      while X > 0 loop X := X - 1; end loop;
   end Wait;

   procedure TX (C : Character) is
   begin
      loop exit when USART1_Periph.SR.TXE; end loop;
      USART1_Periph.DR.DR := HAL.UInt9 (Character'Pos (C));
   end TX;

   procedure TX_S (S : String) is
   begin for I in S'Range loop TX (S (I)); end loop; end TX_S;

   function RX return Character is
   begin
      loop exit when USART1_Periph.SR.RXNE; end loop;
      return Character'Val (HAL.UInt8 (USART1_Periph.DR.DR));
   end RX;

   -- Ввод строки с Backspace и эхом
   procedure Read (Buf : out String; Len : out Natural) is
      C : Character;
   begin
      Len := 0;
      loop
         C := RX;
         
         -- Backspace (ASCII 8)
         if C = Character'Val (8) then
            if Len > 0 then
               Len := Len - 1;
               TX (Character'Val (8)); -- Курсор назад
               TX (' ');               -- Пробел (стирание)
               TX (Character'Val (8)); -- Курсор назад
            end if;
            
         -- Enter
         elsif C = Character'Val (13) or C = Character'Val (10) then 
            TX_S (Character'Val (13) & Character'Val (10)); -- NewLine
            exit;
            
         -- Символы
         elsif C >= ' ' and C <= '~' then
            if Len < Buf'Length then 
               Len := Len + 1; 
               Buf (Len) := C; 
               TX (C); -- Эхо
            end if;
         end if;
      end loop;
   end Read;

   procedure LED (N : Natural) is
   begin
      for I in 1 .. N loop
         GPIOC_Periph.ODR.ODR.Arr(13) := False; 
         Wait (200_000);
         GPIOC_Periph.ODR.ODR.Arr(13) := True;  
         Wait (200_000);
      end loop;
   end LED;

   procedure Menu is
   begin
      TX_S ("" & Character'Val (13) & Character'Val (10));
      TX_S ("=== Pass Vault v2 ===" & Character'Val (13) & Character'Val (10));
      TX_S ("1. List entries" & Character'Val (13) & Character'Val (10));
      TX_S ("2. Add entry" & Character'Val (13) & Character'Val (10));
      TX_S ("3. Delete entry" & Character'Val (13) & Character'Val (10));
      TX_S ("4. Clear all" & Character'Val (13) & Character'Val (10));
      TX_S ("> ");
   end Menu;

   Buf  : String (1 .. 32);
   L    : Natural;

begin
   -- 1. Clock Init
   RCC_Periph.CR.HSION := True;
   loop exit when RCC_Periph.CR.HSIRDY; end loop;

   -- 2. GPIO Init (PA9 TX, PA10 RX)
   RCC_Periph.AHB1ENR.GPIOAEN  := True;
   RCC_Periph.APB2ENR.USART1EN := True;
   GPIOA_Periph.MODER.Arr(9)  := 0;
   GPIOA_Periph.MODER.Arr(10) := 0;
   GPIOA_Periph.MODER.Arr(9)  := 2#10#;
   GPIOA_Periph.MODER.Arr(10) := 2#10#;
   GPIOA_Periph.OSPEEDR.Arr(9)  := 2#10#;
   GPIOA_Periph.OSPEEDR.Arr(10) := 2#10#;
   GPIOA_Periph.AFRH.Arr(9)  := 0;
   GPIOA_Periph.AFRH.Arr(10) := 0;
   GPIOA_Periph.AFRH.Arr(9)  := 7;
   GPIOA_Periph.AFRH.Arr(10) := 7;

   -- 3. USART Init
   USART1_Periph.CR1.RE := True;
   USART1_Periph.CR1.TE := True;
   USART1_Periph.CR1.OVER8 := True;
   USART1_Periph.BRR.DIV_Mantissa := 0;
   USART1_Periph.BRR.DIV_Mantissa := 17;
   USART1_Periph.BRR.DIV_Fraction := 3;
   USART1_Periph.CR1.UE := True;

   -- 4. LED Init
   RCC_Periph.AHB1ENR.GPIOCEN := True;
   GPIOC_Periph.MODER.Arr(13) := 2#01#;
   GPIOC_Periph.ODR.ODR.Arr(13) := True;

   -- 5. Boot
   Wait (500_000); -- Stabilization
   LED (2);
   Menu;

   -- 6. Main Loop
   loop
      Read (Buf, L);
      if L = 0 then goto Next; end if;

      case Buf (1) is
         when '1' =>
            TX_S ("" & Character'Val (13) & Character'Val (10));
            TX_S ("--- Database ---" & Character'Val (13) & Character'Val (10));
            if Count = 0 then TX_S ("Empty" & Character'Val (13) & Character'Val (10));
            else
               for I in 1 .. Count loop
                  TX (Character'Val (Character'Pos ('0') + I)); TX_S (". ");
                  TX_S (DB (I).Key (1 .. DB (I).K_Len));
                  TX_S (" | ");
                  TX_S (DB (I).Val (1 .. DB (I).V_Len));
                  TX_S ("" & Character'Val (13) & Character'Val (10));
               end loop;
            end if;

         when '2' =>
            if Count >= MAX_ITEMS then TX_S ("Full!" & Character'Val (13) & Character'Val (10));
            else
               TX_S ("Key: "); Read (Buf, L);
               if L = 0 or (L = 1 and Buf (1) = 'c') then 
                  TX_S (" [Cancelled]" & Character'Val (13) & Character'Val (10));
               else
                  declare K : String := Buf; KL : Natural := L; V : String (1 .. MAX_LEN); VL : Natural; begin
                     TX_S ("Val: "); Read (V, VL);
                     if VL = 0 or (VL = 1 and V (1) = 'c') then 
                        TX_S (" [Cancelled]" & Character'Val (13) & Character'Val (10));
                     else
                        Count := Count + 1;
                        DB (Count).K_Len := KL; DB (Count).V_Len := VL;
                        for I in 1 .. KL loop DB (Count).Key (I) := K (I); end loop;
                        for I in 1 .. VL loop DB (Count).Val (I) := V (I); end loop;
                        TX_S (" [OK]" & Character'Val (13) & Character'Val (10)); 
                        LED (2);
                     end if;
                  end;
               end if;
            end if;

         when '3' =>
            TX_S ("Num to delete: "); Read (Buf, L);
            if L > 0 and then Buf (1) in '1' .. '9' then
               declare N : Natural := Character'Pos (Buf (1)) - Character'Pos ('0'); begin
                  if N > 0 and N <= Count then
                     Count := Count - 1;
                     if N <= Count then
                        for I in N .. Count loop DB (I) := DB (I + 1); end loop;
                     end if;
                     TX_S (" [Deleted]" & Character'Val (13) & Character'Val (10)); LED (2);
                  else TX_S (" [Invalid]" & Character'Val (13) & Character'Val (10));
                  end if;
               end;
            end if;

         when '4' =>
            TX_S ("Confirm (YES): "); Read (Buf, L);
            if L >= 3 and then Buf (1) = 'Y' and then Buf (2) = 'E' and then Buf (3) = 'S' then
               Count := 0; TX_S (" [Cleared]" & Character'Val (13) & Character'Val (10)); LED (3);
            else TX_S (" [Cancelled]" & Character'Val (13) & Character'Val (10));
            end if;

         when others =>
            TX_S (" [?]" & Character'Val (13) & Character'Val (10));
      end case;

      <<Next>>
      Menu;
   end loop;
end Main;
