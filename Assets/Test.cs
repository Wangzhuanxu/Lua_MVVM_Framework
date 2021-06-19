using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// public class Test : MonoBehaviour
// {
//     // Start is called before the first frame update
//     void Start()
//     {
//         
//     }
//
//     // Update is called once per frame
//     void Update()
//     {
//         
//     }
// }

public class Model
{
    private bool a;
    public bool A
    {
        get => a;
        set
        {
            a = value;
            //4.model通知view
            temp?.Invoke(a);
        }
    }
    public event Action<bool> temp;
    public void Add(Action<bool> a)
    {
        temp += a;
    }
}

public class Control
{
    //省略初始化
    private Model model;
    private View view;
    public Control(Model model)
    {
        this.model = model;
        this.view = new View(model,this);
    }
    public void SetA(bool a)
    {
        //2.改变model状态
        model.A = a;
        //3.改变view显示
        view.SetActive();
    }
}

public class View
{
    private Model model;
    private Control control;
    public Text text;
    public Toggle toggle;
    public View(Model model,Control control)
    {
        this.model = model;
        this.control = control;
        model.Add(function);
        //1.用户输入
        toggle.onValueChanged.AddListener(control.SetA);
    }
    public void function(bool a) { }
    public void SetActive()
    {
        //5.获取数据
        bool active = model.A;
        text.gameObject.SetActive(active);
    }

}