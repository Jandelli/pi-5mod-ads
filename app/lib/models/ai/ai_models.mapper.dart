// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ai_models.dart';

class AISummaryRequestMapper extends ClassMapperBase<AISummaryRequest> {
  AISummaryRequestMapper._();

  static AISummaryRequestMapper? _instance;
  static AISummaryRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AISummaryRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AISummaryRequest';

  static String _$timeframe(AISummaryRequest v) => v.timeframe;
  static const Field<AISummaryRequest, String> _f$timeframe =
      Field('timeframe', _$timeframe);
  static List<String> _$events(AISummaryRequest v) => v.events;
  static const Field<AISummaryRequest, List<String>> _f$events =
      Field('events', _$events);
  static List<String> _$notes(AISummaryRequest v) => v.notes;
  static const Field<AISummaryRequest, List<String>> _f$notes =
      Field('notes', _$notes);
  static List<String> _$upcomingTasks(AISummaryRequest v) => v.upcomingTasks;
  static const Field<AISummaryRequest, List<String>> _f$upcomingTasks =
      Field('upcomingTasks', _$upcomingTasks);
  static DateTime _$fromDate(AISummaryRequest v) => v.fromDate;
  static const Field<AISummaryRequest, DateTime> _f$fromDate =
      Field('fromDate', _$fromDate);
  static DateTime _$toDate(AISummaryRequest v) => v.toDate;
  static const Field<AISummaryRequest, DateTime> _f$toDate =
      Field('toDate', _$toDate);

  @override
  final MappableFields<AISummaryRequest> fields = const {
    #timeframe: _f$timeframe,
    #events: _f$events,
    #notes: _f$notes,
    #upcomingTasks: _f$upcomingTasks,
    #fromDate: _f$fromDate,
    #toDate: _f$toDate,
  };

  static AISummaryRequest _instantiate(DecodingData data) {
    return AISummaryRequest(
        timeframe: data.dec(_f$timeframe),
        events: data.dec(_f$events),
        notes: data.dec(_f$notes),
        upcomingTasks: data.dec(_f$upcomingTasks),
        fromDate: data.dec(_f$fromDate),
        toDate: data.dec(_f$toDate));
  }

  @override
  final Function instantiate = _instantiate;

  static AISummaryRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AISummaryRequest>(map);
  }

  static AISummaryRequest fromJson(String json) {
    return ensureInitialized().decodeJson<AISummaryRequest>(json);
  }
}

mixin AISummaryRequestMappable {
  String toJson() {
    return AISummaryRequestMapper.ensureInitialized()
        .encodeJson<AISummaryRequest>(this as AISummaryRequest);
  }

  Map<String, dynamic> toMap() {
    return AISummaryRequestMapper.ensureInitialized()
        .encodeMap<AISummaryRequest>(this as AISummaryRequest);
  }

  AISummaryRequestCopyWith<AISummaryRequest, AISummaryRequest, AISummaryRequest>
      get copyWith =>
          _AISummaryRequestCopyWithImpl<AISummaryRequest, AISummaryRequest>(
              this as AISummaryRequest, $identity, $identity);
  @override
  String toString() {
    return AISummaryRequestMapper.ensureInitialized()
        .stringifyValue(this as AISummaryRequest);
  }

  @override
  bool operator ==(Object other) {
    return AISummaryRequestMapper.ensureInitialized()
        .equalsValue(this as AISummaryRequest, other);
  }

  @override
  int get hashCode {
    return AISummaryRequestMapper.ensureInitialized()
        .hashValue(this as AISummaryRequest);
  }
}

