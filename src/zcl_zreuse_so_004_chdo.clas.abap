class ZCL_ZREUSE_SO_004_CHDO definition
  public
  create public .

public section.

  interfaces IF_CHDO_ENHANCEMENTS .

  class-data OBJECTCLASS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTCL read-only value 'ZREUSE_SO_004' ##NO_TEXT.

  class-methods WRITE
    importing
      !OBJECTID type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTV
      !UTIME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUZEIT
      !UDATE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDDATUM
      !USERNAME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUSERNAME
      !PLANNED_CHANGE_NUMBER type IF_CHDO_OBJECT_TOOLS_REL=>TY_PLANCHNGNR default SPACE
      !OBJECT_CHANGE_INDICATOR type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default 'U'
      !PLANNED_OR_REAL_CHANGES type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !NO_CHANGE_POINTERS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !O_ZREUSE_HEAD_002 type ZREUSE_HEAD_002 optional
      !N_ZREUSE_HEAD_002 type ZREUSE_HEAD_002 optional
      !UPD_ZREUSE_HEAD_002 type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default SPACE
    exporting
      value(CHANGENUMBER) type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR
    raising
      CX_CHDO_WRITE_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZREUSE_SO_004_CHDO IMPLEMENTATION.


  method WRITE.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZREUSE_SO_004
*"         never change it manually, please!        :11/29/2024
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA: l_upd        TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    CALL METHOD cl_chdo_write_tools=>changedocument_open
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        planned_change_number   = planned_change_number
        planned_or_real_changes = planned_or_real_changes.

     IF ( N_ZREUSE_HEAD_002 IS INITIAL ) AND
        ( O_ZREUSE_HEAD_002 IS INITIAL ).
       l_upd  = space.
     ELSE.
       l_upd = UPD_ZREUSE_HEAD_002.
     ENDIF.

     IF  l_upd  NE space.
       CALL METHOD CL_CHDO_WRITE_TOOLS=>changedocument_single_case
         EXPORTING
           tablename              = 'ZREUSE_HEAD_002'
           workarea_old           = O_ZREUSE_HEAD_002
           workarea_new           = N_ZREUSE_HEAD_002
           change_indicator       = UPD_ZREUSE_HEAD_002
           docu_delete            = ''
           docu_insert            = ''
           docu_delete_if         = ''
           docu_insert_if         = ''
                  .
     ENDIF.

    CALL METHOD cl_chdo_write_tools=>changedocument_close
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        date_of_change          = udate
        time_of_change          = utime
        username                = username
        object_change_indicator = object_change_indicator
        no_change_pointers      = no_change_pointers
      IMPORTING
        changenumber            = changenumber.

  endmethod.
ENDCLASS.
