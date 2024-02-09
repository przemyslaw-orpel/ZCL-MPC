class zcl_mpc definition
  public
  create public .

  public section.

    class-data screen type ref to zcl_mpc .

    class-methods display_popup
      importing
        i_equnr type equnr optional .
    class-methods create_mdoc
      importing
        mpoint         type imrg-point
        read_date      type imrg-idate
        read_time      type imrg-itime
        short_text     type imrg-mdtxt
        recorded_value type rimr0-recdc
        reader         type sy-uname
      exporting
        mdocm          type imrg-mdocm
        error          type sy-subrc.
    methods constructor .
  private section.
    methods:
      select_data,
      conv_si_value,
      create_popup,
      set_colum_setting,
      set_alv_handler,
      show_popup,
      on_link_click for event link_click of cl_salv_events_table importing row column.

    types: begin of ty_column_info,
             column_id   type lvc_fname,
             short_text  type scrtext_s,
             medium_text type scrtext_m,
             long_text   type scrtext_l,
             visible     type abap_bool,
           end of ty_column_info.

    constants: gc_mdoc_col  type lvc_fname value 'MDOCM',
               gc_equnr_col type lvc_fname value 'EQUNR',
               gc_point_col type lvc_fname value 'POINT'.

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
    me->set_alv_handler( ).
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
* | Static Public Method ZCL_MPC=>CREATE_MDOC
* +-------------------------------------------------------------------------------------------------+
* | [--->] MPOINT                         TYPE        IMRG-POINT
* | [--->] READ_DATE                      TYPE        IMRG-IDATE
* | [--->] READ_TIME                      TYPE        IMRG-ITIME
* | [--->] SHORT_TEXT                     TYPE        IMRG-MDTXT
* | [--->] RECORDED_VALUE                 TYPE        RIMR0-RECDC
* | [--->] READER                         TYPE        SY-UNAME
* | [<---] MDOCM                          TYPE        IMRG-MDOCM
* | [<---] ERROR                          TYPE        SY-SUBRC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method create_mdoc.
    call function 'MEASUREM_DOCUM_RFC_SINGLE_001'
      exporting
        measurement_point    = mpoint
        secondary_index      = ' '
        reading_date         = read_date
        reading_time         = read_time
        short_text           = short_text
        reader               = reader
        origin_indicator     = 'A'
        reading_after_action = ' '
        recorded_value       = recorded_value
        difference_reading   = ' '
        code_catalogue       = ' '
        code_group           = ' '
        valuation_code       = ' '
        code_version         = ' '
        user_data            = ' '
        check_custom_duprec  = ' '
        with_dialog_screen   = ' '
        prepare_update       = 'X'
        commit_work          = 'X'
        wait_after_commit    = 'X'
        create_notification  = ' '
        notification_type    = 'M2'
        notification_prio    = ' '
      importing
        measurement_document = mdocm
      exceptions
        no_authority         = 1
        point_not_found      = 2
        index_not_unique     = 3
        type_not_found       = 4
        point_locked         = 5
        point_inactive       = 6
        timestamp_in_future  = 7
        timestamp_duprec     = 8
        unit_unfit           = 9
        value_not_fltp       = 10
        value_overflow       = 11
        value_unfit          = 12
        value_missing        = 13
        code_not_found       = 14
        notif_type_not_found = 15
        notif_prio_not_found = 16
        notif_gener_problem  = 17
        update_failed        = 18
        invalid_time         = 19
        invalid_date         = 20
        others               = 21.
    if sy-subrc <> 0.
      error = sy-subrc.
    endif.

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
* | Instance Private Method ZCL_MPC->ON_LINK_CLICK
* +-------------------------------------------------------------------------------------------------+
* | [--->] ROW                            LIKE
* | [--->] COLUMN                         LIKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method on_link_click.
    " Read row
    read table gt_empc into data(ls_empc) index row.

    case column.
      when gc_mdoc_col.
        "Display measuring document
        set parameter id: 'IMD' field ls_empc-mdocm.
        call transaction 'IK13' and skip first screen.
      when gc_equnr_col.
        "Display equimpent
        set parameter id: 'EQN' field ls_empc-equnr.
        call transaction 'IE03' and skip first screen.
      when gc_point_col.
        "Display measuring point/counter.
        set parameter id: 'IPT' field ls_empc-point.
        call transaction 'IK03' and skip first screen.
    endcase.
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
* | Instance Private Method ZCL_MPC->SET_ALV_HANDLER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_alv_handler.
    " Set column hostspot
    data: lt_hotspot_col type table of lvc_fname,
          lv_col_name    type lvc_fname.
    lt_hotspot_col = value #( ( gc_equnr_col ) ( gc_mdoc_col ) ( gc_point_col ) ).
    try.
        loop at lt_hotspot_col into lv_col_name.
          data(lo_md_col) = cast cl_salv_column_table(
                  go_alv->get_columns( )->get_column( lv_col_name ) ).

          lo_md_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
        endloop.
      catch cx_salv_not_found into data(lx_not_found).
        message lx_not_found->get_text( ) type 'E'.
    endtry.

    " Register handler
    data(lo_event) = go_alv->get_event( ).
    set handler me->on_link_click for lo_event.
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