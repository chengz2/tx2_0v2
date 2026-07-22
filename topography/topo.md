# tx2_0v2 Topography Generation

This document describes the workflow used to generate the **tx2_0v2 ocean model topography** and associated files.

---

## Topography Creation Workflow

### 1) Compile source code

```
cd src
gmake create_model_topo
gmake append_topo_interp_smooth
make
cd ..
```

---

### 2) Create initial topography

Run:
```
qsub run_create_topo.tx2_0v2.pbs
```
This step creates the basic topography file with **raw cell-level depth statistics** and a **first-cut land mask**.

**Output**
```
topo.sub150.tx2_0v2.SRTM15_V2.4.nc
```

---

### 3) Edit land mask

Notebook:
```
MaskEdit_tx2_0v1.ipynb
```
This notebook edits the land mask, including **removing 1-point bays around Greenland and Antarctica**.

**Output**
```
topo.sub150.tx2_0v1.SRTM15_V2.4.edit1.nc
```

---

### 4) Interpolate and smooth depths

Run:
```
qsub run_append_topo_interp_smooth_tx2_0v1.pbs
```
This step appends a new depth variable **`D_interp`** to the topography file with **lightly smoothed depths**.

**Output**
```
topo.sub150.tx2_0v1.SRTM15_V2.4.edit1.SmL1.0_C1.0.nc
```

---

### 5) Apply manual depth edits

Notebook:
```
Append_topo_edits_tx2_0v1.ipynb
```
This notebook applies **hand edits to depths for straits and channels**.
This step produces the **final model input topography**.

**Output**
```
topo.sub150.tx2_0v1.SRTM15_V2.4.edit2.SmL1.0_C1.0.nc
```
Final topography variable used by the model:
```
D_edit2
```

---

### 6) Create channel width file

Notebook:
```
Channel_width_tx2_0v1.ipynb
```
Creates the **channel width file** used by the model.

**Output**
```
channels_tx2_0v1_[yymmdd].txt
```

