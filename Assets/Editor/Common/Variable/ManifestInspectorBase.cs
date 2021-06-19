using System;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;

namespace FrameworkEditor
{
    public class ManifestInspectorBase : Editor
    {
        public const float UISpace = 2f;

        protected ReorderableList InitList(string name, string keyName = "Key", string valueName = "Value",
            int rowsPerElement = 1)
        {
            var property = serializedObject.FindProperty(name);
            ReorderableList.AddCallbackDelegate add = list =>
            {
                ReorderableList.defaultBehaviours.DoAddButton(list);

                var index = list.serializedProperty.arraySize - 1;
                var data = list.serializedProperty.GetArrayElementAtIndex(index);

                data.FindPropertyRelative(keyName).stringValue = "";
                data.FindPropertyRelative(valueName).objectReferenceValue = null;
            };

            var resultList = new ReorderableList(serializedObject, property, true, true, true, true)
            {
                drawElementCallback = (rect, index, isActive, isFocused) =>
                {
                    var element = property.GetArrayElementAtIndex(index);
                    rect.y += UISpace;

                    rect.height = EditorGUIUtility.singleLineHeight * rowsPerElement +
                                  EditorGUIUtility.standardVerticalSpacing * (rowsPerElement - 1);
                    EditorGUI.PropertyField(rect, element, GUIContent.none);
                },

                onAddCallback = add
            };

            resultList.elementHeightCallback = index =>
            {
                var count = property.arraySize;
                if (count <= 0) return EditorGUIUtility.singleLineHeight;

                return EditorGUIUtility.singleLineHeight * rowsPerElement +
                       EditorGUIUtility.standardVerticalSpacing * (rowsPerElement + 1);
            };

            resultList.drawHeaderCallback = rect =>
            {
                EditorGUI.LabelField(rect, string.Format("{0}: {1}", property.displayName, property.arraySize),
                    EditorStyles.label);

                var buttonRect = rect;
                buttonRect.width = rect.height * 1.5f;
                buttonRect.x = rect.xMax - buttonRect.width * 2 - UISpace;

                if (GUI.Button(buttonRect, EditorGUIUtility.IconContent("Toolbar Plus"))) add(resultList);

                buttonRect.x += buttonRect.width + UISpace;
                GUI.enabled = resultList.serializedProperty.arraySize > 0;
                if (GUI.Button(buttonRect, EditorGUIUtility.IconContent("Toolbar Minus")))
                    ReorderableList.defaultBehaviours.DoRemoveButton(resultList);

                GUI.enabled = true;
            };

            return resultList;
        }
    }

    public class ManifestEntryFieldName : Attribute
    {
        public string keyName;
        public string valueName;

        public ManifestEntryFieldName(string keyName, string valueName)
        {
            this.keyName = keyName;
            this.valueName = valueName;
        }
    }

    public class ManifestEntryDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect rect, SerializedProperty property, GUIContent label)
        {
            var attr =
                (ManifestEntryFieldName) Attribute.GetCustomAttribute(GetType(), typeof(ManifestEntryFieldName));
            var keyName = attr != null ? attr.keyName : "Key";
            var valueName = attr != null ? attr.valueName : "Value";

            var key = property.FindPropertyRelative(keyName);
            var value = property.FindPropertyRelative(valueName);

            OnPrepare(key, value);
            OnDrawKey(GetKeyRect(rect, key), key);
            OnDrawValue(GetValueRect(rect, key), value);
            OnDrawOther(rect, property);
        }

        protected virtual void OnPrepare(SerializedProperty key, SerializedProperty value)
        {
        }

        protected virtual Rect GetKeyRect(Rect rowRect, SerializedProperty key)
        {
            var keyRect = rowRect;
            keyRect.width = rowRect.width * 0.6f;
            return keyRect;
        }

        protected virtual Rect GetValueRect(Rect rowRect, SerializedProperty value)
        {
            var keyRect = rowRect;
            keyRect.width = rowRect.width * 0.6f;
            var valueRect = rowRect;
            valueRect.x = keyRect.xMax + ManifestInspectorBase.UISpace;
            valueRect.xMax = rowRect.xMax;
            return valueRect;
        }

        protected virtual void OnDrawKey(Rect rect, SerializedProperty key)
        {
            EditorGUI.PropertyField(rect, key, GUIContent.none);
        }

        protected virtual void OnDrawValue(Rect rect, SerializedProperty value)
        {
            EditorGUI.PropertyField(rect, value, GUIContent.none);
        }

        protected virtual void OnDrawOther(Rect rowRect, SerializedProperty property)
        {
        }
    }
}