import 'package:flutter/material.dart';
import '../../prestataire_app/constants/app_theme.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<bool> completedSteps;
  final List<String> stepTitles;
  final List<String> stepDescriptions;
  final bool showStepHeader;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
    required this.stepTitles,
    required this.stepDescriptions,
    this.showStepHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Indicateur de progression avec numéros et coches
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 1; i <= totalSteps; i++) ...[
                _buildStepIndicator(i, 32.0),
                if (i < totalSteps)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: _getConnectorColor(i),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        if (showStepHeader) ...[
          const SizedBox(height: 24),

          // Titre et description de l'étape actuelle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stepTitles[currentStep - 1],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stepDescriptions[currentStep - 1],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStepIndicator(int stepNumber, double size) {
    final isCompleted =
        stepNumber <= completedSteps.length && completedSteps[stepNumber - 1];
    final isCurrent = currentStep == stepNumber;
    final isPast = stepNumber < currentStep;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.primaryGreen
            : isCurrent
            ? AppTheme.primaryGreen
            : Colors.grey[300],
        shape: BoxShape.circle,
        border: isCompleted
            ? Border.all(color: AppTheme.primaryGreen, width: 2)
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: size * 0.5)
            : Text(
                stepNumber.toString(),
                style: TextStyle(
                  color: isCurrent || isPast ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.4,
                ),
              ),
      ),
    );
  }

  Color _getConnectorColor(int stepNumber) {
    final isCompleted =
        stepNumber <= completedSteps.length && completedSteps[stepNumber - 1];
    final isPast = stepNumber < currentStep;

    return isCompleted || isPast ? AppTheme.primaryGreen : Colors.grey[300]!;
  }
}
