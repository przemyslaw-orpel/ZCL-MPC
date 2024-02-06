class zcl_unit definition public.
  public section.
    class-methods conversion_si
      importing i_value type imrc_readg
                i_msehi type msehi
      exporting e_menge type menge_d.

ENDCLASS.



CLASS ZCL_UNIT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_UNIT=>CONVERSION_SI
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VALUE                        TYPE        IMRC_READG
* | [--->] I_MSEHI                        TYPE        MSEHI
* | [<---] E_MENGE                        TYPE        MENGE_D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method conversion_si.
    constants: lc_temp type dimid value 'TEMP'.
    " Select unit structure from DB
    select single *  from t006 into @data(ls_unit)
      where msehi = @i_msehi.

    "Check time unit
    if ls_unit-dimid eq lc_temp.
      e_menge  =  ( i_value -  ls_unit-addko ) * ls_unit-nennr / ls_unit-zaehl.
    else.
      e_menge =  i_value * ls_unit-nennr / ls_unit-zaehl.
    endif.
  endmethod.
ENDCLASS.