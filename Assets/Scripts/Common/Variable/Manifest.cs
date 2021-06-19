using System;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Framework
{
    public class Manifest : MonoBehaviour
    {
        private readonly Dictionary<Type, List<GameObject>> _componentMap = new Dictionary<Type, List<GameObject>>();
        private readonly Dictionary<string, Object> _map = new Dictionary<string, Object>();
        private string[] _containerNames = new string[0];
        private string[] _itemNames = new string[0];
        public Item[] Items = new Item[0];

        public Dictionary<string, Object> map
        {
            get
            {
                if (Items.Length > 0 && _map.Count <= 0) InitItemMap();
                return _map;
            }
        }

        public string[] itemNames
        {
            get
            {
                if (Items.Length > 0 && _itemNames.Length <= 0) InitItemMap();
                return _itemNames;
            }
        }

        public string[] containerNames
        {
            get
            {
                if (Items.Length > 0 && _map.Count <= 0) InitItemMap();
                return _containerNames;
            }
        }

        private void InitItemMap()
        {
            _map.Clear();
            var containers = new List<string>();
            _componentMap.Clear();
            for (var i = 0; i < Items.Length; ++i)
            {
                var item = Items[i];
                if (_map.ContainsKey(item.Key))
                {
                    Console.Error.WriteLine("Duplicated item key in Manifest, key1={0}, new={1}, exist={2}", item.Key,
                        item.Value.name, map[item.Key].name);
                    continue;
                }

                _map.Add(item.Key, item.Value);
                if (item.Value == null)
                    continue;

                if (item.value is UIContainer) containers.Add(item.Key);

                var itemType = item.Value.GetType();
                if (!_componentMap.ContainsKey(itemType))
                {
                    var list = new List<GameObject>();
                    _componentMap.Add(itemType, list);
                }

                var compList = _componentMap[itemType];
                if (item.Value is GameObject)
                {
                    compList.Add(item.Value as GameObject);
                }
                else if (item.Value is Component)
                {
                    var com = item.Value as Component;
                    compList.Add(com.gameObject);
                }
            }

            _itemNames = new string[map.Keys.Count];
            map.Keys.CopyTo(_itemNames, 0);
            _containerNames = new string[containers.Count];
            containers.CopyTo(_containerNames);
        }

        private void Awake()
        {
            InitItemMap();
        }

        public Object GetItem(string key)
        {
            Object rawObject = null;
            if (map.TryGetValue(key, out rawObject)) return rawObject;
            return null;
        }

        public T GetItem<T>(string key) where T : Object
        {
            return (T) GetItem(key);
        }

        public GameObject[] GetItems<T>() where T : Component
        {
            return _componentMap.TryGetValue(typeof(T), out var list) ? list.ToArray() : null;
        }

        public interface Entry
        {
            string key { get; set; }
            Object value { get; set; }
        }

        [Serializable]
        public class Item : Entry
        {
            public string Key;
            public Object Value;

            public string key
            {
                get => Key;
                set => Key = value;
            }

            public Object value
            {
                get => Value;
                set => Value = value;
            }
        }
    }
}