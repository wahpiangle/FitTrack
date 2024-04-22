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

Map<String, List<String>> descriptionMap = {
  'Wide Grip Seated Row (Cable)': [
    "Sit on the rowing machine with your feet firmly planted on the footrests and your knees slightly bent.",
    "Grasp the wide grip handles with an overhand grip, making sure your palms are facing downward.",
    "Keep your back straight and your chest up, engaging your core muscles.",
    "Begin the exercise by pulling the handles towards your torso, squeezing your shoulder blades together.",
    "Focus on using your back muscles to initiate the movement, rather than relying on your arms.",
    "Keep your elbows close to your body as you pull the handles towards you, and avoid using excessive momentum.",
    "Pause for a moment when the handles are close to your torso, feeling the contraction in your back muscles.",
    "Slowly extend your arms back to the starting position, maintaining control throughout the movement.",
    "Repeat the exercise for the desired number of repetitions, ensuring proper form and technique.",
    " Remember to breathe steadily throughout the exercise, inhaling as you pull the handles towards you and exhaling as you extend your arms."
  ],
  'Chest Fly (Dumbbell)': [
    "Begin by lying flat on a bench with a dumbbell in each hand, palms facing inward towards each other.",
    "Start with the dumbbells extended above your chest, arms slightly bent, and elbows slightly below shoulder level.",
    "Lower the dumbbells out to the sides in a wide arc, maintaining a slight bend in your elbows.",
    "Keep your wrists stable throughout the movement, and avoid locking your elbows.",
    "Lower the dumbbells until you feel a stretch in your chest muscles, but avoid going too deep to prevent strain on your shoulder joints.",
    "Pause briefly at the bottom of the movement, feeling the stretch in your chest.",
    "Engage your chest muscles to bring the dumbbells back up to the starting position, following the same wide arc motion.",
    "Exhale as you bring the dumbbells back up, and inhale as you lower them down.",
    "Keep your core engaged and your back flat against the bench throughout the exercise to maintain stability.",
    " Repeat for the desired number of repetitions, ensuring smooth and controlled motion with each repetition.",
    " Avoid using momentum or swinging the dumbbells; instead, focus on using your chest muscles to move the weight."
  ],
  'Incline Bench Press (Dumbbell)': [
    "Lie back on an incline bench with a dumbbell in each hand, resting on your thighs. ",
    "Use your thighs to help push the dumbbells up to shoulder width. ",
    "Once at shoulder width, rotate your wrists forward so that the palms of your hands are facing away from you. This will be your starting position. ",
    "As you breathe in, lower the dumbbells slowly to the sides of your chest. Keep your elbows at a 45-degree angle to your body. ",
    "At the bottom of the movement, pause for a second and then push the dumbbells back up to the starting position as you breathe out. ",
    "Lock your arms at the top of the lift and squeeze your chest, hold for a second and then begin coming down slowly again. ",
    "Repeat for the recommended amount of repetitions."
  ],
  'Rear Delt Fly (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand, palms facing inwards towards your body.",
    "Bend your knees slightly and hinge forward at the hips, maintaining a straight back and keeping your core engaged.",
    "Extend your arms straight down towards the floor, with a slight bend in your elbows. This is your starting position.",
    "Keeping your back straight and your core engaged, exhale and lift both arms out to the sides, squeezing your shoulder blades together as you do so.",
    "Continue to raise your arms until they are parallel to the floor, forming a \"T\" shape with your body. Keep your elbows slightly bent throughout the movement.",
    "Pause for a moment at the top of the movement, focusing on squeezing your rear delts.",
    "Inhale and slowly lower the dumbbells back to the starting position, maintaining control and keeping your back straight.",
    "Repeat for the desired number of repetitions."
  ],
  'Hack Squat': [
    "Stand with your feet shoulder-width apart, toes slightly pointed outwards.",
    "Lower your body down by bending your knees, keeping your back straight and chest up.",
    "Squat down until your thighs are parallel to the ground or lower if you can.",
    "Push through your heels to return to the starting position.",
    "Repeat for the desired number of reps.",
    "Focus on engaging your quadriceps, hamstrings, and glutes throughout the exercise."
  ],
  'Lat Pulldown (Cable)': [
    "Stand in front of the lat pulldown machine and adjust the thigh pad so that it rests comfortably on your thighs.",
    "Grasp the wide bar attachment with an overhand grip, slightly wider than shoulder-width apart.",
    "Sit down on the seat and position your knees under the thigh pad, keeping your feet flat on the floor.",
    "Keep your back straight and your chest up, engaging your core muscles.",
    "Pull your shoulder blades down and back, creating a slight arch in your lower back.",
    "Begin the exercise by pulling the bar down towards your upper chest, leading with your elbows.",
    "Keep your elbows pointed out to the sides and focus on squeezing your shoulder blades together as you pull the bar down.",
    "Continue pulling until the bar is just below your chin or touches your upper chest.",
    "Pause for a moment, feeling the contraction in your back muscles.",
    " Slowly release the bar back to the starting position, allowing your arms to fully extend.",
    " Repeat the movement for the desired number of repetitions.",
    " Remember to breathe throughout the exercise, exhaling as you pull the bar down and inhaling as you release it back up.",
    " Maintain control and avoid using momentum to perform the exercise.",
    " Adjust the weight as needed to ensure proper form and challenge yourself appropriately.",
    " To target different areas of your back, you can also try using different grip attachments, such as a narrow grip or a V-bar attachment."
  ],
  'Leg Extension': [
    "Sit on a leg extension machine with your back against the backrest and your feet flat on the foot pad.",
    "Adjust the machine so that the foot pad is positioned just above your ankles.",
    "Grasp the handles on the sides of the seat for stability.",
    "Engage your core muscles and maintain an upright posture throughout the exercise.",
    "Slowly extend your legs in front of you by straightening your knees, pushing against the foot pad.",
    "Continue extending your legs until they are fully straightened, but avoid locking your knees.",
    "Pause for a brief moment at the top of the movement, focusing on squeezing your quadriceps (front thigh muscles).",
    "Slowly lower the weight back to the starting position by bending your knees and allowing the foot pad to return towards your body.",
    "Repeat the movement for the desired number of repetitions.",
    " Breathe steadily throughout the exercise, inhaling as you lower the weight and exhaling as you extend your legs.",
    " Maintain control and avoid using momentum to swing the weight up or down."
  ],
  'Single Arm Bent Over Row (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in one hand.",
    "Hinge at the hips and bend your knees slightly, keeping your back straight and chest up.",
    "Let the dumbbell hang at arm's length towards the floor, palm facing your body.",
    "Pull the dumbbell up towards your hip, keeping your elbow close to your body and squeezing your shoulder blade at the top of the movement.",
    "Lower the dumbbell back down towards the floor in a controlled manner.",
    "Complete the desired number of reps on one side before switching to the other arm."
  ],
  'Standing Calf Raise (Machine)': [
    "Stand on the calf raise machine with your shoulders positioned under the pads and your toes pointing forward.",
    "Keep your core engaged and your back straight throughout the exercise.",
    "Slowly lower your heels towards the ground, feeling a stretch in your calf muscles.",
    "Push through your toes to raise your heels as high as you can, contracting your calf muscles at the top of the movement.",
    "Hold for a second at the top, then slowly lower your heels back down to the starting position.",
    "Repeat for the desired number of repetitions, focusing on controlled movements and full range of motion."
  ],
  'Cross Body Hammer Curl': [
    "Stand up straight with a dumbbell in each hand, palms facing your body. This is your starting position.",
    "Keep your upper arms stationary and exhale as you curl the right dumbbell across your body towards your left shoulder. Your forearm should be perpendicular to the floor at the top of the movement. Hold the contracted position for a brief pause as you squeeze your biceps.",
    "Inhale as you slowly lower the dumbbell back to the starting position in a controlled manner.",
    "Repeat the movement with the left dumbbell, curling it across your body towards your right shoulder. Again, hold the contracted position for a brief pause before lowering it back down.",
    "Continue alternating arms for the desired number of repetitions.",
    "Remember to keep your elbows close to your torso and only move your forearms during the exercise. Avoid using your shoulders or upper body to lift the weights.",
    "Perform the exercise in a slow and controlled manner, focusing on the contraction of your biceps.",
    "Aim for a full range of motion, ensuring that you fully extend your arms at the bottom of each repetition and fully contract your biceps at the top.",
    "Adjust the weight of the dumbbells according to your fitness level and gradually increase the resistance as you become stronger.",
    " Complete the recommended number of sets and repetitions for an effective workout."
  ],
  'Arnold Press (Dumbbell)': [
    "Stand upright with your feet shoulder-width apart, holding a dumbbell in each hand. Your palms should be facing your body, and your elbows should be bent at a 90-degree angle, with the dumbbells positioned near your shoulders.",
    "Begin the movement by simultaneously rotating your palms away from your body, so they are facing forward. This is your starting position.",
    "As you exhale, press the dumbbells overhead by extending your arms fully. Continue to rotate your palms during the movement, so they end up facing forward at the top of the press.",
    "Pause briefly at the top of the movement, ensuring your arms are fully extended and the dumbbells are directly above your head.",
    "Inhale and slowly lower the dumbbells back to the starting position, while simultaneously rotating your palms back towards your body.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Assisted Dip': [
    "Stand facing the dip machine with your hands gripping the handles at shoulder width.",
    "Jump or step up onto the platform, allowing your body to hang freely with your arms fully extended.",
    "Keeping your chest up and shoulders back, slowly lower your body by bending your elbows until your upper arms are parallel to the ground.",
    "Push through your palms to straighten your arms and return to the starting position.",
    "Repeat for the desired number of reps, making sure to keep your core engaged and your body in a straight line throughout the movement."
  ],
  'Assisted Inverse Leg Curl': [
    "Begin by lying face down on a leg curl machine with your legs extended straight out behind you.",
    "Position yourself so that the pad of the machine rests just above your Achilles tendon.",
    "Place your hands on the handles or grips provided on the machine to stabilize your upper body.",
    "Engage your core muscles and keep your upper body flat on the machine throughout the exercise.",
    "Bend your knees and curl your legs upward towards your glutes, focusing on using your hamstrings to initiate the movement.",
    "As you curl your legs, exhale and squeeze your hamstrings at the top of the movement.",
    "Slowly lower your legs back to the starting position, maintaining control and tension in your hamstrings.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to maintain a controlled and smooth motion throughout the exercise, avoiding any jerking or swinging motions.",
    " Adjust the weight or resistance on the machine as needed to suit your fitness level and goals"
  ],
  'Assisted Pull Up (Machine)': [
    "Begin by grasping the handles or bar of the assisted pull-up machine with an overhand grip, palms facing away from you.",
    "Position your knees on the padding provided on the machine, and extend your arms fully to support your body weight.",
    "Engage your core and back muscles, and slowly pull your body up towards the handles or bar. Focus on squeezing your shoulder blades together as you lift yourself up.",
    "Continue to pull yourself up until your chin is level with or slightly above the bar.",
    "Pause at the top of the movement, then slowly lower yourself back down to the starting position with control.",
    "Repeat for the desired number of repetitions, aiming to maintain proper form throughout the exercise. ",
    "Remember to breathe consistently and avoid using momentum to lift yourself up."
  ],
  'Back Extension': [
    "Lie face down on a mat or flat surface, with your legs extended straight and your arms resting alongside your body.",
    "Position your hands either by your temples or crossed over your chest, whichever feels more comfortable.",
    "Engage your core muscles by gently drawing your navel towards your spine.",
    "Begin the movement by slowly lifting your upper body off the ground, using your lower back muscles. Keep your neck in a neutral position, avoiding any strain or tension.",
    "Continue lifting until your upper body is in line with your legs, or until you feel a comfortable stretch in your lower back.",
    "Hold the position for a brief moment, focusing on squeezing your lower back muscles.",
    "Slowly lower your upper body back down to the starting position, maintaining control throughout the movement.",
    "Repeat the exercise for the desired number of repetitions."
  ],
  'Bent Over Row (Band)': [
    "Stand with your feet shoulder-width apart, knees slightly bent, and band securely anchored beneath your feet.",
    "Hinge at your hips and bend your upper body forward until it is almost parallel to the ground. Keep your back straight and core engaged.",
    "Grab the handles of the band with an overhand grip, palms facing towards you.",
    "Keep your elbows close to your body and pull the handles towards your lower ribcage, squeezing your shoulder blades together at the top of the movement.",
    "Slowly lower the handles back down to the starting position with control, keeping tension on the band the entire time.",
    "Repeat for the desired number of reps, making sure to maintain proper form throughout the exercise."
  ],
  'Band Hip Abduction': [
    "Lie on your side on the floor with your legs straight and your bottom arm tucked under your head for support.",
    "Keep your top leg straight and slowly lift it up as high as you can without rotating your hips.",
    "Hold the top position for a second, then slowly lower your leg back down to the starting position.",
    "Repeat for the desired number of reps, then switch to the other side and repeat the exercise on the opposite leg. ",
    "Make sure to engage your core muscles and keep your hips stable throughout the movement. ",
    "To further challenge yourself, add a resistance band around your thighs just above your knees to increase the resistance and intensity of the exercise."
  ],
  'Lat Pulldown (Band)': [
    "Stand with your feet shoulder-width apart and firmly plant them on the ground.",
    "Hold the resistance band with both hands, ensuring that your palms are facing away from you.",
    "Extend your arms fully overhead, keeping a slight bend in your elbows.",
    "Engage your core and maintain a straight posture throughout the exercise.",
    "Begin the movement by pulling the band down towards your chest, leading with your elbows.",
    "Keep your elbows close to your body and squeeze your shoulder blades together as you pull the band down.",
    "Continue pulling until your hands are positioned just above your chest.",
    "Pause for a moment, feeling the contraction in your back muscles.",
    "Slowly release the tension in the band and return to the starting position with your arms fully extended overhead.",
    " Repeat the exercise for the desired number of repetitions, focusing on maintaining proper form and control throughout the movement.",
    " Remember to breathe steadily throughout the exercise, inhaling during the upward phase and exhaling during the downward phase."
  ],
  'Lying Hamstring Curl (Band)': [
    "Lie flat on your stomach on a comfortable surface, such as a yoga mat or exercise mat.",
    "Loop a resistance band around your ankles and make sure it is securely in place.",
    "Extend your legs fully and keep them straight.",
    "Place your hands under your chin or by your sides for support.",
    "Engage your core muscles by pulling your belly button towards your spine.",
    "Slowly bend your knees and bring your heels towards your glutes, while keeping your upper legs on the mat.",
    "Pause for a moment at the top of the movement, squeezing your hamstrings.",
    "Slowly lower your legs back to the starting position, fully extending them.",
    "Repeat the movement for the desired number of repetitions.",
    " Focus on maintaining control throughout the exercise and avoid using momentum.",
    " Breathe steadily throughout the movement, inhaling as you lower your legs and exhaling as you curl them up.",
    " Adjust the resistance of the band as needed to challenge yourself appropriately.",
    " Perform the exercise at a controlled pace, aiming for a smooth and fluid motion.",
    " Remember to listen to your body and stop if you experience any pain or discomfort.",
    " Incorporate this exercise into your leg or hamstring workout routine, aiming for 2-3 sets of 10-15 repetitions."
  ],
  'Overhead Tricep Extension (Band)': [
    "Stand with your feet shoulder-width apart on the center of the resistance band, holding one end of the band in each hand.",
    "Raise your hands overhead, keeping your elbows close to your ears and your palms facing each other.",
    "Slowly lower your hands behind your head, bending at the elbows to lower the resistance band behind your head.",
    "Keep your core engaged and your back straight throughout the movement.",
    "Once your elbows are at a 90-degree angle, pause for a moment before slowly extending your arms back to the starting position.",
    "Repeat for the desired number of repetitions, ensuring you maintain proper form throughout the exercise."
  ],
  'Shoulder Extension (Band)': [
    "Begin by holding one end of a resistance band in each hand, with your palms facing inward and the band placed behind your back.",
    "Keeping your arms straight, slowly lift your hands upwards towards the ceiling, while simultaneously pulling the band apart to create tension.",
    "Hold the top position for a brief moment, focusing on squeezing your shoulder blades together.",
    "Slowly lower your hands back down to starting position, keeping tension on the band throughout the movement.",
    "Repeat for the desired number of repetitions, focusing on maintaining good posture and control throughout the exercise."
  ],
  'Band Shoulder Flexion': [
    "Stand with your feet hip-width apart and hold a resistance band in both hands.",
    "Start with your arms by your sides and palms facing your body.",
    "Slowly raise both arms straight out in front of you, keeping a slight bend in your elbows.",
    "Continue to raise your arms until they are parallel to the ground, or as high as you can comfortably go.",
    "Hold this position for a brief moment, then slowly lower your arms back down to the starting position.",
    "Repeat for the desired number of repetitions."
  ],
  'Tricep Pushdown (Band)': [
    "Stand facing the anchor point with your feet shoulder-width apart and your knees slightly bent.",
    "Grasp the band with both hands, palms facing down, and bring your hands up to shoulder height.",
    "Keep your elbows close to your sides and your upper arms stationary as you extend your forearms down towards the floor.",
    "Pause briefly at the bottom of the movement, then slowly return to the starting position.",
    "Repeat for the desired number of repetitions."
  ],
  'Face Pull (Band)': [
    "Begin by attaching a resistance band to a sturdy anchor point at chest height. You can use a door frame, a pole, or any other secure structure.",
    "Stand facing the anchor point and hold the resistance band with both hands. Your palms should be facing each other, and your hands should be shoulder-width apart.",
    "Take a step back to create tension in the band. Your arms should be fully extended in front of you, and your feet should be shoulder-width apart.",
    "Engage your core and maintain a neutral spine throughout the exercise. Keep your chest up and your shoulders relaxed.",
    "Start the movement by retracting your shoulder blades. Squeeze your shoulder blades together as you pull the band towards your face. Your elbows should be pointing out to the sides.",
    "Continue pulling until your hands are beside your temples or slightly behind your head. Keep your elbows high and in line with your shoulders.",
    "Pause for a moment at the end position, feeling the contraction in your upper back muscles.",
    "Slowly reverse the movement, extending your arms back to the starting position. Maintain control and tension in the band throughout the entire exercise.",
    "Repeat for the desired number of repetitions",
    ""
  ],
  'Bent Over Row (Barbell)': [
    "Stand with your feet shoulder-width apart, knees slightly bent, and hold a barbell with an overhand grip. Your hands should be slightly wider than shoulder-width apart.",
    "Bend forward at your hips, keeping your back straight and chest up. Your torso should be almost parallel to the floor, and your arms should be fully extended, hanging straight down from your shoulders.",
    "Engage your core and squeeze your shoulder blades together to stabilize your upper body.",
    "Exhale and pull the barbell up towards your lower chest, keeping your elbows close to your body. Focus on using your back muscles to initiate the movement, rather than relying on your arms.",
    "Pause for a moment at the top of the movement, squeezing your back muscles.",
    "Inhale and slowly lower the barbell back to the starting position, fully extending your arms.",
    "Repeat for the desired number of repetitions."
  ],
  'Box Squat (Barbell)': [
    "Start by standing with your feet shoulder-width apart, toes slightly pointed outwards. Place a barbell across your upper back, resting it on your trapezius muscles. Make sure to grip the barbell firmly with both hands, slightly wider than shoulder-width apart.",
    "Take a deep breath and brace your core muscles. This will help stabilize your spine throughout the movement.",
    "Begin the squat by pushing your hips back and bending your knees. Imagine sitting back onto an imaginary chair. Keep your chest up and your back straight throughout the movement.",
    "Continue descending until your thighs are parallel to the ground or slightly below. It's important to maintain proper form and not let your knees cave inwards or extend past your toes.",
    "Pause briefly at the bottom of the squat, ensuring you maintain tension in your muscles.",
    "Push through your heels and drive your hips forward to initiate the ascent. Keep your chest up and back straight as you rise.",
    "Continue to extend your hips and knees until you reach the starting position, fully standing upright.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Bicep Curl (Barbell)': [
    "Stand up straight with your feet shoulder-width apart and grasp the barbell with an underhand grip, hands slightly wider than shoulder-width apart. Your palms should be facing upward.",
    "Keep your upper arms close to your sides, engage your core, and maintain a straight back throughout the exercise.",
    "Begin the movement by bending your elbows and curling the barbell upwards towards your shoulders. Keep your wrists straight and avoid using your back or shoulders to lift the weight.",
    "Continue curling until your biceps are fully contracted and the barbell is at shoulder level. Squeeze your biceps at the top of the movement for a brief pause.",
    "Slowly lower the barbell back down to the starting position, fully extending your arms. Maintain control and avoid swinging or using momentum to lift the weight.",
    "Repeat the movement for the desired number of repetitions, focusing on maintaining proper form and control throughout the exercise.",
    "Remember to breathe steadily throughout the exercise, exhaling as you curl the weight up and inhaling as you lower it back down.",
    "Once you have completed the set, carefully place the barbell back down and rest before performing additional sets or moving on to other exercises."
  ],
  'Romanian Deadift (Barbell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Place the barbell on the floor in front of you, ensuring it is centered and loaded with an appropriate weight.",
    "Bend your knees slightly and hinge forward at the hips, maintaining a neutral spine. Engage your core and keep your back straight throughout the movement.",
    "Reach down and grip the barbell with an overhand grip, hands slightly wider than shoulder-width apart. Your palms should be facing your body.",
    "Take a deep breath, brace your core, and lift the barbell by extending your hips and standing up straight. Keep your arms straight and allow the barbell to hang in front of your thighs.",
    "Begin the descent by pushing your hips back and bending at the hips, allowing the barbell to slide down your thighs. Keep your back straight and maintain tension in your hamstrings and glutes.",
    "Lower the barbell until you feel a stretch in your hamstrings, but avoid rounding your back or allowing the barbell to touch the ground.",
    "Pause for a moment at the bottom of the movement, then reverse the motion by driving your hips forward and standing up straight. Keep the barbell close to your body throughout the ascent.",
    "Repeat the movement for the desired number of repetitions, maintaining proper form and control. Exhale as you reach the top of the movement and inhale as you descend."
  ],
  'Floor Press (Barbell)': [
    "Lie flat on your back on a bench with your feet planted firmly on the ground.",
    "Position yourself in a way that your eyes are directly under the barbell.",
    "Reach up and grip the barbell with your palms facing away from you, slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack and hold it directly above your chest with your arms fully extended.",
    "Slowly lower the barbell towards your chest, keeping your elbows tucked in close to your body.",
    "Once the barbell touches your chest, pause for a brief moment.",
    "Push the barbell back up to the starting position by extending your arms, while maintaining control and stability.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to breathe throughout the exercise, inhaling as you lower the barbell and exhaling as you push it back up.",
    " Once you have completed your set, carefully rack the barbell back onto the rack."
  ],
  'Front Squat (Barbell)': [
    "Start by standing with your feet shoulder-width apart, toes slightly turned out. Place the barbell on the front of your shoulders, resting it across your collarbone and shoulders. Your palms should be facing upwards, and your elbows should be pointing forward.",
    "Engage your core and keep your chest up. Take a deep breath in.",
    "Begin the movement by pushing your hips back and bending your knees. Lower your body down into a squatting position, keeping your weight on your heels.",
    "Continue descending until your thighs are parallel to the ground, or as low as your flexibility allows. Make sure to maintain an upright torso throughout the movement.",
    "Pause for a moment at the bottom of the squat, then exhale and drive through your heels to push yourself back up to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Good Morning (Barbell)': [
    "Start by placing a barbell on your upper back, across your trapezius muscles. Make sure to grip the bar with both hands slightly wider than shoulder-width apart.",
    "Stand with your feet shoulder-width apart and toes pointing slightly outward.",
    "Take a deep breath and brace your core muscles to stabilize your spine.",
    "Begin the movement by hinging at your hips, pushing your buttocks backward as if you are trying to touch the wall behind you with your glutes. Keep your back straight and maintain a slight arch in your lower back throughout the exercise.",
    "Continue to lower your torso forward until it is parallel to the floor or slightly below, feeling a stretch in your hamstrings. Keep your knees slightly bent and avoid locking them.",
    "Pause for a moment at the bottom position, then exhale and engage your glutes and hamstrings to reverse the movement.",
    "Push your hips forward and return to the starting position by extending your hips and standing tall.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Hack Squat (Barbell)': [
    "Stand with your feet shoulder-width apart underneath the barbell with your toes slightly pointing outwards.",
    "Bend your knees and lower your body down to grab the barbell with both hands, keeping your back straight and chest up.",
    "Push through your heels and drive the barbell upwards by extending your legs and straightening your knees.",
    "Lower the barbell back down by bending your knees and lowering your body until your thighs are parallel to the ground or below.",
    "Repeat for the desired number of repetitions, focusing on maintaining proper form and control throughout the exercise."
  ],
  'Hang Clean & Jerk (Barbell)': [
    "Start by standing with your feet shoulder-width apart, toes pointing slightly outward. Place the barbell in front of you, resting it on your thighs, with an overhand grip (palms facing down) slightly wider than shoulder-width apart.",
    "Bend your knees slightly and hinge forward at the hips, keeping your back straight and chest up. This is the starting position, known as the hang position.",
    "Explosively extend your hips, knees, and ankles, driving the barbell upward. As you do this, shrug your shoulders and pull the barbell as high as possible, keeping it close to your body.",
    "Once the barbell reaches its highest point, quickly drop underneath it by bending your knees and hips, while simultaneously rotating your elbows forward.",
    "Catch the barbell on the front of your shoulders, with your elbows pointing forward and your upper arms parallel to the ground. Your feet should be in a split stance, with one foot slightly forward and the other foot slightly back.",
    "From the split stance position, quickly stand up by extending your legs and driving through your front foot. As you do this, press the barbell overhead by fully extending your arms.",
    "Lock out your elbows and stabilize the barbell overhead. Your feet should now be together, and your body should be in a straight line from head to toe.",
    "To complete the exercise, lower the barbell back to the front of your shoulders, then lower it down to the hang position by bending your knees and hips. Repeat the movement for the desired number of repetitions."
  ],
  'Hip Thrust (Barbell)': [
    "Start by sitting on the ground with your back against a bench or a sturdy elevated surface. Place a barbell across your hips, ensuring it is securely positioned.",
    "Bend your knees and position your feet flat on the ground, hip-width apart. Your toes should be pointing forward or slightly outward.",
    "Engage your core muscles and press your upper back firmly against the bench or surface for stability.",
    "Begin the movement by driving through your heels and lifting your hips off the ground. Push your hips upward until your thighs and torso are in a straight line, parallel to the ground.",
    "Squeeze your glutes at the top of the movement and hold for a brief pause to maximize the contraction.",
    "Slowly lower your hips back down to the starting position, maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions, focusing on maintaining proper form and engaging your glutes throughout the exercise."
  ],
  'Lying Skullcrusher (Barbell)': [
    "Start by lying flat on a bench with your feet firmly planted on the ground.",
    "Hold a barbell with an overhand grip, hands shoulder-width apart, extending your arms straight up towards the ceiling.",
    "Keep your elbows in a fixed position and slowly lower the barbell towards your forehead by bending your elbows.",
    "Lower the barbell until your elbows are at a 90-degree angle or slightly below, ensuring your upper arms remain perpendicular to the floor.",
    "Engage your triceps to extend your arms and raise the barbell back to the starting position.",
    "Repeat for the desired number of repetitions, being mindful to control the movement and avoid using momentum."
  ],
  'Overhead Squat (Barbell)': [
    "Start with the barbell positioned on your upper back, gripping it with both hands slightly wider than shoulder-width apart.",
    "Stand with your feet shoulder-width apart, toes pointed slightly outward.",
    "Engage your core and keep your chest up as you begin to squat down, pushing your hips back and bending your knees.",
    "Continue squatting down until your thighs are parallel to the ground, or as low as you can comfortably go while maintaining good form.",
    "As you squat down, make sure to keep the barbell positioned over your head, with your arms fully extended.",
    "Press through your heels to return to the starting position, standing up and extending your hips fully.",
    "Repeat for the desired number of reps, focusing on maintaining proper form and control throughout the movement."
  ],
  'Pin Squat  (Barbell)': [
    "Stand with your feet shoulder-width apart and the barbell resting on the pins of a squat rack at knee height.",
    "Position yourself under the barbell with your back straight and core engaged.",
    "Grasp the barbell with an overhand grip slightly wider than shoulder-width.",
    "Drive through your heels and lift the barbell off the pins, standing up into a fully upright position.",
    "Take a deep breath in, brace your core, and slowly lower yourself down into a squat position. Keep your chest up and back straight.",
    "Lower yourself until your thighs are parallel to the ground, or as low as you can comfortably go.",
    "Push through your heels and drive yourself back up to the starting position, keeping your core tight throughout the movement.",
    "Repeat for the desired number of repetitions."
  ],
  'Pullover (Barbell)': [
    "Lie down on a flat bench with your feet planted firmly on the ground and your back pressed against the bench.",
    "Grasp the barbell with an overhand grip, slightly wider than shoulder-width apart.",
    "Hold the barbell directly above your chest with your arms extended.",
    "Keeping your arms straight, slowly lower the barbell behind your head in a controlled motion until you feel a stretch in your chest and lats.",
    "Pause for a moment at the bottom of the movement, then slowly raise the barbell back to the starting position, using your chest and lats to pull the weight back up.",
    "Repeat for the desired number of repetitions, being mindful to keep your core engaged and your back pressed against the bench throughout the exercise."
  ],
  'Reverse Wrist Curl (Barbell)': [
    "Stand up straight with your feet shoulder-width apart and hold a barbell with an overhand grip (palms facing down). Your hands should be slightly wider than shoulder-width apart.",
    "Rest your forearms on a flat bench or any stable surface, with your wrists hanging off the edge and the barbell resting on top of your hands.",
    "Keep your forearms stationary throughout the exercise. This will be your starting position.",
    "Slowly lower the barbell by allowing your wrists to flex, allowing it to roll down towards your fingertips. This is the eccentric phase of the exercise.",
    "Once your wrists are fully flexed and the barbell is at the base of your fingers, pause for a brief moment.",
    "Begin the concentric phase by contracting your wrist extensors (the muscles on the back of your forearms) to lift the barbell back up towards your forearms.",
    "Continue curling the barbell up until your wrists are fully extended, and the barbell is resting on top of your hands again.",
    "Pause briefly at the top, squeezing your wrist extensors.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to maintain control throughout the exercise, avoiding any jerking or swinging motions."
  ],
  'Shrug (Barbell)': [
    "Stand with your feet shoulder-width apart and position a barbell in front of you at thigh level. ",
    "Bend your knees slightly and maintain a straight back throughout the exercise. ",
    "Reach down and grip the barbell with an overhand grip, slightly wider than shoulder-width apart. ",
    "Lift the barbell by extending your hips and knees, keeping your arms fully extended. ",
    "As you lift the barbell, focus on contracting your shoulder muscles. ",
    "Once the barbell is fully lifted, hold the position for a brief moment, squeezing your shoulder blades together. ",
    "Slowly lower the barbell back to the starting position, maintaining control throughout the movement. ",
    "Repeat the exercise for the desired number of repetitions."
  ],
  'Split Squat (Barbell)': [
    "Start by standing in a split stance, with one foot forward and one foot back. The back foot should be resting on a bench or step, with the top of your foot facing down.",
    "Hold a barbell across your upper back with both hands, palms facing forward. Make sure your chest is lifted and your core is engaged.",
    "Lower your body down by bending your front knee, ensuring it stays in line with your toes. Your back knee should come close to the ground but not touch it.",
    "Keep your weight in your front heel as you push back up to the starting position. Make sure to keep your torso upright and avoid leaning forward.",
    "Repeat for the desired number of reps on one side before switching to the other side.",
    "Focus on maintaining good form throughout the exercise, keeping your chest lifted and your core engaged."
  ],
  'Squats (Barbell)': [
    "Stand with your feet shoulder-width apart and the barbell resting on your upper back, just below your neck.",
    "Engage your core and keep your chest up as you lower your body by bending your knees and pushing your hips back.",
    "Lower yourself until your thighs are parallel to the ground, or as low as you can comfortably go.",
    "Keep your weight in your heels and push through them as you straighten your legs to return to the starting position.",
    "Repeat for the desired number of reps, making sure to maintain proper form throughout the exercise."
  ],
  'Squat Clean (Barbell)': [
    "Start with the barbell on the ground in front of you, feet hip-width apart and toes pointing slightly outwards.",
    "Squat down and grip the barbell with hands slightly wider than shoulder-width apart, palms facing towards you.",
    "Keep your chest up and back straight, engage your core and lift the barbell off the ground by driving through your heels.",
    "As the barbell passes your knees, explosively extend your hips, knees, and ankles to propel the barbell upwards.",
    "Pull yourself under the barbell by quickly dropping into a squat position, catching the barbell on your shoulders in a front rack position with your elbows high.",
    "Stand up tall with the barbell resting on your shoulders, maintaining a tight core and straight back.",
    "Lower the barbell back to the ground by reversing the movement - squatting down and releasing your grip on the barbell.",
    "Repeat the movement for the desired number of reps, ensuring proper form and technique throughout the exercise."
  ],
  'Step Up (Barbell)': [
    "Begin by standing in front of a bench or step with a barbell resting on your shoulders.",
    "Place one foot on the bench or step, ensuring that your entire foot is firmly planted on the surface.",
    "Push through your heel and lift your body up onto the bench or step, bringing your other foot up to meet the first foot.",
    "Step back down with the same foot you started with, followed by the other foot.",
    "Repeat for the desired number of repetitions, then switch legs and repeat the exercise on the other side.",
    "Keep your core engaged and your back straight throughout the exercise to maintain proper form and prevent injury.",
    "Adjust the weight of the barbell as needed to challenge yourself appropriately."
  ],
  'Stiff Legged Deadlift (Barbell)': [
    "Stand with your feet shoulder-width apart, toes pointing forward, and the barbell placed in front of you on the floor. Your knees should be slightly bent.",
    "Bend at the hips and lower your upper body, keeping your back straight and your core engaged. Your knees should remain slightly bent throughout the movement.",
    "Grasp the barbell with an overhand grip, hands slightly wider than shoulder-width apart. Your palms should be facing down.",
    "Take a deep breath, brace your core, and lift the barbell by extending your hips and standing up straight. Keep your back straight and your shoulders pulled back.",
    "As you lift, focus on using your glutes and hamstrings to drive the movement. Avoid using your lower back to prevent injury.",
    "Once you reach a standing position, pause for a moment, squeezing your glutes at the top of the movement.",
    "Slowly lower the barbell back down by hinging at the hips, keeping your back straight and your core engaged. Maintain control throughout the descent.",
    "Continue lowering the barbell until it reaches just below your knees or until you feel a stretch in your hamstrings.",
    "Repeat the movement for the desired number of repetitions, maintaining proper form and control throughout.",
    " Once you have completed the set, carefully place the barbell back on the floor."
  ],
  'Sumo Deadlift (Barbell)': [
    "Stand with your feet wider than hip-width apart, toes pointing slightly outward.",
    "Bend at the hips and knees to grip the barbell with an overhand grip, hands shoulder-width apart.",
    "Keep your back straight and chest up, engage your core muscles.",
    "Drive through your heels and lift the barbell by extending your hips and knees simultaneously.",
    "Pull your shoulders back and keep the barbell close to your body as you stand up straight.",
    "Slowly lower the barbell back to the ground by bending at the hips and knees, maintaining a flat back throughout the movement.",
    "Repeat for the desired number of repetitions."
  ],
  'Sumo Squat (Barbell)': [
    "Stand with your feet wider than hip-width apart, toes pointed outwards.",
    "Hold a barbell with an overhand grip, resting it on your shoulders.",
    "Keeping your chest up and core engaged, lower your body down by bending your knees and pushing your hips back.",
    "Lower down until your thighs are parallel to the ground, making sure your knees track over your toes and do not extend past your toes.",
    "Push through your heels to return to the starting position, fully extending your hips and knees.",
    "Repeat for the desired number of repetitions.",
    "Remember to maintain proper form throughout the exercise and avoid leaning forward or rounding your back."
  ],
  'Wide Grip Bench Press (Barbell)': [
    "Lie flat on a bench with your feet firmly planted on the ground.",
    "Grasp the barbell with a wide grip, slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack and hold it directly above your chest with your arms fully extended.",
    "Lower the barbell slowly and under control towards your chest, keeping your elbows pointed outwards.",
    "Continue lowering the barbell until it lightly touches your chest or reaches a comfortable depth.",
    "Pause for a brief moment at the bottom of the movement, maintaining tension in your chest muscles.",
    "Push the barbell back up to the starting position by extending your arms, while keeping your elbows slightly bent.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to breathe throughout the exercise, inhaling as you lower the barbell and exhaling as you push it back up.",
    " Maintain proper form and avoid arching your back or using excessive momentum during the exercise.",
    " Once you have completed your set, carefully rack the barbell back onto the bench press rack."
  ],
  'Wide Grip (Barbell)': [
    "Begin by standing with your feet shoulder-width apart and your knees slightly bent.",
    "Grab the barbell with a wide grip, hands positioned slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack or the ground, keeping your back straight and core engaged.",
    "Lower the barbell towards your chest, allowing your elbows to flare out to the sides.",
    "Press the barbell back up towards the starting position, fully extending your arms at the top.",
    "Repeat for the desired number of repetitions.",
    "Remember to breathe throughout the exercise and maintain proper form to avoid injury."
  ],
  'Wrist Curls (Barbell)': [
    "Stand with your feet shoulder-width apart and hold a barbell with an underhand grip, palms facing up.",
    "Rest your forearms on a flat surface (such as a bench or the tops of your thighs) with your wrists hanging off the edge.",
    "Slowly curl your wrists upwards, bringing the barbell towards you while keeping your forearms stationary.",
    "Hold the contraction at the top for a second, then slowly lower the barbell back down to the starting position.",
    "Repeat for the desired number of reps, focusing on controlled movements and squeezing your forearms throughout the exercise.",
    "To increase the intensity, you can perform wrist curls with a heavier barbell or use wrist straps for support."
  ],
  'Battle Rope ': [
    "Stand with your feet shoulder-width apart and knees slightly bent.",
    "Hold one end of the battle rope in each hand, with your palms facing each other.",
    "Start by creating a wave-like motion with the ropes. Lift one arm up and then quickly bring it down as you lift the other arm up. Continue this alternating motion to create a continuous wave-like movement.",
    "As you get comfortable with the wave motion, try to increase the speed and intensity of your movements.",
    "To add variation, you can perform different battle rope exercises such as slams, circles, or snakes. For slams, lift both arms up simultaneously and forcefully slam the ropes down to the ground. For circles, move your arms in a circular motion, creating circles with the ropes. For snakes, move your arms in a side-to-side motion, creating a snake-like pattern with the ropes.",
    "Keep your core engaged throughout the exercise to maintain stability and control.",
    "Aim to perform the battle rope exercise for a specific duration, such as 30 seconds to 1 minute, or for a certain number of repetitions, depending on your fitness level and goals.",
    "Remember to breathe continuously and maintain proper form throughout the exercise.",
    "To increase the intensity, you can try performing the battle rope exercise in different stances, such as a squat position or a lunge position.",
    " Cool down and stretch your arms, shoulders, and back after completing the exercise."
  ],
  'Behind The Back Shrug (Barbell)': [
    "Stand with your feet shoulder-width apart and your knees slightly bent.",
    "Hold the barbell with an overhand grip, palms facing away from you, behind your back. Your hands should be slightly wider than shoulder-width apart.",
    "Keep your back straight and your core engaged throughout the exercise.",
    "Begin the movement by shrugging your shoulders upward, lifting the barbell as high as possible.",
    "Squeeze your shoulder blades together at the top of the movement, focusing on contracting your upper back muscles.",
    "Hold the contraction for a brief moment, then slowly lower the barbell back to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Belt Squat': [
    "Stand inside a belt squat machine or attach a belt around your waist with a weight plate or kettlebell hanging from it.",
    "Position your feet shoulder-width apart, toes slightly pointed outwards.",
    "Engage your core and maintain an upright posture throughout the exercise.",
    "Begin the movement by bending your knees and lowering your hips, as if sitting back into a chair.",
    "Continue descending until your thighs are parallel to the ground or slightly below, ensuring your knees do not extend beyond your toes.",
    "Pause briefly at the bottom of the squat, then push through your heels to extend your legs and return to the starting position.",
    "Repeat the movement for the desired number of repetitions.",
    "Focus on maintaining proper form and control throughout the exercise, avoiding any jerky or sudden movements.",
    "Breathe in as you lower down and exhale as you push back up."
  ],
  'Bench Dip ': [
    "Keep your feet flat on the ground, shoulder-width apart. ",
    "Lift your body off the bench using your arms, keeping your elbows slightly bent. ",
    "Slowly lower your body by bending your elbows until your upper arms are parallel to the ground. ",
    "Push through your palms to straighten your arms and return to the starting position. ",
    "Repeat for the desired number of repetitions."
  ],
  'Bicycle Crunch ': [
    "Lie flat on your back on a mat or the floor. Place your hands gently behind your head, elbows pointing outwards, and lift your legs off the ground, bending your knees at a 90-degree angle.",
    "Lift your head, neck, and shoulders off the ground, engaging your core muscles.",
    "Begin the movement by bringing your right knee towards your chest while simultaneously twisting your upper body to the left. As you do this, extend your left leg straight out, keeping it a few inches off the ground.",
    "As you twist, bring your left elbow towards your right knee, aiming to touch them together or as close as possible.",
    "Now, switch sides by straightening your right leg and bringing your left knee towards your chest. Simultaneously, twist your upper body to the right, bringing your right elbow towards your left knee.",
    "Continue alternating sides in a pedaling motion, as if you were riding a bicycle. Remember to keep your core engaged throughout the exercise.",
    "Breathe steadily and maintain a controlled pace. Exhale as you twist and bring your elbow towards your knee, and inhale as you switch sides.",
    "Aim to perform 10-15 repetitions on each side, or as many as you can while maintaining proper form.",
    "To increase the intensity, you can try extending your legs further out or increasing the speed of the pedaling motion.",
    " Once you have completed the desired number of repetitions, slowly lower your head, neck, shoulders, and legs back to the starting position, and relax."
  ],
  'Block Pull Deadlift (Barbell)': [
    "Stand with your feet hip-width apart and the barbell in front of you, with the bar over the middle of your feet.",
    "Bend at the hips and knees to lower your body and grip the barbell with an overhand grip, hands shoulder-width apart.",
    "Keep your back straight, chest up, and shoulders back as you lift the barbell by extending your hips and knees.",
    "As you lift the barbell, keep it close to your body and push your hips forward to fully extend your body.",
    "Lower the barbell back down to the starting position by bending at the hips and knees, keeping your back straight and chest up.",
    "Repeat for the desired number of repetitions.",
    "Remember to engage your core and keep your back straight throughout the movement to prevent injury."
  ],
  'Body Saw Plank': [
    "Start in a plank position with your forearms on the ground and your body in a straight line from head to heels.",
    "Keeping your core engaged and your back flat, slowly shift your weight forward and back, using your toes to \"saw\" your body back and forth.",
    "Make sure to move only at the shoulders and elbows, keeping your body in a straight line throughout the movement.",
    "Continue for the desired number of reps or time duration.",
    "Focus on maintaining a strong core and controlled movement throughout the exercise."
  ],
  'Hip Thrust (Bodyweight)': [
    "Lie down on your back with your knees bent and feet flat on the ground, hip-width apart. Your arms should be resting by your sides.",
    "Engage your core muscles by drawing your belly button in towards your spine.",
    "Press your feet firmly into the ground, ensuring that your heels are directly under your knees.",
    "Begin the movement by driving your hips upwards towards the ceiling, squeezing your glutes (buttocks) as you lift.",
    "Keep your core engaged and avoid arching your lower back excessively. Your body should form a straight line from your knees to your shoulders.",
    "Pause for a moment at the top of the movement, focusing on squeezing your glutes as hard as possible.",
    "Slowly lower your hips back down to the starting position, maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions, aiming for a full range of motion and maintaining proper form.",
    "Remember to breathe throughout the exercise, inhaling as you lower your hips and exhaling as you lift."
  ],
  'Lunge (Bodyweight)': [
    "Stand with your feet hip-width apart and your hands on your hips.",
    "Take a big step forward with your right foot, keeping your left foot in place.",
    "Lower your body down until your right thigh is parallel to the ground and your right knee is directly above your ankle.",
    "Keep your back straight and your core engaged.",
    "Push through your right heel to stand back up to the starting position.",
    "Repeat on the other side, stepping forward with your left foot.",
    "Continue alternating legs for the desired number of repetitions or time."
  ],
  'Split Squat (Bodyweight)': [
    "Stand with your feet hip-width apart, and take a step forward with your right foot.",
    "Position your right foot far enough ahead so that when you lower your body, your right knee is directly above your ankle.",
    "Keep your left foot stationary, with your heel lifted off the ground.",
    "Engage your core muscles by pulling your belly button towards your spine.",
    "Begin the movement by slowly lowering your body towards the ground, bending both knees simultaneously.",
    "Keep your torso upright and your chest lifted throughout the exercise.",
    "Lower your body until your right thigh is parallel to the ground, or as close as you can comfortably go.",
    "Pause for a moment at the bottom of the movement, ensuring your right knee is in line with your toes.",
    "Push through your right heel to return to the starting position, straightening your right leg.",
    " Repeat the movement for the desired number of repetitions on the right side.",
    " Switch legs by stepping forward with your left foot and repeat the exercise on the left side."
  ],
  'Squat (Bodyweight)': [
    "Stand with your feet hip-width apart, toes pointing slightly outwards.",
    "Engage your core and keep your chest up and shoulders back.",
    "Lower your body by bending your knees and pushing your hips back as if you are sitting down on a chair.",
    "Keep your weight in your heels and make sure your knees do not go past your toes.",
    "Lower yourself down until your thighs are parallel to the ground or as low as comfortable.",
    "Drive through your heels to push yourself back up to the starting position.",
    "Repeat for desired number of reps."
  ],
  'Walking Lunge (Bodyweight)': [
    "Begin by standing tall with your feet hip-width apart and your hands on your hips.",
    "Take a large step forward with your right foot, lowering your body down until both knees are bent at 90-degree angles. Your front knee should be directly above your ankle and your back knee should be hovering just above the ground.",
    "Push through your front heel to return to the starting position, bringing your back leg forward to meet your front leg.",
    "Repeat the lunge on the opposite leg, stepping forward with your left foot this time.",
    "Continue alternating legs as you move forward with each lunge, focusing on keeping your chest lifted and your core engaged."
  ],
  'Crossover (Cable)': [
    "Start by standing upright with your feet shoulder-width apart. Keep your core engaged and maintain a slight bend in your knees throughout the exercise.",
    "Extend your arms out to the sides, parallel to the floor. Your palms should be facing forward, and your elbows should be slightly bent.",
    "Begin the movement by crossing your right arm over your left arm, bringing your right hand towards your left shoulder. At the same time, cross your left leg over your right leg, bringing your left foot towards your right foot.",
    "Return to the starting position by uncrossing your arms and legs simultaneously. Extend your arms back out to the sides and place your feet back to the shoulder-width position.",
    "Repeat the movement, this time crossing your left arm over your right arm and your right leg over your left leg. Alternate the crossing pattern with each repetition.",
    "Continue performing the crossover motion for the desired number of repetitions or time duration."
  ],
  'Crunch (Cable)': [
    "Stand facing away from the cable machine with your feet shoulder-width apart.",
    "Adjust the cable machine so that the pulley is positioned at the highest setting.",
    "Attach a rope handle to the cable machine and hold it with both hands, palms facing each other.",
    "Position yourself on your knees, facing away from the machine, and maintain a slight forward lean.",
    "Keep your hips stationary and engage your core muscles by contracting your abs.",
    "Begin the movement by flexing your spine and bending forward at the waist, bringing your head towards the floor.",
    "Exhale as you crunch forward, focusing on contracting your abdominal muscles.",
    "Pause for a moment at the bottom of the movement, feeling the stretch in your abs.",
    "Slowly return to the starting position by extending your spine and bringing your torso back up to a neutral position.",
    " Inhale as you return to the starting position, maintaining control throughout the movement.",
    " Repeat for the desired number of repetitions."
  ],
  'Donkey Kickback (Cable)': [
    "Stand facing a cable machine with a cable attachment positioned at the lowest setting. Attach an ankle cuff to your right ankle and secure it tightly.",
    "Position yourself a few feet away from the machine, with your feet hip-width apart and your knees slightly bent.",
    "Place your hands on a stable surface, such as a bench or the machine itself, for support.",
    "Engage your core muscles to stabilize your body throughout the exercise.",
    "Keeping your right knee bent at a 90-degree angle, kick your right leg straight back, extending it as far as possible while maintaining control.",
    "Squeeze your glutes at the top of the movement to fully engage the muscles.",
    "Slowly return your right leg to the starting position, maintaining control and keeping tension on the cable throughout the entire movement.",
    "Repeat for the desired number of repetitions on your right leg before switching to your left leg.",
    "Perform the exercise in a controlled manner, focusing on the contraction of your glutes and avoiding any swinging or jerking motions.",
    " Breathe steadily throughout the exercise, exhaling as you extend your leg and inhaling as you return to the starting position."
  ],
  'Face Pull (Cable)': [
    "Stand facing the cable machine with the pulley set at shoulder height.",
    "Grab the rope handles with an overhand grip, palms facing down.",
    "Step back a few feet to create tension in the cable.",
    "Keeping your elbows high and in line with your shoulders, pull the handles towards your face, squeezing your shoulder blades together.",
    "Slowly return to the starting position, keeping tension in the cable throughout the movement.",
    "Repeat for the desired number of repetitions.",
    "Remember to engage your core and keep your back straight throughout the exercise."
  ],
  'Lateral Raise (Cable)': [
    "Stand upright with your feet shoulder-width apart, facing the cable machine.",
    "Grasp the cable handle with your hand, palm facing your body.",
    "Keep a slight bend in your elbow and maintain a neutral spine throughout the exercise.",
    "Engage your core and stabilize your body by slightly bending your knees.",
    "Begin the movement by raising your arm out to the side, keeping it parallel to the floor. Exhale as you lift.",
    "Continue raising your arm until it reaches shoulder height, or slightly above, while maintaining a slight bend in your elbow.",
    "Pause for a moment at the top of the movement, focusing on contracting your shoulder muscles.",
    "Slowly lower your arm back down to the starting position, inhaling as you lower.",
    "Repeat the exercise for the desired number of repetitions.",
    " Remember to maintain control throughout the movement, avoiding any swinging or jerking motions."
  ],
  'Chest Fly (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart and your arms extended out to the sides, parallel to the floor.",
    "Grasp the handles of the cable machine with your palms facing forward.",
    "Keeping your arms straight, bring your hands together in front of your chest, squeezing your chest muscles as you do so.",
    "Slowly release your arms back out to the sides, keeping them parallel to the floor.",
    "Repeat for the desired number of repetitions."
  ],
  'Pull Through (Cable)': [
    "Stand facing away from the cable machine with your feet shoulder-width apart.",
    "Grab the rope attachment or handle with both hands, palms facing each other.",
    "Take a step forward to create tension in the cable, keeping your arms extended in front of you.",
    "Engage your core and maintain a slight bend in your knees throughout the exercise.",
    "Begin the movement by hinging at your hips, pushing them back while keeping your back straight.",
    "Lower your torso towards the ground, allowing the cable to pull your arms and hands between your legs.",
    "Keep your chest up and shoulders back as you lower your body, feeling a stretch in your hamstrings and glutes.",
    "Once you reach a comfortable stretch or your torso is parallel to the ground, reverse the movement.",
    "Drive your hips forward and squeeze your glutes to return to the starting position.",
    " Maintain control and avoid using momentum to perform the exercise effectively.",
    " Repeat for the desired number of repetitions."
  ],
  'Pullover (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart. Adjust the cable pulley to a high position.",
    "Grab the handle or rope attachment with an overhand grip, palms facing down. Your hands should be slightly wider than shoulder-width apart.",
    "Take a step forward, creating tension in the cable. This will be your starting position.",
    "Keeping a slight bend in your elbows, engage your core and maintain a stable stance throughout the exercise.",
    "Begin the movement by pulling the cable down and back, while simultaneously bending your elbows and lowering your hands behind your head.",
    "Continue the motion until your hands are parallel to the floor or until you feel a stretch in your chest and shoulders. Keep your elbows slightly bent throughout the exercise to avoid excessive strain on the joints.",
    "Pause for a moment at the bottom of the movement, feeling the stretch in your chest muscles.",
    "Slowly reverse the motion, bringing your hands back up to the starting position, maintaining control and tension in the cable.",
    "Repeat for the desired number of repetitions.",
    " Remember to breathe throughout the exercise, exhaling as you pull the cable down and inhaling as you return to the starting position."
  ],
  'Tricep Push Down (Cable)': [
    "Stand in front of the cable machine with a straight posture and a slight bend in your knees.",
    "Grasp the rope or bar attachment with an overhand grip, with your hands shoulder-width apart.",
    "Keep your elbows close to your sides and your upper arms stationary throughout the exercise.",
    "Begin the movement by extending your elbows and pushing the rope or bar down towards your thighs.",
    "Focus on contracting your triceps and feeling the burn in the back of your arms as you push the weight down.",
    "Once your arms are fully extended, hold the position for a brief moment to really squeeze your triceps.",
    "Slowly reverse the movement by allowing the weight to rise back up in a controlled manner.",
    "Repeat for the desired number of repetitions, ensuring proper form and control throughout the exercise."
  ],
  'Rear Delt Row (Cable)': [
    "Stand facing a cable machine with the cable set at chest height. ",
    "Grasp the handle with one hand and take a step back to create tension in the cable. ",
    "Keep your chest up and shoulders back, engage your core, and hinge slightly at the hips. ",
    "Pull the handle towards your body, leading with your elbow and squeezing your shoulder blade towards your spine. ",
    "Pause at the top of the movement, then slowly lower the handle back to the starting position. ",
    "Repeat for the desired number of reps, then switch sides and perform the exercise with the other arm. ",
    "Make sure to keep a controlled and smooth motion throughout the exercise, focusing on using your rear deltoids to perform the rowing motion."
  ],
  'Reverse Grip Pushdown (Cable)': [
    "Stand facing a cable machine with a straight bar attachment at chest height.",
    "Grasp the bar with an underhand grip (palms facing up) and your hands shoulder-width apart.",
    "Position your feet shoulder-width apart, slightly bend your knees, and maintain a slight forward lean from your hips.",
    "Keep your elbows tucked close to your sides throughout the exercise.",
    "Begin with your arms fully extended, and your wrists in line with your forearms.",
    "Engage your core and maintain a neutral spine position.",
    "Exhale and slowly pull the bar down towards your thighs by flexing your elbows.",
    "Focus on using your triceps to initiate the movement, while keeping your upper arms stationary.",
    "Continue lowering the bar until your forearms are parallel to the ground, or until you feel a good contraction in your triceps.",
    " Pause for a brief moment, squeezing your triceps at the bottom of the movement.",
    " Inhale and slowly return the bar to the starting position by extending your elbows.",
    " Repeat for the desired number of repetitions."
  ],
  'Seated Rear Delt Fly (Cable)': [
    "Start by sitting on a bench with a cable machine at shoulder height behind you.",
    "Grab the cable handles with each hand and extend your arms straight out in front of you, palms facing each other.",
    "Keeping a slight bend in your elbows, squeeze your shoulder blades together and pull the cable handles out to the sides, leading with your elbows.",
    "Focus on using your rear delts to lift the weight, rather than your arms or back.",
    "Hold the peak contraction for a second, then slowly release back to the starting position."
  ],
  'Seated Row (Cable)': [
    "Sit on the rowing machine with your feet firmly planted on the footrests and knees slightly bent.",
    "Grab the handle or attachment with an overhand grip, hands shoulder-width apart.",
    "Sit up tall, engaging your core muscles and keeping your back straight.",
    "Start with your arms fully extended in front of you, maintaining a slight bend in your elbows.",
    "Pull the handle towards your torso by retracting your shoulder blades and squeezing your back muscles.",
    "Keep your elbows close to your body as you pull the handle towards your lower chest or upper abdomen.",
    "Pause for a moment at the fully contracted position, feeling the squeeze in your back muscles.",
    "Slowly extend your arms back to the starting position, maintaining control and tension in your back muscles.",
    "Repeat the movement for the desired number of repetitions.",
    " Focus on maintaining proper form throughout the exercise, avoiding any jerking or swinging motions.",
    " Breathe out as you pull the handle towards your body and breathe in as you return to the starting position."
  ],
  'Shoulder Press (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart and knees slightly bent.",
    "Grab the handles or the bar attached to the cable machine with an overhand grip.",
    "Bring the handles up to shoulder height, keeping your elbows bent and close to your body.",
    "Press the handles or bar straight up overhead until your arms are fully extended.",
    "Slowly lower the handles back to shoulder height, keeping your core engaged and back straight.",
    "Repeat for the desired number of repetitions.",
    "Focus on maintaining proper form throughout the exercise, keeping your shoulders down and back, and avoiding arching your back."
  ],
  'Shrug (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart and a slight bend in your knees.",
    "Grasp the handles of the cable machine with an overhand grip, keeping your arms fully extended and your shoulders relaxed.",
    "Keeping your back straight and core engaged, exhale and slowly raise your shoulders towards your ears, as if you are trying to touch them to your head.",
    "Hold the top position for a brief moment, then inhale and slowly lower your shoulders back down to the starting position.",
    "Repeat for the desired number of repetitions, focusing on using your shoulder muscles to lift the weight and avoiding using momentum or swinging your body."
  ],
  'Straight Arm Pulldown (Cable)': [
    "Stand in front of a cable machine with a straight bar attachment at the high pulley.",
    "Grasp the bar with an overhand grip, hands shoulder-width apart.",
    "Keep your arms straight and your core engaged.",
    "Pull the bar down towards your thighs by contracting your lats and squeezing your shoulder blades together.",
    "Slowly return the bar to the starting position, keeping your arms straight throughout the movement.",
    "Repeat for the desired number of repetitions.",
    "Focus on using your back muscles to perform the movement, rather than relying on your arms to pull the weight down."
  ],
  'Upright Row (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart. Grab the cable attachment with an overhand grip, hands slightly narrower than shoulder-width apart. Your palms should be facing your body.",
    "Keep your back straight, chest up, and engage your core muscles for stability throughout the exercise.",
    "Begin the movement by pulling the cable attachment straight up towards your chin, leading with your elbows. Keep your elbows higher than your hands throughout the exercise.",
    "As you lift the cable, focus on squeezing your shoulder blades together and engaging your upper back muscles. Your elbows should be pointing out to the sides, not forward.",
    "Continue pulling the cable attachment up until it reaches your upper chest or just below your chin. Pause for a moment and squeeze your shoulder blades together at the top of the movement.",
    "Slowly lower the cable attachment back down to the starting position, maintaining control and tension in your muscles.",
    "Repeat the exercise for the desired number of repetitions."
  ],
  'Y-Raise (Cable)': [
    "Stand facing a cable machine with the cable set at a low position. Attach a handle or rope to the cable.",
    "Grab the handle or rope with an overhand grip, palms facing down. Stand with your feet shoulder-width apart and maintain a slight bend in your knees.",
    "Begin with your arms fully extended in front of you, keeping a slight bend in your elbows.",
    "Engage your core and maintain a straight back throughout the exercise.",
    "Keeping your arms straight, raise them up and out to the sides in a Y-shape, forming a wide \"V\" with your body. Imagine you are spreading your wings.",
    "Continue raising your arms until they are parallel to the floor or slightly above shoulder height. Keep your shoulders down and away from your ears.",
    "Pause for a moment at the top of the movement, focusing on squeezing your shoulder blades together.",
    "Slowly lower your arms back to the starting position, maintaining control and tension in your shoulder muscles.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to breathe throughout the exercise, inhaling as you lower your arms and exhaling as you raise them."
  ],
  'Captains Chair Leg Raise': [
    "Begin by sitting on the captain's chair with your back pressed against the backrest and your forearms resting on the arm pads.",
    "Grip the handles on either side of the chair firmly to stabilize yourself.",
    "Keep your upper body straight and engage your core muscles.",
    "Lift your legs off the ground, bending your knees slightly.",
    "Slowly raise your knees towards your chest, using your abdominal muscles to lift them.",
    "Continue lifting until your thighs are parallel to the ground or as close as you can comfortably get.",
    "Hold this position for a brief moment, focusing on contracting your abs.",
    "Slowly lower your legs back down to the starting position, but do not let them touch the ground.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to maintain control throughout the exercise and avoid swinging your legs or using momentum to lift them.",
    " Breathe steadily throughout the exercise, exhaling as you lift your legs and inhaling as you lower them."
  ],
  'Chest Dip': [
    "Find a dip station or parallel bars that are sturdy and at a height where your feet can comfortably touch the ground.",
    "Stand between the bars and grip each bar with an overhand grip, palms facing down.",
    "Lift yourself up by straightening your arms, keeping your elbows slightly bent but not locked.",
    "Lean your torso forward slightly, creating a slight angle between your upper body and legs.",
    "Lower your body by bending your elbows, allowing your chest to descend towards the bars.",
    "Continue lowering until your shoulders are slightly below your elbows or until you feel a stretch in your chest muscles.",
    "Pause for a moment at the bottom position, then push yourself back up by straightening your arms.",
    "Exhale as you push up and fully extend your arms, returning to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Chest Press': [
    "Begin by lying flat on a bench with your feet planted firmly on the ground.",
    "Hold a dumbbell in each hand, with your palms facing away from you and your elbows bent at a 90-degree angle.",
    "Press the dumbbells up towards the ceiling, straightening your arms while keeping your wrists directly above your elbows.",
    "Slowly lower the dumbbells back down to chest level, making sure to keep your elbows at a 90-degree angle.",
    "Repeat the movement for the desired number of reps, focusing on engaging your chest muscles throughout the exercise.",
    "Remember to breathe consistently and keep your core engaged for stability."
  ],
  'Chin Up': [
    "Stand underneath a pull-up bar with your arms fully extended overhead and your hands gripping the bar with an underhand grip.",
    "Engage your core and shoulder muscles as you pull yourself up towards the bar, leading with your chest and pulling your elbows down towards your sides.",
    "Continue pulling yourself up until your chin clears the bar and your chest is close to touching it.",
    "Slowly lower yourself back down to the starting position, maintaining control and keeping your core engaged throughout the movement.",
    "Repeat for the desired number of repetitions, focusing on using your back and arm muscles to perform the exercise."
  ],
  'Close-Grip Bench Press (Barbell)': [
    "Lie flat on a bench with your feet firmly planted on the ground.",
    "Grasp the barbell with a grip that is narrower than shoulder-width apart. Your palms should be facing towards your feet.",
    "Lift the barbell off the rack and hold it directly above your chest with your arms fully extended.",
    "Slowly lower the barbell towards your chest, keeping your elbows tucked in close to your body. Aim to bring the barbell to the middle of your chest.",
    "Pause for a brief moment when the barbell touches your chest.",
    "Push the barbell back up to the starting position by extending your arms, while maintaining control and keeping your elbows close to your body.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Close-Grip Lat Pulldown': [
    "Sit down at a lat pulldown machine and grasp the close-grip handle with both hands, palms facing towards you.",
    "Keep your back straight and chest up, engage your core muscles.",
    "Pull the handle down towards your chest, keeping your elbows close to your body.",
    "Squeeze your shoulder blades together at the bottom of the movement.",
    "Slowly return the handle to the starting position, keeping tension in your back muscles.",
    "Repeat for the desired number of repetitions.",
    "Focus on using your back muscles to pull the weight, rather than relying on momentum or your arms."
  ],
  'Close Grip Pull Up': [
    "Stand in front of a pull-up bar with your palms facing towards you, and your hands placed shoulder-width apart or slightly narrower.",
    "Jump or step up to grab the bar, ensuring that your grip is secure and your body is hanging freely.",
    "Engage your core muscles by pulling your belly button towards your spine and slightly tucking your pelvis.",
    "Begin the movement by pulling your shoulder blades down and back, while simultaneously bending your elbows and pulling your body up towards the bar.",
    "Continue pulling until your chin is above the bar, or as close as you can comfortably get.",
    "Pause briefly at the top of the movement, squeezing your shoulder blades together and engaging your back muscles.",
    "Slowly lower yourself back down to the starting position, fully extending your arms and allowing your shoulder blades to protract.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Cobra Push Up ': [
    "Start in a plank position with your hands directly under your shoulders and your body in a straight line from head to heels.",
    "Lower your body down towards the ground while keeping your elbows close to your sides.",
    "Push through your palms to lift your chest up off the ground, arching your back and looking upwards.",
    "Hold the cobra position for a few seconds, then slowly lower yourself back down to the starting position.",
    "Repeat for desired number of reps."
  ],
  'Concentration Curl (Dumbbell)': [
    "Sit on a bench or chair with your feet flat on the floor, shoulder-width apart.",
    "Hold a dumbbell in your hand and place your elbow against the inside of your thigh, just above the knee. Your arm should be fully extended, and your palm should be facing up.",
    "Keep your back straight and your core engaged throughout the exercise.",
    "Slowly curl the dumbbell towards your shoulder, while keeping your upper arm stationary against your thigh. Exhale as you lift the weight.",
    "Continue curling until your bicep is fully contracted and the dumbbell is close to your shoulder. Hold this position for a brief pause, squeezing your bicep.",
    "In a controlled manner, lower the dumbbell back to the starting position, fully extending your arm. Inhale as you lower the weight.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Conventional Single Leg Squat': [
    "Stand tall with your feet hip-width apart.",
    "Lift one foot off the ground, keeping your knee bent at a 90-degree angle.",
    "Extend your arms straight out in front of you for balance.",
    "Slowly lower your body down by bending your standing leg at the knee, while keeping your back straight.",
    "Continue lowering until your thigh is parallel to the ground, or as low as you can comfortably go.",
    "Pause for a moment at the bottom, then push through your heel to return to the starting position.",
    "Repeat the movement for the desired number of repetitions on one leg before switching to the other leg.",
    "Keep your core engaged throughout the exercise to maintain stability and control.",
    "Focus on maintaining proper form and balance throughout the movement.",
    " Perform the exercise at a controlled pace, avoiding any sudden or jerky movements.",
    " Breathe in as you lower your body down and exhale as you push back up."
  ],
  'Crunch': [
    "Lie down on your back on a mat or a comfortable surface.",
    "Bend your knees and place your feet flat on the ground, hip-width apart.",
    "Place your hands behind your head, lightly supporting it with your fingers. Avoid pulling on your neck.",
    "Engage your core muscles by drawing your belly button towards your spine.",
    "Slowly lift your head, neck, and shoulders off the ground, while keeping your lower back pressed into the mat.",
    "Exhale as you lift, and focus on contracting your abdominal muscles.",
    "Hold the crunch position for a moment, ensuring you feel the tension in your abs.",
    "Inhale as you lower your upper body back down to the starting position, with control.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to maintain a steady and controlled pace throughout the exercise, avoiding any jerking or swinging motions."
  ],
  'Bench Press (Dumbbell)': [
    "Lie flat on a bench with your feet firmly planted on the ground.",
    "Hold a dumbbell in each hand, with your palms facing forward and your arms extended above your chest.",
    "Slowly lower the dumbbells towards your chest, keeping your elbows at a 90-degree angle.",
    "Pause for a moment when the dumbbells are just above your chest.",
    "Push the dumbbells back up to the starting position, fully extending your arms.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to breathe out as you push the dumbbells up and breathe in as you lower them down.",
    "Maintain control throughout the exercise, avoiding any jerking or swinging motions.",
    "Focus on engaging your chest muscles to perform the movement, rather than relying solely on your arms.",
    " Adjust the weight of the dumbbells according to your strength and fitness level."
  ],
  'Hammer Curl (Dumbbell)': [
    "Stand up straight with a dumbbell in each hand, palms facing your body. This is your starting position.",
    "Keep your upper arms stationary, exhale, and curl the weights while contracting your biceps. Continue to raise the dumbbells until your biceps are fully contracted and the dumbbells are at shoulder level. Hold the contracted position for a brief pause as you squeeze your biceps.",
    "Inhale and slowly begin to lower the dumbbells back to the starting position, allowing your biceps to fully stretch.",
    "Repeat for the recommended amount of repetitions."
  ],
  'Decline Bench Press (Barbell)': [
    "Lie down on the decline bench with your feet secured under the foot pads.",
    "Grab the barbell with a grip slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack and hold it directly above your chest with your arms fully extended.",
    "Slowly lower the barbell towards your chest, keeping your elbows at a 45-degree angle to your body.",
    "Pause for a brief moment when the barbell is close to your chest.",
    "Push the barbell back up to the starting position, fully extending your arms.",
    "Repeat for the desired number of repetitions."
  ],
  'Decline Cable Fly': [
    "Start by adjusting the cable machine to a low position and attaching the handles to the cables.",
    "Position a decline bench in front of the cable machine, ensuring that it is securely locked in place.",
    "Sit on the decline bench and place your feet under the provided foot pads to stabilize your body.",
    "Grab the handles with an overhand grip, palms facing down, and extend your arms straight out in front of you.",
    "Slowly lower the handles out to your sides in a controlled manner, while maintaining a slight bend in your elbows.",
    "Keep your chest up, shoulders back, and core engaged throughout the movement.",
    "Continue lowering the handles until you feel a stretch in your chest muscles, but avoid any discomfort or excessive strain.",
    "Pause for a brief moment at the bottom of the movement, then slowly bring the handles back up to the starting position.",
    "As you bring the handles back up, focus on squeezing your chest muscles together to maximize the contraction.",
    " Repeat the exercise for the desired number of repetitions.",
    " Remember to breathe steadily throughout the exercise, inhaling as you lower the handles and exhaling as you bring them back up."
  ],
  'Decline Crunch': [
    "Lie down on a decline bench with your feet securely locked in place at the top end of the bench.",
    "Place your hands behind your head, crossing your arms over your chest, or keep them extended alongside your body.",
    "Engage your core muscles by drawing your belly button towards your spine.",
    "Slowly lift your upper body off the bench, curling your torso towards your knees. Exhale as you crunch up.",
    "Focus on using your abdominal muscles to initiate the movement, rather than pulling with your neck or using momentum.",
    "Continue to curl up until your shoulder blades are off the bench and you feel a strong contraction in your abs.",
    "Hold the contracted position for a brief moment, squeezing your abs.",
    "Slowly lower your upper body back down to the starting position, inhaling as you do so.",
    "Repeat the movement for the desired number of repetitions.",
    " Maintain control throughout the exercise, avoiding any jerking or swinging motions.",
    " Remember to breathe steadily throughout the exercise, exhaling during the crunch and inhaling during the descent."
  ],
  'Decline Push-Up': [
    "Start in a push-up position with your hands shoulder-width apart and your feet elevated on a bench or step.",
    "Keep your body in a straight line from your head to your heels, engaging your core and glutes.",
    "Lower your chest towards the ground by bending your elbows, keeping them close to your body.",
    "Push through your palms to straighten your arms and return to the starting position.",
    "Repeat for the desired number of repetitions.",
    "Remember to keep your core engaged and maintain proper form throughout the exercise."
  ],
  'Decline Sit Up': [
    "Lie down on a decline bench with your feet securely locked in place at the top of the bench.",
    "Place your hands behind your head or across your chest, whichever is more comfortable for you.",
    "Engage your core and slowly lift your upper body off the bench, keeping your back straight.",
    "Exhale as you come up and inhale as you lower your body back down to the starting position.",
    "Repeat for the desired number of reps, making sure to keep your core engaged throughout the movement.",
    "Once you have completed your set, carefully release your feet from the bench and stand up slowly."
  ],
  'Deficit Bulgarian Split Squat': [
    "Begin by standing about two feet in front of a bench or step with your hands on your hips.",
    "Place one foot behind you on the bench, making sure the top of your foot is resting on the surface.",
    "Take a deep breath and engage your core as you lower your body down by bending your front knee, lowering your back knee towards the ground.",
    "Keep your torso upright and press through your front heel to return to the starting position.",
    "Repeat for the desired number of reps on each leg."
  ],
  'Deficit Deadlift': [
    "Stand with your feet hip-width apart and a barbell in front of you on the ground.",
    "Bend at the hips and knees to grip the barbell with an overhand grip, hands shoulder-width apart.",
    "Keep your back straight and chest up as you lift the barbell off the ground, extending your hips and knees to stand up straight.",
    "Lower the barbell back down to the ground, keeping it close to your body and maintaining a straight back throughout the movement.",
    "Perform the desired number of repetitions, focusing on maintaining proper form and control throughout the exercise."
  ],
  'Diamond Push-Up': [
    "Start by getting into a high plank position on the floor, with your hands directly under your shoulders and your body in a straight line from head to toe.",
    "Bring your hands close together, forming a diamond shape with your thumbs and index fingers. Your thumbs and index fingers should be touching each other.",
    "Position your hands so that your fingers are pointing towards your feet.",
    "Engage your core muscles and keep your back straight throughout the exercise.",
    "Lower your body towards the floor by bending your elbows, while keeping them close to your sides. Aim to bring your chest as close to your hands as possible.",
    "Pause for a brief moment when your chest is just above the ground.",
    "Push through your palms and extend your arms to raise your body back up to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Donkey Calf Raise': [
    "Stand on the edge of a raised platform or step, with your toes on the edge and your heels hanging off. Hold onto a stable object or have someone hold your shoulders for support.",
    "Keep your legs straight and your feet parallel to each other, about hip-width apart.",
    "Slowly lower your heels down as far as possible, feeling a stretch in your calves.",
    "Push through the balls of your feet and raise your heels as high as you can, contracting your calf muscles at the top of the movement.",
    "Hold the contracted position for a second, squeezing your calves.",
    "Slowly lower your heels back down to the starting position, feeling the stretch in your calves again.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Bicep Curl (Dumbbell)': [
    "Stand with your feet shoulder-width apart and hold a dumbbell in each hand with your palms facing forward.",
    "Keep your elbows close to your sides and slowly lift the dumbbells towards your shoulders, bending your elbows.",
    "Pause for a second at the top of the movement, squeezing your biceps.",
    "Slowly lower the dumbbells back down to the starting position, straightening your arms.",
    "Repeat for the desired number of repetitions."
  ],
  'Bulgarian Split Squat (Dumbbell)': [
    "Hold a dumbbell in each hand, with your arms hanging by your sides.",
    "Stand with your back facing a bench or elevated surface.",
    "Place the top of one foot on the bench behind you, and step your other foot out in front of you.",
    "Lower your body down by bending your front knee, keeping your back straight and chest up.",
    "Lower yourself until your front thigh is parallel to the ground, making sure your front knee does not go past your toes.",
    "Push through your front heel to return to the starting position.",
    "Repeat for the desired number of repetitions."
  ],
  'Close Grip Press (Dumbbell)': [
    "Lie down on a flat bench with a dumbbell in each hand. Your palms should be facing towards each other and the dumbbells should be positioned directly above your chest.",
    "Lower the dumbbells towards your chest, keeping your elbows close to your body and your wrists straight. Inhale as you lower the dumbbells.",
    "Press the dumbbells back up towards the starting position, exhaling as you push the weights up. Make sure to fully extend your arms at the top of the movement.",
    "Repeat for the desired number of reps, making sure to keep your core engaged and your back flat on the bench throughout the exercise.",
    "To target the triceps even more, you can slightly angle the dumbbells towards each other as you press them up, keeping your elbows close to your body.",
    "Remember to use a weight that challenges you but allows you to maintain proper form throughout the exercise."
  ],
  'Deadlift (Dumbbell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Place a dumbbell on the ground in front of you.",
    "Bend your knees and hinge at your hips, keeping your back straight and chest lifted. Reach down and grab the dumbbell with an overhand grip, palms facing your body. Your hands should be shoulder-width apart.",
    "Engage your core and keep your back straight as you begin to lift the dumbbell. Push through your heels and drive your hips forward, straightening your legs as you stand up. Keep the dumbbell close to your body throughout the movement.",
    "As you reach the top of the movement, squeeze your glutes and engage your hamstrings. Your body should be in a tall, upright position with your shoulders pulled back.",
    "Slowly lower the dumbbell back down by bending at your hips and knees, keeping your back straight. Lower the dumbbell until it touches the ground, maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions, ensuring proper form and technique. Remember to breathe throughout the exercise, inhaling as you lower the dumbbell and exhaling as you lift it."
  ],
  'Decline Bench Press (Dumbbell)': [
    "Lie down on a decline bench with your feet secured under the foot pads or by placing them firmly on the floor.",
    "Hold a dumbbell in each hand, palms facing forward, and extend your arms straight up above your chest.",
    "Slowly lower the dumbbells towards the sides of your chest, keeping your elbows at a 90-degree angle.",
    "Pause for a moment at the bottom of the movement, ensuring a full stretch in your chest muscles.",
    "Push the dumbbells back up to the starting position, fully extending your arms without locking your elbows.",
    "Repeat the movement for the desired number of repetitions.",
    "Focus on maintaining control throughout the exercise, avoiding any jerking or swinging motions.",
    "Breathe out as you push the dumbbells up and breathe in as you lower them down.",
    "Keep your core engaged and your back flat against the bench throughout the exercise."
  ],
  'Chest Expansion (Band)': [
    "Stand with your feet shoulder-width apart and hold the resistance band in front of you with both hands, palms facing down.",
    "Pull the band apart, bringing your arms out to the sides and squeezing your shoulder blades together.",
    "Keep your chest lifted and your core engaged as you hold the position for a few seconds.",
    "Slowly release the tension in the band and return to the starting position."
  ],
  'Belt Squat (Between Boxes)': [
    "Stand in between two sturdy boxes or platforms, with a belt attached around your waist and the weight hanging below you.",
    "Keeping your feet shoulder-width apart, lower yourself down into a squat position, making sure your knees do not go past your toes.",
    "Once you reach the bottom of the squat, push through your heels to stand back up to the starting position.",
    "Repeat for the desired number of repetitions.",
    "Focus on maintaining proper form throughout the exercise, keeping your back straight and core engaged."
  ],
  'Butterfly Sit Up': [
    "Begin by lying flat on your back with your knees bent and feet flat on the floor.",
    "Bring the soles of your feet together and let your knees fall out to the sides, creating a diamond shape with your legs.",
    "Place your hands behind your head with your elbows out to the sides.",
    "Engage your core muscles and lift your upper body off the floor, aiming to touch your elbows to your knees.",
    "Slowly lower back down to the starting position, keeping your core muscles engaged throughout the movement.",
    "Repeat for the desired number of repetitions.",
    "Remember to breathe throughout the exercise and focus on using your abdominal muscles to lift your body, rather than straining your neck or back."
  ],
  'Face Pull (Dumbbell)': [
    "Stand with your feet shoulder-width apart and hold a dumbbell in each hand.",
    "Start by bringing your arms up to shoulder height, with your palms facing each other and elbows bent.",
    "Keep your back straight, chest up, and engage your core muscles.",
    "Begin the movement by pulling the dumbbells towards your face, leading with your elbows.",
    "As you pull, focus on squeezing your shoulder blades together and keeping your upper back muscles engaged.",
    "Continue pulling until the dumbbells are at the sides of your face, with your upper arms parallel to the ground.",
    "Hold this position for a brief pause, feeling the contraction in your upper back muscles.",
    "Slowly reverse the movement, extending your arms back to the starting position.",
    "Repeat for the desired number of repetitions, maintaining control and proper form throughout the exercise.",
    " Remember to breathe steadily throughout the movement, inhaling as you pull the dumbbells towards your face and exhaling as you extend your arms back to the starting position."
  ],
  'Front Raise (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand with an overhand grip. Let your arms hang down in front of your thighs, palms facing your body.",
    "Keep your back straight, engage your core, and slightly bend your knees for stability.",
    "Begin the movement by simultaneously raising both dumbbells directly in front of you. Keep your arms straight, but avoid locking your elbows.",
    "Continue lifting the dumbbells until they reach shoulder level or slightly above. Your palms should be facing the floor at the top of the movement.",
    "Hold the position for a brief pause, ensuring that your shoulders are fully engaged.",
    "Slowly lower the dumbbells back down to the starting position, maintaining control and avoiding any swinging or jerking motions.",
    "Repeat the exercise for the desired number of repetitions, focusing on maintaining proper form and control throughout the movement.",
    "Remember to breathe steadily throughout the exercise, inhaling as you lower the dumbbells and exhaling as you raise them."
  ],
  'Front Squat (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand. Position the dumbbells at shoulder height, with your palms facing upward and elbows pointing forward.",
    "Engage your core muscles by pulling your belly button towards your spine. Keep your chest up and maintain a straight back throughout the exercise.",
    "Begin the movement by bending your knees and pushing your hips back as if you were sitting into a chair. Lower your body until your thighs are parallel to the ground or slightly below, ensuring your knees do not extend past your toes.",
    "As you descend, keep your weight evenly distributed on your heels and maintain an upright torso. This will help activate your quadriceps, hamstrings, and glutes effectively.",
    "Pause briefly at the bottom of the squat, then exhale and push through your heels to return to the starting position. Keep your core engaged and maintain control throughout the movement.",
    "Repeat the exercise for the desired number of repetitions."
  ],
  'Goblet Squat (Dumbbell)': [
    "Hold a dumbbell vertically in front of your chest with both hands, keeping your elbows close to your body.",
    "Stand with your feet shoulder-width apart and toes slightly turned out.",
    "Lower your body down by bending your knees and pushing your hips back, keeping your chest up and core engaged.",
    "Continue to lower yourself until your thighs are at least parallel to the ground, making sure your knees are tracking over your toes.",
    "Push through your heels to straighten your legs and return to the starting position, squeezing your glutes at the top.",
    "Repeat for the desired number of reps, focusing on maintaining proper form and control throughout the movement."
  ],
  'Good Morning (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand. Keep your arms extended down in front of your thighs, palms facing your body.",
    "Engage your core muscles by pulling your belly button in towards your spine. This will help stabilize your torso throughout the exercise.",
    "Begin the movement by hinging at your hips, pushing your buttocks back as if you were trying to touch your glutes to the wall behind you. Keep your back straight and maintain a slight bend in your knees.",
    "Continue to lower your upper body until it is parallel to the floor or until you feel a stretch in your hamstrings. Make sure to keep your head in a neutral position, looking straight ahead.",
    "Pause for a moment at the bottom of the movement, then slowly return to the starting position by squeezing your glutes and pushing your hips forward.",
    "Repeat for the desired number of repetitions, maintaining control and proper form throughout the exercise.",
    "Remember to breathe steadily throughout the movement, exhaling as you lower your body and inhaling as you return to the starting position.",
    "To increase the intensity, you can use heavier dumbbells or perform the exercise on an elevated surface, such as a step or bench."
  ],
  'Hack Squat (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand. Keep your arms extended down by your sides, palms facing your body.",
    "Engage your core and maintain a straight back throughout the exercise.",
    "Begin the movement by bending at your knees and hips simultaneously, as if you are sitting back into a chair. Keep your chest up and your gaze forward.",
    "Continue descending until your thighs are parallel to the ground, or as low as your flexibility allows. Ensure that your knees do not extend beyond your toes.",
    "Pause briefly at the bottom of the squat, then push through your heels to extend your knees and hips, returning to the starting position.",
    "Exhale as you push up and inhale as you descend.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Hex Press (Dumbbell)': [
    "Begin by lying on a flat bench with a dumbbell in each hand, held directly above your chest with your palms facing each other.",
    "Lower the dumbbells towards the sides of your head, keeping your elbows pointed outwards and your upper arms parallel to the ground.",
    "Pause briefly at the bottom of the movement, then press the dumbbells back up to the starting position, fully extending your arms.",
    "Keep your core engaged and maintain a slight bend in your elbows throughout the exercise to avoid locking out your joints.",
    "Perform the desired number of reps, focusing on controlled and steady movements to target your chest and triceps effectively.",
    "Remember to breathe evenly throughout the exercise and avoid arching your back or using momentum to lift the weights."
  ],
  'Hip Thrust (Dumbbell)': [
    "Start by sitting on the ground with your upper back resting against a bench or elevated surface. Place a dumbbell on your hips, holding it securely with both hands.",
    "Bend your knees and position your feet flat on the ground, hip-width apart. Your heels should be close to your glutes.",
    "Engage your core muscles and press your feet into the ground, driving your hips upward. Lift your glutes off the ground until your body forms a straight line from your knees to your shoulders.",
    "Squeeze your glutes at the top of the movement and hold for a brief pause. Ensure that your knees are in line with your toes and your thighs are parallel to the ground.",
    "Slowly lower your hips back down to the starting position, maintaining control throughout the movement. Avoid letting your hips touch the ground completely before beginning the next repetition.",
    "Repeat the exercise for the desired number of repetitions, focusing on maintaining proper form and engaging your glutes throughout the movement."
  ],
  'Pullover (Dumbbell)': [
    "Lie down on a flat bench with your head at one end and your feet firmly planted on the ground.",
    "Hold a dumbbell with both hands, palms facing up, and extend your arms straight above your chest.",
    "Keep a slight bend in your elbows throughout the exercise to avoid strain on the joints.",
    "Inhale deeply and slowly lower the dumbbell backward in an arc motion behind your head, maintaining control and a slight bend in your elbows.",
    "Continue lowering the dumbbell until you feel a stretch in your chest and shoulders, but be cautious not to go too far or strain your shoulders.",
    "Exhale and use your chest and shoulder muscles to bring the dumbbell back to the starting position, following the same arc motion.",
    "Repeat the movement for the desired number of repetitions, ensuring you maintain control and a steady pace throughout the exercise.",
    "Once you complete the set, carefully place the dumbbell down and rest before performing additional sets if desired."
  ],
  'Reverse Curl (Dumbbell)': [
    "Stand up straight with your feet shoulder-width apart and hold a dumbbell in each hand, palms facing down. This is your starting position.",
    "Keeping your upper arms stationary, exhale and curl the weights while contracting your biceps. Continue to raise the dumbbells until your biceps are fully contracted and the dumbbells are at shoulder level. Hold the contracted position for a brief pause as you squeeze your biceps.",
    "Inhale and slowly begin to lower the dumbbells back to the starting position, allowing your arms to fully extend and your biceps to stretch.",
    "Repeat for the desired number of repetitions."
  ],
  'Reverse Wrist Curl (Dumbbell)': [
    "Hold a dumbbell in each hand with an overhand grip, palms facing down.",
    "Sit on a bench or chair with your forearms resting on your thighs and your wrists hanging over the knees.",
    "Slowly lower the dumbbells towards the floor by bending your wrists, keeping your forearms stationary.",
    "Once you feel a stretch in your forearms, slowly curl the dumbbells back up by extending your wrists, keeping your forearms stationary.",
    "Repeat for the desired number of repetitions, focusing on controlled movements and a full range of motion."
  ],
  'Side Bend (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in your right hand with your arm extended down by your side.",
    "Keeping your back straight and core engaged, slowly bend to the right as far as comfortably possible, lowering the dumbbell towards your right knee.",
    "Hold the position for a moment, then slowly return to the starting position.",
    "Repeat the movement for the desired number of repetitions on the right side, then switch the dumbbell to your left hand and perform the same number of repetitions on the left side."
  ],
  'Skullcrushers (Dumbbell)': [
    "Lie flat on a bench with your feet planted firmly on the ground and your knees bent.",
    "Hold a dumbbell in each hand, with your palms facing inward and your arms fully extended above your chest.",
    "Slowly lower the dumbbells towards your forehead by bending your elbows, keeping your upper arms stationary and perpendicular to the floor.",
    "Pause for a moment when the dumbbells are just above your forehead, then exhale and extend your arms back to the starting position, fully contracting your triceps.",
    "Repeat the movement for the desired number of repetitions, ensuring that you maintain control and a steady pace throughout the exercise.",
    "Remember to keep your elbows in a fixed position and avoid any swinging or jerking motions.",
    "Once you have completed the set, carefully place the dumbbells back on the ground or rack, ensuring proper safety and control."
  ],
  'Split Squat (Dumbbell)': [
    "Stand with your feet hip-width apart, holding a dumbbell in each hand by your sides.",
    "Take a big step forward with your right foot, keeping your torso upright and your core engaged.",
    "Lower your body down by bending both knees until your right thigh is parallel to the ground, and your left knee is hovering just above the floor.",
    "Ensure that your right knee is directly above your ankle and not extending past your toes.",
    "Push through your right heel to return to the starting position, keeping your weight centered and balanced.",
    "Repeat the movement for the desired number of repetitions on the right side.",
    "Switch sides by stepping forward with your left foot and repeat the exercise on the left side.",
    "Remember to maintain proper form throughout the exercise, keeping your chest lifted, shoulders back, and core engaged.",
    "Breathe steadily throughout the movement, inhaling as you lower down and exhaling as you push back up.",
    " Start with a weight that challenges you but allows you to maintain proper form. Gradually increase the weight as you become more comfortable and stronger with the exercise."
  ],
  'Squat (Dumbbell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Hold a dumbbell in each hand, allowing them to hang by your sides with your palms facing inward.",
    "Engage your core muscles by pulling your belly button in towards your spine. Keep your chest lifted and your shoulders relaxed.",
    "Begin the movement by bending your knees and pushing your hips back as if you are sitting back into a chair. Keep your weight on your heels throughout the exercise.",
    "Continue lowering your body until your thighs are parallel to the ground, or as low as you can comfortably go. Ensure that your knees do not extend beyond your toes.",
    "Pause for a moment at the bottom of the squat, then exhale and push through your heels to return to the starting position. Keep your chest lifted and maintain good posture throughout the movement.",
    "Repeat the squat for the desired number of repetitions, maintaining proper form and control. ",
    "Remember to breathe throughout the exercise, inhaling as you lower your body and exhaling as you push back up."
  ],
  'Stiff Legged Deadlift (Dumbbell)': [
    "Stand with your feet shoulder-width apart and hold a dumbbell in each hand with your palms facing your thighs.",
    "Keep your back straight and your core engaged as you hinge forward at the hips, lowering the dumbbells towards the ground.",
    "Keep your knees slightly bent and your weight in your heels as you lower the dumbbells as far as you can without rounding your back.",
    "Pause for a moment at the bottom of the movement, then slowly raise your torso back up to the starting position, squeezing your glutes and hamstrings as you do so.",
    "Repeat for the desired number of reps, keeping your back straight and your core engaged throughout the movement."
  ],
  'Sumo Deadlift (Dumbbell)': [
    "Stand with your feet shoulder-width apart and your toes pointing outwards at a 45-degree angle.",
    "Hold a dumbbell in each hand with an overhand grip and let your arms hang straight down in front of you.",
    "Bend your knees and lower your hips until your thighs are parallel to the ground.",
    "Keep your back straight and your chest up as you lift the dumbbells off the ground by extending your hips and knees.",
    "As you lift the dumbbells, keep them close to your body and squeeze your glutes at the top of the movement.",
    "Lower the dumbbells back down to the ground by bending your knees and hips, keeping your back straight and your chest up.",
    "Repeat for the desired number of reps."
  ],
  'Sumo Goblet Squat (Dumbbell)': [
    "Stand with your feet slightly wider than shoulder-width apart, toes pointed outwards at a 45-degree angle.",
    "Hold a dumbbell vertically with both hands, gripping the sides of the dumbbell head.",
    "Keep your chest up, shoulders back, and engage your core muscles.",
    "Begin the movement by bending your knees and pushing your hips back, as if you are sitting back into a chair.",
    "Lower your body down until your thighs are parallel to the ground, or as low as you can comfortably go.",
    "Ensure that your knees are tracking over your toes and not collapsing inward.",
    "Pause for a moment at the bottom of the squat, then push through your heels to return to the starting position.",
    "Squeeze your glutes at the top of the movement to fully engage your hip muscles.",
    "Repeat the squat for the desired number of repetitions.",
    " Remember to maintain proper form throughout the exercise, keeping your back straight and chest lifted."
  ],
  'Elevated Glute Bridge': [
    "Start by lying on your back with your knees bent and feet flat on an elevated surface such as a bench or platform.",
    "Engage your core and glutes as you lift your hips off the ground, creating a straight line from your knees to your shoulders.",
    "Hold the top position for a second, focusing on squeezing your glutes.",
    "Slowly lower your hips back down to the starting position, keeping your core engaged throughout the movement.",
    "Repeat for the desired number of reps, making sure to maintain proper form and control throughout the exercise."
  ],
  'Elliptical': [
    "Stand on the foot pedals of the elliptical machine with your feet hip-width apart and grasp the handles with your hands.",
    "Start moving your legs in a smooth, circular motion by pushing down on the pedals with your heels and pulling up with your toes. Keep your back straight and core engaged throughout the exercise.",
    "As you start to move your legs, push and pull the handles back and forth in a coordinated motion to work your upper body as well."
  ],
  'Bicep Curl (Ez Bar)': [
    "Stand up straight with your feet shoulder-width apart and hold the EZ bar with an underhand grip. Your palms should be facing upward, and your hands should be slightly wider than shoulder-width apart.",
    "Keep your upper arms close to your torso and your elbows locked in place. This is your starting position.",
    "Slowly exhale and curl the EZ bar upwards by contracting your biceps. Keep your upper arms stationary throughout the movement. Continue lifting until your biceps are fully contracted and the bar is at shoulder level.",
    "Hold the contracted position for a brief pause, squeezing your biceps.",
    "Inhale and slowly lower the EZ bar back to the starting position, allowing your arms to fully extend.",
    "Repeat for the desired number of repetitions."
  ],
  'Farmers Walk': [
    "Stand tall with a dumbbell or kettlebell in each hand, your arms extended by your sides.",
    "Keep your core engaged and shoulders pulled back.",
    "Take slow and controlled steps forward while keeping your back straight and chest up.",
    "Walk for a specific distance or time, making sure to keep your posture in check throughout the movement.",
    "Once you've reached the end of your set distance or time, carefully set the weights down and rest as needed before repeating the exercise."
  ],
  'Glute Ham Raise': [
    "Position yourself on a glute ham raise machine or secure your feet under a stable object like a bench or barbell.",
    "Start by kneeling on the pad with your knees slightly behind the edge and your feet secured.",
    "Engage your core and keep your back straight throughout the movement.",
    "Slowly lower your upper body forward while maintaining control until your torso is parallel to the ground.",
    "As you descend, allow your body to hinge at the hips and keep your glutes engaged.",
    "Continue lowering your upper body until you feel a stretch in your hamstrings.",
    "Once you reach the bottom position, contract your hamstrings and glutes to raise your upper body back up to the starting position.",
    "As you ascend, focus on using your hamstrings and glutes to pull your body up rather than relying on your lower back.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to maintain a controlled and smooth motion throughout the exercise, avoiding any jerking or swinging motions"
  ],
  'Handstand Push Up': [
    "Start by standing with your feet shoulder-width apart and your arms extended overhead.",
    "Bend forward at the waist and place your hands on the ground, shoulder-width apart.",
    "Kick your legs up into the air, using your core and upper body strength to balance yourself upside down.",
    "Once in the handstand position, slowly lower your body towards the ground by bending your elbows. Keep your head neutral and your neck in line with your spine.",
    "Continue lowering your body until your head lightly touches the ground or your range of motion allows.",
    "Push through your palms and extend your arms to push your body back up to the starting handstand position.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to engage your core, glutes, and shoulder muscles throughout the exercise to maintain stability and control.",
    "If you're a beginner, you can modify this exercise by performing it against a wall for added support and stability."
  ],
  'Hanging Leg Raise': [
    "Hang from a pull-up bar with an overhand grip, keeping your arms fully extended.",
    "Engage your core muscles and lift your legs up towards the ceiling, keeping them straight.",
    "Continue lifting until your legs are parallel to the ground or as high as you can go while maintaining control.",
    "Hold for a moment at the top of the movement before slowly lowering your legs back to the starting position.",
    "Avoid swinging or using momentum to lift your legs, focus on using your abdominal muscles to control the movement.",
    "Repeat for desired number of repetitions."
  ],
  'High Pulley Cable Curl': [
    "Stand facing the cable machine with the pulley set to the highest position.",
    "Grab the handle attachment with an underhand grip, palms facing up.",
    "Keep your elbows close to your sides and engage your core for stability.",
    "Slowly curl the handle towards your shoulders, contracting your biceps at the top of the movement.",
    "Hold the peak contraction for a second, then slowly lower the handle back to the starting position.",
    "Repeat for the desired number of repetitions.",
    "Focus on controlled movements and avoid swinging or using momentum to lift the weight."
  ],
  'Incline Cable Fly': [
    "Adjust the cable machine to a height slightly above your shoulder level. Attach the desired weight to both sides of the machine.",
    "Stand in the middle of the cable machine, facing away from it. Grab one handle in each hand, palms facing forward. Step forward a few feet to create tension in the cables.",
    "Position yourself on an incline bench set at a 45-degree angle. Keep your feet flat on the floor, shoulder-width apart, and your back firmly pressed against the bench.",
    "Start with your arms extended out to the sides, slightly bent at the elbows. This is your starting position.",
    "Inhale and slowly lower your arms in a controlled manner, maintaining a slight bend in your elbows. Keep your palms facing forward throughout the movement.",
    "Continue lowering your arms until your hands are in line with your chest or slightly below, feeling a stretch in your chest muscles. Keep your elbows at a fixed angle throughout the exercise.",
    "Exhale and squeeze your chest muscles as you reverse the movement, bringing your arms back up to the starting position. Focus on using your chest muscles to perform the movement, rather than relying on your arms or shoulders.",
    "Repeat the exercise for the desired number of repetitions, typically 8-12 reps per set. Remember to maintain proper form and control throughout the exercise.",
    "Once you have completed the set, carefully release the tension in the cables and place the handles back on the machine."
  ],
  'Incline Curl (Dumbbell)': [
    "Stand upright with a dumbbell in each hand, palms facing forward, and arms fully extended by your sides.",
    "Take a step forward with one foot, positioning yourself on an incline bench set at a 45-degree angle.",
    "Keep your back straight, chest up, and core engaged throughout the exercise.",
    "Slowly curl the dumbbells towards your shoulders, while keeping your upper arms stationary and elbows close to your sides.",
    "Continue curling until your biceps are fully contracted and the dumbbells are at shoulder level.",
    "Hold the contracted position for a brief pause, squeezing your biceps.",
    "Slowly lower the dumbbells back to the starting position, fully extending your arms.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to breathe steadily throughout the exercise, exhaling as you curl the dumbbells up and inhaling as you lower them down.",
    " Maintain control and avoid swinging or using momentum to lift the weights, focusing on the contraction of your biceps.",
    " Once you have completed the set, switch legs and repeat the exercise with the opposite foot forward."
  ],
  'Incline Chest Fly (Dumbbell)': [
    "Start by holding a dumbbell in each hand and lie down on an incline bench with your feet flat on the floor.",
    "Extend your arms out to the sides, slightly bending your elbows.",
    "Slowly lower the dumbbells down towards the ground in a controlled motion, keeping a slight bend in your elbows.",
    "As you lower the dumbbells, focus on feeling a stretch in your chest muscles.",
    "Once your arms are parallel to the ground, pause for a moment before squeezing your chest muscles to bring the dumbbells back up to the starting position.",
    "Repeat for the desired number of repetitions, making sure to keep your core engaged and maintain proper form throughout the exercise."
  ],
  'Incline Hammer Curl (Dumbbell)': [
    "Holding a dumbbell in each hand, sit on an incline bench with your back against the pad and arms extended down by your sides.",
    "Keep your elbows close to your torso and palms facing inward throughout the movement.",
    "Slowly curl the dumbbells towards your shoulders, focusing on contracting your biceps as you lift the weight.",
    "Pause at the top of the movement and squeeze your biceps before slowly lowering the weights back to the starting position.",
    "Repeat for the desired number of reps, ensuring to maintain proper form and control throughout the exercise.",
    "Remember to breathe consistently throughout the movement and avoid swinging or using momentum to lift the weights. Focus on isolating the biceps to maximize the effectiveness of the exercise."
  ],
  'Incline Push Up': [
    "Stand facing a sturdy elevated surface, such as a bench, step, or countertop.",
    "Place your hands slightly wider than shoulder-width apart on the surface, fingers pointing forward.",
    "Step back and position your feet hip-width apart, creating a straight line from your head to your heels.",
    "Engage your core muscles by drawing your belly button towards your spine.",
    "Lower your chest towards the surface by bending your elbows, keeping them close to your body.",
    "Continue lowering until your chest is just above the surface, or as far as you can comfortably go.",
    "Pause for a moment, then push through your hands to extend your arms and return to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Inverted Row': [
    "Find a sturdy horizontal bar or a Smith machine at waist height.",
    "Stand facing the bar and grab it with an overhand grip, slightly wider than shoulder-width apart.",
    "Walk your feet forward until your body is at an angle, leaning back with your arms fully extended.",
    "Keep your body straight and engage your core muscles.",
    "Pull your chest towards the bar by squeezing your shoulder blades together.",
    "Continue pulling until your chest touches the bar or comes close to it.",
    "Pause for a moment, then slowly lower your body back to the starting position, fully extending your arms.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Goblet Squat (Kettlebell)': [
    "Stand with your feet slightly wider than shoulder-width apart, toes pointing slightly outward. Hold a kettlebell with both hands, gripping the sides of the handle, close to your chest. This is your starting position.",
    "Brace your core by pulling your belly button in towards your spine. Keep your chest up, shoulders back, and maintain a neutral spine throughout the exercise.",
    "Initiate the movement by pushing your hips back and bending your knees to lower your body into a squat position. Imagine sitting back into a chair.",
    "As you descend, keep your weight on your heels and maintain a strong posture. Your knees should track in line with your toes, and your thighs should be parallel to the ground or slightly below.",
    "Pause briefly at the bottom of the squat, ensuring your knees are stable and not collapsing inward.",
    "Push through your heels and engage your glutes and quadriceps to drive yourself back up to the starting position. Exhale as you rise.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Lateral Raise (Kettlebell)': [
    "Stand with your feet shoulder-width apart, holding a kettlebell in each hand with an overhand grip. Let your arms hang down by your sides, palms facing your body.",
    "Engage your core muscles and maintain a slight bend in your elbows throughout the exercise.",
    "Keeping your back straight and your gaze forward, exhale and lift both kettlebells out to the sides until your arms are parallel to the floor. Your elbows should be slightly higher than your wrists.",
    "Pause for a moment at the top of the movement, squeezing your shoulder blades together to engage your deltoids (shoulder muscles).",
    "Inhale and slowly lower the kettlebells back down to the starting position, maintaining control and resisting any swinging or jerking motions.",
    "Repeat the exercise for the desired number of repetitions, focusing on maintaining proper form and control throughout the movement.",
    "Remember to breathe steadily throughout the exercise, exhaling as you lift the kettlebells and inhaling as you lower them.",
    "To increase the intensity, you can use heavier kettlebells or perform the exercise with a slower tempo.",
    "It's important to listen to your body and stop the exercise if you experience any pain or discomfort."
  ],
  'Overhead Squat (Kettlebell)': [
    "Stand with your feet shoulder-width apart, with a kettlebell held overhead in one hand.",
    "Keep your arm straight and your gaze forward as you lower your body into a squat position, pushing your hips back and bending your knees.",
    "Lower down as far as you can while keeping your chest up and your back straight.",
    "Drive through your heels to stand back up, keeping the kettlebell overhead the entire time.",
    "Repeat for the desired number of repetitions, then switch sides and perform the exercise with the kettlebell in the other hand."
  ],
  'Romanian Deadlift (Kettlebell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Hold a kettlebell in one hand, allowing it to hang in front of your thighs with your arm fully extended.",
    "Engage your core muscles by pulling your belly button in towards your spine. Keep your back straight and maintain a slight bend in your knees throughout the exercise.",
    "Begin the movement by hinging at your hips, pushing your glutes back as if you are trying to touch the wall behind you with your buttocks. Keep your chest lifted and your shoulders pulled back.",
    "As you lower the kettlebell, allow it to slide down your thighs while keeping it close to your body. Continue to lower the kettlebell until you feel a stretch in your hamstrings, but avoid rounding your back.",
    "Once you reach the maximum stretch in your hamstrings, reverse the movement by engaging your glutes and hamstrings to pull your body back up to the starting position. Keep your back straight and avoid using your lower back to lift the kettlebell.",
    "Repeat the movement for the desired number of repetitions, then switch the kettlebell to the other hand and perform the exercise again."
  ],
  'Side Squat (Kettlebell)': [
    "Hold a kettlebell with both hands at chest level.",
    "Stand with your feet shoulder-width apart.",
    "Take a wide step to the right, bending your right knee and keeping your left leg straight.",
    "Lower your body down into a squat position, keeping your chest up and back straight.",
    "Push through your right heel to return to the starting position.",
    "Repeat the movement on the left side, taking a wide step to the left and squatting down.",
    "Continue alternating sides for the desired number of repetitions."
  ],
  'Snatch (Kettlebell)': [
    "Stand with your feet shoulder-width apart and a kettlebell on the floor between your feet.",
    "Hinge at your hips and bend your knees to reach down and grab the kettlebell with one hand.",
    "Engage your core and drive through your heels to lift the kettlebell off the ground, using the momentum to swing it between your legs.",
    "As the kettlebell swings back, quickly extend your hips and knees to generate upward momentum.",
    "Pull the kettlebell up towards your shoulder, allowing your elbow to bend and your hand to rotate around the handle.",
    "As the kettlebell reaches its highest point, quickly drop underneath it and catch it in a squat position, with your arm fully extended overhead.",
    "Stand up from the squat position, keeping the kettlebell overhead, and then lower it back down to the starting position between your legs.",
    "Repeat the movement for the desired number of repetitions, then switch to the other hand and perform the same number of reps."
  ],
  'Squat (Kettlebell)': [
    "Stand with feet shoulder-width apart and toes slightly turned outward. Hold a kettlebell by the handle with both hands, close to your chest.",
    "Engage your core, keep your chest up, and maintain a neutral spine as you begin to lower your body by bending at the hips and knees.",
    "Keep your weight in your heels and lower yourself down until your thighs are parallel to the ground. Make sure your knees track in line with your toes.",
    "Push through your heels to stand back up to the starting position, straightening your legs and squeezing your glutes at the top.",
    "Repeat for the desired number of repetitions, focusing on maintaining proper form throughout the movement."
  ],
  'Sumo Squat (Kettlebell)': [
    "Hold a kettlebell in both hands at arm's length, with your feet wider than shoulder-width apart and your toes slightly turned out.",
    "Keep your chest up, engage your core, and lower your body by bending your knees and pushing your hips back as if you're sitting into a chair.",
    "Go as low as you can while keeping your chest up and your heels flat on the ground.",
    "Drive through your heels to return to the starting position, squeezing your glutes at the top.",
    "Repeat for desired number of repetitions."
  ],
  'Swings (Kettlebell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Place the kettlebell on the floor in front of you.",
    "Bend your knees slightly and hinge at the hips, keeping your back straight and chest up. Reach down and grab the kettlebell handle with both hands, palms facing towards you.",
    "Engage your core muscles and maintain a strong grip on the kettlebell. This will be your starting position.",
    "In one fluid motion, explosively drive your hips forward, extending your knees and swinging the kettlebell up to chest level. Your arms should remain straight throughout the movement, using the momentum generated by your hips to swing the kettlebell.",
    "As the kettlebell reaches its highest point, squeeze your glutes and tighten your core to create a strong and stable position.",
    "Allow the kettlebell to swing back down between your legs, maintaining control and keeping your back straight. Your arms should still be straight at this point.",
    "As the kettlebell swings back between your legs, quickly hinge at the hips and repeat the explosive hip drive to swing the kettlebell back up to chest level. Remember to keep your core engaged and maintain a strong grip on the kettlebell.",
    "Continue this swinging motion, smoothly transitioning from the downswing to the upswing, using the power generated by your hips and lower body.",
    "Perform the desired number of repetitions, ensuring proper form and control throughout the exercise.",
    " To finish, gently lower the kettlebell back down to the starting position, maintaining control and keeping your back straight."
  ],
  'Upright Row (Kettlebell)': [
    "Stand with your feet shoulder-width apart and hold the kettlebell with both hands in front of your thighs. Keep your back straight and core engaged.",
    "Engage your shoulders and pull the kettlebell straight up towards your chin, keeping your elbows higher than your forearms. Your elbows should be in line with your shoulders.",
    "Slowly lower the kettlebell back down to starting position and repeat for the desired number of reps.",
    "Ensure that you are using proper form throughout the exercise to avoid any strain on your shoulders or back."
  ],
  'Lateral Raise (Machine)': [
    "Sit on the lateral raise machine with your back against the backrest and your feet flat on the floor.",
    "Adjust the seat height so that the handles are at shoulder level.",
    "Grasp the handles with an overhand grip, palms facing down.",
    "Keep your core engaged and maintain a slight bend in your elbows throughout the exercise.",
    "Exhale and slowly lift the handles out to the sides, away from your body, until your arms are parallel to the floor.",
    "Pause for a moment at the top of the movement, focusing on squeezing your shoulder muscles.",
    "Inhale and slowly lower the handles back to the starting position, controlling the movement.",
    "Repeat for the desired number of repetitions.",
    "Remember to maintain proper form throughout the exercise, avoiding any jerking or swinging motions.",
    " To increase the intensity, you can adjust the weight on the machine or perform the exercise with one arm at a time."
  ],
  'Lever Back Extension (Machine)': [
    "Sit in the lever back extension machine with your feet secured under the foot pads.",
    "Slowly lean forward at the hips, keeping your back straight.",
    "Lower your torso towards the floor until you feel a stretch in your lower back and hamstrings.",
    "Engage your back muscles and slowly lift your torso back up to the starting position.",
    "Avoid using momentum to lift yourself back up, focus on engaging your back muscles to perform the movement.",
    "Repeat for the desired number of repetitions."
  ],
  'Lever High Row (Machine)': [
    "Sit on the machine with your back straight and your feet flat on the footrests.",
    "Adjust the seat height and footrests so that your knees are slightly bent and your legs are comfortably positioned.",
    "Grasp the handles with an overhand grip, palms facing down. Your hands should be shoulder-width apart or slightly wider.",
    "Keep your chest up, shoulders back, and engage your core muscles.",
    "Begin the movement by pulling the handles towards your upper abdomen, squeezing your shoulder blades together.",
    "Keep your elbows close to your body and your wrists straight throughout the exercise.",
    "Pause for a moment at the fully contracted position, feeling the tension in your back muscles.",
    "Slowly release the handles and return to the starting position, allowing your arms to fully extend.",
    "Repeat the movement for the desired number of repetitions.",
    " Focus on maintaining proper form and control throughout the exercise. Avoid using momentum or jerking motions.",
    " Breathe out as you pull the handles towards your body and breathe in as you return to the starting position.",
    " Adjust the weight on the machine according to your fitness level and goals.",
    " To increase the intensity, you can pause for a few seconds at the fully contracted position or perform the exercise with a slower tempo."
  ],
  'Lever Preacher Curl (Machine)': [
    "Sit on the preacher curl machine with your chest against the pad and your arms extended, holding the handles with an underhand grip.",
    "Keep your upper arms stationary and exhale as you curl the handles towards your shoulders, contracting your biceps.",
    "Hold the peak contraction for a moment, then slowly lower the handles back to the starting position while inhaling.",
    "Repeat for the desired number of reps, focusing on maintaining proper form and control throughout the movement.",
    "Once you have completed your set, carefully release the handles and carefully dismount from the machine."
  ],
  'Lever Pullover (Machine)': [
    "Sit on the machine with your back against the backrest and your feet flat on the floor.",
    "Adjust the seat height and position so that your arms can comfortably reach the lever handles.",
    "Grasp the lever handles with an overhand grip, slightly wider than shoulder-width apart.",
    "Keep your arms extended and your elbows slightly bent throughout the exercise.",
    "Inhale and slowly pull the lever handles towards your body, allowing your arms to move in a semi-circular motion.",
    "Focus on engaging your chest and back muscles as you bring the handles closer to your body.",
    "Exhale and slowly return the lever handles to the starting position, maintaining control and resistance.",
    "Repeat the movement for the desired number of repetitions.",
    "Keep your core engaged and maintain a stable posture throughout the exercise.",
    " Remember to breathe steadily and avoid holding your breath during the movement."
  ],
  'Lever Reverse Hyperextension': [
    "Lie face down on a lever reverse hyperextension machine with your hips lined up at the edge of the pad and your legs straight out behind you.",
    "Engage your core and glutes as you lift your legs up towards the ceiling, keeping them straight.",
    "Squeeze your glutes at the top of the movement, then slowly lower your legs back down to the starting position.",
    "Repeat for the desired number of reps, making sure to keep your core engaged and control the movement throughout."
  ],
  'Low Cable Chest Fly ': [
    "Stand facing away from the cable machine with a handle in each hand, arms extended to the sides at shoulder height.",
    "Keep a slight bend in your elbows and engage your core for stability.",
    "Slowly bring your arms forward in a wide arc, squeezing your chest muscles as you bring your hands together in front of your body.",
    "Hold the contraction for a moment, then slowly release back to the starting position.",
    "Repeat for the desired number of reps, focusing on controlled movements and proper form throughout the exercise.",
    "Remember to breathe continuously and avoid using momentum to swing the weights. Focus on using your chest muscles to perform the movement."
  ],
  'Muscle Up': [
    "Start by hanging from a pull-up bar with an overhand grip, hands slightly wider than shoulder-width apart.",
    "Engage your core and pull your chest towards the bar, using the momentum to swing your body up and over the bar.",
    "As you reach the top of the bar, quickly rotate your wrists so that your palms are facing away from you.",
    "Push down on the bar and straighten your arms to push your body up and over the bar, bringing your chest up towards the bar.",
    "Once your chest is over the bar, continue to press down and straighten your arms to complete the muscle up.",
    "Lower yourself back down with control, reversing the movement to return to the starting position.",
    "Repeat the movement for the desired number of repetitions. Remember to engage your core throughout to maintain control and stability."
  ],
  'Negative Pull Up ': [
    "Stand underneath a pull-up bar and reach up to grab the bar with an overhand grip, hands shoulder-width apart.",
    "Jump or use a bench to assist yourself in getting into the top position of a pull-up, with your chin above the bar.",
    "Slowly lower yourself down, focusing on controlling the movement with your arms and back muscles.",
    "Aim to lower yourself as slowly as possible, taking at least 3-5 seconds to reach the bottom of the movement.",
    "Once at the bottom, release the bar and reset for the next repetition."
  ],
  'Neutral Grip Lateral Pulldown ': [
    "Sit down on the pulldown machine and grasp the handles with a neutral grip (palms facing each other) at shoulder width.",
    "Keep your chest up and your back straight as you pull the handles down towards your chest.",
    "As you pull the handles down, focus on squeezing your shoulder blades together and engaging your back muscles.",
    "Slowly release the handles back to the starting position, keeping your back straight and your chest up.",
    "Repeat for the desired number of repetitions, maintaining control and focusing on the contraction of your back muscles throughout the movement."
  ],
  'Neutral Grip Pull Up ': [
    "Start hanging from a pull-up bar with your palms facing each other and your hands shoulder-width apart.",
    "Keep your core engaged, and pull yourself up towards the bar until your chin is above the bar.",
    "Pause for a moment at the top of the movement, then slowly lower yourself back down to the starting position.",
    "Repeat for the desired number of repetitions, focusing on using your back muscles to pull yourself up rather than relying on momentum.",
    "Keep your body straight and avoid swinging or using excessive momentum to complete the movement. ",
    "Exhale as you pull yourself up and inhale as you lower yourself back down. ",
    "Perform the exercise with control and focus on engaging the muscles in your back throughout the movement. ",
    "Adjust the difficulty by using resistance bands or a weight belt as needed."
  ],
  'Parallel Bar Dips': [
    "Stand between the parallel bars with your arms extended and palms facing down on each bar.",
    "Keep your chest up and shoulders back as you lower your body down by bending your elbows until they are at a 90-degree angle.",
    "Push yourself back up to the starting position by straightening your arms, keeping your core engaged throughout the movement.",
    "Repeat for the desired number of reps, focusing on controlled and smooth movements.",
    "Remember to keep your body in a straight line throughout the exercise and avoid swinging or using momentum to complete the movement."
  ],
  'Pec Deck': [
    "Sit on the Pec Deck machine with your back flat against the backrest and your feet firmly planted on the floor.",
    "Adjust the seat height so that the handles are at chest level.",
    "Grasp the handles with an overhand grip, palms facing downward.",
    "Keep your elbows slightly bent and in line with your shoulders throughout the exercise.",
    "Exhale and push the handles forward, bringing them together in front of your chest.",
    "Squeeze your chest muscles at the peak of the movement for a brief moment.",
    "Inhale and slowly return the handles back to the starting position, allowing your chest muscles to stretch.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Pendlay Row ': [
    "Stand with your feet shoulder-width apart and your knees slightly bent.",
    "Hold a barbell with an overhand grip, hands slightly wider than shoulder-width apart.",
    "Hinge at the hips and lower your torso until it is almost parallel to the floor, keeping your back straight.",
    "Pull the barbell up towards your chest, keeping your elbows close to your body and squeezing your shoulder blades together at the top of the movement.",
    "Lower the barbell back down to the starting position in a controlled manner.",
    "Repeat for the desired number of repetitions."
  ],
  'Pistol Squat': [
    "Stand tall with your feet hip-width apart, toes pointing forward.",
    "Shift your weight onto your left leg and lift your right foot off the ground, keeping it slightly extended in front of you.",
    "Engage your core and maintain a straight back throughout the exercise.",
    "Begin to lower your body down by bending your left knee and pushing your hips back, as if sitting into a chair.",
    "As you lower, keep your right leg extended in front of you, parallel to the ground.",
    "Continue descending until your left thigh is parallel to the ground, or as low as you can comfortably go.",
    "Pause for a moment at the bottom, then push through your left heel to rise back up to the starting position.",
    "Repeat the movement for the desired number of repetitions on one leg before switching to the other leg."
  ],
  'Plance Dip Muscles': [
    "Start in a plank position with your hands directly under your shoulders and your body in a straight line from head to heels.",
    "Lower your body by bending your elbows, keeping them close to your sides, until your chest nearly touches the ground.",
    "Push through your palms to straighten your arms and return to the starting position.",
    "Repeat for the desired number of reps, keeping your core engaged and your body in a straight line throughout the movement."
  ],
  'Pile Squat ': [
    "Stand with your feet slightly wider than hip-width apart and your toes turned out at a 45-degree angle.",
    "Lower your body down into a squat position, keeping your back straight and your chest lifted.",
    "As you lower down, bring your hands together in front of your chest in a prayer position.",
    "Once you reach the bottom of the squat, press through your heels to return to the starting position.",
    "Repeat for the desired number of reps, focusing on keeping your chest lifted and your back straight throughout the movement."
  ],
  'Preacher Curl (Barbell)': [
    "Stand in front of a preacher curl bench with your feet shoulder-width apart.",
    "Adjust the height of the bench so that your armpits rest comfortably on the top pad.",
    "Grasp the barbell with an underhand grip (palms facing up) and hands slightly wider than shoulder-width apart.",
    "Rest your upper arms on the angled pad of the bench, allowing your elbows to fully extend.",
    "Keep your back straight, chest up, and shoulders relaxed throughout the exercise.",
    "Inhale and slowly curl the barbell upwards by flexing your elbows. Keep your upper arms stationary and only use your forearms to lift the weight.",
    "Continue curling until your biceps are fully contracted and the barbell is at shoulder level. Hold this position for a brief pause, squeezing your biceps.",
    "Exhale and slowly lower the barbell back to the starting position, fully extending your elbows.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Pronated Grip Cable Fly': [
    "Stand in the middle of a cable machine, with the pulleys set at shoulder height. Adjust the weight according to your fitness level.",
    "Grab the handles with a pronated grip (palms facing down), keeping your arms extended out to the sides. Your elbows should be slightly bent.",
    "Take a step forward, creating tension on the cables. This will be your starting position.",
    "Engage your core and maintain a slight bend in your knees throughout the exercise.",
    "Keeping your arms slightly bent, exhale and bring your hands together in front of your chest. Imagine hugging a large tree trunk.",
    "Squeeze your chest muscles at the peak of the movement for a brief moment.",
    "Inhale and slowly return your arms back to the starting position, controlling the resistance.",
    "Repeat for the desired number of repetitions."
  ],
  'Pull Up': [
    "Find a sturdy horizontal bar that is high enough for you to hang from without your feet touching the ground.",
    "Stand underneath the bar and reach up to grip it with your palms facing away from you. Your hands should be slightly wider than shoulder-width apart. This is called an overhand grip.",
    "Jump or use a small step to get your chin above the bar. This is the starting position.",
    "Engage your core muscles by squeezing your abs and glutes. This will help maintain stability throughout the exercise",
    "Begin the pull-up by pulling your body upward using your arms and back muscles. Focus on pulling your elbows down towards the ground while keeping your chest lifted.",
    "Continue pulling until your chin is above the bar, or as close as you can get. Try to maintain a smooth and controlled motion throughout the movement.",
    "Pause briefly at the top of the movement, squeezing your shoulder blades together.",
    "Slowly lower your body back down to the starting position, fully extending your arms. Keep your core engaged and avoid swinging or using momentum to complete the repetition.",
    "Repeat the exercise for the desired number of repetitions or until you reach muscle fatigue.",
    " Remember to breathe throughout the exercise. Inhale as you lower your body and exhale as you pull yourself up."
  ],
  'Rack Pull (Barbell)': [
    "Stand in front of the barbell with your feet shoulder-width apart.",
    "Bend your knees slightly and hinge at your hips to reach down and grip the barbell with an overhand grip.",
    "Lift the barbell up until it is just below your knees.",
    "Keeping your back straight and your core engaged, pull the barbell up towards your hips by driving your elbows back.",
    "Pause at the top of the movement, squeezing your glutes and shoulder blades together.",
    "Lower the barbell back down to just below your knees, keeping your back straight and your core engaged.",
    "Repeat for the desired number of repetitions."
  ],
  'Reverse Pec Deck': [
    "Sit on the Reverse Pec Deck machine with your back against the backrest and your feet flat on the floor.",
    "Adjust the seat height so that the handles are at shoulder level or slightly below.",
    "Grasp the handles with an overhand grip, palms facing down.",
    "Keep your elbows slightly bent and your arms parallel to the floor throughout the exercise.",
    "Engage your core and maintain a neutral spine position.",
    "Begin the movement by squeezing your shoulder blades together and pulling the handles backward.",
    "Continue to squeeze your shoulder blades as you bring your arms back as far as possible, feeling a contraction in your upper back muscles.",
    "Hold the contracted position for a brief moment, focusing on the tension in your back muscles.",
    "Slowly return to the starting position by allowing your arms to move forward, maintaining control throughout the movement.",
    " Repeat for the desired number of repetitions."
  ],
  'Ring Dips': [
    "Start by gripping the rings firmly with both hands, palms facing inward. Hang freely with your arms fully extended and your body straight.",
    "Engage your core muscles and slightly lean forward, keeping your elbows close to your body.",
    "Begin to lower your body by bending your elbows, allowing them to flare out to the sides. Lower yourself until your shoulders are below your elbows, aiming for a 90-degree angle at the bottom of the movement.",
    "Once you reach the bottom position, push through your palms and straighten your arms to return to the starting position. Keep your body straight throughout the movement, avoiding any swinging or excessive movement.",
    "Repeat the movement for the desired number of repetitions or as instructed by your workout plan.",
    "Remember to breathe throughout the exercise, exhaling as you push up and inhaling as you lower yourself down."
  ],
  'Rope Climb': [
    "Stand in front of the rope with your feet shoulder-width apart.",
    "Reach up and grab the rope with both hands, making sure your grip is secure.",
    "Use your legs to push off the ground and start climbing the rope.",
    "As you climb, alternate between using your arms and legs to pull yourself up.",
    "Keep your body close to the rope to maintain balance and control.",
    "Continue climbing until you reach the top of the rope or your desired height.",
    "To descend, slowly lower yourself down the rope using your arms and legs to control your speed.",
    "Once you reach the ground, release your grip on the rope and step away."
  ],
  'Rowing': [
    "Sit on the rowing machine with your feet shoulder-width apart. Adjust the foot straps so that they securely hold your feet in place.",
    "Bend your knees and hinge forward at the hips, keeping your back straight. Grasp the handle with an overhand grip, hands slightly wider than shoulder-width apart.",
    "Extend your arms fully in front of you, keeping your shoulders relaxed and your core engaged.",
    "Initiate the movement by driving through your legs, pushing against the foot pedals. As you straighten your legs, lean back slightly, maintaining a strong posture.",
    "Once your legs are fully extended, pull the handle towards your lower chest, leading with your elbows. Keep your wrists straight and your shoulders pulled back.",
    "Squeeze your shoulder blades together at the end of the movement, engaging your upper back muscles.",
    "Reverse the movement by extending your arms forward, leaning your upper body slightly forward, and bending your knees to return to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Wide Grip Pull Up': [
    "Find a sturdy horizontal bar or pull-up bar that is high enough for you to hang from without your feet touching the ground.",
    "Stand facing the bar with your feet shoulder-width apart.",
    "Reach up and grab the bar with both hands using an overhand grip (palms facing away from you) that is wider than shoulder-width apart. Your thumbs should be wrapped around the bar.",
    "Hang from the bar with your arms fully extended, keeping your body straight and your core engaged.",
    "Begin the movement by pulling your shoulder blades down and back, while simultaneously bending your elbows and pulling your chest towards the bar.",
    "Continue pulling until your chin is above the bar, or as close to the bar as you can comfortably reach.",
    "Pause briefly at the top of the movement, squeezing your shoulder blades together and engaging your back muscles.",
    "Slowly lower yourself back down to the starting position, fully extending your arms and maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions.",
    " Remember to breathe throughout the exercise, inhaling as you lower yourself and exhaling as you pull yourself up."
  ],
  'Seated Calf Raise': [
    "Sit on the edge of a chair or bench with your feet flat on the floor and your knees bent at a 90-degree angle.",
    "Place a weight on your thighs just above your knees for added resistance.",
    "Lift your heels off the ground by pushing through the balls of your feet.",
    "Hold the top position for a moment, then slowly lower your heels back down to the starting position.",
    "Repeat for the desired number of repetitions."
  ],
  'Single Leg Calf Raise': [
    "Stand on one leg with your knee slightly bent.",
    "Slowly raise your heel off the ground as high as you can, keeping your toes on the ground.",
    "Hold the raised position for a second to engage your calf muscle.",
    "Lower your heel back down to the starting position in a controlled manner.",
    "Repeat the movement for the desired number of repetitions.",
    "Switch legs and repeat the exercise on the other side."
  ],
  'Single Leg Deadlift (Barbell)': [
    "Stand with your feet hip-width apart, holding a barbell in front of your thighs with an overhand grip. Your palms should be facing your body.",
    "Shift your weight onto your left leg and slightly lift your right foot off the ground, keeping your knee slightly bent.",
    "Engage your core and maintain a straight back throughout the exercise.",
    "Begin the movement by hinging at your hips, pushing your glutes back, and lowering the barbell towards the ground. Simultaneously, extend your right leg straight behind you, keeping it in line with your torso.",
    "Lower the barbell until you feel a stretch in your hamstrings, while keeping your back straight and your right leg in line with your body.",
    "Pause for a moment at the bottom position, then engage your glutes and hamstrings to reverse the movement.",
    "Slowly raise your torso back up to the starting position, while simultaneously lowering your right leg back down to the ground.",
    "Repeat the movement for the desired number of repetitions on one leg before switching to the other leg."
  ],
  'Sit Up': [
    "Lie down on your back on a comfortable mat or floor. Bend your knees and place your feet flat on the ground, hip-width apart. Keep your arms straight and extended above your head, parallel to the ground.",
    "Engage your core muscles by drawing your belly button towards your spine. This will help stabilize your body during the exercise.",
    "Inhale deeply, and as you exhale, slowly lift your upper body off the ground. Start by curling your head, neck, and shoulders off the floor, and continue to roll up until your torso is at a 45-degree angle with the ground. Keep your arms extended and parallel to the ground throughout the movement.",
    "Pause for a moment at the top of the movement, ensuring that your core is fully engaged and your lower back remains in contact with the ground.",
    "Inhale again, and as you exhale, slowly lower your upper body back down to the starting position, rolling down one vertebra at a time. Keep your core engaged and control the movement to avoid flopping back down.",
    "Repeat the movement for the desired number of repetitions or as instructed by your fitness routine. Aim for a controlled and smooth motion, focusing on engaging your abdominal muscles throughout the exercise"
  ],
  'Calf Raise (Smith Machine)': [
    "Stand in front of the Smith Machine with your feet shoulder-width apart and your toes pointing forward. Place the balls of your feet on the edge of a sturdy platform or weight plate, allowing your heels to hang off the edge.",
    "Position the barbell on the Smith Machine at a height that allows you to comfortably reach it while keeping your knees slightly bent. You can adjust the height by unlocking the safety hooks and sliding the bar up or down.",
    "Grasp the barbell with an overhand grip, slightly wider than shoulder-width apart. Your hands should be at the same level as your shoulders.",
    "Straighten your legs and lift the barbell by extending your knees and hips. This is your starting position.",
    "Keeping your core engaged and your back straight, exhale and rise up onto your toes by extending your ankles as high as possible. Focus on contracting your calf muscles throughout the movement.",
    "Hold the contracted position for a brief pause, squeezing your calves at the top.",
    "Inhale and slowly lower your heels back down to the starting position, allowing your calves to stretch.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Deadlift (Smith Machine)': [
    "Stand in front of the Smith Machine with your feet shoulder-width apart. The bar should be at mid-shin level.",
    "Bend your knees and hinge at the hips, keeping your back straight and chest up. Reach down and grip the bar with an overhand grip, slightly wider than shoulder-width apart.",
    "Engage your core and lift your chest, ensuring your shoulders are pulled back and down. This is your starting position.",
    "Take a deep breath in and brace your core.",
    "Begin the movement by driving through your heels and extending your hips and knees simultaneously. Keep your back straight and maintain a neutral spine throughout the lift.",
    "As you stand up, keep the barbell close to your body, sliding it along your thighs.",
    "Once you reach a fully upright position, squeeze your glutes at the top and pause briefly.",
    "Slowly lower the barbell back down by bending at the hips and knees, maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Squat (Smith Machine)': [
    "Stand with your feet shoulder-width apart and position yourself under the bar of the Smith machine.",
    "Place the barbell across your upper back and shoulders, gripping it with both hands slightly wider than shoulder-width apart.",
    "Engage your core and keep your chest up as you slowly lower your body by bending your knees and hips, as if you are sitting back into a chair.",
    "Lower yourself until your thighs are parallel to the ground, making sure your knees do not extend past your toes.",
    "Push through your heels and straighten your legs to return to the starting position.",
    "Repeat for the desired number of repetitions, keeping your back straight and chest up throughout the movement."
  ],
  'Split Squat': [
    "Stand with your feet hip-width apart and take a big step forward with your right foot.",
    "Lower your body down by bending both knees until your right thigh is parallel to the ground and your left knee is hovering just above the floor.",
    "Keep your torso upright and your core engaged.",
    "Push through your right heel to stand back up to the starting position.",
    "Repeat on the other side by stepping forward with your left foot.",
    "Continue alternating legs for the desired number of reps or time."
  ],
  'Calf Raise (Bodyweight)': [
    "Stand with your feet hip-width apart and your weight evenly distributed on both feet.",
    "Engage your core and keep your back straight.",
    "Slowly raise your heels off the ground as high as you can, lifting your body up onto the balls of your feet.",
    "Hold this position for a second to fully contract your calf muscles.",
    "Lower your heels back down to the starting position.",
    "Repeat for the desired number of repetitions.",
    "To make the exercise more challenging, you can perform the calf raises on a step or a raised surface to increase the range of motion.",
    "Remember to breathe consistently throughout the exercise and focus on maintaining proper form."
  ],
  'Standing Leg Curl (Machine)': [
    "Begin by standing in front of the leg curl machine with your feet shoulder-width apart.",
    "Adjust the machine's lever to a suitable weight resistance for your fitness level.",
    "Place your hands on the side handles of the machine for stability and balance.",
    "Lift your right foot and position it against the padded roller of the machine, ensuring that it rests against the back of your ankle.",
    "Keep your core engaged and maintain an upright posture throughout the exercise.",
    "Slowly exhale and bend your right leg at the knee, bringing your heel towards your glutes.",
    "Focus on contracting your hamstring muscles as you curl your leg up.",
    "Hold the contracted position for a brief moment, squeezing your hamstring muscles.",
    "Inhale and gradually lower your right leg back to the starting position, extending it fully but without locking your knee.",
    " Repeat the movement for the desired number of repetitions on your right leg.",
    " Switch sides and perform the same exercise with your left leg.",
    " Continue alternating legs until you have completed the recommended number of sets and repetitions for your workout routine.",
    " Remember to maintain control and avoid using momentum to swing your leg during the exercise.",
    " Once you have finished the exercise, carefully step away from the machine and stretch your hamstrings to cool down."
  ],
  'Overhead Press (Barbell)': [
    "Stand with your feet shoulder-width apart and grip the barbell with your hands slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack and bring it to shoulder height, with your elbows bent and the barbell resting on your collarbone.",
    "Take a deep breath and brace your core.",
    "Press the barbell overhead by extending your arms and pushing the barbell straight up.",
    "Keep your head in a neutral position and avoid arching your back as you press the barbell overhead.",
    "Once the barbell is fully extended overhead, pause for a moment and then slowly lower it back down to the starting position.",
    "Repeat for the desired number of repetitions.",
    "Remember to engage your core and maintain proper form throughout the exercise."
  ],
  'Step Down': [
    "Stand facing a step or platform that is about knee height. Make sure it is sturdy and secure.",
    "Place your right foot firmly on the step, ensuring that your entire foot is in contact with the surface.",
    "Engage your core muscles by pulling your belly button in towards your spine.",
    "Slowly lower your left foot towards the ground, allowing your left toes to lightly touch the floor.",
    "Keep your weight on your right foot and maintain a controlled movement throughout the exercise.",
    "Push through your right heel and lift your left foot back up onto the step, returning to the starting position.",
    "Repeat the movement for the desired number of repetitions on the right side.",
    "Switch sides and perform the exercise with your left foot on the step and your right foot lowering to the ground.",
    "Remember to keep your movements slow and controlled, focusing on maintaining balance and stability.",
    " Perform the Step Down exercise for the desired number of sets and repetitions."
  ],
  'Stiff Legged Deadlift (Smith Machine)': [
    "Stand in front of the Smith Machine with your feet shoulder-width apart.",
    "Position the barbell at mid-thigh level on the Smith Machine.",
    "Stand tall with your chest up, shoulders back, and core engaged.",
    "Grasp the barbell with an overhand grip, slightly wider than shoulder-width apart.",
    "Unlock your knees and keep a slight bend in them throughout the exercise.",
    "Begin the movement by hinging at the hips, pushing your glutes back, and lowering the barbell towards the floor.",
    "Keep your back straight and your head in a neutral position.",
    "Lower the barbell until you feel a stretch in your hamstrings, but avoid rounding your back or letting your shoulders roll forward.",
    "Pause for a moment at the bottom position, then engage your hamstrings and glutes to raise the barbell back up to the starting position.",
    " As you lift, focus on squeezing your glutes and keeping your core tight.",
    " Repeat the movement for the desired number of repetitions.",
    " Remember to maintain control throughout the exercise and avoid using momentum to lift the weight.",
    " Once you have completed the set, carefully place the barbell back on the Smith Machine."
  ],
  'Straight Bar Cable Pushdown': [
    "Stand facing the cable machine with a straight bar attachment attached to the high pulley.",
    "Grasp the bar with an overhand grip, hands shoulder-width apart.",
    "Keep your elbows close to your sides and your upper arms stationary throughout the movement.",
    "Begin the exercise by straightening your arms and pushing the bar downward, focusing on using your triceps to push the weight.",
    "Fully extend your arms at the bottom of the movement, feeling a strong contraction in your triceps.",
    "Slowly return the bar to the starting position by bending your elbows, keeping control of the weight throughout the entire range of motion.",
    "Repeat for the desired number of reps."
  ],
  'Sumo Deadlift (Smith Machine)': [
    "Stand in front of the Smith Machine with your feet wider than shoulder-width apart, toes pointing outwards at a 45-degree angle. The bar should be at mid-shin level.",
    "Bend your knees and lower your hips, keeping your back straight and chest up. Grasp the bar with an overhand grip, hands shoulder-width apart or slightly wider.",
    "Take a deep breath, engage your core, and brace your abs.",
    "Begin the lift by driving through your heels and straightening your legs, pushing your hips forward. Keep your back straight and maintain a neutral spine throughout the movement.",
    "As you lift the bar, focus on pushing your knees outwards and keeping them in line with your toes. This wide stance targets your glutes, hamstrings, and inner thighs.",
    "Continue lifting until you are standing upright, with your hips fully extended and shoulders pulled back.",
    "Pause for a moment at the top, squeezing your glutes and maintaining tension in your core.",
    "To lower the bar, hinge at your hips and push your buttocks back, keeping your back straight. Lower the barbell to the starting position, maintaining control throughout the descent.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'T-Bar Row (Barbell)': [
    "Stand in front of the T-bar machine with your feet shoulder-width apart.",
    "Place a loaded barbell onto the T-bar machine, ensuring it is securely fastened.",
    "Bend your knees slightly and hinge forward at the hips, keeping your back straight and chest up. Grab the handles or the barbell with an overhand grip, slightly wider than shoulder-width apart.",
    "Engage your core and keep your back straight as you pull the barbell towards your torso. Your elbows should be close to your body and pointing backward.",
    "Squeeze your shoulder blades together at the top of the movement, ensuring a full contraction of the back muscles.",
    "Slowly lower the barbell back to the starting position, maintaining control throughout the movement.",
    "Repeat for the desired number of repetitions."
  ],
  'Front Raise (Cable)': [
    "Stand upright with your feet shoulder-width apart, knees slightly bent, and grip the cable attachment with an overhand grip in each hand.",
    "Keep your arms straight and palms facing down as you lift the cable attachment directly in front of you, keeping a slight bend in your elbows.",
    "Lift the cable attachment until your arms are parallel to the floor or just slightly above shoulder height.",
    "Hold this position for a brief pause, then slowly lower the cable attachment back down to the starting position.",
    "Repeat for the desired number of repetitions, making sure to keep your core engaged and maintain proper form throughout the exercise. ",
    "Exhale as you lift the cable attachment and inhale as you lower it back down."
  ],
  'Deadlift (Kettlebell)': [
    "Stand with your feet shoulder-width apart, toes pointing slightly outward. Place the kettlebell on the floor between your feet.",
    "Bend your knees and hinge at the hips, keeping your back straight and chest up. Reach down and grab the kettlebell handle with both hands, palms facing your body. This is your starting position.",
    "Engage your core muscles and brace your abs. Keep your shoulders pulled back and down, away from your ears.",
    "Inhale deeply, then exhale as you drive through your heels and lift the kettlebell off the ground. As you lift, focus on pushing your hips forward and straightening your knees.",
    "Keep your back straight throughout the movement, avoiding any rounding or arching.",
    "Once you reach a standing position, pause for a moment, squeezing your glutes at the top.",
    "Inhale as you slowly lower the kettlebell back down to the starting position, bending at the hips and knees. Keep your back straight and maintain control of the weight.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Single Arm Swing (Kettlebell)': [
    "Begin by standing with your feet shoulder-width apart and the kettlebell on the ground in front of you.",
    "Hinge at the hips and bend your knees slightly to reach down and grab the kettlebell with one hand.",
    "Keep your back flat and core engaged as you drive through your hips and legs to swing the kettlebell back between your legs.",
    "Quickly reverse the motion and drive your hips forward as you swing the kettlebell up to shoulder height, keeping your arm straight.",
    "Let the kettlebell swing back down between your legs and repeat the movement for the desired number of reps.",
    "Switch arms and repeat the exercise on the other side.",
    "Remember to maintain proper form throughout the exercise, keeping your back flat, core engaged, and using the power from your hips to generate the swing."
  ],
  'Split Squat (Kettlebell)': [
    "Begin by standing with your feet hip-width apart, holding a kettlebell in your right hand at shoulder height.",
    "Take a large step forward with your left foot, keeping your right foot in place.",
    "Lower your body down towards the ground by bending your left knee, keeping your right leg straight.",
    "Keep your torso upright and your core engaged throughout the movement.",
    "Pause briefly at the bottom of the movement, then push through your left foot to return to the starting position.",
    "Repeat for the desired number of repetitions, then switch sides and perform the exercise with the kettlebell in your left hand."
  ],
  'Trap Bar Deadlift': [
    "Stand in the center of the trap bar with your feet shoulder-width apart. The bar should be aligned with the middle of your feet.",
    "Bend at your hips and knees, keeping your back straight and chest up. Reach down and grip the handles of the trap bar with an overhand grip.",
    "Take a deep breath, brace your core, and engage your glutes and hamstrings.",
    "Begin the lift by driving through your heels and extending your hips and knees simultaneously. Keep your back straight and maintain a neutral spine throughout the movement.",
    "As you lift the bar, focus on pushing your hips forward and squeezing your glutes at the top of the movement.",
    "Once you reach a standing position, pause briefly and then slowly lower the bar back down by bending at your hips and knees. Keep your back straight and control the descent.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Tricep Dip': [
    "Sit on the edge of a sturdy chair, bench, or step with your hands gripping the edge, fingers pointing forward. Make sure your palms are placed shoulder-width apart.",
    "Slide your buttocks off the edge of the chair, keeping your legs extended in front of you. Your heels should touch the ground, and your knees should be slightly bent.",
    "Straighten your arms, supporting your body weight with your hands. This is your starting position.",
    "Slowly bend your elbows and lower your body towards the ground, keeping your back close to the edge of the chair. Your elbows should be pointing directly behind you.",
    "Continue lowering your body until your upper arms are parallel to the ground. Your forearms should be perpendicular to the floor.",
    "Pause for a moment, then push through your palms to straighten your arms and return to the starting position.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Tricep Extension (Machine)': [
    "Sit down on the tricep extension machine with your back pressed firmly against the backrest.",
    "Grab the handles of the machine with an overhand grip and your palms facing down.",
    "Keep your elbows close to your body and extend your arms fully, pushing the handles down towards the floor.",
    "Squeeze your triceps at the bottom of the movement, then slowly release the handles back to the starting position.",
    "Repeat for the desired number of repetitions, focusing on maintaining control and proper form throughout the exercise.",
    "Remember to breathe regularly and engage your core muscles for added stability."
  ],
  'Tricep Kickback (Dumbbell)': [
    "Stand with your feet shoulder-width apart and hold a dumbbell in your hand.",
    "Bend your knees slightly and hinge forward at the hips, keeping your back straight and your hand resting on your thigh.",
    "Bring your elbow up to your side, keeping it bent at a 90-degree angle and the dumbbell close to your body.",
    "Extend your arm straight back behind you, keeping your elbow close to your side and your palm facing inwards.",
    "Hold for a second, then slowly lower the dumbbell back down to the starting position.",
    "Repeat for the desired number of reps, then switch sides and repeat."
  ],
  'Upright Row (Barbell)': [
    "Stand with your feet shoulder-width apart, holding a barbell with an overhand grip. Your hands should be slightly narrower than shoulder-width apart.",
    "Let the barbell hang in front of your thighs, with your arms fully extended and your palms facing your body.",
    "Keep your back straight, chest up, and engage your core muscles for stability.",
    "Begin the movement by lifting the barbell straight up towards your chin, leading with your elbows. Keep the barbell close to your body throughout the exercise.",
    "As you lift, exhale and squeeze your shoulder blades together, focusing on using your upper back muscles to perform the movement.",
    "Continue lifting until the barbell reaches just below your chin or collarbone level. Your elbows should be higher than your forearms at the top of the movement.",
    "Pause for a moment, then slowly lower the barbell back down to the starting position, inhaling as you do so.",
    "Repeat for the desired number of repetitions."
  ],
  'V Bar Tricep Pushdown (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart and a slight bend in your knees.",
    "Attach a V bar handle to the high pulley of the cable machine.",
    "Grasp the V bar handle with an overhand grip, palms facing down. Your hands should be close together, forming a V shape with the bar.",
    "Position your elbows close to your sides, keeping them stationary throughout the exercise.",
    "Engage your core and maintain an upright posture throughout the movement.",
    "Start with your arms fully extended, keeping a slight bend in your elbows to avoid locking them.",
    "While exhaling, slowly pull the V bar down by contracting your triceps. Focus on using your triceps to push the bar down rather than relying on your shoulders or back.",
    "Continue lowering the bar until your forearms are parallel to the ground and your elbows are fully bent.",
    "Hold the contracted position for a brief pause, squeezing your triceps.",
    " Inhale and slowly reverse the movement, allowing the V bar to rise back up to the starting position in a controlled manner.",
    " Repeat for the desired number of repetitions."
  ],
  'Wall Crunch': [
    "Stand facing a wall with your feet shoulder-width apart.",
    "Extend your arms straight in front of you and place your palms flat against the wall at shoulder height.",
    "Lean your body forward, keeping your arms straight and your core engaged.",
    "Slowly bend your elbows and lower your upper body towards the wall, as if you are performing a push-up against the wall.",
    "Once your forehead is close to the wall, pause for a moment and contract your abdominal muscles.",
    "Push yourself back up to the starting position by straightening your arms.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to breathe steadily throughout the exercise, inhaling as you lower your body and exhaling as you push back up.",
    "Maintain proper form by keeping your back straight, avoiding any arching or rounding.",
    " Focus on engaging your core muscles throughout the movement to maximize the effectiveness of the exercise."
  ],
  'Wall Sit': [
    "Find a clear wall space and stand with your back against the wall.",
    "Position your feet shoulder-width apart and about 2 feet away from the wall.",
    "Slowly slide your back down the wall, bending your knees as you descend.",
    "Continue sliding down until your knees are at a 90-degree angle, or until you reach a comfortable seated position.",
    "Ensure that your knees are directly above your ankles and your thighs are parallel to the floor.",
    "Keep your back straight against the wall, with your shoulders relaxed.",
    "Engage your core muscles by pulling your belly button towards your spine.",
    "Hold this position for the desired duration, starting with 30 seconds and gradually increasing as you build strength.",
    "Breathe steadily throughout the exercise, inhaling and exhaling deeply.",
    " To finish, push through your heels and slowly slide back up the wall to return to a standing position."
  ],
  'Wide Grip Lat Pulldown (Cable)': [
    "Sit down on the lat pulldown machine and grab the wide bar attachment with an overhand grip, hands slightly wider than shoulder-width apart.",
    "Keep your chest up, shoulders back, and a slight arch in your lower back.",
    "Pull the bar down towards your chest, leading with your elbows and keeping them close to your body.",
    "Squeeze your shoulder blades together at the bottom of the movement, and hold for a brief moment to maximize the contraction in your lats.",
    "Slowly release the bar back to the starting position, fully extending your arms without locking out your elbows.",
    "Repeat for the desired number of repetitions, focusing on maintaining proper form and control throughout the exercise."
  ],
  'Yates Row (Barbell)': [
    "Stand with your feet shoulder-width apart, knees slightly bent, and grasp a barbell with an overhand grip (palms facing down). Your hands should be slightly wider than shoulder-width apart.",
    "Bend forward at the waist, keeping your back straight and parallel to the floor. Your torso should be at about a 45-degree angle to the ground. This is your starting position.",
    "Keeping your elbows close to your body, exhale and pull the barbell up towards your lower chest. Focus on squeezing your shoulder blades together as you lift the weight.",
    "Pause for a moment at the top of the movement, squeezing your back muscles.",
    "Inhale and slowly lower the barbell back down to the starting position, fully extending your arms.",
    "Repeat the movement for the desired number of repetitions."
  ],
  'Zercher Bulgarian Split Squat (Barbell)': [
    "Start by standing with a barbell in the crooks of your elbows, with your arms bent and the barbell held at chest height.",
    "Take a large step back with one leg and place the top of your foot on a bench or raised surface behind you.",
    "Lower your body by bending both knees, keeping your front knee in line with your ankle. Your back knee should almost touch the ground.",
    "Push through your front heel to straighten your front leg and return to the starting position.",
    "Repeat for the desired number of reps on one leg before switching to the other leg.",
    "Remember to keep your chest up, core engaged, and back straight throughout the movement. Focus on slow, controlled movements to maximize the benefits of the exercise."
  ],
  'Zercher Squat (Barbell)': [
    "Place the barbell in the crook of your elbows, with your arms bent and elbows pointing forward.",
    "Stand with your feet shoulder-width apart, toes slightly pointed outwards.",
    "Keeping your chest up and core engaged, lower your body down by bending at the knees and hips.",
    "Lower yourself until your thighs are at least parallel to the ground, or as low as you can comfortably go.",
    "Keep the barbell close to your body and maintain an upright posture throughout the movement.",
    "Push through your heels to straighten your legs and return to the starting position.",
    "Repeat for the desired number of reps.",
    "Remember to breathe consistently throughout the exercise and focus on maintaining proper form."
  ],
  'Zottman Curl': [
    "Stand up straight with a dumbbell in each hand, palms facing your body. Keep your feet shoulder-width apart and your knees slightly bent.",
    "Begin the movement by curling the dumbbells up towards your shoulders, while keeping your elbows close to your sides. Continue curling until your forearms are perpendicular to the ground.",
    "Once you reach the top of the curl, rotate your wrists so that your palms are now facing up.",
    "Slowly lower the dumbbells back down to the starting position, while maintaining control and keeping your wrists rotated.",
    "At the bottom of the movement, rotate your wrists back to the starting position with palms facing your body.",
    "Repeat the exercise for the desired number of repetitions."
  ],
  'Overhead Press (Dumbbell)': [
    "Stand with your feet shoulder-width apart and hold a dumbbell in each hand at shoulder height with your palms facing forward.",
    "Press the dumbbells overhead by extending your arms straight up towards the ceiling, keeping your core engaged and back straight.",
    "Once your arms are fully extended overhead, pause for a moment and then slowly lower the dumbbells back down to shoulder height.",
    "Repeat for the desired number of repetitions.",
    "Make sure to keep your elbows slightly in front of your body throughout the exercise to avoid strain on your shoulders.",
    "Remember to breathe out as you press the dumbbells overhead and breathe in as you lower them back down."
  ],
  'Seated Overhead Press (Dumbbell)': [
    "Sit upright on a bench with a dumbbell in each hand, held at shoulder height with palms facing forward.",
    "Press the dumbbells overhead by extending your arms straight up until they are fully extended.",
    "Lower the dumbbells back down to shoulder height, keeping your core engaged and back straight.",
    "Repeat for the desired number of repetitions, making sure to exhale as you press the dumbbells up and inhale as you lower them back down.",
    "Focus on maintaining proper form throughout the exercise, keeping your elbows slightly in front of your body and avoiding any swinging or momentum. ",
    "To increase intensity, you can increase the weight of the dumbbells or perform the exercise standing up for a greater challenge."
  ],
  'Lateral Raise (Dumbbell)': [
    "Stand with your feet shoulder-width apart, holding a dumbbell in each hand by your sides with your palms facing in towards your body.",
    "Engage your core muscles and keep your back straight as you lift the dumbbells out to the sides, keeping a slight bend in your elbows.",
    "Raise the dumbbells until your arms are parallel to the floor, keeping your elbows slightly bent and in line with your shoulders.",
    "Pause for a moment at the top of the movement, then slowly lower the dumbbells back down to starting position.",
    "Repeat for the desired number of repetitions, maintaining control over the movement and focusing on engaging your shoulder muscles throughout the exercise."
  ],
  'Single Arm Lat Pulldown (Cable)': [
    "Stand facing the cable machine with your feet shoulder-width apart and your knees slightly bent.",
    "Grab the handle with one hand, palm facing down, and extend your arm fully overhead.",
    "Keep your core engaged and maintain a slight bend in your elbow throughout the exercise.",
    "Initiate the movement by pulling your shoulder blade down and back, while simultaneously pulling the handle down towards your side.",
    "Focus on using your back muscles to perform the movement, rather than relying on your arm strength.",
    "Continue pulling until your hand is beside your waist, with your elbow pointing towards the ground.",
    "Pause for a moment, squeezing your back muscles, and then slowly release the handle back to the starting position.",
    "Repeat for the desired number of repetitions, and then switch sides to work the other arm."
  ],
  'Seated Overhead Press (Barbell)': [
    "Sit on a bench with your feet flat on the ground, shoulder-width apart.",
    "Grasp the barbell with an overhand grip, slightly wider than shoulder-width apart.",
    "Lift the barbell off the rack and position it at shoulder level, just above your collarbone.",
    "Keep your core engaged and maintain a straight back throughout the exercise.",
    "Inhale and brace your core as you press the barbell directly overhead, extending your arms fully.",
    "Exhale as you slowly lower the barbell back down to the starting position, maintaining control.",
    "Repeat the movement for the desired number of repetitions.",
    "Remember to keep your elbows slightly in front of the barbell throughout the exercise to engage your shoulder muscles effectively.",
    "Focus on maintaining proper form and avoid using momentum to lift the weight.",
    " Once you have completed your set, carefully rack the barbell back onto the rack."
  ],
  'Lying Leg Curl': [
    "Lie face down on the leg curl machine with your legs fully extended and your ankles positioned under the padded lever.",
    "Grab the handles on the machine for stability and support.",
    "Keeping your hips pressed into the bench, slowly bend your knees to curl the weight towards your glutes.",
    "Hold the contraction at the top for a brief moment to maximize the engagement of your hamstrings.",
    "Slowly lower the weight back down to the starting position, making sure to control the movement and not let the weight slam down.",
    "Repeat for the desired number of repetitions."
  ],
  'Reverse Curl (Barbell)': [
    "Stand up straight with your feet shoulder-width apart and grasp a barbell with an overhand grip (palms facing down). Your hands should be slightly wider than shoulder-width apart.",
    "Keep your arms fully extended, allowing the barbell to hang in front of your thighs. This is your starting position.",
    "While keeping your upper arms stationary, exhale and curl the barbell upward by contracting your biceps. Focus on using your forearms to lift the weight.",
    "Continue to raise the barbell until your biceps are fully contracted and the barbell is at shoulder level. Hold the contracted position for a brief pause, squeezing your biceps.",
    "Inhale and slowly lower the barbell back to the starting position, allowing your arms to fully extend.",
    "Repeat the movement for the recommended number of repetitions."
  ],
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
    exercise.description = descriptionMap[key] ?? [];

    exerciseData.add(exercise);
  });
  return exerciseData;
}
