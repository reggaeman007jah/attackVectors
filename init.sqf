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
systemChat format ["Patrol destination is %1 m away", _meters];
// this ^^ gets distance between origin andd destination 

// get dir of dest 
_azimuth = _originPos getDir _destPos;
systemChat format ["Patrol Dest at at %1 degrees", _azimuth];
// this ^^ gets heading of dest from origin 

// divide dist by 3 to get checkpoints 
_checkpointDist = _meters / 3;
systemChat format ["Checkpoints are every %1 m", _checkpointDist];
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

sleep 1;

// Alt1 Column Heading
_dir = _azimuth - 90;
if (_dir < 0) then {
	_dir = _dir + 360;
};
systemChat format ["Alt 1 pos heading: %1", _dir];
// this calcs the relative heading -90 from mainline vector 

// Alt2 Column Heading
_dir2 = _azimuth + 90;
if (_dir2 < 0) then {
	_dir2 = _dir2 + 360;
};
systemChat format ["Alt 2 pos heading: %1", _dir2];
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
