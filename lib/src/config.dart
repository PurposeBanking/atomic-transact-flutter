import 'types.dart';

/// Provide colors to customize Transact.
class AtomicTheme {
  /// Accepts valid values for use with the color CSS property. For example: #FF0000 or rgb(255, 0, 0). This property will mostly be applied to buttons.
  final String? brandColor;

  /// Accepts valid values for use with the background-color CSS property. For example: #FF0000 or rgb(255, 0, 0). This property will change the overlay background color. This overlay is mainly only seen when Transact is used on a Desktop.
  final String? overlayColor;

  /// Change the overall theme to be dark mode.
  final bool? dark;

  AtomicTheme({
    this.brandColor,
    this.overlayColor,
    this.dark,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'brandColor': brandColor,
      'overlayColor': overlayColor,
      'dark': dark,
    }..removeWhere((key, value) => value == null);
  }
}

/// Pass in enforced deposit settings. Enforcing deposit settings will eliminate company search results that do not support the distribution settings.
class AtomicDistribution {
  /// Can be total to indicate the remaining balance of their paycheck, fixed to indicate a specific dollar amount, or percent to indicate a percentage of their paycheck.
  final AtomicDistributionType type;

  /// When type is fixed, it indicates a dollar amount to be used for the distribution. When type is percent, it indicates a percentage of a paycheck. This is not required if type is total.
  /// This value cannot be updated by the user unless canUpdate is set to true.
  final num? amount;

  /// The operation to perform when updating the distribution. The default value is create which will add a new distribution. The value of update indicates an update to an existing distribution matched by the routing and account number. The value of delete removes a distribution matched by the routing and account number.
  final String? action;

  /// Allows a user to specify any amount they would like, overwriting the default amount. Defaults to false.
  final bool? canUpdate;

  AtomicDistribution({
    required this.type,
    this.amount,
    this.action,
    this.canUpdate,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'amount': amount,
      'action': action,
      'canUpdate': canUpdate,
    }..removeWhere((key, value) => value == null);
  }
}

/// Deeplink users into a specific step
class AtomicDeeplink {
  final AtomicDeeplinkStep step;

  /// Required if the step is login_company. Accepts the ID of the company.
  final String? companyId;

  /// Required if the step is search_payroll or login_payroll. Accepts a string of the company name.
  final String? companyName;

  /// Required if the step is login_payroll.
  final String? connectorId;

  AtomicDeeplink({
    required this.step,
    this.companyId,
    this.companyName,
    this.connectorId,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'step': step.name.replaceAll("_", "-"),
      'companyId': companyId,
      'companyName': companyName,
      'connectorId': connectorId,
    }..removeWhere((key, value) => value == null);
  }
}

/// Enforce search queries
class AtomicSearch {
  /// Filters companies by a specific tag. Possible values include gig-economy, payroll-provider, and unemployment.
  final List<String>? tags;

  /// Exclude companies by a specific tag. Possible values include gig-economy, payroll-provider, and unemployment.
  final List<String>? excludedTags;

  AtomicSearch({
    this.tags,
    this.excludedTags,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tags': tags,
      'excludedTags': excludedTags,
    }..removeWhere((key, value) => value == null);
  }
}

/// Override feature flags found in your Atomic Dashboard settings. This parameter can help run A/B tests on features within Transact.
class AtomicExperiments {
  /// Override the Fractional Deposit feature value set within your Atomic Dashboard settings.
  final bool? fractionalDeposits;

  /// Override the Unemployment Carousel feature value set within your Atomic Dashboard settings.
  final bool? unemploymentCarousel;

  AtomicExperiments({
    this.fractionalDeposits,
    this.unemploymentCarousel,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fractionalDeposits': fractionalDeposits,
      'unemploymentCarousel': unemploymentCarousel,
    }..removeWhere((key, value) => value == null);
  }
}

/// Configure for how you interact with the Atomic Transact SDK
class AtomicConfig {
  /// The public token returned during AccessToken creation.
  final String publicToken;

  /// The product to initiate. Valid values include deposit, verify, and identify.
  final AtomicProductType product;

  /// The additional product to initiate.
  final AtomicProductType? additionalProduct;

  /// The linked account to use
  final String? linkedAccount;

  /// Optionally provide colors to customize Transact.
  final AtomicTheme? theme;

  /// Optionally pass in enforced deposit settings. Enforcing deposit settings will eliminate company search results that do not support the distribution settings.
  final AtomicDistribution? distribution;

  /// Optionally change the language. Could be either 'en' for English or 'es' for Spanish. Default is 'en', unless the user's current locale is Spanish, then Spanish will be used.
  final String language;

  /// Optionally deeplink into a specific step
  final AtomicDeeplink? deeplink;

  /// Optionally pass data to Transact that will be returned to you in webhook events.
  final Map<String, String>? metadata;

  /// Used to optionally enforce search queries
  final AtomicSearch? search;

  /// Handoff allows views to be handled outside of Transact.
  final List<AtomicTransactHandoff>? handoff;

  /// Used to override feature flags
  final AtomicExperiments? experiments;

  /// Tasks
  final List<Map<String, String>>? tasks;

  AtomicConfig({
    required this.publicToken,
    required this.product,
    this.additionalProduct,
    this.linkedAccount,
    this.theme,
    this.distribution,
    this.language = 'en',
    this.deeplink,
    this.metadata,
    this.search,
    this.handoff,
    this.experiments,
    this.tasks,
  });

  /// Returns a JSON object representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'publicToken': publicToken,
      'product': product.name,
      'additionalProduct': additionalProduct?.name,
      'linkedAccount': linkedAccount,
      'theme': theme?.toJson(),
      'distribution': distribution?.toJson(),
      'language': language,
      'deeplink': deeplink?.toJson(),
      'metadata': metadata,
      'search': search?.toJson(),
      'handoff': handoff?.map((e) => e.name.replaceAll("_", "-")).toList(),
      'experiments': experiments?.toJson(),
      'tasks': tasks,
    }..removeWhere((key, value) => value == null);
  }
}
