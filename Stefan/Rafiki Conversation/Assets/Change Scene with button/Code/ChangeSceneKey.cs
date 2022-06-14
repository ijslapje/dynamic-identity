using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChangeSceneKey : MonoBehaviour
{
    [SerializeField] private string nextConversation;

    private void LoadScene() {

        if (Input.GetKeyDown(KeyCode.E))
        {
            SceneManager.LoadScene(nextConversation);

        }

    }










}
