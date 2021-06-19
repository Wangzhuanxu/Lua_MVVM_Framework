//*****************************-》 基类 循环列表 《-****************************
//author kim
//初始化:
//      Init(callBackFunc)
//刷新整个列表（首次调用和数量变化时调用）:
//      ShowList(int = 数量)
//刷新单个项:
//      UpdateCell(int = 索引)
//刷新列表数据(无数量变化时调用):
//      UpdateList()
//回调:
//Func(GameObject = Cell, int = Index)  //刷新列表

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Framework
{
    public class UIUtils
    {
        public static void SetActive(GameObject obj, bool isActive)
        {
            if (obj != null) obj.SetActive(isActive);
        }
    }

    public enum e_Direction
    {
        Horizontal,
        Vertical
    }


    public class UICircularScrollView : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
    {
        public GameObject m_CellGameObject; //指定的cell
        private CellInfo[] m_CellInfos;
        private float m_CellObjectHeight;

        private float m_CellObjectWidth;

        private GameObject m_Content;
        private float m_ContentHeight;
        private RectTransform m_ContentRectTrans;

        private float m_ContentWidth;

        public e_Direction m_Direction = e_Direction.Horizontal;
        private Action<int> m_HideFunc;

        /// <summary>
        ///     用来存储需要隐藏的index
        /// </summary>
        private List<int> m_InvisibleList = new List<int>(10);

        private readonly bool m_IsClearList = false; //是否清空列表

        private bool m_isInited;

        private bool m_IsInited;
        public bool m_IsShowArrow = true;

        private int m_MaxCount = -1; //列表数量
        private int m_MaxIndex = -1;

        private int m_MinIndex = -1;
        private float m_PlaneHeight;

        private float m_PlaneWidth;
        public GameObject m_PointingEndArrow;
        public GameObject m_PointingFirstArrow;

        public int m_Row = 1;

        private ScrollRect m_ScrollRect;

        private Func<int, Vector3, bool> m_ShowFunc;

        public float m_Spacing; //间距
        private int MaxSize = 100;

        private RectTransform rectTrans;

        public virtual void OnBeginDrag(PointerEventData eventData)
        {
        }

        public void OnDrag(PointerEventData eventData)
        {
        }

        public virtual void OnEndDrag(PointerEventData eventData)
        {
        }

        public virtual void Init(Func<int, Vector3, bool> showFunc, Action<int> hideFunc)
        {
            DisposeAll();

            m_ShowFunc = showFunc;

            m_HideFunc = hideFunc;

            if (m_isInited)
                return;


            m_Content = GetComponent<ScrollRect>().content.gameObject;

            if (m_CellGameObject == null) m_CellGameObject = m_Content.transform.GetChild(0).gameObject;
            /* Cell 处理 */
            //m_CellGameObject.transform.SetParent(m_Content.transform.parent, false);

            var cellRectTrans = m_CellGameObject.GetComponent<RectTransform>();
            cellRectTrans.pivot = new Vector2(0f, 1f);
            CheckAnchor(cellRectTrans);
            cellRectTrans.anchoredPosition = Vector2.zero;

            //记录 Cell 信息
            m_CellObjectHeight = cellRectTrans.rect.height;
            m_CellObjectWidth = cellRectTrans.rect.width;

            //记录 Plane 信息
            rectTrans = GetComponent<RectTransform>();
            var planeRect = rectTrans.rect;
            m_PlaneHeight = planeRect.height;
            m_PlaneWidth = planeRect.width;

            //记录 Content 信息
            m_ContentRectTrans = m_Content.GetComponent<RectTransform>();
            var contentRect = m_ContentRectTrans.rect;
            m_ContentHeight = contentRect.height;
            m_ContentWidth = contentRect.width;

            m_ContentRectTrans.pivot = new Vector2(0f, 1f);
            //m_ContentRectTrans.sizeDelta = new Vector2 (planeRect.width, planeRect.height);
            //m_ContentRectTrans.anchoredPosition = Vector2.zero;
            CheckAnchor(m_ContentRectTrans);

            m_ScrollRect = GetComponent<ScrollRect>();

            m_ScrollRect.onValueChanged.RemoveAllListeners();
            //添加滑动事件
            m_ScrollRect.onValueChanged.AddListener(delegate(Vector2 value) { ScrollRectListener(value); });

            if (m_PointingFirstArrow != null || m_PointingEndArrow != null)
            {
                m_ScrollRect.onValueChanged.AddListener(delegate(Vector2 value) { OnDragListener(value); });
                OnDragListener(Vector2.zero);
            }

            //InitScrollBarGameObject(); // 废弃

            m_isInited = true;
        }

        //检查 Anchor 是否正确
        private void CheckAnchor(RectTransform rectTrans)
        {
            if (m_Direction == e_Direction.Vertical)
            {
                if (!(rectTrans.anchorMin == new Vector2(0, 1) && rectTrans.anchorMax == new Vector2(0, 1) ||
                      rectTrans.anchorMin == new Vector2(0, 1) && rectTrans.anchorMax == new Vector2(1, 1)))
                {
                    rectTrans.anchorMin = new Vector2(0, 1);
                    rectTrans.anchorMax = new Vector2(0, 1);
                }
            }
            else
            {
                if (!(rectTrans.anchorMin == new Vector2(0, 1) && rectTrans.anchorMax == new Vector2(0, 1) ||
                      rectTrans.anchorMin == new Vector2(0, 0) && rectTrans.anchorMax == new Vector2(0, 1)))
                {
                    rectTrans.anchorMin = new Vector2(0, 1);
                    rectTrans.anchorMax = new Vector2(0, 1);
                }
            }
        }

        //实时刷新列表时用
        public virtual void UpdateList()
        {
            UpdateCheck();
        }

        //删除时，制空某些格子
        public void ClearRange(int start, int end)
        {
            for (var i = start; i < end; i++)
                if (m_CellInfos[i] != null)
                {
                    m_CellInfos[i].isEmpty = true;
                    m_HideFunc(i);
                }
        }

        //刷新某一项
        public void UpdateCell(int index)
        {
            var cellInfo = m_CellInfos[index - 1];
            if (!cellInfo.isEmpty)
            {
                var rangePos = m_Direction == e_Direction.Vertical ? cellInfo.pos.y : cellInfo.pos.x;
                if (!IsOutRange(rangePos)) m_ShowFunc(index, cellInfo.pos);
            }
        }


        public void CalContentSize(int num)
        {
            //-> 计算 Content 尺寸
            if (m_Direction == e_Direction.Vertical)
            {
                var contentSize = (m_Spacing + m_CellObjectHeight) * Mathf.CeilToInt((float) num / m_Row);
                m_ContentHeight = contentSize;
                m_ContentWidth = m_ContentRectTrans.sizeDelta.x;
                contentSize = contentSize < rectTrans.rect.height ? rectTrans.rect.height : contentSize;
                m_ContentRectTrans.sizeDelta = new Vector2(m_ContentWidth, contentSize);
                // if (num != m_MaxCount)
                // {
                //     m_ContentRectTrans.anchoredPosition = new Vector2(m_ContentRectTrans.anchoredPosition.x, 0);
                // }
            }
            else
            {
                var contentSize = (m_Spacing + m_CellObjectWidth) * Mathf.CeilToInt((float) num / m_Row);
                m_ContentWidth = contentSize;
                m_ContentHeight = m_ContentRectTrans.sizeDelta.x;
                contentSize = contentSize < rectTrans.rect.width ? rectTrans.rect.width : contentSize;
                m_ContentRectTrans.sizeDelta = new Vector2(contentSize, m_ContentHeight);
                // if (num != m_MaxCount)
                // {
                //     m_ContentRectTrans.anchoredPosition = new Vector2(0, m_ContentRectTrans.anchoredPosition.y);
                // }
            }
        }

        public virtual void ShowList(int num)
        {
            m_MinIndex = -1;
            m_MaxIndex = -1;

            //-> 计算 开始索引
            var lastEndIndex = 0;

            //-> 过多的物体 扔到对象池 ( 首次调 ShowList函数时 则无效 )
            if (m_IsInited)
            {
                lastEndIndex = num - m_MaxCount > 0 ? m_MaxCount : num;
                lastEndIndex = m_IsClearList ? 0 : lastEndIndex;

                var count = m_IsClearList ? m_CellInfos.Length : m_MaxCount;
                for (var i = lastEndIndex; i < count; i++)
                    if (!m_CellInfos[i].isEmpty)
                    {
                        m_HideFunc(i);
                        m_CellInfos[i].isEmpty = true;
                    }
            }

            //-> 以下四行代码 在for循环所用
            var tempCellInfos = m_CellInfos;
            m_CellInfos = new CellInfo[num];
            InitArray(m_CellInfos);
            //-> 1: 计算 每个Cell坐标并存储 2: 显示范围内的 Cell
            for (var i = 0; i < num; i++)
            {
                // * -> 存储 已有的数据 ( 首次调 ShowList函数时 则无效 )
                if (m_MaxCount != -1 && i < lastEndIndex)
                {
                    var tempCellInfo = tempCellInfos[i];
                    //-> 计算是否超出范围
                    var rPos = m_Direction == e_Direction.Vertical ? tempCellInfo.pos.y : tempCellInfo.pos.x;
                    if (!IsOutRange(rPos))
                    {
                        //-> 记录显示范围中的 首位index 和 末尾index
                        m_MinIndex = m_MinIndex == -1 ? i : m_MinIndex; //首位index
                        m_MaxIndex = i; // 末尾index

                        // if (tempCellInfo.isEmpty)
                        // {
                        //     tempCellInfo.isEmpty = false;
                        // }


                        tempCellInfo.isEmpty = m_ShowFunc(i, tempCellInfo.pos);
                    }
                    else
                    {
                        m_HideFunc(i);
                        m_CellInfos[i].isEmpty = true;
                    }

                    m_CellInfos[i] = tempCellInfo;
                    continue;
                }

                var cellInfo = new CellInfo();

                float pos = 0; //坐标( isVertical ? 记录Y : 记录X )
                float rowPos = 0; //计算每排里面的cell 坐标

                // * -> 计算每个Cell坐标
                if (m_Direction == e_Direction.Vertical)
                {
                    pos = m_CellObjectHeight * Mathf.FloorToInt(i / m_Row) + m_Spacing * Mathf.FloorToInt(i / m_Row);
                    rowPos = m_CellObjectWidth * (i % m_Row) + m_Spacing * (i % m_Row);
                    cellInfo.pos = new Vector3(rowPos, -pos, 0);
                }
                else
                {
                    pos = m_CellObjectWidth * Mathf.FloorToInt(i / m_Row) + m_Spacing * Mathf.FloorToInt(i / m_Row);
                    rowPos = m_CellObjectHeight * (i % m_Row) + m_Spacing * (i % m_Row);
                    cellInfo.pos = new Vector3(pos, -rowPos, 0);
                }

                //-> 计算是否超出范围
                var cellPos = m_Direction == e_Direction.Vertical ? cellInfo.pos.y : cellInfo.pos.x;
                if (IsOutRange(cellPos))
                {
                    m_HideFunc(i);
                    cellInfo.isEmpty = true;
                    m_CellInfos[i] = cellInfo;
                    continue;
                }

                //-> 记录显示范围中的 首位index 和 末尾index
                m_MinIndex = m_MinIndex == -1 ? i : m_MinIndex; //首位index
                m_MaxIndex = i; // 末尾index

                //-> 取或创建 Cell
                // GameObject cell = GetPoolsObj();
                // cell.transform.GetComponent<RectTransform>().anchoredPosition = cellInfo.pos;
                // cell.gameObject.name = i.ToString();

                var ty = m_ShowFunc(i, cellInfo.pos);
              //  Debug.Log(ty + "C# ======================");
                cellInfo.isEmpty = ty;
                ;
                m_CellInfos[i] = cellInfo;

                //-> 回调  函数
                // Func(m_FuncCallBackFunc, i);
            }

            m_MaxCount = num;
            m_IsInited = true;

            OnDragListener(Vector2.zero);
        }

        private void InitArray(CellInfo[] tempCellInfos)
        {
            for (var i = 0; i < tempCellInfos.Length; i++) tempCellInfos[i] = new CellInfo();
        }

        // 更新滚动区域的大小
        public void UpdateSize()
        {
            var rect = GetComponent<RectTransform>().rect;
            m_PlaneHeight = rect.height;
            m_PlaneWidth = rect.width;
        }

        //滑动事件
        protected virtual void ScrollRectListener(Vector2 value)
        {
            UpdateCheck();
        }

        private void UpdateCheck()
        {
            if (m_CellInfos == null)
                return;
            var first = false;
            var second = false;
            //检查超出范围
            for (int i = 0, length = m_CellInfos.Length; i < length; i++)
            {
                var cellInfo = m_CellInfos[i];
                //  GameObject obj = cellInfo.obj;
                var pos = cellInfo.pos;

                var rangePos = m_Direction == e_Direction.Vertical ? pos.y : pos.x;
                //判断是否超出显示范围
                if (IsOutRange(rangePos))
                {
                    //把超出范围的cell 扔进 poolsObj里
                    if (!cellInfo.isEmpty)
                    {
                        m_HideFunc(i);
                        cellInfo.isEmpty = true;
                    }
                    else
                    {
                        if (first) second = true;
                    }
                }
                else
                {
                    //优先从 poolsObj中 取出 （poolsObj为空则返回 实例化的cell）
                    //GameObject cell = GetPoolsObj();
                    // cell.transform.localPosition = pos;
                    // cell.gameObject.name = i.ToString();
                    // m_CellInfos[i].obj = cell;
                    if (cellInfo.isEmpty)
                    {
                        cellInfo.isEmpty = m_ShowFunc(i, pos);
                        ;
                    }

                    first = true;
                }

                if (first && second) break;
            }
        }

        //判断是否超出显示范围
        protected bool IsOutRange(float pos)
        {
            Vector3 listP = m_ContentRectTrans.anchoredPosition;
            if (m_Direction == e_Direction.Vertical)
            {
                if (pos + listP.y > m_CellObjectHeight || pos + listP.y < -(rectTrans.rect.height - 1)) return true;
            }
            else
            {
                if (pos + listP.x < -m_CellObjectWidth || pos + listP.x > rectTrans.rect.width - 1) return true;
            }

            return false;
        }

        public void DisposeAll()
        {
            if (m_HideFunc != null) m_HideFunc = null;
            if (m_ShowFunc != null) m_ShowFunc = null;
        }

        protected void OnDestroy()
        {
            DisposeAll();
        }

        public virtual void OnClickCell(GameObject cell)
        {
        }

        //-> ExpandCircularScrollView 函数
        public virtual void OnClickExpand(int index)
        {
        }

        //-> FlipCircularScrollView 函数
        public virtual void SetToPageIndex(int index)
        {
        }

        protected void OnDragListener(Vector2 value)
        {
            var normalizedPos = m_Direction == e_Direction.Vertical
                ? m_ScrollRect.verticalNormalizedPosition
                : m_ScrollRect.horizontalNormalizedPosition;

            if (m_Direction == e_Direction.Vertical)
            {
                if (m_ContentHeight - rectTrans.rect.height < 10)
                {
                    UIUtils.SetActive(m_PointingFirstArrow, false);
                    UIUtils.SetActive(m_PointingEndArrow, false);
                    return;
                }
            }
            else
            {
                if (m_ContentWidth - rectTrans.rect.width < 10)
                {
                    UIUtils.SetActive(m_PointingFirstArrow, false);
                    UIUtils.SetActive(m_PointingEndArrow, false);
                    return;
                }
            }

            if (normalizedPos >= 0.9)
            {
                UIUtils.SetActive(m_PointingFirstArrow, false);
                UIUtils.SetActive(m_PointingEndArrow, true);
            }
            else if (normalizedPos <= 0.1)
            {
                UIUtils.SetActive(m_PointingFirstArrow, true);
                UIUtils.SetActive(m_PointingEndArrow, false);
            }
            else
            {
                UIUtils.SetActive(m_PointingFirstArrow, true);
                UIUtils.SetActive(m_PointingEndArrow, true);
            }
        }

        private void Start()
        {
            // var go = GameObject.Find("Canvas");
            // var listView = new ListView();
            // listView.SetGameObject(go);
            // listView.SetVm(new ListViewModel());
        }

        //记录 物体的坐标 和 物体 
        private class CellInfo
        {
            public bool isEmpty;
            public Vector3 pos;
        }
    }
}