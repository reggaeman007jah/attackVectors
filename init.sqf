systemChat "starting test";
sleep 1;

_originPos = getPos player;

// Patrol Stage Origin 
deleteMarker "missionOrigin";
_base = createMarker ["missionOrigin", _originPos];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "ColorGreen";
_base setMarkerSize [70, 70];
_base setMarkerAlpha 0.5;
// this ^^ creates green origin marker around player 

// Dest Stage Origin 
_destPos = getMarkerPos "destination";
deleteMarker "destOrigin";
_base = createMarker ["destOrigin", _destPos];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "ColorRed";
_base setMarkerSize [70, 70];
_base setMarkerAlpha 0.5;
// this ^^ sets new destOrigin red marker over a map-made marker called "destination";

// get distance 
_meters = _originPos distance _destPos;
// systemChat format ["Patrol destination is %1 m away", _meters];
// this ^^ gets distance between origin andd destination 

// get dir of dest 
_azimuth = _originPos getDir _destPos;
// systemChat format ["Patrol Dest at at %1 degrees", _azimuth];
// this ^^ gets heading of dest from origin 

// divide dist by 3 to get checkpoints 
_checkpointDist = _meters / 3;
// systemChat format ["Checkpoints are every %1 m", _checkpointDist];
// this ^^ divides distance into three, to enable equal segments to measure 

// main column alt points 
_check1 = _checkpointDist;
_check2 = _checkpointDist * 2;
// these calcs ^^ mainline checkpoints (direct vector)

// mainline point 1 
_pointA1 = _originPos getPos [_check1, _azimuth];
deleteMarker "_pointA1";
_base = createMarker ["_pointA1", _pointA1];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "ColorRed";
_base setMarkerSize [20, 20];

// mainline point 2
_pointA2 = _originPos getPos [_check2, _azimuth];
deleteMarker "_pointA2";
_base = createMarker ["_pointA2", _pointA2];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "ColorRed";
_base setMarkerSize [20, 20];

// ------------- 
// stage 2 - calc alt vectors 
// -------------

// sleep 1;

// Alt1 Column Heading
_dir = _azimuth - 90;
if (_dir < 0) then {
	_dir = _dir + 360;
};
// systemChat format ["Alt 1 pos heading: %1", _dir];
// this calcs the relative heading -90 from mainline vector 

// Alt2 Column Heading
_dir2 = _azimuth + 90;
if (_dir2 < 0) then {
	_dir2 = _dir2 + 360;
};
// systemChat format ["Alt 2 pos heading: %1", _dir2];
// this calcs the relative heading +90 from mainline vector 

// get Alt1 pos and make alt1 marker  
_azimuthAlt1 = _pointA1 getPos [200, _dir];
deleteMarker "_azimuthAlt1";
_base = createMarker ["_azimuthAlt1", _azimuthAlt1];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "Colorgreen";
_base setMarkerSize [20, 20];

// get Alt2 pos and make alt2 marker  
_azimuthAlt2 = _pointA1 getPos [200, _dir2];
deleteMarker "_azimuthAlt2";
_base = createMarker ["_azimuthAlt2", _azimuthAlt2];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "Colorblue";
_base setMarkerSize [20, 20];

// ---
// Checkpoint 
// so far we have origin, destination, two points on mainline, and two alt origins 
// ---

// calc secondary alt points 

// take alt origin and calc heading to dest 
_alt1Azimuth = _azimuthAlt1 getDir _destPos;
// this ^^ gets heading of dest from alt 1 origin 

// gen a new point using _checkpointDist 

// alt1-line point 1 
_pointAltCheckpoint1 = _azimuthAlt1 getPos [_check1, _alt1Azimuth];
deleteMarker "_pointAltCheckpoint1";
_base = createMarker ["_pointAltCheckpoint1", _pointAltCheckpoint1];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "Colorgreen";
_base setMarkerSize [20, 20];

// take alt2 origin and calc heading to dest 
_alt2Azimuth = _azimuthAlt2 getDir _destPos;
// this ^^ gets heading of dest from alt 1 origin 

// gen a new point using _checkpointDist 

// alt2-line point 1 
_pointAltCheckpoint2 = _azimuthAlt2 getPos [_check1, _alt2Azimuth];
deleteMarker "_pointAltCheckpoint2";
_base = createMarker ["_pointAltCheckpoint2", _pointAltCheckpoint2];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "Colorblue";
_base setMarkerSize [20, 20];

