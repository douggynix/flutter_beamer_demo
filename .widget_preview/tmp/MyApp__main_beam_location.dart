  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
    import 'package:beamer_demo/main_beam_location.dart';
    import '/opt/data/dev_project/beamer_demo/lib//widget_preview_wrapper.dart';
    
    void main() {
      runApp(_App());
    }
    
    class _App extends StatelessWidget {
    
      const _App({super.key});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
  home: Material(
    child: WidgetHost(
  widgetName: 'MyApp',
  constructorName: '',
  params: [
    
  ],
  builder: (context, params) => widgetPreviewWrapper(MyApp(
    
  )),
)
  ),
);
    
      }
    }
    





typedef _ParamWidgetBuilder = Widget Function(BuildContext context, Map<String, dynamic> params);

/// A changeable parameter that can be adjusted through the UI.
class ChangeableParam {
  /// The name of the field to show
  final String fieldName;

  /// A function that returns a sensible default value for this parameter if the user didn't do so
  final dynamic Function() defaultValueBuilder;

  /// Whether this parameter can be null
  final bool nullable;

  final Widget Function(dynamic value, ValueChanged onChanged) uiBuilder;

  ChangeableParam({
    required this.fieldName,
    required this.uiBuilder,
    required this.defaultValueBuilder,
    required this.nullable,
  });
}

class WidgetHost extends StatefulWidget {
  const WidgetHost({
    super.key,
    required this.builder,
    required this.params,
    required this.widgetName,
    required this.constructorName,
  });

  final String widgetName;
  final String constructorName;
  final _ParamWidgetBuilder builder;
  final List<ChangeableParam> params;

  @override
  State<WidgetHost> createState() => _WidgetHostState();
}

class _WidgetHostState extends State<WidgetHost> {

  late final Map<String, dynamic> _params = {
    for (final param in widget.params) param.fieldName: param.defaultValueBuilder(),
  };

  bool fullScreen = false;

  @override
  Widget build(BuildContext context) {
    return fullScreen ? _fullScreenView() : _detailedView();
  }

  Widget _detailedView() {
    return CustomPaint(
      painter: PaperDotCustomPainter(),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _TopBar(
              title: widget.widgetName + widget.constructorName,
              onFullScreen: () {
                setState(() {
                  fullScreen = true;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Center(child: widget.builder(context, _params))),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              for (final param in widget.params)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Builder(builder: (context) {
                                    final value = _params[param.fieldName];
                                    void onChanged(value) {
                                      setState(() {
                                        _params[param.fieldName] = value;
                                      });
                                    }

                                    return ParamChanger(
                                      name: param.fieldName,
                                      child: param.uiBuilder(value, onChanged),
                                    );
                                  }),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fullScreenView() {
    return Stack(
      children: [
        widget.builder(context, _params),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.fullscreen_exit),
              onPressed: () {
                setState(() {
                  fullScreen = false;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({super.key, required this.title, required this.onFullScreen,});

  final String title;
  final VoidCallback onFullScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text(
            'Preview Widgets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: onFullScreen
          ),
          IconButton(
            icon: Icon(Icons.border_clear_outlined, color: debugPaintSizeEnabled? Colors.indigo: null ,),
            onPressed: () {
              debugPaintSizeEnabled = !debugPaintSizeEnabled;
            },
          ),
        ],
      ),
    );
  }
}





class ParamChanger extends StatelessWidget {
  const ParamChanger({super.key, required this.name, required this.child});

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final capitalizedName = name[0].toUpperCase() + name.substring(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizedName,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}




class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    this.inputFormatters,
    required this.onChanged,
    this.initialValue = '',
  });

  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 32,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 80),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
            maxLines: null,
            style: const TextStyle(
              fontSize: 14,
            ),
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}




class PaperDotCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spaceBetween = 10.0;
    const dotRadius = 1.0;
    final dotPaint = Paint()..color = Colors.grey[200]!;

    for (var i = 0.0; i < size.width; i += spaceBetween) {
      for (var j = 0.0; j < size.height; j += spaceBetween) {
        canvas.drawCircle(Offset(i, j), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class BoolChanger extends StatelessWidget {
  const BoolChanger({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      visualDensity: VisualDensity.compact,
    );
  }
}


class UnsupportedChanger extends StatelessWidget {
  const UnsupportedChanger({super.key, required this.value, required this.onChanged});

  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return Text('Unsupported type: ${value.runtimeType}');
  }
}




class DoubleChanger extends StatelessWidget {
  const DoubleChanger({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double?> onChanged;

  static final TextInputFormatter dartDoubleOnly =
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));
  @override
  Widget build(BuildContext context) {
    return MyTextField(
      initialValue: value.toString(),
      inputFormatters: [
        dartDoubleOnly,
      ],
      onChanged: (value) {
        double? parsed = double.tryParse(value);
        if (parsed != null) {
          onChanged(double.tryParse(value) ?? 0);
        }
      },
    );
  }
}



class _WidgetTemplate {
  _WidgetTemplate({required this.name, required this.builder});

  final String name;
  final WidgetBuilder builder;
}

class WidgetChanger extends StatelessWidget {
  const WidgetChanger({super.key, required this.value, required this.onChanged});

  final _WidgetTemplate? value;
  final ValueChanged<_WidgetTemplate?> onChanged;

  static final templates = <_WidgetTemplate>[
    _WidgetTemplate(name: 'Placeholder', builder: (context) => const Placeholder()),
    _WidgetTemplate(name: 'SizedBox (empty)', builder: (context) => const SizedBox()),
    _WidgetTemplate(
        name: 'Text small',
        builder: (context) => const Text('Small text', style: TextStyle(fontSize: 12))),
    _WidgetTemplate(
        name: 'Text medium',
        builder: (context) => const Text('Medium text', style: TextStyle(fontSize: 14))),
    _WidgetTemplate(
        name: 'Text large',
        builder: (context) => const Text('Large text', style: TextStyle(fontSize: 24))),
  ];

  /*
  static Widget byName(String name, BuildContext context) {
    final template = _templates.firstWhere((element) => element.name == name);
    return template.builder(context);
  }*/

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: value != null?  Text(
              value!.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ) :
            const Text(
              'Click to select widget',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        // This is a hack to design the dropdown fully custom while keeping the original dropdown functionality
        Opacity(
          opacity: 0.0,
          alwaysIncludeSemantics: true,
          child: DropdownButtonHideUnderline(
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton<_WidgetTemplate>(
                value: value,
                onChanged: onChanged,
                isDense: true,
                borderRadius: BorderRadius.circular(4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                items: [
                  for (final template in templates)
                    DropdownMenuItem(
                      value: template,
                      child: Text(template.name),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}





class IntChanger extends StatelessWidget {
  const IntChanger({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      initialValue: value.toString(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        int? parsed = int.tryParse(value);
        if (parsed != null) {
          onChanged(int.tryParse(value) ?? 0);
        }
      },
    );
  }
}



class StringChanger extends StatelessWidget {
  const StringChanger({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      initialValue: value,
      onChanged: onChanged,
    );
  }
}



class EnumChanger extends StatelessWidget {
  const EnumChanger({
    super.key,
    required this.value,
    required this.onChanged,
    required this.values,
  });

  final dynamic value;
  final List<dynamic> values;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButton(
          value: value,
          onChanged: onChanged,
          isDense: true,
          borderRadius: BorderRadius.circular(4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          items: [
            for (final value in values)
              DropdownMenuItem(
                value: value,
                child: Text('$value'),
              )
          ],
        ),
      ),
    );
  }
}
