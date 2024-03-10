import 'package:group_project/models/exercise.dart';

import 'bodypart_data.dart';
import 'category_data.dart';

Map<String, Map<String, String>> exerciseMap = {
  'Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Incline Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Bench Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Deadlift (Barbell)': {'Back': 'Barbell'},
  'Wide Grip Seated Row (Cable)': {'Back': 'Machine'},
  'Chest Fly (Dumbbell)': {'Chest': 'Dumbbell'},
  'Incline Bench Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Rear Delt Fly (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Hack Squat': {'Legs': 'Machine'},
  'Lat Pulldown (Cable)': {'Back': 'Cable'},
  'Leg Extension': {'Legs': 'Machine'},
  'Single Arm Bent Over Row (Dumbbell)': {'Back': 'Dumbbell'},
  'Standing Calf Raise (Machine)': {'Legs': 'Machine'},
  'Cross Body Hammer Curl': {'Arms': 'Dumbbell'},
  'Arnold Press (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Assisted Dip': {'Shoulders': 'Assisted Bodyweight'},
  'Assisted Inverse Leg Curl': {'Legs': 'Assisted Bodyweight'},
  'Assisted Pull Up (Machine)': {'Back': 'Assisted Bodyweight'},
  'Back Extension': {'Back': 'Weighted Bodyweight'},
  'Bent Over Row (Band)': {'Back': 'Band'},
  'Band Hip Abduction': {'Other': 'Band'},
  'Lat Pulldown (Band)': {'Back': 'Band'},
  'Lying Hamstring Curl (Band)': {'Other': 'Band'},
  'Overhead Tricep Extension (Band)': {'Arms': 'Band'},
  'Shoulder Extension (Band)': {'Shoulders': 'Band'},
  'Band Shoulder Flexion': {'Shoulders': 'Band'},
  'Tricep Pushdown (Band)': {'Arms': 'Band'},
  'Face Pull (Band)': {'Shoulders': 'Band'},
  'Bent Over Row (Barbell)': {'Back': 'Barbell'},
  'Box Squat (Barbell)': {'Legs': 'Barbell'},
  'Bicep Curl (Barbell)': {'Arms': 'Barbell'},
  'Romanian Deadift (Barbell)': {'Legs': 'Barbell'},
  'Floor Press (Barbell)': {'Chest': 'Barbell'},
  'Front Squat (Barbell)': {'Legs': 'Barbell'},
  'Good Morning (Barbell)': {'Legs': 'Barbell'},
  'Hack Squat (Barbell)': {'Legs': 'Barbell'},
  'Hang Clean & Jerk (Barbell)': {'Other': 'Barbell'},
  'Hip Thrust (Barbell)': {'Back': 'Barbell'},
  'Lying Skullcrusher (Barbell)': {'Arms': 'Barbell'},
  'Overhead Squat (Barbell)': {'Other': 'Barbell'},
  'Pin Squat  (Barbell)': {'Legs': 'Barbell'},
  'Pullover (Barbell)': {'Back': 'Barbell'},
  'Reverse Wrist Curl (Barbell)': {'Arms': 'Barbell'},
  'Shrug (Barbell)': {'Back': 'Barbell'},
  'Split Squat (Barbell)': {'Legs': 'Barbell'},
  'Squat (Barbell)': {'Legs': 'Barbell'},
  'Squat Clean (Barbell)': {'Legs': 'Barbell'},
  'Step Up (Barbell)': {'Legs': 'Barbell'},
  'Stiff Legged Deadlift (Barbell)': {'Legs': 'Barbell'},
  'Sumo Deadlift (Barbell)': {'Legs': 'Barbell'},
  'Sumo Squat (Barbell)': {'Legs': 'Barbell'},
  'Wide Grip Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Wrist Curls (Barbell)': {'Arms': 'Barbell'},
  'Battle Rope ': {'Shoulders': 'Other'},
  'Behind The Back Shrug (Barbell)': {'Shoulders': 'Barbell'},
  'Belt Squat': {'Legs': 'Machine'},
  'Bench Dip ': {'Arms': 'Other'},
  'Bicycle Crunch ': {'Core': 'Weighted Bodyweight'},
  'Block Pull Deadlift (Barbell)': {'Legs': 'Barbell'},
  'Body Saw Plank': {'Core': 'Other'},
  'Hip Thrust (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Lunge (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Split Squat (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Squat (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Walking Lunge (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Crossover (Cable)': {'Shoulders': 'Weighted Bodyweight'},
  'Crunch (Cable)': {'Core': 'Weighted Bodyweight'},
  'Donkey Kickback (Cable)': {'Legs': 'Weighted Bodyweight'},
  'Face Pull (Cable)': {'Arms': 'Weighted Bodyweight'},
  'Lateral Raise (Cable)': {'Shoulders': 'Machine'},
  'Chest Fly (Cable)': {'Chest': 'Cable'},
  'Pull Through (Cable)': {'Core': 'Cable'},
  'Pullover (Cable)': {'Arms': 'Cable'},
  'Tricep Push Down (Cable)': {'Arms': 'Cable'},
  'Rear Delt Row (Cable)': {'Back': 'Cable'},
  'Reverse Grip Pushdown (Cable)': {'Arms': 'Cable'},
  'Seated Rear Delt Fly (Cable)': {'Back': 'Cable'},
  'Seated Row (Cable)': {'Back': 'Cable'},
  'Shoulder Press (Cable)': {'Shoulders': 'Cable'},
  'Shrug (Cable)': {'Shoulders': 'Cable'},
  'Straight Arm Pulldown (Cable)': {'Back': 'Cable'},
  'Upright Row (Cable)': {'Back': 'Cable'},
  'Y-Raise (Cable)': {'Shoulders': 'Cable'},
  'Captains Chair Leg Raise': {'Core': 'Machine'},
  'Chest Dip': {'Chest': 'Weighted Bodyweight'},
  'Chest Press': {'Chest': 'Machine'},
  'Chin Up': {'Back': 'Weighted Bodyweight'},
  'Close-Grip Bench Press (Barbell)': {'Arms': 'Barbell'},
  'Close-Grip Lat Pulldown': {'Back': 'Machine'},
  'Close Grip Pull Up': {'Back': 'Machine'},
  'Cobra Push Up ': {'Other': 'Other'},
  'Concentration Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Conventional Single Leg Squat': {'Legs': 'Weighted Bodyweight'},
  'Crunch': {'Core': 'Other'},
  'Hammer Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Decline Bench Press (Barbell)': {'Chest': 'Barbell'},
  'Decline Cable Fly': {'Chest': 'Machine'},
  'Decline Crunch': {'Core': 'Weighted Bodyweight'},
  'Decline Push-Up': {'Arms': 'Weighted Bodyweight'},
  'Decline Sit Up': {'Core': 'Weighted Bodyweight'},
  'Deficit Bulgarian Split Squat': {'Legs': 'Dumbbell'},
  'Deficit Deadlift': {'Legs': 'Barbell'},
  'Diamond Push-Up': {'Arms': 'Weighted Bodyweight'},
  'Donkey Calf Raise': {'Legs': 'Other'},
  'Bicep Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Bulgarian Split Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Close Grip Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Deadlift (Dumbbell)': {'Legs': 'Dumbbell'},
  'Decline Bench Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Belt Squat (Between Boxes)': {'Legs': 'Band'},
  'Butterfly Sit Up': {'Core': 'Weighted Bodyweight'},
  'Face Pull (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Front Raise (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Front Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Goblet Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Good Morning (Dumbbell)': {'Legs': 'Dumbbell'},
  'Hack Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Hex Press (Dumbbell)': {'Chest': 'Dumbbell'},
  'Hip Thrust (Dumbbell)': {'Legs': 'Dumbbell'},
  'Pullover (Dumbbell)': {'Legs': 'Dumbbell'},
  'Reverse Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Reverse Wrist Curl (Dumbbell)': {'Legs': 'Dumbbell'},
  'Side Bend (Dumbbell)': {'Core': 'Dumbbell'},
  'Skullcrushers (Dumbbell)': {'Arms': 'Dumbbell'},
  'Split Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Stiff Legged Deadlift (Dumbbell)': {'Legs': 'Dumbbell'},
  'Sumo Deadlift (Dumbbell)': {'Legs': 'Dumbbell'},
  'Sumo Goblet Squat (Dumbbell)': {'Legs': 'Dumbbell'},
  'Elevated Glute Bridge': {'Legs': 'Weighted Bodyweight'},
  'Elliptical': {'Other': 'Duration'},
  'Bicep Curl (Ez Bar)': {'Arms': 'Barbell'},
  'Farmers Walk': {'Legs': 'Dumbbell'},
  'Glute Ham Raise': {'Legs': 'Weighted Bodyweight'},
  'Handstand Push Up': {'Arms': 'Weighted Bodyweight'},
  'Hanging Leg Raise': {'Core': 'Weighted Bodyweight'},
  'High Pulley Cable Curl': {'Arms': 'Cable'},
  'Incline Cable Fly': {'Chest': 'Cable'},
  'Incline Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Incline Chest Fly (Dumbbell)': {'Chest': 'Dumbbell'},
  'Incline Hammer Curl (Dumbbell)': {'Arms': 'Dumbbell'},
  'Incline Push Up': {'Chest': 'Weighted Bodyweight'},
  'Inverted Row': {'Back': 'Weighted Bodyweight'},
  'Goblet Squat (Kettlebell)': {'Legs': 'Other'},
  'Lateral Raise (Kettlebell)': {'Shoulders': 'Other'},
  'Overhead Squat (Kettlebell)': {'Legs': 'Other'},
  'Romanian Deadlift (Kettlebell)': {'Legs': 'Other'},
  'Side Squat (Kettlebell)': {'Legs': 'Other'},
  'Snatch (Kettlebell)': {'Legs': 'Other'},
  'Squat (Kettlebell)': {'Legs': 'Other'},
  'Sumo Squat (Kettlebell)': {'Legs': 'Other'},
  'Swings (Kettlebell)': {'Other': 'Other'},
  'Upright Row (Kettlebell)': {'Shoulders': 'Other'},
  'Lateral Raise (Machine)': {'Shoulders': 'Machine'},
  'Lever Back Extension (Machine)': {'Core': 'Machine'},
  'Lever High Row (Machine)': {'Back': 'Machine'},
  'Lever Preacher Curl (Machine)': {'Arms': 'Machine'},
  'Lever Pullover (Machine)': {'Back': 'Machine'},
  'Lever Reverse Hyperextension': {'Legs': 'Machine'},
  'Low Cable Chest Fly ': {'Chest': 'Cable'},
  'Muscle Up': {'Back': 'Weighted Bodyweight'},
  'Negative Pull Up ': {'Back': 'Weighted Bodyweight'},
  'Neutral Grip Lateral Pulldown ': {'Shoulders': 'Cable'},
  'Neutral Grip Pull Up ': {'Back': 'Weighted Bodyweight'},
  'Parallel Bar Dips': {'Arms': 'Weighted Bodyweight'},
  'Pec Deck': {'Chest': 'Machine'},
  'Pendlay Row ': {'Back': 'Barbell'},
  'Pistol Squat': {'Legs': 'Weighted Bodyweight'},
  'Plance Dip Muscles': {'Shoulders': 'Weighted Bodyweight'},
  'Pile Squat ': {'Legs': 'Weighted Bodyweight'},
  'Preacher Curl (Barbell)': {'Arms': 'Barbell'},
  'Pronated Grip Cable Fly': {'Chest': 'Cable'},
  'Pull Up': {'Back': 'Weighted Bodyweight'},
  'Rack Pull (Barbell)': {'Shoulders': 'Barbell'},
  'Reverse Pec Deck': {'Shoulders': 'Machine'},
  'Ring Dips': {'Arms': 'Weighted Bodyweight'},
  'Rope Climb': {'Other': 'Weighted Bodyweight'},
  'Rowing': {'Other': 'Duration'},
  'Wide Grip Pull Up': {'Back': 'Weighted Bodyweight'},
  'Seated Calf Raise': {'Legs': 'Machine'},
  'Single Leg Calf Raise': {'Legs': 'Weighted Bodyweight'},
  'Single Leg Deadlift (Barbell)': {'Legs': 'Barbell'},
  'Sit Up': {'Core': 'Weighted Bodyweight'},
  'Calf Raise (Smith Machine)': {'Legs': 'Machine'},
  'Deadlift (Smith Machine)': {'Legs': 'Machine'},
  'Squat (Smith Machine)': {'Legs': 'Machine'},
  'Split Squat': {'Legs': 'Weighted Bodyweight'},
  'Calf Raise (Bodyweight)': {'Legs': 'Weighted Bodyweight'},
  'Standing Leg Curl (Machine)': {'Legs': 'Machine'},
  'Overhead Press (Barbell)': {'Shoulders': 'Barbell'},
  'Step Down': {'Legs': 'Weighted Bodyweight'},
  'Stiff Legged Deadlift (Smith Machine)': {'Legs': 'Machine'},
  'Straight Bar Cable Pushdown': {'Back': 'Cable'},
  'Sumo Deadlift (Smith Machine)': {'Legs': 'Machine'},
  'T-Bar Row (Barbell)': {'Back': 'Barbell'},
  'Front Raise (Cable)': {'Shoulders': 'Cable'},
  'Deadlift (Kettlebell)': {'Legs': 'Other'},
  'Single Arm Swing (Kettlebell)': {'Legs': 'Other'},
  'Split Squat (Kettlebell)': {'Legs': 'Other'},
  'Trap Bar Deadlift': {'Legs': 'Barbell'},
  'Tricep Dip': {'Arms': 'Weighted Bodyweight'},
  'Tricep Extension (Machine)': {'Arms': 'Machine'},
  'Tricep Kickback (Dumbbell)': {'Arms': 'Dumbbell'},
  'Upright Row (Barbell)': {'Shoulders': 'Barbell'},
  'V Bar Tricep Pushdown (Cable)': {'Arms': 'Cable'},
  'Wall Crunch': {'Core': 'Weighted Bodyweight'},
  'Wide Grip Lat Pulldown (Cable)': {'Back': 'Cable'},
  'Yates Row (Barbell)': {'Back': 'Barbell'},
  'Zercher Bulgarian Split Squat (Barbell)': {'Legs': 'Barbell'},
  'Zercher Squat (Barbell)': {'Legs': 'Barbell'},
  'Zottman Curl': {'Arms': 'Dumbbell'},
  'Overhead Press (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Seated Overhead Press (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Lateral Raise (Dumbbell)': {'Shoulders': 'Dumbbell'},
  'Single Arm Lat Pulldown (Cable)': {'Back': 'Cable'},
  'Seated Overhead Press (Barbell)': {'Shoulders': 'Barbell'},
  'Lying Leg Curl': {'Legs': 'Machine'},
  'Reverse Curl (Barbell)': {'Arms': 'Barbell'},
};