extension AISummaryRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AISummaryRequest, $Out> {
  AISummaryRequestCopyWith<$R, AISummaryRequest, $Out>
      get $asAISummaryRequest => $base
          .as((v, t, t2) => _AISummaryRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AISummaryRequestCopyWith<$R, $In extends AISummaryRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get events;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get notes;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get upcomingTasks;
  $R call(
      {String? timeframe,
      List<String>? events,
      List<String>? notes,
      List<String>? upcomingTasks,
      DateTime? fromDate,
      DateTime? toDate});
  AISummaryRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AISummaryRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AISummaryRequest, $Out>
    implements AISummaryRequestCopyWith<$R, AISummaryRequest, $Out> {
  _AISummaryRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AISummaryRequest> $mapper =
      AISummaryRequestMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get events =>
      ListCopyWith($value.events, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(events: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get notes =>
      ListCopyWith($value.notes, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(notes: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get upcomingTasks => ListCopyWith(
          $value.upcomingTasks,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(upcomingTasks: v));
  @override
  $R call(
          {String? timeframe,
          List<String>? events,
          List<String>? notes,
          List<String>? upcomingTasks,
          DateTime? fromDate,
          DateTime? toDate}) =>
      $apply(FieldCopyWithData({
        if (timeframe != null) #timeframe: timeframe,
        if (events != null) #events: events,
        if (notes != null) #notes: notes,
        if (upcomingTasks != null) #upcomingTasks: upcomingTasks,
        if (fromDate != null) #fromDate: fromDate,
        if (toDate != null) #toDate: toDate
      }));
  @override
  AISummaryRequest $make(CopyWithData data) => AISummaryRequest(
      timeframe: data.get(#timeframe, or: $value.timeframe),
      events: data.get(#events, or: $value.events),
      notes: data.get(#notes, or: $value.notes),
      upcomingTasks: data.get(#upcomingTasks, or: $value.upcomingTasks),
      fromDate: data.get(#fromDate, or: $value.fromDate),
      toDate: data.get(#toDate, or: $value.toDate));

  @override
  AISummaryRequestCopyWith<$R2, AISummaryRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AISummaryRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AISummaryResponseMapper extends ClassMapperBase<AISummaryResponse> {
  AISummaryResponseMapper._();

  static AISummaryResponseMapper? _instance;
  static AISummaryResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AISummaryResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AISummaryResponse';

  static String _$summary(AISummaryResponse v) => v.summary;
  static const Field<AISummaryResponse, String> _f$summary =
      Field('summary', _$summary);
  static List<String> _$keyHighlights(AISummaryResponse v) => v.keyHighlights;
  static const Field<AISummaryResponse, List<String>> _f$keyHighlights =
      Field('keyHighlights', _$keyHighlights);
  static List<String> _$upcomingPriorities(AISummaryResponse v) =>
      v.upcomingPriorities;
  static const Field<AISummaryResponse, List<String>> _f$upcomingPriorities =
      Field('upcomingPriorities', _$upcomingPriorities);
  static String _$motivation(AISummaryResponse v) => v.motivation;
  static const Field<AISummaryResponse, String> _f$motivation =
      Field('motivation', _$motivation);
  static DateTime _$generatedAt(AISummaryResponse v) => v.generatedAt;
  static const Field<AISummaryResponse, DateTime> _f$generatedAt =
      Field('generatedAt', _$generatedAt);

  @override
  final MappableFields<AISummaryResponse> fields = const {
    #summary: _f$summary,
    #keyHighlights: _f$keyHighlights,
    #upcomingPriorities: _f$upcomingPriorities,
    #motivation: _f$motivation,
    #generatedAt: _f$generatedAt,
  };

  static AISummaryResponse _instantiate(DecodingData data) {
    return AISummaryResponse(
        summary: data.dec(_f$summary),
        keyHighlights: data.dec(_f$keyHighlights),
        upcomingPriorities: data.dec(_f$upcomingPriorities),
        motivation: data.dec(_f$motivation),
        generatedAt: data.dec(_f$generatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static AISummaryResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AISummaryResponse>(map);
  }

  static AISummaryResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AISummaryResponse>(json);
  }
}

mixin AISummaryResponseMappable {
  String toJson() {
    return AISummaryResponseMapper.ensureInitialized()
        .encodeJson<AISummaryResponse>(this as AISummaryResponse);
  }

  Map<String, dynamic> toMap() {
    return AISummaryResponseMapper.ensureInitialized()
        .encodeMap<AISummaryResponse>(this as AISummaryResponse);
  }

  AISummaryResponseCopyWith<AISummaryResponse, AISummaryResponse,
          AISummaryResponse>
      get copyWith =>
          _AISummaryResponseCopyWithImpl<AISummaryResponse, AISummaryResponse>(
              this as AISummaryResponse, $identity, $identity);
  @override
  String toString() {
    return AISummaryResponseMapper.ensureInitialized()
        .stringifyValue(this as AISummaryResponse);
  }

  @override
  bool operator ==(Object other) {
    return AISummaryResponseMapper.ensureInitialized()
        .equalsValue(this as AISummaryResponse, other);
  }

  @override
  int get hashCode {
    return AISummaryResponseMapper.ensureInitialized()
        .hashValue(this as AISummaryResponse);
  }
}

extension AISummaryResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AISummaryResponse, $Out> {
  AISummaryResponseCopyWith<$R, AISummaryResponse, $Out>
      get $asAISummaryResponse => $base
          .as((v, t, t2) => _AISummaryResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AISummaryResponseCopyWith<$R, $In extends AISummaryResponse,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get keyHighlights;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get upcomingPriorities;
  $R call(
      {String? summary,
      List<String>? keyHighlights,
      List<String>? upcomingPriorities,
      String? motivation,
      DateTime? generatedAt});
  AISummaryResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AISummaryResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AISummaryResponse, $Out>
    implements AISummaryResponseCopyWith<$R, AISummaryResponse, $Out> {
  _AISummaryResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AISummaryResponse> $mapper =
      AISummaryResponseMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get keyHighlights => ListCopyWith(
          $value.keyHighlights,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(keyHighlights: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get upcomingPriorities => ListCopyWith(
          $value.upcomingPriorities,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(upcomingPriorities: v));
  @override
  $R call(
          {String? summary,
          List<String>? keyHighlights,
          List<String>? upcomingPriorities,
          String? motivation,
          DateTime? generatedAt}) =>
      $apply(FieldCopyWithData({
        if (summary != null) #summary: summary,
        if (keyHighlights != null) #keyHighlights: keyHighlights,
        if (upcomingPriorities != null) #upcomingPriorities: upcomingPriorities,
        if (motivation != null) #motivation: motivation,
        if (generatedAt != null) #generatedAt: generatedAt
      }));
  @override
  AISummaryResponse $make(CopyWithData data) => AISummaryResponse(
      summary: data.get(#summary, or: $value.summary),
      keyHighlights: data.get(#keyHighlights, or: $value.keyHighlights),
      upcomingPriorities:
          data.get(#upcomingPriorities, or: $value.upcomingPriorities),
      motivation: data.get(#motivation, or: $value.motivation),
      generatedAt: data.get(#generatedAt, or: $value.generatedAt));

  @override
  AISummaryResponseCopyWith<$R2, AISummaryResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AISummaryResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OpenAIRequestMapper extends ClassMapperBase<OpenAIRequest> {
  OpenAIRequestMapper._();

  static OpenAIRequestMapper? _instance;
  static OpenAIRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OpenAIRequestMapper._());
      OpenAIMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OpenAIRequest';

  static String _$model(OpenAIRequest v) => v.model;
  static const Field<OpenAIRequest, String> _f$model =
      Field('model', _$model, opt: true, def: 'gpt-3.5-turbo');
  static List<OpenAIMessage> _$messages(OpenAIRequest v) => v.messages;
  static const Field<OpenAIRequest, List<OpenAIMessage>> _f$messages =
      Field('messages', _$messages);
  static double _$temperature(OpenAIRequest v) => v.temperature;
  static const Field<OpenAIRequest, double> _f$temperature =
      Field('temperature', _$temperature, opt: true, def: 0.7);
  static int _$maxTokens(OpenAIRequest v) => v.maxTokens;
  static const Field<OpenAIRequest, int> _f$maxTokens =
      Field('maxTokens', _$maxTokens, opt: true, def: 1000);

  @override
  final MappableFields<OpenAIRequest> fields = const {
    #model: _f$model,
    #messages: _f$messages,
    #temperature: _f$temperature,
    #maxTokens: _f$maxTokens,
  };

  static OpenAIRequest _instantiate(DecodingData data) {
    return OpenAIRequest(
        model: data.dec(_f$model),
        messages: data.dec(_f$messages),
        temperature: data.dec(_f$temperature),
        maxTokens: data.dec(_f$maxTokens));
  }

  @override
  final Function instantiate = _instantiate;

  static OpenAIRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OpenAIRequest>(map);
  }

  static OpenAIRequest fromJson(String json) {
    return ensureInitialized().decodeJson<OpenAIRequest>(json);
  }
}

mixin OpenAIRequestMappable {
  String toJson() {
    return OpenAIRequestMapper.ensureInitialized()
        .encodeJson<OpenAIRequest>(this as OpenAIRequest);
  }

  Map<String, dynamic> toMap() {
    return OpenAIRequestMapper.ensureInitialized()
        .encodeMap<OpenAIRequest>(this as OpenAIRequest);
  }

  OpenAIRequestCopyWith<OpenAIRequest, OpenAIRequest, OpenAIRequest>
      get copyWith => _OpenAIRequestCopyWithImpl<OpenAIRequest, OpenAIRequest>(
          this as OpenAIRequest, $identity, $identity);
  @override
  String toString() {
    return OpenAIRequestMapper.ensureInitialized()
        .stringifyValue(this as OpenAIRequest);
  }

  @override
  bool operator ==(Object other) {
    return OpenAIRequestMapper.ensureInitialized()
        .equalsValue(this as OpenAIRequest, other);
  }

  @override
  int get hashCode {
    return OpenAIRequestMapper.ensureInitialized()
        .hashValue(this as OpenAIRequest);
  }
}

extension OpenAIRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OpenAIRequest, $Out> {
  OpenAIRequestCopyWith<$R, OpenAIRequest, $Out> get $asOpenAIRequest =>
      $base.as((v, t, t2) => _OpenAIRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OpenAIRequestCopyWith<$R, $In extends OpenAIRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, OpenAIMessage,
      OpenAIMessageCopyWith<$R, OpenAIMessage, OpenAIMessage>> get messages;
  $R call(
      {String? model,
      List<OpenAIMessage>? messages,
      double? temperature,
      int? maxTokens});
  OpenAIRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OpenAIRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OpenAIRequest, $Out>
    implements OpenAIRequestCopyWith<$R, OpenAIRequest, $Out> {
  _OpenAIRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OpenAIRequest> $mapper =
      OpenAIRequestMapper.ensureInitialized();
  @override
  ListCopyWith<$R, OpenAIMessage,
          OpenAIMessageCopyWith<$R, OpenAIMessage, OpenAIMessage>>
      get messages => ListCopyWith($value.messages,
          (v, t) => v.copyWith.$chain(t), (v) => call(messages: v));
  @override
  $R call(
          {String? model,
          List<OpenAIMessage>? messages,
          double? temperature,
          int? maxTokens}) =>
      $apply(FieldCopyWithData({
        if (model != null) #model: model,
        if (messages != null) #messages: messages,
        if (temperature != null) #temperature: temperature,
        if (maxTokens != null) #maxTokens: maxTokens
      }));
  @override
  OpenAIRequest $make(CopyWithData data) => OpenAIRequest(
      model: data.get(#model, or: $value.model),
      messages: data.get(#messages, or: $value.messages),
      temperature: data.get(#temperature, or: $value.temperature),
      maxTokens: data.get(#maxTokens, or: $value.maxTokens));

  @override
  OpenAIRequestCopyWith<$R2, OpenAIRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OpenAIRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OpenAIMessageMapper extends ClassMapperBase<OpenAIMessage> {
  OpenAIMessageMapper._();

  static OpenAIMessageMapper? _instance;
  static OpenAIMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OpenAIMessageMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'OpenAIMessage';

  static String _$role(OpenAIMessage v) => v.role;
  static const Field<OpenAIMessage, String> _f$role = Field('role', _$role);
  static String _$content(OpenAIMessage v) => v.content;
  static const Field<OpenAIMessage, String> _f$content =
      Field('content', _$content);

  @override
  final MappableFields<OpenAIMessage> fields = const {
    #role: _f$role,
    #content: _f$content,
  };

  static OpenAIMessage _instantiate(DecodingData data) {
    return OpenAIMessage(
        role: data.dec(_f$role), content: data.dec(_f$content));
  }

  @override
  final Function instantiate = _instantiate;

  static OpenAIMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OpenAIMessage>(map);
  }

  static OpenAIMessage fromJson(String json) {
    return ensureInitialized().decodeJson<OpenAIMessage>(json);
  }
}

mixin OpenAIMessageMappable {
  String toJson() {
    return OpenAIMessageMapper.ensureInitialized()
        .encodeJson<OpenAIMessage>(this as OpenAIMessage);
  }

  Map<String, dynamic> toMap() {
    return OpenAIMessageMapper.ensureInitialized()
        .encodeMap<OpenAIMessage>(this as OpenAIMessage);
  }

  OpenAIMessageCopyWith<OpenAIMessage, OpenAIMessage, OpenAIMessage>
      get copyWith => _OpenAIMessageCopyWithImpl<OpenAIMessage, OpenAIMessage>(
          this as OpenAIMessage, $identity, $identity);
  @override
  String toString() {
    return OpenAIMessageMapper.ensureInitialized()
        .stringifyValue(this as OpenAIMessage);
  }

  @override
  bool operator ==(Object other) {
    return OpenAIMessageMapper.ensureInitialized()
        .equalsValue(this as OpenAIMessage, other);
  }

  @override
  int get hashCode {
    return OpenAIMessageMapper.ensureInitialized()
        .hashValue(this as OpenAIMessage);
  }
}

extension OpenAIMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OpenAIMessage, $Out> {
  OpenAIMessageCopyWith<$R, OpenAIMessage, $Out> get $asOpenAIMessage =>
      $base.as((v, t, t2) => _OpenAIMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OpenAIMessageCopyWith<$R, $In extends OpenAIMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? role, String? content});
  OpenAIMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OpenAIMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OpenAIMessage, $Out>
    implements OpenAIMessageCopyWith<$R, OpenAIMessage, $Out> {
  _OpenAIMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OpenAIMessage> $mapper =
      OpenAIMessageMapper.ensureInitialized();
  @override
  $R call({String? role, String? content}) => $apply(FieldCopyWithData(
      {if (role != null) #role: role, if (content != null) #content: content}));
  @override
  OpenAIMessage $make(CopyWithData data) => OpenAIMessage(
      role: data.get(#role, or: $value.role),
      content: data.get(#content, or: $value.content));

  @override
  OpenAIMessageCopyWith<$R2, OpenAIMessage, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OpenAIMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OpenAIResponseMapper extends ClassMapperBase<OpenAIResponse> {
  OpenAIResponseMapper._();

  static OpenAIResponseMapper? _instance;
  static OpenAIResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OpenAIResponseMapper._());
      OpenAIChoiceMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OpenAIResponse';

  static List<OpenAIChoice> _$choices(OpenAIResponse v) => v.choices;
  static const Field<OpenAIResponse, List<OpenAIChoice>> _f$choices =
      Field('choices', _$choices);

  @override
  final MappableFields<OpenAIResponse> fields = const {
    #choices: _f$choices,
  };

  static OpenAIResponse _instantiate(DecodingData data) {
    return OpenAIResponse(choices: data.dec(_f$choices));
  }

  @override
  final Function instantiate = _instantiate;

  static OpenAIResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OpenAIResponse>(map);
  }

  static OpenAIResponse fromJson(String json) {
    return ensureInitialized().decodeJson<OpenAIResponse>(json);
  }
}

mixin OpenAIResponseMappable {
  String toJson() {
    return OpenAIResponseMapper.ensureInitialized()
        .encodeJson<OpenAIResponse>(this as OpenAIResponse);
  }

  Map<String, dynamic> toMap() {
    return OpenAIResponseMapper.ensureInitialized()
        .encodeMap<OpenAIResponse>(this as OpenAIResponse);
  }

  OpenAIResponseCopyWith<OpenAIResponse, OpenAIResponse, OpenAIResponse>
      get copyWith =>
          _OpenAIResponseCopyWithImpl<OpenAIResponse, OpenAIResponse>(
              this as OpenAIResponse, $identity, $identity);
  @override
  String toString() {
    return OpenAIResponseMapper.ensureInitialized()
        .stringifyValue(this as OpenAIResponse);
  }

  @override
  bool operator ==(Object other) {
    return OpenAIResponseMapper.ensureInitialized()
        .equalsValue(this as OpenAIResponse, other);
  }

  @override
  int get hashCode {
    return OpenAIResponseMapper.ensureInitialized()
        .hashValue(this as OpenAIResponse);
  }
}

extension OpenAIResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OpenAIResponse, $Out> {
  OpenAIResponseCopyWith<$R, OpenAIResponse, $Out> get $asOpenAIResponse =>
      $base.as((v, t, t2) => _OpenAIResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OpenAIResponseCopyWith<$R, $In extends OpenAIResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, OpenAIChoice,
      OpenAIChoiceCopyWith<$R, OpenAIChoice, OpenAIChoice>> get choices;
  $R call({List<OpenAIChoice>? choices});
  OpenAIResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _OpenAIResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OpenAIResponse, $Out>
    implements OpenAIResponseCopyWith<$R, OpenAIResponse, $Out> {
  _OpenAIResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OpenAIResponse> $mapper =
      OpenAIResponseMapper.ensureInitialized();
  @override
  ListCopyWith<$R, OpenAIChoice,
          OpenAIChoiceCopyWith<$R, OpenAIChoice, OpenAIChoice>>
      get choices => ListCopyWith($value.choices,
          (v, t) => v.copyWith.$chain(t), (v) => call(choices: v));
  @override
  $R call({List<OpenAIChoice>? choices}) =>
      $apply(FieldCopyWithData({if (choices != null) #choices: choices}));
  @override
  OpenAIResponse $make(CopyWithData data) =>
      OpenAIResponse(choices: data.get(#choices, or: $value.choices));

  @override
  OpenAIResponseCopyWith<$R2, OpenAIResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OpenAIResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OpenAIChoiceMapper extends ClassMapperBase<OpenAIChoice> {
  OpenAIChoiceMapper._();

  static OpenAIChoiceMapper? _instance;
  static OpenAIChoiceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OpenAIChoiceMapper._());
      OpenAIMessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OpenAIChoice';

  static OpenAIMessage _$message(OpenAIChoice v) => v.message;
  static const Field<OpenAIChoice, OpenAIMessage> _f$message =
      Field('message', _$message);

  @override
  final MappableFields<OpenAIChoice> fields = const {
    #message: _f$message,
  };

  static OpenAIChoice _instantiate(DecodingData data) {
    return OpenAIChoice(message: data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static OpenAIChoice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OpenAIChoice>(map);
  }

  static OpenAIChoice fromJson(String json) {
    return ensureInitialized().decodeJson<OpenAIChoice>(json);
  }
}

mixin OpenAIChoiceMappable {
  String toJson() {
    return OpenAIChoiceMapper.ensureInitialized()
        .encodeJson<OpenAIChoice>(this as OpenAIChoice);
  }

  Map<String, dynamic> toMap() {
    return OpenAIChoiceMapper.ensureInitialized()
        .encodeMap<OpenAIChoice>(this as OpenAIChoice);
  }

  OpenAIChoiceCopyWith<OpenAIChoice, OpenAIChoice, OpenAIChoice> get copyWith =>
      _OpenAIChoiceCopyWithImpl<OpenAIChoice, OpenAIChoice>(
          this as OpenAIChoice, $identity, $identity);
  @override
  String toString() {
    return OpenAIChoiceMapper.ensureInitialized()
        .stringifyValue(this as OpenAIChoice);
  }

  @override
  bool operator ==(Object other) {
    return OpenAIChoiceMapper.ensureInitialized()
        .equalsValue(this as OpenAIChoice, other);
  }

  @override
  int get hashCode {
    return OpenAIChoiceMapper.ensureInitialized()
        .hashValue(this as OpenAIChoice);
  }
}

extension OpenAIChoiceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OpenAIChoice, $Out> {
  OpenAIChoiceCopyWith<$R, OpenAIChoice, $Out> get $asOpenAIChoice =>
      $base.as((v, t, t2) => _OpenAIChoiceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OpenAIChoiceCopyWith<$R, $In extends OpenAIChoice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  OpenAIMessageCopyWith<$R, OpenAIMessage, OpenAIMessage> get message;
  $R call({OpenAIMessage? message});
  OpenAIChoiceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OpenAIChoiceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OpenAIChoice, $Out>
    implements OpenAIChoiceCopyWith<$R, OpenAIChoice, $Out> {
  _OpenAIChoiceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OpenAIChoice> $mapper =
      OpenAIChoiceMapper.ensureInitialized();
  @override
  OpenAIMessageCopyWith<$R, OpenAIMessage, OpenAIMessage> get message =>
      $value.message.copyWith.$chain((v) => call(message: v));
  @override
  $R call({OpenAIMessage? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  OpenAIChoice $make(CopyWithData data) =>
      OpenAIChoice(message: data.get(#message, or: $value.message));

  @override
  OpenAIChoiceCopyWith<$R2, OpenAIChoice, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OpenAIChoiceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
