using System;
using System.Collections.Generic;
using System.Linq;
using Framework;
using TMPro;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.UI;
using Object = UnityEngine.Object;

namespace FrameworkEditor
{
    [CustomEditor(typeof(Manifest))]
    public class ManifestInspector : ManifestInspectorBase
    {
        private ReorderableList _itemsList;

        private void OnEnable()
        {
            _itemsList = InitList("Items");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            EditorGUILayout.Space();
            _itemsList.DoLayoutList();

            serializedObject.ApplyModifiedProperties();
        }
    }

    [CustomPropertyDrawer(typeof(Manifest.Item))]
    [ManifestEntryFieldName("Key", "Value")]
    public class ManifestItemDrawer : ManifestEntryDrawer
    {
        private static readonly List<Type> ComponentSort = new List<Type>
        {
            typeof(Button),
            typeof(Dropdown),
            typeof(Toggle),
            typeof(Slider),
            typeof(Scrollbar),
            typeof(ScrollRect),
            typeof(InputField),
            typeof(ToggleGroup),
            typeof(TextMeshProUGUI),
            typeof(Image),
            typeof(RawImage)
        };

        protected override void OnPrepare(SerializedProperty key, SerializedProperty value)
        {
            if (string.IsNullOrEmpty(key.stringValue) && value.objectReferenceValue != null)
            {
                key.stringValue = value.objectReferenceValue.name;
                PrepareDefaultComponent(value);
            }

            base.OnPrepare(key, value);
        }

        protected override Rect GetKeyRect(Rect rowRect, SerializedProperty key)
        {
            var keyRect = rowRect;
            keyRect.width = rowRect.width * 0.45f;
            return keyRect;
        }

        protected override Rect GetValueRect(Rect rowRect, SerializedProperty value)
        {
            var keyRect = rowRect;
            keyRect.width = rowRect.width * 0.45f;
            var valueRect = rowRect;
            valueRect.x = keyRect.xMax + ManifestInspectorBase.UISpace;
            valueRect.xMax = rowRect.xMax;
            return valueRect;
        }

        private void PrepareDefaultComponent(SerializedProperty value)
        {
            GetPopupData(value, out _, out _, out var go, out var components);
            Object defaultObj = go;
            foreach (var type in ComponentSort)
            foreach (var component in components)
            {
                if (component.GetType() != type) continue;
                defaultObj = component;
                break;
            }

            value.objectReferenceValue = defaultObj;
        }

        protected override void OnDrawValue(Rect rect, SerializedProperty value)
        {
            var index = 0;
            GameObject go = null;
            Component[] components = null;
            string[] names = null;
            GetPopupData(value, out index, out names, out go, out components);

            var objRect = rect;
            objRect.width = rect.width * 0.6f;
            var typeRect = rect;
            typeRect.x = objRect.xMax + ManifestInspectorBase.UISpace;
            typeRect.xMax = rect.xMax;

            if (go == null) objRect.xMax = rect.xMax;

            EditorGUI.PropertyField(objRect, value, GUIContent.none);
            if (go != null)
            {
                var selected = EditorGUI.Popup(typeRect, index, names);
                if (selected != index)
                {
                    if (selected == 0)
                        value.objectReferenceValue = go;
                    else
                        value.objectReferenceValue = components[selected - 1];
                }
            }
        }

        private void GetPopupData(SerializedProperty value, out int index, out string[] names, out GameObject go,
            out Component[] components)
        {
            var obj = value.objectReferenceValue;
            if (!obj)
            {
                index = 0;
                names = null;
                go = null;
                components = null;
                return;
            }

            Component current = null;
            if (value.objectReferenceValue is GameObject)
            {
                go = value.objectReferenceValue as GameObject;
                components = go.GetComponents<Component>();
            }
            else
            {
                current = value.objectReferenceValue as Component;
                go = current.gameObject;
                components = go.GetComponents<Component>();
            }

            index = 0;
            names = new string[components.Length + 1];
            names[0] = go.name;

            for (var i = 0; i < components.Length; ++i)
            {
                var component = components[i];
                var name = component.GetType().Name;
                if (names.Contains(name)) continue;
                names[i + 1] = name;
                if (component == current) index = i + 1;
            }
        }
    }
}