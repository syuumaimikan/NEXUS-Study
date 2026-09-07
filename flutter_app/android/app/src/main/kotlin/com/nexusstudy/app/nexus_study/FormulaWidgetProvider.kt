package com.nexusstudy.app.nexus_study

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class FormulaWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("nexus_widget_prefs", Context.MODE_PRIVATE)
        val subject = prefs.getString("formula_subject", "【数学】本日の重要公式") ?: "【数学】本日の重要公式"
        val title = prefs.getString("formula_title", "積分の1/6公式 (放物線と直線の面積)") ?: "積分の1/6公式 (放物線と直線の面積)"
        val body = prefs.getString("formula_body", "S = (|a| / 6) * (β - α)³") ?: "S = (|a| / 6) * (β - α)³"

        for (appWidgetId in appWidgetIds) {
            val intent = Intent(context, MainActivity::class.java).apply {
                putExtra("route", "/formulas")
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 2, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val views = RemoteViews(context.packageName, R.layout.formula_widget_layout)
            views.setTextViewText(R.id.widget_formula_subject, subject)
            views.setTextViewText(R.id.widget_formula_title, title)
            views.setTextViewText(R.id.widget_formula_body, body)
            views.setOnClickPendingIntent(R.id.formula_widget_container, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
