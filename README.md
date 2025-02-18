# Digital Lock FSM on FPGA

## Overview
This project implements a **Digital Lock FSM** on an **iCE40-HX8K FPGA** using **SystemVerilog**. The lock system consists of a **finite state machine (FSM)**, a **button synchronizer**, a **sequence shift register**, and a **seven-segment display module**. The user enters an **8-digit hexadecimal passcode**, which the system stores and verifies upon re-entry. Incorrect entries trigger an **ALARM state**, while correct entries unlock the system.

## Modules

### 1️⃣ **synckey.sv** (Button Synchronizer & Edge Detector)
- Synchronizes button presses using a **2-stage flip-flop synchronizer**.
- Detects rising edges using an **edge detector** to prevent glitches.
- Outputs a **strobe signal** when a button press is registered.

**Ports:**
| Port  | Type   | Description |
|-------|--------|-------------|
| clk   | input  | 100 Hz clock |
| rst   | input  | Active-low reset |
| in    | input  | 20-bit button input |
| out   | output | 5-bit encoded key output |
| strobe | output | Edge-detected strobe signal |

---
### 2️⃣ **fsm.sv** (Digital Lock Finite State Machine)
- Implements a **10-state FSM** to verify the 8-digit passcode.
- Uses the **synckey module's strobe** as the clock.
- Transitions from **INIT → LS0–LS7 → OPEN** upon correct inputs.
- Moves to **ALARM state** on incorrect input, requiring reset (3-0-W key).
- Allows re-locking from OPEN using **W key**.

**States:**
| State  | Description |
|--------|-------------|
| INIT   | Stores 8-digit passcode |
| LS0–LS7 | Verification states |
| OPEN   | Correct passcode entered |
| ALARM  | Incorrect passcode entered |

**Ports:**
| Port  | Type   | Description |
|-------|--------|-------------|
| clk   | input  | Strobe from synckey |
| rst   | input  | Active-low reset |
| keyout | input  | 5-bit encoded key |
| seq   | input  | 32-bit stored passcode |
| state | output | Current FSM state |

---
### 3️⃣ **sequence_sr.sv** (Passcode Storage Shift Register)
- Stores the **8-digit passcode** entered in INIT state.
- Uses a **32-bit shift register** (4 bits per digit).
- Shifts new values in upon valid button press.

**Ports:**
| Port  | Type   | Description |
|-------|--------|-------------|
| clk   | input  | 100 Hz clock |
| rst   | input  | Active-low reset |
| en    | input  | Enable signal (only in INIT) |
| in    | input  | 5-bit key input |
| out   | output | 32-bit stored passcode |

---
### 4️⃣ **display.sv** (State Display on Seven-Segment Displays)
- Shows stored passcode in INIT.
- Displays **which digit to enter** in LS0–LS7 (via decimal points).
- Hardcoded seven-segment mappings for:
  - **"OPEN"** (when unlocked)
  - **"CALL 911"** (in ALARM state)
- Controls RGB LEDs for status indication:
  - **Green (OPEN)**, **Blue (LOCKED)**, **Red (ALARM)**.

**Ports:**
| Port  | Type   | Description |
|-------|--------|-------------|
| state | input  | Current FSM state |
| seq   | input  | Stored passcode |
| ss    | output | 64-bit seven-segment display output |
| red   | output | Red LED control |
| green | output | Green LED control |
| blue  | output | Blue LED control |

---
## Functionality & Testing

1️⃣ **Passcode Entry (INIT State)**
- User enters an **8-digit hexadecimal passcode**.
- Each key press shifts a new digit into the **sequence_sr** register.
- Pressing **W** confirms the passcode and moves to LS0.

2️⃣ **Verification (LS0–LS7 States)**
- User must re-enter the same **8-digit passcode**.
- Correct entry moves from **LS0 → LS7**.
- Incorrect entry triggers **ALARM state**.

3️⃣ **Unlock & Relock (OPEN & ALARM States)**
- **Correct passcode unlocks the system (OPEN state)**.
- **Incorrect entry triggers ALARM (CALL 911 displayed).**
- To reset ALARM, user must press **3-0-W**.
- To relock from OPEN, user presses **W**, returning to LS0.

### **Testbench Verification**
✅ **Power-on Reset:** Ensures FSM starts in INIT.
✅ **Correct Passcode:** Verifies transition from **INIT → LS0–LS7 → OPEN**.
✅ **Incorrect Passcode:** Ensures transition to **ALARM**.
✅ **Reset Functionality:** Confirms ALARM resets only with **3-0-W**.
✅ **Display Outputs:** Verifies correct messages on the seven-segment displays.

---
## Contributors
👤 **Medha Shinde**

🎯 **STARS 2024 | Purdue University**