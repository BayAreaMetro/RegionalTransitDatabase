--------------------------------------------------------------------------------------------------
Print 'Fix stop_name values that are in UPPER Case format'
--------------------------------------------------------------------------------------------------
--from http://stackoverflow.com/questions/230138/sql-server-make-all-upper-case-to-proper-case-title-case
create function ProperCase(@Text as varchar(8000))
returns varchar(8000)
as
begin
   declare @Reset bit;
   declare @Ret varchar(8000);
   declare @i int;
   declare @c char(1);

   select @Reset = 1, @i=1, @Ret = '';

   while (@i <= len(@Text))
    select @c= substring(@Text,@i,1),
               @Ret = @Ret + case when @Reset=1 then UPPER(@c) else LOWER(@c) end,
               @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
               @i = @i +1
   return @Ret
end;

go

update stops_tpa_staging
set stop_name = dbo.ProperCase(stop_name);