// ---
// Checkpoint 
// so far we have origin, destination, two points on mainline, two alt origins and additional points 
// 8 positions in total 
// Origin
// red 1 red 2 
// green 1 green 2 
// blue 1 blue 2
// destination 
// now calc best attack vector 
// ---

/*
We want to check for ASL for each point to build up a battleplan 
*/

_originASL = getTerrainHeightASL _originPos;
_destASL = getTerrainHeightASL _destPos;

// mainline 
_mainLinePoint1 = getTerrainHeightASL _pointA1;
_mainLinePoint2 = getTerrainHeightASL _pointA2;

// alt1 
_alt1LinePoint1 = getTerrainHeightASL _azimuthAlt1;
_alt1LinePoint2 = getTerrainHeightASL _pointAltCheckpoint1;

// alt 2
_alt2LinePoint1 = getTerrainHeightASL _azimuthAlt2;
_alt2LinePoint2 = getTerrainHeightASL _pointAltCheckpoint2;

systemChat format ["Starting ASL: %1", _originASL];
systemChat format ["Target ASL: %1", _destASL];
systemChat format ["RED Direct Line ASL Point 1: %1", _mainLinePoint1];
systemChat format ["RED Direct Line ASL Point 2: %1", _mainLinePoint2];
systemChat format ["GREEN Alt1 Line ASL Point 1: %1", _alt1LinePoint1];
systemChat format ["GREEN Alt1 Line ASL Point 2: %1", _alt1LinePoint2];
systemChat format ["BLUE Alt2 Line ASL Point 1: %1", _alt2LinePoint1];
systemChat format ["BLUE Alt2 Line ASL Point 2: %1", _alt2LinePoint2];

// obs 
systemChat "Observations";
_diff = _originASL - _destASL;
if (_diff > 0) then {
	systemChat format ["Origin Point is %1 higher than Target Point", _diff];
} else {
	systemChat format ["Origin Point is %1 Lower than Target Point", _diff];
};

systemChat "There are three calculated staging points";

_redStaging = _mainLinePoint2 - _destASL;
_greenStaging = _alt1LinePoint2 - _destASL;
_blueStaging = _alt2LinePoint2 - _destASL;

if (_redStaging > 0) then {
	systemChat format ["Red Staging Point is %1 higher than Target Point", _redStaging];
} else {
	systemChat format ["Red Staging Point is not suitable, as it is %1 Lower than the Target Point", _redStaging];
};

if (_greenStaging > 0) then {
	systemChat format ["Green Staging Point is %1 higher than Target Point", _greenStaging];
} else {
	systemChat format ["Green Staging Point is not suitable, as it is %1 Lower than the Target Point", _greenStaging];
};

if (_blueStaging > 0) then {
	systemChat format ["Blue Staging Point is %1 higher than Target Point", _blueStaging];
} else {
	systemChat format ["Blue Staging Point is not suitable, as it is %1 Lower than the Target Point", _blueStaging];
};

// pop smoke to view staging areas 
_originSmoke = "SmokeShell" createVehicle _originPos;
_redSmoke1 = "SmokeShellRed" createVehicle _pointA1;
_redSmoke2 = "SmokeShellRed" createVehicle _pointA2;
_greenSmoke2 = "SmokeShellGreen" createVehicle _azimuthAlt1;
_greenSmoke2 = "SmokeShellGreen" createVehicle _pointAltCheckpoint1;
_blueSmoke2 = "SmokeShellBlue" createVehicle _azimuthAlt2;
_blueSmoke2 = "SmokeShellBlue" createVehicle _pointAltCheckpoint2;
_targetSmoke = "SmokeShellPurple" createVehicle _destPos;

sleep 30;
// pop smoke to view staging areas 
_originSmoke = "SmokeShell" createVehicle _originPos;
_redSmoke1 = "SmokeShellRed" createVehicle _pointA1;
_redSmoke2 = "SmokeShellRed" createVehicle _pointA2;
_greenSmoke2 = "SmokeShellGreen" createVehicle _azimuthAlt1;
_greenSmoke2 = "SmokeShellGreen" createVehicle _pointAltCheckpoint1;
_blueSmoke2 = "SmokeShellBlue" createVehicle _azimuthAlt2;
_blueSmoke2 = "SmokeShellBlue" createVehicle _pointAltCheckpoint2;
_targetSmoke = "SmokeShellPurple" createVehicle _destPos;