Map<String, String> imageMap = {
  'Bench Press (Barbell)': 'assets/exercises/barbell-bench.png',
  'Incline Bench Press (Barbell)': 'assets/exercises/incline-barbell-bench.png',
  'Bench Press (Dumbbell)': 'assets/exercises/dumbbell-bench.png',
  'Deadlift (Barbell)': 'assets/exercises/barbell-deadlift.png',
  'Wide Grip Seated Row (Cable)':
      'assets/exercises/cable-seated-wide-grip-row.png',
  'Chest Fly (Dumbbell)': 'assets/exercises/dumbbell-chest-fly.png',
  'Incline Bench Press (Dumbbell)':
      'assets/exercises/dumbbell-incline-bench-press.png',
  'Rear Delt Fly (Dumbbell)': 'assets/exercises/dumbbell-rear-delt-fly.png',
  'Hack Squat': 'assets/exercises/hack-squat.png',
  'Lat Pulldown (Cable)':
      'assets/exercises/cable-lat-pulldown-muscles-1024x688.png',
  'Leg Extension': 'assets/exercises/leg-extension.png',
  'Single Arm Bent Over Row (Dumbbell)':
      'assets/exercises/single-arm-bent-over-row.png',
  'Standing Calf Raise (Machine)': 'assets/exercises/standing-calf-raise.png',
  'Cross Body Hammer Curl': 'assets/exercises/cross-body-hammer-curl.png',
  'Arnold Press (Dumbbell)':
      'assets/exercises/arnold-press-muscles-1024x753.png',
  'Assisted Dip': 'assets/exercises/assisted-dip-muscles-1024x710.png',
  'Assisted Inverse Leg Curl':
      'assets/exercises/assisted-inverse-leg-curl-1024x329.png',
  'Assisted Pull Up (Machine)':
      'assets/exercises/assisted-pull-up-machine-1024x792.png',
  'Back Extension': 'assets/exercises/back-extension-muscles-1024x575.png',
  'Bent Over Row (Band)': 'assets/exercises/band-bent-over-row-1024x746.png',
  'Band Hip Abduction': 'assets/exercises/band-hip-abduction-1024x519.png',
  'Lat Pulldown (Band)':
      'assets/exercises/band-lat-pulldown-muscles-1024x652.png',
  'Lying Hamstring Curl (Band)':
      'assets/exercises/band-lying-hamstring-curl-1024x202.png',
  'Overhead Tricep Extension (Band)':
      'assets/exercises/band-overhead-tricep-extension.png',
  'Shoulder Extension (Band)':
      'assets/exercises/band-shoulder-extension-1024x604.png',
  'Band Shoulder Flexion':
      'assets/exercises/band-shoulder-flexion-1024x588.png',
  'Tricep Pushdown (Band)':
      'assets/exercises/band-tricep-pushdown-muscles-1024x790.png',
  'Face Pull (Band)': 'assets/exercises/banded-face-pull-muscles.png',
  'Bent Over Row (Barbell)':
      'assets/exercises/barbell-bent-over-row-1024x554.png',
  'Box Squat (Barbell)': 'assets/exercises/barbell-box-squat-1024x573.png',
  'Bicep Curl (Barbell)': 'assets/exercises/barbell-curl-muscles-1024x622.png',
  'Romanian Deadift (Barbell)':
      'assets/exercises/barbell-romanian-deadlift.png',
  'Floor Press (Barbell)':
      'assets/exercises/barbell-floor-press-muscles-1024x337.png',
  'Front Squat (Barbell)': 'assets/exercises/barbell-front-squat-1024x661.png',
  'Good Morning (Barbell)':
      'assets/exercises/barbell-good-morning-1-1024x558.png',
  'Hack Squat (Barbell)':
      'assets/exercises/barbell-hack-squat-movement-1024x912.png',
  'Hang Clean & Jerk (Barbell)':
      'assets/exercises/barbell-hang-clean-and-jerk-2nd-position-1024x567.png',
  'Hip Thrust (Barbell)':
      'assets/exercises/barbell-hip-thrust-muscles-1024x366.png',
  'Lying Skullcrusher (Barbell)':
      'assets/exercises/barbell-lying-skullcrusher.png',
  'Overhead Squat (Barbell)':
      'assets/exercises/barbell-overhead-squat-muscles-1024x789.png',
  'Pin Squat  (Barbell)':
      'assets/exercises/barbell-pin-squat-muscles-1024x657.png',
  'Pullover (Barbell)':
      'assets/exercises/barbell-pullover-muscles-1024x375.png',
  'Reverse Wrist Curl (Barbell)':
      'assets/exercises/barbell-reverse-wrist-curl-muscles-1024x435.png',
  'Shrug (Barbell)': 'assets/exercises/barbell-shrug-1024x657.png',
  'Split Squat (Barbell)':
      'assets/exercises/barbell-split-squat-muscles-1024x689.png',
  'Squat (Barbell)': 'assets/exercises/barbell-squat.png',
  'Squat Clean (Barbell)':
      'assets/exercises/barbell-squat-clean-muscles-1024x319.png',
  'Step Up (Barbell)': 'assets/exercises/barbell-step-up-1024x445.png',
  'Stiff Legged Deadlift (Barbell)':
      'assets/exercises/barbell-stiff-legged-deadlift-1024x647.png',
  'Sumo Deadlift (Barbell)':
      'assets/exercises/barbell-sumo-deadlift-form-1024x600.png',
  'Sumo Squat (Barbell)':
      'assets/exercises/barbell-sumo-squat-muscles-1024x543.png',
  'Wide Grip Bench Press (Barbell)':
      'assets/exercises/barbell-wide-grip-bench-press-muscles.png',
  'Wrist Curls (Barbell)':
      'assets/exercises/barbell-wrist-curls-muscles-1024x554.png',
  'Battle Rope ': 'assets/exercises/battle-rope-1024x353.png',
  'Behind The Back Shrug (Barbell)':
      'assets/exercises/behind-the-back-shrug-muscles-1024x664.png',
  'Belt Squat': 'assets/exercises/belt-squat-muscles-1024x581.png',
  'Bench Dip ': 'assets/exercises/bench-dip-1024x451.png',
  'Bicycle Crunch ': 'assets/exercises/bicycle-crunch-1024x293.png',
  'Block Pull Deadlift (Barbell)':
      'assets/exercises/block-pull-deadlift-muscles-1024x643.png',
  'Body Saw Plank': 'assets/exercises/body-saw-plank-muscles-1024x167.png',
  'Hip Thrust (Bodyweight)':
      'assets/exercises/bodyweight-hip-thrust-muscles-1024x394.png',
  'Lunge (Bodyweight)': 'assets/exercises/bodyweight-lunge-1024x637.png',
  'Split Squat (Bodyweight)':
      'assets/exercises/bodyweight-split-squat-muscles-1024x713.png',
  'Squat (Bodyweight)': 'assets/exercises/bodyweight-squat-1024x720.png',
  'Walking Lunge (Bodyweight)':
      'assets/exercises/bodyweight-walking-lunge-muscles-1024x413.png',
  'Crossover (Cable)': 'assets/exercises/cable-crossover-1024x564.png',
  'Crunch (Cable)': 'assets/exercises/cable-crunch-1024x610.png',
  'Donkey Kickback (Cable)':
      'assets/exercises/cable-donkey-kickback-1024x471.png',
  'Face Pull (Cable)': 'assets/exercises/cable-face-pull-muscles-1024x482.png',
  'Lateral Raise (Cable)':
      'assets/exercises/cable-lateral-raise-muscles-1024x479.png',
  'Chest Fly (Cable)': 'assets/exercises/cable-machine-fly.png',
  'Pull Through (Cable)': 'assets/exercises/cable-pull-through.png',
  'Pullover (Cable)': 'assets/exercises/cable-pullover-1024x662.png',
  'Tricep Push Down (Cable)': 'assets/exercises/cable-push-down-1024x786.png',
  'Rear Delt Row (Cable)':
      'assets/exercises/cable-rear-delt-row-muscles-1024x516.png',
  'Reverse Grip Pushdown (Cable)':
      'assets/exercises/cable-reverse-pushdown-1024x749.png',
  'Seated Rear Delt Fly (Cable)':
      'assets/exercises/cable-seated-rear-delt-fly-1024x715.png',
  'Seated Row (Cable)': 'assets/exercises/cable-seated-row-muscles-1024x520',
  'Shoulder Press (Cable)':
      'assets/exercises/cable-shoulder-press-muscles-1024x768.png',
  'Shrug (Cable)': 'assets/exercises/cable-shrug-muscles-1024x743.png',
  'Straight Arm Pulldown (Cable)':
      'assets/exercises/cable-straight-arm-pulldown.png',
  'Upright Row (Cable)':
      'assets/exercises/cable-upright-row-muscles-1024x727.png',
  'Y-Raise (Cable)': 'assets/exercises/cable-y-raise-1024x600.png',
  'Captains Chair Leg Raise':
      'assets/exercises/captains-chair-leg-raise-muscles-1024x596.png',
  'Chest Dip': 'assets/exercises/chest-dip-1024x694.png',
  'Chest Press': 'assets/exercises/chest-press-1024x673.png',
  'Chin Up': 'assets/exercises/chin-up-muscles-1024x724.png',
  'Close-Grip Bench Press (Barbell)':
      'assets/exercises/close-grip-bench-press-1024x490.png',
  'Close-Grip Lat Pulldown':
      'assets/exercises/close-grip-lat-pulldown-muscles-1024x699.png',
  'Close Grip Pull Up':
      'assets/exercises/close-grip-pull-up-muscles-1024x654.png',
  'Cobra Push Up ':
      'assets/exercises/cobra-push-up-spinal-extension-1024x335.png',
  'Concentration Curl (Dumbbell)':
      'assets/exercises/concentration-curl-1024x471.png',
  'Conventional Single Leg Squat':
      'assets/exercises/conventional-single-leg-squat-1024x763.png',
  'Crunch': 'assets/exercises/crunch-muscles-1024x260.png',
  'Hammer Curl (Dumbbell)': 'assets/exercises/db-hammer-curl-1024x792.png',
  'Decline Bench Press (Barbell)':
      'assets/exercises/decline-bench-press-1024x566.png',
  'Decline Cable Fly': 'assets/exercises/decline-cable-fly-1024x584.png',
  'Decline Crunch': 'assets/exercises/decline-crunch-muscles-1024x456.png',
  'Decline Push-Up': 'assets/exercises/decline-push-up-muscles-1024x252.png',
  'Decline Sit Up': 'assets/exercises/decline-sit-up-muscles-1024x670.png',
  'Deficit Bulgarian Split Squat':
      'assets/exercises/deficit-bulgarian-split-squat-muscles-1024x628.png',
  'Deficit Deadlift': 'assets/exercises/deficit-deadlift-muscles-1024x609.png',
  'Diamond Push-Up': 'assets/exercises/diamond-push-up-muscles-1024x372.png',
  'Donkey Calf Raise':
      'assets/exercises/donkey-calf-raise-muscles-1024x397.png',
  'Bicep Curl (Dumbbell)': 'assets/exercises/dumbbell-biceps-curl-1024x900.png',
  'Bulgarian Split Squat (Dumbbell)':
      'assets/exercises/dumbbell-bulgarian-split-squat-muscles-1024x663.png',
  'Close Grip Press (Dumbbell)':
      'assets/exercises/dumbbell-close-grip-press-muscles-1024x689.png',
  'Deadlift (Dumbbell)':
      'assets/exercises/dumbbell-deadlift-muscles-1024x609.png',
  'Decline Bench Press (Dumbbell)':
      'assets/exercises/dumbbell-decline-bench-press-1024x596.png',
  'Belt Squat (Between Boxes)':
      'assets/exercises/belt-squat-between-boxes-muscles-used-1024x703.png',
  'Butterfly Sit Up': 'assets/exercises/butterfly-sit-up-muscles-1024x270.png',
  'Face Pull (Dumbbell)':
      'assets/exercises/dumbbell-face-pull-muscles-1024x592.png',
  'Front Raise (Dumbbell)':
      'assets/exercises/dumbbell-front-raise-movement-1024x689.png',
  'Front Squat (Dumbbell)':
      'assets/exercises/dumbbell-front-squat-muscles-1024x691.png',
  'Goblet Squat (Dumbbell)':
      'assets/exercises/dumbbell-goblet-squat-1024x704.png',
  'Good Morning (Dumbbell)':
      'assets/exercises/dumbbell-good-morning-muscles-1024x766.png',
  'Hack Squat (Dumbbell)':
      'assets/exercises/dumbbell-hack-squat-muscles-1024x779.png',
  'Hex Press (Dumbbell)':
      'assets/exercises/dumbbell-hex-press-muscles-1024x670.png',
  'Hip Thrust (Dumbbell)':
      'assets/exercises/dumbbell-hip-thrust-muscles-1024x363.png',
  'Pullover (Dumbbell)': 'assets/exercises/dumbbell-pullover-1024x554.png',
  'Reverse Curl (Dumbbell)':
      'assets/exercises/dumbbell-reverse-curl-muscles-1024x732.png',
  'Reverse Wrist Curl (Dumbbell)':
      'assets/exercises/dumbbell-reverse-wrist-curl-1024x487.png',
  'Side Bend (Dumbbell)':
      'assets/exercises/dumbbell-side-bend-muscles-1024x746.png',
  'Skullcrushers (Dumbbell)':
      'assets/exercises/dumbbell-skull-crushers-1024x428.png',
  'Split Squat (Dumbbell)':
      'assets/exercises/dumbbell-split-squat-muscles-1024x827.png',
  'Squat (Dumbbell)': 'assets/exercises/dumbbell-squat-muscles-1024x738.png',
  'Stiff Legged Deadlift (Dumbbell)':
      'assets/exercises/dumbbell-stiff-legged-deadlifts-muscles-1024x653.png',
  'Sumo Deadlift (Dumbbell)':
      'assets/exercises/dumbbell-sumo-deadlift-muscles-1024x791.png',
  'Sumo Goblet Squat (Dumbbell)':
      'assets/exercises/dumbbell-sumo-goblet-squat-muscles-1024x745.png',
  'Elevated Glute Bridge':
      'assets/exercises/elevated-glute-bridge-muscles-1024x285.png',
  'Elliptical': 'assets/exercises/elliptical-1024x560.png',
  'Bicep Curl (Ez Bar)': 'assets/exercises/ez-barbell-curl-1024x731.png',
  'Farmers Walk': 'assets/exercises/farmers-walk-1024x553.png',
  'Glute Ham Raise': 'assets/exercises/glute-ham-raise-1024x693.png',
  'Handstand Push Up': 'assets/exercises/handstand-pushup-muscles-760x1024.png',
  'Hanging Leg Raise': 'assets/exercises/hanging-leg-raise-1024x712.png',
  'High Pulley Cable Curl':
      'assets/exercises/high-pulley-cable-curl-muscles-1024x512.png',
  'Incline Cable Fly':
      'assets/exercises/incline-cable-fly-muscles-1024x599.png',
  'Incline Curl (Dumbbell)':
      'assets/exercises/incline-dumbbell-biceps-curl-muscles-1024x594.png',
  'Incline Chest Fly (Dumbbell)':
      'assets/exercises/incline-dumbbell-fly-1024x620.png',
  'Incline Hammer Curl (Dumbbell)':
      'assets/exercises/incline-hammer-curl-muscles-1024x616.png',
  'Incline Push Up': 'assets/exercises/incline-push-up-muscles-1024x507.png',
  'Inverted Row': 'assets/exercises/inverted-row-movement-1024x557.png',
  'Goblet Squat (Kettlebell)':
      'assets/exercises/kettlebell-goblet-squat-930x1024.png',
  'Lateral Raise (Kettlebell)':
      'assets/exercises/kettlebell-lateral-raise-muscles-1024x658.png',
  'Overhead Squat (Kettlebell)':
      'assets/exercises/kettlebell-overhead-squat-muscles-1024x747.png',
  'Romanian Deadlift (Kettlebell)':
      'assets/exercises/kettlebell-romanian-deadlift-1024x686.png',
  'Side Squat (Kettlebell)':
      'assets/exercises/kettlebell-side-squat-muscles-1024x346.png',
  'Snatch (Kettlebell)': 'assets/exercises/kettlebell-snatch-1024x506.png',
  'Squat (Kettlebell)':
      'assets/exercises/kettlebell-squat-muscles-1024x691.png',
  'Sumo Squat (Kettlebell)':
      'assets/exercises/kettlebell-sumo-squat-muscles-1024x669.png',
  'Swings (Kettlebell)': 'assets/exercises/kettlebell-swings-1024x684.png',
  'Upright Row (Kettlebell)':
      'assets/exercises/kettlebell-upright-row-muscles-1024x717.png',
  'Lateral Raise (Machine)':
      'assets/exercises/lateral-raise-machine-muscles-1024x559.png',
  'Lever Back Extension (Machine)':
      'assets/exercises/lever-back-extension-1024x527.png',
  'Lever High Row (Machine)': 'assets/exercises/lever-high-row-1024x692.png',
  'Lever Preacher Curl (Machine)':
      'assets/exercises/lever-preacher-curl-machine.png',
  'Lever Pullover (Machine)':
      'assets/exercises/lever-pullover-machine-muscles-1024x563.png',
  'Lever Reverse Hyperextension':
      'assets/exercises/lever-reverse-hyperextension-1024x498.png',
  'Low Cable Chest Fly ': 'assets/exercises/low-cable-chest-fly-1024x564.png',
  'Muscle Up': 'assets/exercises/muscle-up-muscles-used-1024x604.png',
  'Negative Pull Up ': 'assets/exercises/negative-pull-up-1024x481.png',
  'Neutral Grip Lateral Pulldown ':
      'assets/exercises/neutral-grip-lat-pulldown-muscles-1024x705.png',
  'Neutral Grip Pull Up ':
      'assets/exercises/neutral-grip-pull-up-muscles-1024x647.png',
  'Parallel Bar Dips':
      'assets/exercises/parallel-bar-dips-muscles-1024x762.png',
  'Pec Deck': 'assets/exercises/pec-deck-muscles-1024x794.png',
  'Pendlay Row ': 'assets/exercises/pendlay-row-1024x598.png',
  'Pistol Squat': 'assets/exercises/pistol-squat-1024x754.png',
  'Plance Dip Muscles': 'assets/exercises/planche-dip-muscles-1024x513.png',
  'Pile Squat ': 'assets/exercises/plie-squat-1024x804.png',
  'Preacher Curl (Barbell)': 'assets/exercises/preacher-curl-benefits.png',
  'Pronated Grip Cable Fly':
      'assets/exercises/pronated-grip-cable-fly-1024x467.png',
  'Pull Up': 'assets/exercises/pull-up-1024x907.png',
  'Rack Pull (Barbell)': 'assets/exercises/rack-pull-mechanics-1024x675.png',
  'Reverse Pec Deck': 'assets/exercises/reverse-pec-dec-muscles-1024x655.png',
  'Ring Dips': 'assets/exercises/ring-dips-muscles-1024x787.png',
  'Rope Climb': 'assets/exercises/rope-climb-muscles-506x1024.png',
  'Rowing': 'assets/exercises/rowing-1024x178.png',
  'Seated Calf Raise': 'assets/exercises/seated-calf-raise.png',
  'Single Leg Calf Raise':
      'assets/exercises/single-leg-calf-raise-muscles-1024x707.png',
  'Single Leg Deadlift (Barbell)':
      'assets/exercises/single-leg-deadlift-muscles-1024x502.png',
  'Sit Up': 'assets/exercises/sit-up-1024x344.png',
  'Calf Raise (Smith Machine)':
      'assets/exercises/smith-machine-calf-raise-1024x635.png',
  'Deadlift (Smith Machine)':
      'assets/exercises/smith-machine-deadlift-muscles-1024x665.png',
  'Squat (Smith Machine)': 'assets/exercises/smith-machine-squat-1024x627.png',
  'Split Squat': 'assets/exercises/split-squat-muscles-1024x719.png',
  'Calf Raise (Bodyweight)':
      'assets/exercises/standing-bodyweight-calf-raise-1024x677.png',
  'Standing Leg Curl (Machine)':
      'assets/exercises/standing-leg-curl-1024x692.png',
  'Overhead Press (Barbell)': 'assets/exercises/standing-military-press.png',
  'Step Down': 'assets/exercises/step-down-1024x734.png',
  'Stiff Legged Deadlift (Smith Machine)':
      'assets/exercises/stiff-legged-smith-deadlift-muscles-1024x650.png',
  'Straight Bar Cable Pushdown':
      'assets/exercises/straight-bar-cable-pushdown-muscles-956x1024.png',
  'Sumo Deadlift (Smith Machine)':
      'assets/exercises/sumo-smith-machine-deadlift-muscles-1024x610.png',
  'T-Bar Row (Barbell)': 'assets/exercises/t-bar-row-muscles-1024x350.png',
  'Front Raise (Cable)': 'assets/exercises/the-cable-front-raise-1024x832.png',
  'Deadlift (Kettlebell)':
      'assets/exercises/the-kettlebell-deadlift-1024x634.png',
  'Single Arm Swing (Kettlebell)':
      'assets/exercises/the-kettlebell-single-arm-swing-1024x684.png',
  'Split Squat (Kettlebell)':
      'assets/exercises/the-kettlebell-split-squat-1024x719.png',
  'Trap Bar Deadlift':
      'assets/exercises/trap-bar-deadlift-muscles-1024x518.png',
  'Tricep Dip': 'assets/exercises/tricep-dip-muscles.png',
  'Tricep Extension (Machine)': 'assets/exercises/tricep-extension-machine.png',
  'Tricep Kickback (Dumbbell)':
      'assets/exercises/tricep-kickback-muscles-1024x670.png',
  'Upright Row (Barbell)': 'assets/exercises/upright-row.png',
  'V Bar Tricep Pushdown (Cable)':
      'assets/exercises/v-bar-tricep-pushdown-muscles-1024x684.png',
  'Wall Crunch': 'assets/exercises/wall-crunch-muscles-1024x639.png',
  'Wide Grip Lat Pulldown (Cable)':
      'assets/exercises/wide-grip-lat-pulldown-muscles-1024x721.png',
  'Wide Grip Pull Up':
      'assets/exercises/wide-grip-pull-up-muscles-1024x653.png',
  'Yates Row (Barbell)': 'assets/exercises/yates-row-muscle-1024x657.png',
  'Zercher Bulgarian Split Squat (Barbell)':
      'assets/exercises/zercher-bulgarian-split-squat-muscles-1024x511.png',
  'Zercher Squat (Barbell)':
      'assets/exercises/zercher-squat-muscles-1024x664.png',
  'Zottman Curl': 'assets/exercises/zottman-curl-muscles-1024x360.png',
  'Overhead Press (Dumbbell)':
      'assets/exercises/Standing-Overhead-Dumbbell-Shoulder-Press-3681395754.png',
  'Seated Overhead Press (Dumbbell)':
      'assets/exercises/seated-overhead-db-press.png',
  'Lateral Raise (Dumbbell)': 'assets/exercises/dumbbell-lateral-raises.png',
  'Single Arm Lat Pulldown (Cable)':
      'assets/exercises/single-arm-lat-pulldown.png',
  'Seated Overhead Press (Barbell)':
      'assets/exercises/barbell-seated-overhead-press.png',
  'Lying Leg Curl': 'assets/exercises/lying-leg-curl.png',
  'Reverse Curl (Barbell)': 'assets/exercises/barbell-reverse-curl.png',
};

