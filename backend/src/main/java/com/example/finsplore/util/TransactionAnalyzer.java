package com.example.finsplore.util;

import java.math.BigDecimal;
import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

import com.example.finsplore.entity.Transaction;

public class TransactionAnalyzer {

    public static List<Map<String, Object>> summarizeTransactions(List<Transaction> transactions) {
        // 限制最多500条数据
        List<Transaction> limitedTransactions = transactions.stream()
                // .sorted((t1, t2) -> Instant.parse(t2.getTransactionDate()).compareTo(Instant.parse(t1.getTransactionDate())))
                // .limit(500)
                .collect(Collectors.toList());

        // 初始化每天的收入和支出
        Map<DayOfWeek, BigDecimal> incomeMap = new HashMap<>();
        Map<DayOfWeek, BigDecimal> spendingMap = new HashMap<>();

        // 初始化为0
        for (DayOfWeek day : DayOfWeek.values()) {
            incomeMap.put(day, BigDecimal.ZERO);
            spendingMap.put(day, BigDecimal.ZERO);
        }

        // 遍历交易
        for (Transaction t : limitedTransactions) {
            LocalDate date = Instant.parse(t.getTransactionDate()).atZone(ZoneId.systemDefault()).toLocalDate();
            DayOfWeek dayOfWeek = date.getDayOfWeek(); // MONDAY...SUNDAY

            BigDecimal amount = t.getAmount();
            if (amount.compareTo(BigDecimal.ZERO) > 0) {
                // 收入
                incomeMap.put(dayOfWeek, incomeMap.get(dayOfWeek).add(amount));
            } else {
                // 支出
                spendingMap.put(dayOfWeek, spendingMap.get(dayOfWeek).add(amount.abs()));
            }
        }

        // 构造结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (DayOfWeek day : DayOfWeek.values()) {
            Map<String, Object> daySummary = new HashMap<>();
            daySummary.put("day", capitalize(day.name().substring(0, 3).toLowerCase())); // Mon, Tue, ...
            daySummary.put("income", incomeMap.get(day));
            daySummary.put("spending", spendingMap.get(day));
            result.add(daySummary);
        }

        return result;
    }

    // 小写首字母转大写，例如 "mon" -> "Mon"
    private static String capitalize(String s) {
        if (s == null || s.isEmpty()) return s;
        return s.substring(0, 1).toUpperCase() + s.substring(1);
    }
}
