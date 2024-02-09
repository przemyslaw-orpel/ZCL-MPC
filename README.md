# ZCL-MPC

SAP ABAP Class for measuring point/counter
### Static Methods:
+  display_popup - display measuring documents for equimpent salv table popup.
+  create_mdoc - create measuring document.

## Tabels
### ZMES_POINTC_V - Equimpent measuring point/counter view
#### Join Conditions

| Table | Field name     | = | Table | Field name     |
| :-------- | :------- | :------ | :-------- | :------- |
| `EQUI` | `MANDT` | = | `EQUI` | `MANDT` |
| `IMPTT` | `MANDT` | = | `IMRG` | `MANDT` |
| `EQUI` | `OBJNR` | = | `IMPTT` | `MPOBJ` |
| `IMPTT` | `POINT` | = | `IMRG` | `POINT` |

#### View Fields
| View Field | Table | Field | Data Type | Length | Short Description |
|------------|-------|------------|-----------|--------|--------------------|
| MANDT      | EQUI  | MANDT      | CLNT      | 3      | Client             |
| EQUNR      | EQUI  | EQUNR      | CHAR      | 18     | Equipment Number   |
| MDOCM      | IMRG  | MDOCM      | CHAR      | 20     | Measurement Document |
| POINT      | IMPTT | POINT      | CHAR      | 12     | Measuring Point    |
| PTTXT      | IMPTT | PTTXT      | CHAR      | 40     | Description of Measuring Point |
| IDATE      | IMRG  | IDATE      | DATS      | 8      | Date of the Measurement |
| ITIME      | IMRG  | ITIME      | TIMS      | 6      | Time of Measurement |
| READG      | IMRG  | READG      | FLTP      | 16     | Measurement Reading/Total Counter Reading in SI Unit |
| MRNGU      | IMPTT | MRNGU      | UNIT      | 3      | Measurement Range Unit |
| MDTXT      | IMRG  | MDTXT      | CHAR      | 40     | Measurement Document Text |
| MRMIN      | IMPTT | MRMIN      | FLTP      | 16     | Lower Measurement Range Limit/Minimum Total Counter Reading |
| MRMAX      | IMPTT | MRMAX      | FLTP      | 16     | Upper Measurement Range Limit/Maximum Total Counter Reading |
| READR      | IMRG  | READR      | CHAR      | 12     | Person who Took the Measurement Reading |
| AENAM      | IMRG  | AENAM      | CHAR      | 12     | Name of the user who last changed the object |
| RECDV      | IMRG  | RECDV      | FLTP      | 16     | Measurement Reading in Unit of Entry |
| RECDU      | IMRG  | RECDU      | UNIT      | 3      | Unit of Measurement for Document Entry |
| INDCT      | IMPTT | INDCT      | CHAR      | 1      | Indicator to Show that Measuring Point Is a Counter |
| DESIR      | IMPTT | DESIR      | FLTP      | 16     | Measuring Point Target Value |

### ZMES_POINTC_TAB - Equimpent measuring point/counter table type
| Line Type: | ZMES_POINTC |
| :-------- | :------- | 

### ZMES_POINTC - Equimpent measuring point/counter structure

| Component | Typing Method| Component Type | Data Type | Length | Decimals | Short Description |
|------------|-------|------------|-----------|--------|----------|--------------------|
| EQUNR      | Types | EQUNR      | CHAR      | 18     | 0        | Equipment Number   |
| MDOCM      | Types | IMRC_MDOCM | CHAR      | 20     | 0        | Measurement Document |
| POINT      | Types | IMRC_POINT | CHAR      | 12     | 0        | Measuring Point    |
| INDCT      | Types | IMRC_INDCT | CHAR      | 1      | 0        | Indicator to Show that Measuring Point Is a Counter |
| PTTXT      | Types | IMRC_PTTXT | CHAR      | 40     | 0        | Description of Measuring Point |
| IDATE      | Types | IMRC_IDATE | DATS      | 8      | 0        | Date of the Measurement |
| ITIME      | Types | IMRC_ITIME | TIMS      | 6      | 0        | Time of Measurement |
| CREADG     | Types | MENGE_D    | QUAN      | 13     | 3        | Quantity           |
| READG      | Types | IMRC_READG | FLTP      | 16     | 16       | Measurement Reading/Total Counter Reading in SI Unit |
| MRNGU      | Types | IMRC_MRNGU | UNIT      | 3      | 0        | Measurement Range Unit |
| MDTXT      | Types | IMRC_MDTXT | CHAR      | 40     | 0        | Measurement Document Text |
| MRMIN      | Types | IMRC_MRMIN | FLTP      | 16     | 16       | Lower Measurement Range Limit/Minimum Total Counter Reading |
| MRMAX      | Types | IMRC_MRMAX | FLTP      | 16     | 16       | Upper Measurement Range Limit/Maximum Total Counter Reading |
| READR      | Types | IMRC_READR | CHAR      | 12     | 0        | Person who Took the Measurement Reading |
| AENAM      | Types | IUPNA      | CHAR      | 12     | 0        | Name of the user who last changed the object |
| CMRMIN     | Types | MENGE_D    | QUAN      | 13     | 3        | Quantity           |
| CMRMAX     | Types | MENGE_D    | QUAN      | 13     | 3        | Quantity           |
| DESIR      | Types | IMRC_DESIR | FLTP      | 16     | 16       | Measuring Point Target Value |
| CDESIR     | Types | MENGE_D    | QUAN      | 13     | 3        | Quantity           |

### Design pattern
+ OOP


    
## Usage
```
zcl_mpc=>display_popup( i_equnr = lv_equnr ).
```