Map<String, String> halfImageMap = {
  'Bench Press (Barbell)': 'assets/exercises/half/barbell-bench-half.png',
  'Incline Bench Press (Barbell)':
      'assets/exercises/half/incline-barbell-bench-half.png',
  'Bench Press (Dumbbell)': 'assets/exercises/half/dumbbell-bench-half.png',
  'Deadlift (Barbell)': 'assets/exercises/half/barbell-deadlift-half.png',
  'Wide Grip Seated Row (Cable)':
      'assets/exercises/half/cable-seated-wide-grip-row-half.png',
  'Chest Fly (Dumbbell)': 'assets/exercises/half/dumbbell-chest-fly-half.png',
  'Incline Bench Press (Dumbbell)':
      'assets/exercises/half/dumbbell-incline-bench-press-half.png',
  'Rear Delt Fly (Dumbbell)':
      'assets/exercises/half/dumbbell-rear-delt-fly-half.png',
  'Hack Squat': 'assets/exercises/half/hack-squat-half.png',
  'Leg Extension': 'assets/exercises/half/leg-extension-half.png',
  'Single Arm Bent Over Row (Dumbbell)':
      'assets/exercises/half/single-arm-bent-over-row-half.png',
  'Standing Calf Raise (Machine)':
      'assets/exercises/half/standing-calf-raise-half.png',
  'Cross Body Hammer Curl':
      'assets/exercises/half/cross-body-hammer-curl-half.png',
  'Arnold Press (Dumbbell)':
      'assets/exercises/half/arnold-press-muscles-1024x753-half.png',
  'Assisted Dip':
      'assets/exercises/half/assisted-dip-muscles-1024x710-half.png',
  'Assisted Inverse Leg Curl':
      'assets/exercises/half/assisted-inverse-leg-curl-1024x329-half.png',
  'Assisted Pull Up (Machine)':
      'assets/exercises/half/assisted-pull-up-machine-1024x792-half.png',
  'Back Extension':
      'assets/exercises/half/back-extension-muscles-1024x575-half.png',
  'Bent Over Row (Band)':
      'assets/exercises/half/band-bent-over-row-1024x746-half.png',
  'Band Hip Abduction':
      'assets/exercises/half/band-hip-abduction-1024x519-half.png',
  'Lat Pulldown (Band)':
      'assets/exercises/half/band-lat-pulldown-muscles-1024x652-half.png',
  'Lying Hamstring Curl (Band)':
      'assets/exercises/half/band-lying-hamstring-curl-1024x202-half.png',
  'Overhead Tricep Extension (Band)':
      'assets/exercises/half/band-overhead-tricep-extension-half.png',
  'Shoulder Extension (Band)':
      'assets/exercises/half/band-shoulder-extension-1024x604-half.png',
  'Band Shoulder Flexion':
      'assets/exercises/half/band-shoulder-flexion-1024x588-half.png',
  'Tricep Pushdown (Band)':
      'assets/exercises/half/band-tricep-pushdown-muscles-1024x790-half.png',
  'Face Pull (Band)': 'assets/exercises/half/banded-face-pull-muscles-half.png',
  'Bent Over Row (Barbell)':
      'assets/exercises/half/barbell-bent-over-row-1024x554-half.png',
  'Box Squat (Barbell)':
      'assets/exercises/half/barbell-box-squat-1024x573-half.png',
  'Bicep Curl (Barbell)':
      'assets/exercises/half/barbell-curl-muscles-1024x622-half.png',
  'Romanian Deadift (Barbell)':
      'assets/exercises/half/barbell-romanian-deadlift-half.png',
  'Floor Press (Barbell)':
      'assets/exercises/half/barbell-floor-press-muscles-1024x337-half.png',
  'Front Squat (Barbell)':
      'assets/exercises/half/barbell-front-squat-1024x661-half.png',
  'Good Morning (Barbell)':
      'assets/exercises/half/barbell-good-morning-1-1024x558-half.png',
  'Hack Squat (Barbell)':
      'assets/exercises/half/barbell-hack-squat-movement-1024x912-half.png',
  'Hang Clean & Jerk (Barbell)':
      'assets/exercises/half/barbell-hang-clean-and-jerk-2nd-position-1024x567-half.png',
  'Hip Thrust (Barbell)':
      'assets/exercises/half/barbell-hip-thrust-muscles-1024x366-half.png',
  'Lying Skullcrusher (Barbell)':
      'assets/exercises/half/barbell-lying-skullcrusher-half.png',
  'Overhead Squat (Barbell)':
      'assets/exercises/half/barbell-overhead-squat-muscles-1024x789-half.png',
  'Pin Squat  (Barbell)':
      'assets/exercises/half/barbell-pin-squat-muscles-1024x657-half.png',
  'Pullover (Barbell)':
      'assets/exercises/half/barbell-pullover-muscles-1024x375-half.png',
  'Reverse Wrist Curl (Barbell)':
      'assets/exercises/half/barbell-reverse-wrist-curl-muscles-1024x435-half.png',
  'Shrug (Barbell)': 'assets/exercises/half/barbell-shrug-1024x657-half.png',
  'Split Squat (Barbell)':
      'assets/exercises/half/barbell-split-squat-muscles-1024x689-half.png',
  'Squat (Barbell)': 'assets/exercises/half/barbell-squat-half.png',
  'Squat Clean (Barbell)':
      'assets/exercises/half/barbell-squat-clean-muscles-1024x319-half.png',
  'Step Up (Barbell)':
      'assets/exercises/half/barbell-step-up-1024x445-half.png',
  'Stiff Legged Deadlift (Barbell)':
      'assets/exercises/half/barbell-stiff-legged-deadlift-1024x647-half.png',
  'Sumo Deadlift (Barbell)':
      'assets/exercises/half/barbell-sumo-deadlift-form-1024x600-half.png',
  'Sumo Squat (Barbell)':
      'assets/exercises/half/barbell-sumo-squat-muscles-1024x543-half.png',
  'Wide Grip Bench Press (Barbell)':
      'assets/exercises/half/barbell-wide-grip-bench-press-muscles-half.png',
  'Wrist Curls (Barbell)':
      'assets/exercises/half/barbell-wrist-curls-muscles-1024x554-half.png',
  'Battle Rope ': 'assets/exercises/half/battle-rope-1024x353-half.png',
  'Behind The Back Shrug (Barbell)':
      'assets/exercises/half/behind-the-back-shrug-muscles-1024x664-half.png',
  'Belt Squat': 'assets/exercises/half/belt-squat-muscles-1024x581-half.png',
  'Bench Dip ': 'assets/exercises/half/bench-dip-1024x451-half.png',
  'Bicycle Crunch ': 'assets/exercises/half/bicycle-crunch-1024x293-half.png',
  'Block Pull Deadlift (Barbell)':
      'assets/exercises/half/block-pull-deadlift-muscles-1024x643-half.png',
  'Body Saw Plank':
      'assets/exercises/half/body-saw-plank-muscles-1024x167-half.png',
  'Hip Thrust (Bodyweight)':
      'assets/exercises/half/bodyweight-hip-thrust-muscles-1024x394-half.png',
  'Lunge (Bodyweight)':
      'assets/exercises/half/bodyweight-lunge-1024x637-half.png',
  'Split Squat (Bodyweight)':
      'assets/exercises/half/bodyweight-split-squat-muscles-1024x713-half.png',
  'Squat (Bodyweight)':
      'assets/exercises/half/bodyweight-squat-1024x720-half.png',
  'Walking Lunge (Bodyweight)':
      'assets/exercises/half/bodyweight-walking-lunge-muscles-1024x413-half.png',
  'Crossover (Cable)':
      'assets/exercises/half/cable-crossover-1024x564-half.png',
  'Crunch (Cable)': 'assets/exercises/half/cable-crunch-1024x610-half.png',
  'Donkey Kickback (Cable)':
      'assets/exercises/half/cable-donkey-kickback-1024x471-half.png',
  'Face Pull (Cable)':
      'assets/exercises/half/cable-face-pull-muscles-1024x482-half.png',
  'Lat Pulldown (Cable)':
      'assets/exercises/half/cable-lat-pulldown-muscles-1024x688-half.png',
  'Lateral Raise (Cable)':
      'assets/exercises/half/cable-lateral-raise-muscles-1024x479-half.png',
  'Chest Fly (Cable)': 'assets/exercises/half/cable-machine-fly-half.png',
  'Pull Through (Cable)': 'assets/exercises/half/cable-pull-through-half.png',
  'Pullover (Cable)': 'assets/exercises/half/cable-pullover-1024x662-half.png',
  'Tricep Push Down (Cable)':
      'assets/exercises/half/cable-push-down-1024x786-half.png',
  'Rear Delt Row (Cable)':
      'assets/exercises/half/cable-rear-delt-row-muscles-1024x516-half.png',
  'Reverse Grip Pushdown (Cable)':
      'assets/exercises/half/cable-reverse-pushdown-1024x749-half.png',
  'Seated Rear Delt Fly (Cable)':
      'assets/exercises/half/cable-seated-rear-delt-fly-1024x715-half.png',
  'Seated Row (Cable)':
      'assets/exercises/half/cable-seated-row-muscles-1024x520-half.png',
  'Shoulder Press (Cable)':
      'assets/exercises/half/cable-shoulder-press-muscles-1024x768-half.png',
  'Shrug (Cable)':
      'assets/exercises/half/cable-shrug-muscles-1024x743-half.png',
  'Straight Arm Pulldown (Cable)':
      'assets/exercises/half/cable-straight-arm-pulldown-half.png',
  'Upright Row (Cable)':
      'assets/exercises/half/cable-upright-row-muscles-1024x727-half.png',
  'Y-Raise (Cable)': 'assets/exercises/half/cable-y-raise-1024x600-half.png',
  'Captains Chair Leg Raise':
      'assets/exercises/half/captains-chair-leg-raise-muscles-1024x596-half.png',
  'Chest Dip': 'assets/exercises/half/chest-dip-1024x694-half.png',
  'Chest Press': 'assets/exercises/half/chest-press-1024x673-half.png',
  'Chin Up': 'assets/exercises/half/chin-up-muscles-1024x724-half.png',
  'Close-Grip Bench Press (Barbell)':
      'assets/exercises/half/close-grip-bench-press-1024x490-half.png',
  'Close-Grip Lat Pulldown':
      'assets/exercises/half/close-grip-lat-pulldown-muscles-1024x699-half.png',
  'Close Grip Pull Up':
      'assets/exercises/half/close-grip-pull-up-muscles-1024x654-half.png',
  'Cobra Push Up ':
      'assets/exercises/half/cobra-push-up-spinal-extension-1024x335-half.png',
  'Concentration Curl (Dumbbell)':
      'assets/exercises/half/concentration-curl-1024x471-half.png',
  'Conventional Single Leg Squat':
      'assets/exercises/half/conventional-single-leg-squat-1024x763-half.png',
  'Crunch': 'assets/exercises/half/crunch-muscles-1024x260-half.png',
  'Hammer Curl (Dumbbell)':
      'assets/exercises/half/db-hammer-curl-1024x792-half.png',
  'Decline Bench Press (Barbell)':
      'assets/exercises/half/decline-bench-press-1024x566-half.png',
  'Decline Cable Fly':
      'assets/exercises/half/decline-cable-fly-1024x584-half.png',
  'Decline Crunch':
      'assets/exercises/half/decline-crunch-muscles-1024x456-half.png',
  'Decline Push-Up':
      'assets/exercises/half/decline-push-up-muscles-1024x252-half.png',
  'Decline Sit Up':
      'assets/exercises/half/decline-sit-up-muscles-1024x670-half.png',
  'Deficit Bulgarian Split Squat':
      'assets/exercises/half/deficit-bulgarian-split-squat-muscles-1024x628-half.png',
  'Deficit Deadlift':
      'assets/exercises/half/deficit-deadlift-muscles-1024x609-half.png',
  'Diamond Push-Up':
      'assets/exercises/half/diamond-push-up-muscles-1024x372-half.png',
  'Donkey Calf Raise':
      'assets/exercises/half/donkey-calf-raise-muscles-1024x397-half.png',
  'Bicep Curl (Dumbbell)':
      'assets/exercises/half/dumbbell-biceps-curl-1024x900-half.png',
  'Bulgarian Split Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-bulgarian-split-squat-muscles-1024x663-half.png',
  'Close Grip Press (Dumbbell)':
      'assets/exercises/half/dumbbell-close-grip-press-muscles-1024x689-half.png',
  'Deadlift (Dumbbell)':
      'assets/exercises/half/dumbbell-deadlift-muscles-1024x609-half.png',
  'Decline Bench Press (Dumbbell)':
      'assets/exercises/half/dumbbell-decline-bench-press-1024x596-half.png',
  'Belt Squat (Between Boxes)':
      'assets/exercises/half/belt-squat-between-boxes-muscles-used-1024x703-half.png',
  'Butterfly Sit Up':
      'assets/exercises/half/butterfly-sit-up-muscles-1024x270-half.png',
  'Face Pull (Dumbbell)':
      'assets/exercises/half/dumbbell-face-pull-muscles-1024x592-half.png',
  'Front Raise (Dumbbell)':
      'assets/exercises/half/dumbbell-front-raise-movement-1024x689-half.png',
  'Front Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-front-squat-muscles-1024x691-half.png',
  'Goblet Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-goblet-squat-1024x704-half.png',
  'Good Morning (Dumbbell)':
      'assets/exercises/half/dumbbell-good-morning-muscles-1024x766-half.png',
  'Hack Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-hack-squat-muscles-1024x779-half.png',
  'Hex Press (Dumbbell)':
      'assets/exercises/half/dumbbell-hex-press-muscles-1024x670-half.png',
  'Hip Thrust (Dumbbell)':
      'assets/exercises/half/dumbbell-hip-thrust-muscles-1024x363-half.png',
  'Pullover (Dumbbell)':
      'assets/exercises/half/dumbbell-pullover-1024x554-half.png',
  'Reverse Curl (Dumbbell)':
      'assets/exercises/half/dumbbell-reverse-curl-muscles-1024x732-half.png',
  'Reverse Wrist Curl (Dumbbell)':
      'assets/exercises/half/dumbbell-reverse-wrist-curl-1024x487-half.png',
  'Side Bend (Dumbbell)':
      'assets/exercises/half/dumbbell-side-bend-muscles-1024x746-half.png',
  'Skullcrushers (Dumbbell)':
      'assets/exercises/half/dumbbell-skull-crushers-1024x428-half.png',
  'Split Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-split-squat-muscles-1024x827-half.png',
  'Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-squat-muscles-1024x738-half.png',
  'Stiff Legged Deadlift (Dumbbell)':
      'assets/exercises/half/dumbbell-stiff-legged-deadlifts-muscles-1024x653-half.png',
  'Sumo Deadlift (Dumbbell)':
      'assets/exercises/half/dumbbell-sumo-deadlift-muscles-1024x791-half.png',
  'Sumo Goblet Squat (Dumbbell)':
      'assets/exercises/half/dumbbell-sumo-goblet-squat-muscles-1024x745-half.png',
  'Elevated Glute Bridge':
      'assets/exercises/half/elevated-glute-bridge-muscles-1024x285-half.png',
  'Elliptical': 'assets/exercises/half/elliptical-1024x560-half.png',
  'Bicep Curl (Ez Bar)':
      'assets/exercises/half/ez-barbell-curl-1024x731-half.png',
  'Farmers Walk': 'assets/exercises/half/farmers-walk-1024x553-half.png',
  'Glute Ham Raise': 'assets/exercises/half/glute-ham-raise-1024x693-half.png',
  'Handstand Push Up':
      'assets/exercises/half/handstand-pushup-muscles-760x1024-half.png',
  'Hanging Leg Raise':
      'assets/exercises/half/hanging-leg-raise-1024x712-half.png',
  'High Pulley Cable Curl':
      'assets/exercises/half/high-pulley-cable-curl-muscles-1024x512-half.png',
  'Incline Cable Fly':
      'assets/exercises/half/incline-cable-fly-muscles-1024x599-half.png',
  'Incline Curl (Dumbbell)':
      'assets/exercises/half/incline-dumbbell-biceps-curl-muscles-1024x594-half.png',
  'Incline Chest Fly (Dumbbell)':
      'assets/exercises/half/incline-dumbbell-fly-1024x620-half.png',
  'Incline Hammer Curl (Dumbbell)':
      'assets/exercises/half/incline-hammer-curl-muscles-1024x616-half.png',
  'Incline Push Up':
      'assets/exercises/half/incline-push-up-muscles-1024x507-half.png',
  'Inverted Row':
      'assets/exercises/half/inverted-row-movement-1024x557-half.png',
  'Goblet Squat (Kettlebell)':
      'assets/exercises/half/kettlebell-goblet-squat-930x1024-half.png',
  'Lateral Raise (Kettlebell)':
      'assets/exercises/half/kettlebell-lateral-raise-muscles-1024x658-half.png',
  'Overhead Squat (Kettlebell)':
      'assets/exercises/half/kettlebell-overhead-squat-muscles-1024x747-half.png',
  'Romanian Deadlift (Kettlebell)':
      'assets/exercises/half/kettlebell-romanian-deadlift-1024x686-half.png',
  'Side Squat (Kettlebell)':
      'assets/exercises/half/kettlebell-side-squat-muscles-1024x346-half.png',
  'Snatch (Kettlebell)':
      'assets/exercises/half/kettlebell-snatch-1024x506-half.png',
  'Squat (Kettlebell)':
      'assets/exercises/half/kettlebell-squat-muscles-1024x691-half.png',
  'Sumo Squat (Kettlebell)':
      'assets/exercises/half/kettlebell-sumo-squat-muscles-1024x669-half.png',
  'Swings (Kettlebell)':
      'assets/exercises/half/kettlebell-swings-1024x684-half.png',
  'Upright Row (Kettlebell)':
      'assets/exercises/half/kettlebell-upright-row-muscles-1024x717-half.png',
  'Lateral Raise (Machine)':
      'assets/exercises/half/lateral-raise-machine-muscles-1024x559-half.png',
  'Lever Back Extension (Machine)':
      'assets/exercises/half/lever-back-extension-1024x527-half.png',
  'Lever High Row (Machine)':
      'assets/exercises/half/lever-high-row-1024x692-half.png',
  'Lever Preacher Curl (Machine)':
      'assets/exercises/half/lever-preacher-curl-machine-half.png',
  'Lever Pullover (Machine)':
      'assets/exercises/half/lever-pullover-machine-muscles-1024x563-half.png',
  'Lever Reverse Hyperextension':
      'assets/exercises/half/lever-reverse-hyperextension-1024x498-half.png',
  'Low Cable Chest Fly ':
      'assets/exercises/half/low-cable-chest-fly-1024x564-half.png',
  'Muscle Up': 'assets/exercises/half/muscle-up-muscles-used-1024x604-half.png',
  'Negative Pull Up ':
      'assets/exercises/half/negative-pull-up-1024x481-half.png',
  'Neutral Grip Lateral Pulldown ':
      'assets/exercises/half/neutral-grip-lat-pulldown-muscles-1024x705-half.png',
  'Neutral Grip Pull Up ':
      'assets/exercises/half/neutral-grip-pull-up-muscles-1024x647-half.png',
  'Parallel Bar Dips':
      'assets/exercises/half/parallel-bar-dips-muscles-1024x762-half.png',
  'Pec Deck': 'assets/exercises/half/pec-deck-muscles-1024x794-half.png',
  'Pendlay Row ': 'assets/exercises/half/pendlay-row-1024x598-half.png',
  'Pistol Squat': 'assets/exercises/half/pistol-squat-1024x754-half.png',
  'Plance Dip Muscles':
      'assets/exercises/half/planche-dip-muscles-1024x513-half.png',
  'Pile Squat ': 'assets/exercises/half/plie-squat-1024x804-half.png',
  'Preacher Curl (Barbell)':
      'assets/exercises/half/preacher-curl-benefits-half.png',
  'Pronated Grip Cable Fly':
      'assets/exercises/half/pronated-grip-cable-fly-1024x467-half.png',
  'Pull Up': 'assets/exercises/half/pull-up-1024x907-half.png',
  'Rack Pull (Barbell)':
      'assets/exercises/half/rack-pull-mechanics-1024x675-half.png',
  'Reverse Pec Deck':
      'assets/exercises/half/reverse-pec-dec-muscles-1024x655-half.png',
  'Ring Dips': 'assets/exercises/half/ring-dips-muscles-1024x787-half.png',
  'Rope Climb': 'assets/exercises/half/rope-climb-muscles-506x1024-half.png',
  'Rowing': 'assets/exercises/half/rowing-1024x178-half.png',
  'Seated Calf Raise': 'assets/exercises/half/seated-calf-raise-half.png',
  'Single Leg Calf Raise':
      'assets/exercises/half/single-leg-calf-raise-muscles-1024x707-half.png',
  'Single Leg Deadlift (Barbell)':
      'assets/exercises/half/single-leg-deadlift-muscles-1024x502-half.png',
  'Sit Up': 'assets/exercises/half/sit-up-1024x344-half.png',
  'Calf Raise (Smith Machine)':
      'assets/exercises/half/smith-machine-calf-raise-1024x635-half.png',
  'Deadlift (Smith Machine)':
      'assets/exercises/half/smith-machine-deadlift-muscles-1024x665-half.png',
  'Squat (Smith Machine)':
      'assets/exercises/half/smith-machine-squat-1024x627-half.png',
  'Split Squat': 'assets/exercises/half/split-squat-muscles-1024x719-half.png',
  'Calf Raise (Bodyweight)':
      'assets/exercises/half/standing-bodyweight-calf-raise-1024x677-half.png',
  'Standing Leg Curl (Machine)':
      'assets/exercises/half/standing-leg-curl-1024x692-half.png',
  'Overhead Press (Barbell)':
      'assets/exercises/half/standing-military-press-half.png',
  'Step Down': 'assets/exercises/half/step-down-1024x734-half.png',
  'Stiff Legged Deadlift (Smith Machine)':
      'assets/exercises/half/stiff-legged-smith-deadlift-muscles-1024x650-half.png',
  'Straight Bar Cable Pushdown':
      'assets/exercises/half/straight-bar-cable-pushdown-muscles-956x1024-half.png',
  'Sumo Deadlift (Smith Machine)':
      'assets/exercises/half/sumo-smith-machine-deadlift-muscles-1024x610-half.png',
  'T-Bar Row (Barbell)':
      'assets/exercises/half/t-bar-row-muscles-1024x350-half.png',
  'Front Raise (Cable)':
      'assets/exercises/half/the-cable-front-raise-1024x832-half.png',
  'Deadlift (Kettlebell)':
      'assets/exercises/half/the-kettlebell-deadlift-1024x634-half.png',
  'Single Arm Swing (Kettlebell)':
      'assets/exercises/half/the-kettlebell-single-arm-swing-1024x684-half.png',
  'Split Squat (Kettlebell)':
      'assets/exercises/half/the-kettlebell-split-squat-1024x719-half.png',
  'Trap Bar Deadlift':
      'assets/exercises/half/trap-bar-deadlift-muscles-1024x518-half.png',
  'Tricep Dip': 'assets/exercises/half/tricep-dip-muscles-half.png',
  'Tricep Extension (Machine)':
      'assets/exercises/half/tricep-extension-machine-half.png',
  'Tricep Kickback (Dumbbell)':
      'assets/exercises/half/tricep-kickback-muscles-1024x670-half.png',
  'Upright Row (Barbell)': 'assets/exercises/half/upright-row-half.png',
  'V Bar Tricep Pushdown (Cable)':
      'assets/exercises/half/v-bar-tricep-pushdown-muscles-1024x684-half.png',
  'Wall Crunch': 'assets/exercises/half/wall-crunch-muscles-1024x639-half.png',
  'Wide Grip Lat Pulldown (Cable)':
      'assets/exercises/half/wide-grip-lat-pulldown-muscles-1024x721-half.png',
  'Wide Grip Pull Up':
      'assets/exercises/half/wide-grip-pull-up-muscles-1024x653-half.png',
  'Yates Row (Barbell)':
      'assets/exercises/half/yates-row-muscle-1024x657-half.png',
  'Zercher Bulgarian Split Squat (Barbell)':
      'assets/exercises/half/zercher-bulgarian-split-squat-muscles-1024x511-half.png',
  'Zercher Squat (Barbell)':
      'assets/exercises/half/zercher-squat-muscles-1024x664-half.png',
  'Zottman Curl':
      'assets/exercises/half/zottman-curl-muscles-1024x360-half.png',
  'Overhead Press (Dumbbell)':
      'assets/exercises/half/Standing-Overhead-Dumbbell-Shoulder-Press-3681395754-half.png',
  'Seated Overhead Press (Dumbbell)':
      'assets/exercises/half/seated-overhead-db-press-half.png',
  'Lateral Raise (Dumbbell)':
      'assets/exercises/half/dumbbell-lateral-raises-half.png',
  'Single Arm Lat Pulldown (Cable)':
      'assets/exercises/half/single-arm-lat-pulldown-half.png',
  'Seated Overhead Press (Barbell)':
      'assets/exercises/half/barbell-seated-overhead-press-half.png',
  'Lying Leg Curl': 'assets/exercises/half/lying-leg-curl-half.png',
  'Reverse Curl (Barbell)':
      'assets/exercises/half/barbell-reverse-curl-half.png',
};

List<Exercise> generateExerciseData() {
  List<Exercise> exerciseData = [];
  exerciseMap.forEach((
    key,
    value,
  ) {
    final int index = exerciseMap.keys.toList().indexOf(key);
    Exercise exercise = Exercise(
      id: index,
      name: key,
      imagePath: imageMap[key]!,
      halfImagePath: halfImageMap[key]!,
    );
    exercise.bodyPart.target = bodyPartData.firstWhere((element) {
      return element.name == value.keys.first;
    });
    exercise.category.target = categoryData.firstWhere((element) {
      return element.name == value.values.first;
    });
    exerciseData.add(exercise);
  });
  return exerciseData;
}
