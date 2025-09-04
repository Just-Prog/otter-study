import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otter_study/http/api.dart';
import 'package:otter_study/http/index.dart';

class SelectionPage extends StatefulWidget {
  final String type;
  final String? currentValue;

  const SelectionPage({
    Key? key,
    required this.type,
    this.currentValue,
  }) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List items = [];

  List get filteredItems {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) => item.contains(_searchQuery)).toList();
  }

  @override
  void initState() {
    late final target;
    late final params;
    if (widget.type == 'school') {
      target = Api.fetchCollegeList;
      params = {};
    } else {
      target = Api.fetchCityList;
      params = {'sortType': 'province'};
    }
    Request().get(target, params: params).then((_) {
      final _data = _.data as List<dynamic>;
      setState(() {
        items = widget.type == 'school'
            ? _data.map((v) => v['collegesName']).toList()
            : _data.map((v) => v['name']).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'school' ? '选择学校' : '选择所在地'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.type == 'school' ? '搜索学校...' : '搜索城市...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final isSelected = item == widget.currentValue;

                return ListTile(
                  title: Text(item),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    Get.back(result: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
