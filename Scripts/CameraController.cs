using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform cam;
    
    [SerializeField, Range(0f, 100f)]
    float speed = 12f;
    [SerializeField, Range(0f, 500f)]
    float mouseSensitivity = 100f;

    float yRotation = 0f;
    float xRotation = 0f;
    float mouseX;
    float mouseY;
    Vector3 movement;

    void Awake()
    {
        if(Camera.main.depthTextureMode != DepthTextureMode.Depth)
            Camera.main.depthTextureMode = DepthTextureMode.Depth;
    }

    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    // Update is called once per frame
    void Update()
    {
        movement.x = Input.GetAxis("Horizontal");
        movement.z = Input.GetAxis("Vertical");
        movement.y = Input.GetKey("space") ? 1 : Input.GetKey("c") ? -1: 0;

        mouseX = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
        mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;

        yRotation -= mouseY;
        xRotation += mouseX;
        yRotation = Mathf.Clamp(yRotation, -90f, 90f);
        cam.localRotation = Quaternion.Euler(yRotation, xRotation, 0f);

        cam.Translate(movement * speed * Time.deltaTime);
    }
}
