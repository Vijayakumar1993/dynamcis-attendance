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

import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Component
public class EventReport {

    private static final Logger logger = LoggerFactory.getLogger(EventReport.class);

    @Autowired
    private MatchService matchService;

    @Autowired
    private Utility utility;

    private Document doc;
    private PdfWriter writer;

    /* ===================== FONTS ===================== */

    private static final Font TITLE_FONT =
            new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);

    private static final Font SUB_TITLE_FONT =
            new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.BLACK);

    private static final Font META_FONT =
            new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, BaseColor.BLACK);

    private static final Font SECTION_FONT =
            new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);

    private static final Font TABLE_HEADER_FONT =
            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);

    private static final Font TABLE_FONT =
            new Font(Font.FontFamily.HELVETICA, 9);

    private static final Font FOOTER_FONT =
            new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, BaseColor.BLACK);

    /* ===================== INIT ===================== */

    public void init(OutputStream outputStream) throws DocumentException {

        this.doc = new Document(PageSize.A4, 36, 36, 30, 50);
        this.writer = PdfWriter.getInstance(doc, outputStream);

        this.writer.setPageEvent(new PdfPageEventHelper() {
            @Override
            public void onEndPage(PdfWriter writer, Document document) {
                ColumnText.showTextAligned(
                        writer.getDirectContent(),
                        Element.ALIGN_CENTER,
                        new Phrase("Page " + writer.getPageNumber(), FOOTER_FONT),
                        (document.left() + document.right()) / 2,
                        document.bottom() - 18,
                        0
                );
            }
        });
    }

    /* ===================== MAIN REPORT ===================== */

    public void generateReport(Competition competition, Event event) throws DocumentException {

        doc.open();

        renderHeader(competition, event);
        renderMeta(event);
        renderDrawTable(event);

        doc.close();
        writer.close();

        logger.info("Event draw PDF generated successfully");
    }
    private PdfPCell logoCell(String resourcePath) {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        try {
            Image logo = Image.getInstance(
                    getClass().getClassLoader().getResource(resourcePath)
            );

            logo.scaleToFit(60, 60);
            logo.setAlignment(Image.ALIGN_LEFT);
            cell.addElement(logo);

        } catch (Exception e) {
            logger.warn("Logo not found: {}", resourcePath);
        }

        return cell;
    }


    /* ===================== HEADER ===================== */

    private void renderHeader(Competition competition, Event event) throws DocumentException {

        PdfPTable header = new PdfPTable(2);
        header.setWidthPercentage(100);
        header.setWidths(new float[]{1.5f, 6f});
        header.setSpacingAfter(10);

        // LEFT LOGO
        header.addCell(
                logoCell("static/images/logo.png")
        );

        // RIGHT CONTENT
        PdfPCell contentCell = new PdfPCell();
        contentCell.setBorder(Rectangle.NO_BORDER);

        Paragraph title =
                new Paragraph(competition.getCompetitionName(), TITLE_FONT);
        title.setAlignment(Element.ALIGN_LEFT);

        Paragraph subtitle =
                new Paragraph(competition.getCompetitionType()+" Event", SUB_TITLE_FONT);
        subtitle.setAlignment(Element.ALIGN_LEFT);
//        subtitle.setSpacingAfter(6);

        contentCell.addElement(title);
        contentCell.addElement(subtitle);

        utility.getConfig("title", "name")
                .ifPresent(c ->
                        contentCell.addElement(
                                centeredParagraph(c.getConfigValue(), META_FONT)));

        utility.getConfig("title", "website")
                .ifPresent(c ->
                        contentCell.addElement(
                                centeredParagraph(c.getConfigValue(), META_FONT)));

        header.addCell(contentCell);

        doc.add(header);

        LineSeparator separator = new LineSeparator();
        separator.setLineWidth(0.8f);
        doc.add(separator);
        doc.add(Chunk.NEWLINE);
    }

    private Paragraph centeredParagraph(String text, Font font) {
        Paragraph p = new Paragraph(text, font);
        p.setAlignment(Element.ALIGN_LEFT);
        return p;
    }


    private void addCenteredText(String text, Font font) {
        try {
            Paragraph p = new Paragraph(text, font);
            p.setAlignment(Element.ALIGN_LEFT);
            doc.add(p);
        } catch (DocumentException e) {
            throw new RuntimeException(e);
        }
    }

    /* ===================== META INFO ===================== */

    private void renderMeta(Event event) throws DocumentException {



        Paragraph drawTitle = new Paragraph(
                "Draw Sheet – " + utility.getEventDefination(event),
                SECTION_FONT
        );
        drawTitle.setAlignment(Element.ALIGN_CENTER);
        doc.add(drawTitle);
        if (event.getEventDate() != null) {
            Paragraph asOf = new Paragraph(
                    "As of " + event.getEventDate()
                            .format(DateTimeFormatter.ofPattern("EEE dd MMM yyyy")),
                    META_FONT
            );
            asOf.setAlignment(Element.ALIGN_CENTER);
            doc.add(asOf);
        }

        Paragraph total =
                new Paragraph("Total Players: " + countPlayers(event), META_FONT);
        total.setAlignment(Element.ALIGN_CENTER);
        total.setSpacingAfter(12);
        doc.add(total);
    }

    /* ===================== DRAW TABLE ===================== */

    private void renderDrawTable(Event event) throws DocumentException {

        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingBefore(5);
        table.setWidths(new float[]{2f, 2f, 5f});

        table.addCell(headerCell("Team"));
        table.addCell(headerCell("Player"));
        table.addCell(headerCell(""));

        List<Match> matches = matchService.findByEvent(event);

        for (Match match : matches) {

            addSpacerRow(table,false);
            // FROM player
            addMatchRow(
                    match.getFrom().getCustomerId().getTeam().getTeamName(),
                    match.getFrom().getCustomerId().getName(),
                    false,
                    table
            );

            addSpacerRow(table, true);
            if (match.getBye()) {
                addByeRow(table);
            } else {
                addMatchRow(
                        match.getTo().getCustomerId().getTeam().getTeamName(),
                        match.getTo().getCustomerId().getName(),
                        true,
                        table
                );
            }

            addSpacerRow(table, false);
        }

        doc.add(table);
    }

    /* ===================== TABLE ROW HELPERS ===================== */

    private void addMatchRow(String team, String name, boolean rightBorder, PdfPTable table) {

        table.addCell(bodyCell(team, Rectangle.BOTTOM));
        table.addCell(bodyCell(name, rightBorder ? Rectangle.RIGHT|Rectangle.BOTTOM : Rectangle.BOTTOM ));
        table.addCell(bodyCell("", Rectangle.NO_BORDER));
    }

    private void addByeRow(PdfPTable table) {

        PdfPCell bye = new PdfPCell(new Phrase("BYE", TABLE_FONT));
        bye.setColspan(3);
        bye.setHorizontalAlignment(Element.ALIGN_CENTER);
        bye.setBorder(Rectangle.BOTTOM);
        bye.setPadding(6);
        table.addCell(bye);
    }

    private void addSpacerRow(PdfPTable table, Boolean rightBorder ) {

        PdfPCell spacer = new PdfPCell(new Phrase(" "));
        spacer.setColspan(2);
        spacer.setBorder(rightBorder? Rectangle.RIGHT: Rectangle.NO_BORDER);

        PdfPCell spacerEmpty = new PdfPCell(new Phrase(" "));
        spacerEmpty.setBorder(rightBorder? Rectangle.BOTTOM: Rectangle.NO_BORDER);
        table.addCell(spacer);
        table.addCell(spacerEmpty);
    }

    private PdfPCell headerCell(String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_HEADER_FONT));
        cell.setBackgroundColor(new BaseColor(230, 230, 230));
        cell.setPadding(6);
        cell.setBorder(Rectangle.BOTTOM);
        return cell;
    }

    private PdfPCell bodyCell(String text, int border) {
        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_FONT));
        cell.setPadding(6);
        cell.setBorder(border);
        return cell;
    }

    /* ===================== PLAYER COUNT ===================== */

    private long countPlayers(Event event) {

        List<Match> matches = matchService.findByEvent(event);
        long byes = matches.stream().filter(Match::getBye).count();
        long fights = matches.stream().filter(m -> !m.getBye()).count() * 2;
        return byes + fights;
    }
}
