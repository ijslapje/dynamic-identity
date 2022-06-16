using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class KeyChangeLevel : MonoBehaviour
{
    [SerializeField] private string nextConversationOne;
    [SerializeField] private string nextConversationTwo;
    [SerializeField] private string nextConversationThree;
    [SerializeField] private string nextConversationFour;
    [SerializeField] private string nextConversationFive;
    [SerializeField] private string nextConversationSix;

    private void Update()
    {

        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SceneManager.LoadScene(nextConversationOne);

        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            SceneManager.LoadScene(nextConversationTwo);

        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            SceneManager.LoadScene(nextConversationThree);

        }

        if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            SceneManager.LoadScene(nextConversationFour);

        }

        if (Input.GetKeyDown(KeyCode.Alpha5))
        {
            SceneManager.LoadScene(nextConversationFive);

        }

        if (Input.GetKeyDown(KeyCode.Alpha6))
        {
            SceneManager.LoadScene(nextConversationSix);

        }
    }
}
