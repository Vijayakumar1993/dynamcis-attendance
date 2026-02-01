package com.attendence.Attendance.reports;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.entity.Match;
import com.attendence.Attendance.services.MatchService;
import com.attendence.Attendance.util.Utility;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class EventListReport {

    private static final Logger logger = LoggerFactory.getLogger(EventListReport.class);

    private Document document;
    private PdfWriter writer;

    @Autowired
    private MatchService matchService;

    @Autowired
    private Utility utility;

    /* ===================== FONTS ===================== */

    private static final Font TITLE_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD);

    private static final Font SUB_TITLE_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.BOLD);

    private static final Font META_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 9, Font.NORMAL);

    private static final Font TABLE_HEADER_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 9, Font.BOLD, BaseColor.WHITE);

    private static final Font TABLE_BODY_FONT =
            new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL);

    private static final Font FOOTER_FONT =
            new Font(Font.FontFamily.HELVETICA, 8, Font.ITALIC);

    /* ===================== INIT ===================== */

    public void init(OutputStream out) throws IOException, DocumentException {

        document = new Document(PageSize.LETTER, 30, 30, 30, 50);
        writer = PdfWriter.getInstance(document, out);

        writer.setPageEvent(new PdfPageEventHelper() {
            @Override
            public void onEndPage(PdfWriter writer, Document document) {
                addFooter(writer, document);
                // addWatermark(writer); // ← intentionally commented
            }
        });

        logger.info("PDF initialized successfully");
    }

    /* ===================== REPORT ===================== */

    public void generateReport(List<Event> events, String reportTitle, Integer bout)
            throws DocumentException {

        if (events == null || events.isEmpty()) {
            return;
        }

        document.open();

        Competition competition = null;
        //since the event can be filter based on competion so takeing the first events competition
        if(!events.isEmpty()){
            competition = events.get(0).getCompetition();
        }
        addHeader(competition);
        addMeta(events);
        addTable(events, bout);

        document.close();
        writer.close();
    }

    /* ===================== HEADER ===================== */

    private void addHeader(Competition competition) throws DocumentException {

        PdfPTable header = new PdfPTable(3);
        header.setWidthPercentage(100);
        header.setWidths(new float[]{2f, 6f, 2f});

        // LEFT LOGO
        header.addCell(
                logoCell("static/images/logo.png", Image.ALIGN_LEFT)
        );

        // CENTER TITLE
        header.addCell(centerHeaderCell(competition));

        // RIGHT EMPTY CELL (REQUIRED)
        header.addCell(emptyCell());

        header.setSpacingAfter(12);

        document.add(header);
        document.add(new LineSeparator());
        document.add(Chunk.NEWLINE);
    }


    private PdfPCell logoCell(String resourcePath, int alignment) {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        try {
            Image logo = Image.getInstance(
                    getClass().getClassLoader().getResource(resourcePath)
            );

            logo.scaleToFit(55, 55);   // adjust size if needed
            logo.setAlignment(alignment);
            cell.addElement(logo);

        } catch (Exception e) {
            logger.warn("Logo not found: {}", resourcePath);
        }

        return cell;
    }


    private PdfPCell centerHeaderCell(Competition competition) {

        Paragraph p = new Paragraph();
        p.setAlignment(Element.ALIGN_CENTER);
        p.setLeading(14f);

        if(competition!=null){

            p.add(new Chunk(competition.getCompetitionName().toUpperCase(), TITLE_FONT));
            p.add(Chunk.NEWLINE);

            p.add(new Chunk(competition.getCompetitionType()+" Event", SUB_TITLE_FONT));
            p.add(Chunk.NEWLINE);

            p.add(new Chunk(competition.getVenue(), META_FONT));
        }
        p.add(Chunk.NEWLINE);
        utility.getConfig("title", "website")
                .ifPresent(c ->  p.add(new Chunk(c.getConfigValue(), META_FONT)));



        PdfPCell cell = new PdfPCell(p);
        cell.setBorder(Rectangle.NO_BORDER);
        return cell;
    }

    private PdfPCell emptyCell() {
        PdfPCell cell = new PdfPCell(new Phrase(""));
        cell.setBorder(Rectangle.NO_BORDER);
        return cell;
    }

    /* ===================== META ===================== */

    private void addMeta(List<Event> events) throws DocumentException {

        Optional<Long> totalBouts = events.stream()
                .map(ev -> matchService.findByEvent(ev).stream()
                        .filter(m -> !m.getBye())
                        .count())
                .reduce(Long::sum);

        Paragraph meta = new Paragraph(
                "Total Bouts : " + totalBouts.orElse(0L),
                SUB_TITLE_FONT
        );

        meta.setAlignment(Element.ALIGN_CENTER);
        meta.setSpacingAfter(10);

        document.add(meta);
    }

    /* ===================== TABLE ===================== */

    private void addTable(List<Event> events, Integer bt) throws DocumentException {

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1f, 1f, 3f, 3f, 3f});

        addTableHeader(table);

        AtomicInteger order = new AtomicInteger(0);
        AtomicInteger bout = new AtomicInteger(bt);

        for (Event ev : events) {
            matchService.findByEvent(ev).stream()
                    .filter(m -> !m.getBye())
                    .forEach(m -> {

                        order.incrementAndGet();
                        bout.incrementAndGet();

                        addBodyCell(table, String.valueOf(order.get()));
                        addBodyCell(table, String.valueOf(bout.get()));

                        addBodyCell(table, utility.getEventDefination(ev));

                        table.addCell(cornerCell(m));
                        table.addCell(teamCell(m));
                    });
        }

        document.add(table);
    }

    private void addTableHeader(PdfPTable table) {

        table.addCell(headerCell("Order"));
        table.addCell(headerCell("Bout"));
        table.addCell(headerCell("Category"));
        table.addCell(headerCell("Corner"));
        table.addCell(headerCell("Team"));
    }

    /* ===================== CELLS ===================== */

    private PdfPCell headerCell(String text) {

        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_HEADER_FONT));
        cell.setBackgroundColor(BaseColor.BLACK);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(6);
        return cell;
    }

    private void addBodyCell(PdfPTable table, String text) {

        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_BODY_FONT));
        cell.setPadding(5);
        table.addCell(cell);
    }

    private PdfPCell cornerCell(Match m) {

        PdfPTable t = new PdfPTable(2);
        try {
            t.setWidths(new float[]{1f, 2f});
        } catch (Exception ignored) {}

        addInnerCell(t, m.getToCorner().toString(), true);
        addInnerCell(t, m.getTo().getCustomerId().getName(), true);
        addInnerCell(t, m.getFromCorner().toString(), false);
        addInnerCell(t, m.getFrom().getCustomerId().getName(), false);

        return new PdfPCell(t);
    }

    private PdfPCell teamCell(Match m) {

        PdfPTable t = new PdfPTable(1);

        addInnerCell(t,
                m.getTo().getCustomerId().getTeam().getTeamName(), true);
        addInnerCell(t,
                m.getFrom().getCustomerId().getTeam().getTeamName(), false);

        return new PdfPCell(t);
    }

    private void addInnerCell(PdfPTable t, String text, boolean borderBottom) {

        PdfPCell c = new PdfPCell(new Phrase(text, TABLE_BODY_FONT));
        c.setBorder(borderBottom ? Rectangle.BOTTOM : Rectangle.NO_BORDER);
        c.setPadding(4);
        t.addCell(c);
    }

    /* ===================== FOOTER ===================== */

    private void addFooter(PdfWriter writer, Document document) {

        ColumnText.showTextAligned(
                writer.getDirectContent(),
                Element.ALIGN_CENTER,
                new Phrase("Page " + writer.getPageNumber(), FOOTER_FONT),
                (document.left() + document.right()) / 2,
                document.bottom() - 20,
                0
        );
    }

    /* ===================== WATERMARK (COMMENTED) ===================== */

    /*
    private void addWatermark(PdfWriter writer) {
        try {
            PdfContentByte canvas = writer.getDirectContentUnder();
            Image img = Image.getInstance("watermark.png");
            img.scaleToFit(400, 400);
            img.setAbsolutePosition(100, 200);
            canvas.addImage(img);
        } catch (Exception ignored) {}
    }
    */
}
