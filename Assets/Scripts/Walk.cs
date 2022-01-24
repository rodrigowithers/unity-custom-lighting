using UnityEngine;

public class Walk : MonoBehaviour
{
    public CharacterController Controller;
    public Transform Head;
    
    public float Speed = 1;

    private void Start()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update()
    {
        Vector3 movement = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));
        Vector2 mouseMovement = new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y"));
        
        var headDir = Head.localEulerAngles;
        Head.localEulerAngles = new Vector3(headDir.x - mouseMovement.y, headDir.y + mouseMovement.x, 0);

        Vector3 move = Head.forward * movement.z + Head.right * movement.x;
        move = Vector3.ClampMagnitude(move, 1);
        
        Controller.SimpleMove(move * Speed);

        if (Input.GetKeyDown(KeyCode.Mouse0))
        {
            RaycastHit hit;
            if (Physics.Raycast(Head.position, Head.forward, out hit, 2))
            {
                var rigidbody = hit.collider.GetComponent<Rigidbody>();

                if (rigidbody != null)
                {
                    var force = Head.forward;
                    force.y = 0;
                    force.Normalize();
                    rigidbody.AddForce(force * 5, ForceMode.Impulse);
                }
            }
        }
    }
}
