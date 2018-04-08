using UnityEngine;
using System.Collections;

public class ReceivePosition : MonoBehaviour {
    
   	public OSC osc;
	public float scale = 4000f;
	public float inertia = 0.2f;

	float X = 0f;
	float Z = 0f;

	// Use this for initialization
	void Start () {
	   osc.SetAddressHandler( "/xyz" , OnReceiveXYZ );
    }
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnReceiveXYZ(OscMessage message){
		 
		float x = message.GetFloat(0) / scale;
		// float y = message.GetFloat(1) / scale;
		float z = message.GetFloat(2) / scale;

		X += inertia * (x - X);
		Z += inertia * (z - Z);

		transform.position = new Vector3(X,10,-Z);

		Debug.Log (X + " " + Z);
	}

}
