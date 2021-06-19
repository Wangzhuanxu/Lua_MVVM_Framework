using UnityEngine;

namespace Framework
{
    public class UIContainer : MonoBehaviour
    {
        [SerializeField] private string _navigatorParams = "mode=stack";

        public string navigatorParams
        {
            get => _navigatorParams;
            protected set => _navigatorParams = value;
        }
    }
}