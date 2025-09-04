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
  List provinces = [];
  bool _isShowingCities = false;
  String? _selectedProvinceName;
  List _currentCities = [];

  List get filteredItems {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) => item.contains(_searchQuery)).toList();
  }

  List get filteredProvinces {
    if (_searchQuery.isEmpty) return provinces;
    return provinces
        .where((province) => province['name'].contains(_searchQuery))
        .toList();
  }

  List get filteredCities {
    if (_searchQuery.isEmpty) return _currentCities;
    return _currentCities
        .where((city) => city['name'].contains(_searchQuery))
        .toList();
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
      if (widget.type == 'school') {
        setState(() {
          items = _data.map((v) => v['collegesName']).toList();
        });
      } else {
        // Handle province-city structure
        setState(() {
          provinces = _data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        leading: _isShowingCities
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isShowingCities = false;
                    _selectedProvinceName = null;
                    _currentCities = [];
                  });
                },
              )
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _getSearchHint(),
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
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    if (widget.type == 'school') {
      return '选择学校';
    }
    if (_isShowingCities) {
      return _selectedProvinceName ?? '选择城市';
    }
    return '选择所在地';
  }

  String _getSearchHint() {
    if (widget.type == 'school') {
      return '搜索学校...';
    }
    if (_isShowingCities) {
      return '搜索城市...';
    }
    return '搜索省份...';
  }

  Widget _buildListView() {
    if (widget.type == 'school') {
      return _buildSchoolList();
    }

    if (_isShowingCities) {
      return _buildCityList();
    }

    return _buildProvinceList();
  }

  Widget _buildSchoolList() {
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = item == widget.currentValue;

        return ListTile(
          title: Text(item),
          trailing:
              isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          onTap: () {
            Get.back(result: item);
          },
        );
      },
    );
  }

  Widget _buildProvinceList() {
    return ListView.builder(
      itemCount: filteredProvinces.length,
      itemBuilder: (context, index) {
        final province = filteredProvinces[index];
        final provinceName = province['name'] ?? '';
        final isSelected = provinceName == widget.currentValue;

        return ListTile(
          title: Text(provinceName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            setState(() {
              _isShowingCities = true;
              _selectedProvinceName = provinceName;
              _currentCities = province['provinceCityResList'] ?? [];
            });
          },
        );
      },
    );
  }

  Widget _buildCityList() {
    return ListView.builder(
      itemCount: filteredCities.length,
      itemBuilder: (context, index) {
        final city = filteredCities[index];
        final cityName = city['name'] ?? '';
        final combinedName = '$_selectedProvinceName/$cityName';
        final isSelected = combinedName == widget.currentValue;

        return ListTile(
          title: Text(cityName),
          trailing:
              isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          onTap: () {
            Get.back(result: combinedName);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
