class zcl_mpc definition public.
  public section.
    class-data:
     screen type ref to zcl_mpc.
    class-methods:
      display_popup importing i_equnr type equnr optional.
    methods:
      constructor.
  private section.
    methods:
      select_data,
      conv_si_value,
      create_popup,
      set_colum_setting,
      show_popup.

    types: begin of ty_column_info,
             column_id   type lvc_fname,
             short_text  type scrtext_s,
             medium_text type scrtext_m,
             long_text   type scrtext_l,
             visible     type abap_bool,
           end of ty_column_info.

    data: go_alv         type ref to cl_salv_table,
          gv_equnr       type equnr,
          gt_column_info type table of ty_column_info,
          gt_empc        type zmes_pointc_tab.

ENDCLASS.



CLASS ZCL_MPC IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MPC->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method constructor.
    me->create_popup( ).
    me->set_colum_setting( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MPC->CONV_SI_VALUE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method conv_si_value.
    " Conversion value SI to measuring unit
    loop at gt_empc assigning field-symbol(<ls_row>).
      zcl_unit=>conversion_si( exporting i_value = <ls_row>-readg i_msehi = <ls_row>-mrngu importing e_menge = <ls_row>-creadg ).
      zcl_unit=>conversion_si( exporting i_value = <ls_row>-mrmin i_msehi = <ls_row>-mrngu importing e_menge = <ls_row>-cmrmin ).
      zcl_unit=>conversion_si( exporting i_value = <ls_row>-mrmax i_msehi = <ls_row>-mrngu importing e_menge = <ls_row>-cmrmax ).
      zcl_unit=>conversion_si( exporting i_value = <ls_row>-desir i_msehi = <ls_row>-mrngu importing e_menge = <ls_row>-cdesir ).
    endloop.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MPC->CREATE_POPUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method create_popup.
    constants: lc_scol  type i value 30,
               lc_ecol  type i value 170,
               lc_sline type i value 3,
               lc_eline type i value 23.

    " Create object instance
    try.
        cl_salv_table=>factory(
         importing
          r_salv_table = go_alv
          changing
            t_table =  gt_empc ).
      catch cx_salv_msg into data(lx_error).
        message lx_error->get_text( ) type 'E'.
    endtry.

    " Display alv as popup
    go_alv->set_screen_popup( start_column = lc_scol end_column = lc_ecol start_line =  lc_sline end_line = lc_eline ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MPC=>DISPLAY_POPUP
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_EQUNR                        TYPE        EQUNR(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method display_popup.
    if screen is initial.
      screen = new #( ).
    endif.

    screen->gv_equnr = i_equnr.
    screen->select_data( ).
    screen->conv_si_value( ).
    screen->show_popup( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MPC->SELECT_DATA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method select_data.
    " Select data from DB
    select * from zmes_pointc_v
      where equnr = @gv_equnr order by point, idate, itime
    into corresponding fields of table @gt_empc.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MPC->SET_COLUM_SETTING
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_colum_setting.
    " Declare ALV column settings
    gt_column_info = value #(
     ( column_id = 'CREADG' short_text = 'Reading' medium_text = 'Reading' long_text = 'Reading' visible = abap_true )
     ( column_id = 'CMRMIN' short_text = 'Min' medium_text = 'Min' long_text = 'Min' visible = abap_true )
     ( column_id = 'CMRMAX' short_text = 'Max' medium_text = 'Max' long_text = 'Max' visible = abap_true )
     ( column_id = 'CDESIR' short_text = 'Target' medium_text = 'Target' long_text = 'Target' visible = abap_true )
     ( column_id = 'READG' visible = abap_false )
     ( column_id = 'MRMIN' visible = abap_false )
     ( column_id = 'MRMAX' visible = abap_false )
     ( column_id = 'DESIR' visible = abap_false ) ).

    " Change column text & hide column
    try.
        loop at gt_column_info into data(ls_column_info).
          data(lo_column) = go_alv->get_columns( )->get_column( ls_column_info-column_id ).
          lo_column->set_short_text( ls_column_info-short_text ).
          lo_column->set_medium_text( ls_column_info-medium_text ).
          lo_column->set_long_text( ls_column_info-long_text ).
          lo_column->set_visible( ls_column_info-visible ).
        endloop.
      catch cx_salv_not_found into data(lx_not_found).
        message lx_not_found->get_text( ) type 'E'.
    endtry.

    " Optimalize column witdh
    go_alv->get_columns( )->set_optimize( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MPC->SHOW_POPUP
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method show_popup.
    go_alv->refresh( ).
    go_alv->display( ).
  endmethod.
ENDCLASS.