import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel_provider.dart';
import '../models/search_result_model.dart';
import '../constants/app_colors.dart'; // Import your colors

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(SearchAutoCompleteItem) onSearch;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(10),
            child: Consumer<HotelProvider>(
              builder: (context, hotelProvider, child) {
                if (hotelProvider.isLoading) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark, // Using AppColors
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.info, // Using AppColors
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                if (hotelProvider.searchSuggestions.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark, // Using AppColors
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3), // Using AppColors
                      width: 1,
                    ),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: hotelProvider.searchSuggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.textTertiary.withOpacity(0.3), // Using AppColors
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = hotelProvider.searchSuggestions[index];
                      return ListTile(
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              suggestion.icon,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          suggestion.displayValue,
                          style: const TextStyle(
                            color: AppColors.textPrimary, // Using AppColors
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: suggestion.subtitle.isNotEmpty
                            ? Text(
                          suggestion.subtitle,
                          style: TextStyle(
                            color: AppColors.textSecondary, // Using AppColors
                            fontSize: 12,
                          ),
                        )
                            : null,
                        onTap: () {
                          widget.controller.text = suggestion.displayValue;
                          widget.onSearch(suggestion);
                          _focusNode.unfocus();
                          hotelProvider.clearSearch();
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: const TextStyle(color: AppColors.textPrimary), // Using AppColors
        decoration: InputDecoration(
          hintText: 'Search city, hotel, or destination',
          hintStyle: TextStyle(color: AppColors.textTertiary), // Using AppColors
          prefixIcon: const Icon(Icons.search, color: AppColors.info), // Using AppColors
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: AppColors.textTertiary), // Using AppColors
            onPressed: () {
              widget.controller.clear();
              hotelProvider.clearSearch();
              setState(() {});
            },
          )
              : null,
          filled: true,
          fillColor: AppColors.cardDark, // Using AppColors
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.info, // Using AppColors
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.length >= 2) {
            hotelProvider.searchAutoComplete(value);
          } else {
            hotelProvider.clearSearch();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }
}