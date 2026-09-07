package com.nexusstudy.app.nexus_study

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nexusstudy.app/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val appWidgetManager = AppWidgetManager.getInstance(this)
            when (call.method) {
                "isPinSupported" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        result.success(appWidgetManager.isRequestPinAppWidgetSupported)
                    } else {
                        result.success(false)
                    }
                }
                "requestPinWidget" -> {
                    val widgetType = call.argument<String>("widgetType") ?: "vocabulary"
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        if (appWidgetManager.isRequestPinAppWidgetSupported) {
                            val providerClass = when (widgetType) {
                                "countdown" -> CountdownWidgetProvider::class.java
                                "formula" -> FormulaWidgetProvider::class.java
                                else -> NexusStudyWidgetProvider::class.java
                            }
                            val provider = ComponentName(this, providerClass)
                            val success = appWidgetManager.requestPinAppWidget(provider, null, null)
                            result.success(success)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                "updateWidgetData" -> {
                    val prefs = getSharedPreferences("nexus_widget_prefs", Context.MODE_PRIVATE)
                    val editor = prefs.edit()

                    call.argument<Int>("streakDays")?.let { editor.putInt("streak_days", it) }
                    call.argument<String>("todayWord")?.let { editor.putString("today_word", it) }
                    call.argument<String>("targetSchool")?.let { editor.putString("target_school", it) }
                    call.argument<Double>("targetDeviation")?.let { editor.putFloat("target_deviation", it.toFloat()) }
                    call.argument<Int>("countdownDays")?.let { editor.putInt("countdown_days", it) }
                    call.argument<String>("formulaSubject")?.let { editor.putString("formula_subject", it) }
                    call.argument<String>("formulaTitle")?.let { editor.putString("formula_title", it) }
                    call.argument<String>("formulaBody")?.let { editor.putString("formula_body", it) }

                    editor.apply()

                    // Trigger refresh on all widgets
                    refreshAllWidgets()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun refreshAllWidgets() {
        val appWidgetManager = AppWidgetManager.getInstance(this)

        // Vocab widgets
        val vocabProvider = ComponentName(this, NexusStudyWidgetProvider::class.java)
        val vocabIds = appWidgetManager.getAppWidgetIds(vocabProvider)
        if (vocabIds.isNotEmpty()) {
            val intent = Intent(this, NexusStudyWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, vocabIds)
            }
            sendBroadcast(intent)
        }

        // Countdown widgets
        val countdownProvider = ComponentName(this, CountdownWidgetProvider::class.java)
        val countdownIds = appWidgetManager.getAppWidgetIds(countdownProvider)
        if (countdownIds.isNotEmpty()) {
            val intent = Intent(this, CountdownWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, countdownIds)
            }
            sendBroadcast(intent)
        }

        // Formula widgets
        val formulaProvider = ComponentName(this, FormulaWidgetProvider::class.java)
        val formulaIds = appWidgetManager.getAppWidgetIds(formulaProvider)
        if (formulaIds.isNotEmpty()) {
            val intent = Intent(this, FormulaWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, formulaIds)
            }
            sendBroadcast(intent)
        }
    }
}
