---@class CS.Framework.UICircularScrollView : CS.UnityEngine.MonoBehaviour
CS.Framework.UICircularScrollView = {}

---@field public CS.Framework.UICircularScrollView.m_CellGameObject : CS.UnityEngine.GameObject
CS.Framework.UICircularScrollView.m_CellGameObject = nil

---@field public CS.Framework.UICircularScrollView.m_Direction : CS.Framework.e_Direction
CS.Framework.UICircularScrollView.m_Direction = nil

---@field public CS.Framework.UICircularScrollView.m_IsShowArrow : CS.System.Boolean
CS.Framework.UICircularScrollView.m_IsShowArrow = nil

---@field public CS.Framework.UICircularScrollView.m_PointingEndArrow : CS.UnityEngine.GameObject
CS.Framework.UICircularScrollView.m_PointingEndArrow = nil

---@field public CS.Framework.UICircularScrollView.m_PointingFirstArrow : CS.UnityEngine.GameObject
CS.Framework.UICircularScrollView.m_PointingFirstArrow = nil

---@field public CS.Framework.UICircularScrollView.m_Row : CS.System.Int32
CS.Framework.UICircularScrollView.m_Row = nil

---@field public CS.Framework.UICircularScrollView.m_Spacing : CS.System.Single
CS.Framework.UICircularScrollView.m_Spacing = nil

---@return CS.Framework.UICircularScrollView
function CS.Framework.UICircularScrollView()
end

---@param eventData : CS.UnityEngine.EventSystems.PointerEventData
function CS.Framework.UICircularScrollView:OnBeginDrag(eventData)
end

---@param eventData : CS.UnityEngine.EventSystems.PointerEventData
function CS.Framework.UICircularScrollView:OnDrag(eventData)
end

---@param eventData : CS.UnityEngine.EventSystems.PointerEventData
function CS.Framework.UICircularScrollView:OnEndDrag(eventData)
end

---@param showFunc : CS.System.Func
---@param hideFunc : CS.System.Action
function CS.Framework.UICircularScrollView:Init(showFunc, hideFunc)
end

function CS.Framework.UICircularScrollView:UpdateList()
end

---@param start : CS.System.Int32
---@param end_ : CS.System.Int32
function CS.Framework.UICircularScrollView:ClearRange(start, end_)
end

---@param index : CS.System.Int32
function CS.Framework.UICircularScrollView:UpdateCell(index)
end

---@param num : CS.System.Int32
function CS.Framework.UICircularScrollView:CalContentSize(num)
end

---@param num : CS.System.Int32
function CS.Framework.UICircularScrollView:ShowList(num)
end

function CS.Framework.UICircularScrollView:UpdateSize()
end

function CS.Framework.UICircularScrollView:DisposeAll()
end

---@param cell : CS.UnityEngine.GameObject
function CS.Framework.UICircularScrollView:OnClickCell(cell)
end

---@param index : CS.System.Int32
function CS.Framework.UICircularScrollView:OnClickExpand(index)
end

---@param index : CS.System.Int32
function CS.Framework.UICircularScrollView:SetToPageIndex(index)
end