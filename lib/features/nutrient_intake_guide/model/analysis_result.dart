class AnalysisResult {
  final String answer;

  AnalysisResult(this.answer);

  factory AnalysisResult.fromApiResponse(String response) {
    return AnalysisResult(response.trim());
  }
}
