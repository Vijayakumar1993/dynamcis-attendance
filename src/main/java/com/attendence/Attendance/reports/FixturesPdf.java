package com.attendence.Attendance.reports;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.services.EventServices;
import com.attendence.Attendance.services.TemCompetionCustomerServices;
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

@Component
public class FixturesPdf implements Report {

    private static final Logger logger = LoggerFactory.getLogger(FixturesPdf.class);

    private PdfWriter pdfWriter;
    private Document doc;

    @Autowired
    private Utility utility;

    @Autowired
    private TemCompetionCustomerServices services;

    @Autowired
    private EventServices eventServices;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    private String fileName;

    /* ===================== FONTS ===================== */

    private final Font TITLE_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 16, Font.BOLD);

    private final Font SUBTITLE_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.NORMAL, BaseColor.BLACK);

    private final Font META_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 9, Font.ITALIC, BaseColor.BLACK);

    private final Font SECTION_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 11, Font.BOLD);

    private final Font TABLE_HEADER_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 9, Font.BOLD);

    private final Font TABLE_BODY_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 9);

    private final Font FOOTER_FONT =
            new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL, BaseColor.BLACK);

    /* ===================== INIT ===================== */

    public void init(OutputStream outputStream) throws IOException, DocumentException {

        this.doc = new Document(PageSize.A4, 36, 36, 30, 50);
        this.pdfWriter = PdfWriter.getInstance(doc, outputStream);

        this.pdfWriter.setPageEvent(new PdfPageEventHelper() {
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

    /* ===================== REPORT ===================== */

    @Override
    public void generateReport(Competition competition) throws DocumentException {

        doc.open();

        addHeaderWithLogoAndTitle(competition);
        if(competition.getStatus().equals(CompetitionStatus.SCHEDULED)){
            addPlayersSection(competition);
        }

        doc.close();
        logger.info("PDF created successfully: {}", fileName);
    }

    /* ===================== TITLE SECTION ===================== */

    private void addHeaderWithLogoAndTitle(Competition competition) throws DocumentException {

        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{1.2f, 4f});
        headerTable.setSpacingAfter(12);

        /* ===== LOGO CELL (LEFT) ===== */
        PdfPCell logoCell = new PdfPCell();
        logoCell.setBorder(Rectangle.NO_BORDER);
        logoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        try {
            Image logo = Image.getInstance(
                    getClass().getClassLoader()
                            .getResource("static/images/logo.png")
            );

            logo.scaleToFit(70, 70);
            logo.setAlignment(Image.ALIGN_LEFT);
            logoCell.addElement(logo);

        } catch (Exception e) {
            logger.warn("Logo not found, skipping logo rendering", e);
        }

        headerTable.addCell(logoCell);

        /* ===== TITLE CELL (RIGHT) ===== */
        PdfPCell titleCell = new PdfPCell();
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        Paragraph title = new Paragraph(competition.getCompetitionName().toUpperCase(), TITLE_FONT);
        title.setSpacingAfter(3);

        Paragraph subtitle =
                new Paragraph(competition.getCompetitionType()+" Event", SUBTITLE_FONT);
        subtitle.setSpacingAfter(6);

        titleCell.addElement(title);
        titleCell.addElement(subtitle);

        utility.getConfig("title", "name").ifPresent(c ->
                titleCell.addElement(new Paragraph("Organized By "+c.getConfigValue(), META_FONT)));

        utility.getConfig("title", "website").ifPresent(c ->
                titleCell.addElement(new Paragraph(c.getConfigValue(), META_FONT)));

        headerTable.addCell(titleCell);

        doc.add(headerTable);

        LineSeparator separator = new LineSeparator();
        separator.setLineColor(BaseColor.BLACK);
        separator.setLineWidth(0.8f);
        doc.add(separator);
        doc.add(Chunk.NEWLINE);
    }

    /* ===================== PLAYERS SECTION ===================== */

    private void addPlayersSection(Competition competition) throws DocumentException {

        Paragraph section = new Paragraph("Players List", SECTION_FONT);
        section.setSpacingAfter(6);
        doc.add(section);
        List<TemCompetionCustomer> temCompetionCustomers = services.findByCompetition(competition);
        if(!temCompetionCustomers.isEmpty()){
            List<Customer> players  = temCompetionCustomers.stream().map(TemCompetionCustomer::getCustomer).toList();
            players = players.stream().filter(customer -> customer.getStatus().equalsIgnoreCase("ACTIVE")).filter(customer->{
                        List<Authorities> authorities = authorityServices
                                .findByCustomerId(customer.getId());
                        return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.ROLE_PLAYER);
                    }).toList();



        Paragraph count =
                new Paragraph("Total Players: " + players.size(), META_FONT);
        count.setSpacingAfter(10);
        doc.add(count);

        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setSpacingBefore(5);

        table.addCell(header("ID"));
        table.addCell(header("Name"));
        table.addCell(header("Gender"));
        table.addCell(header("Category"));
        table.addCell(header("Weight (kg)"));
        table.addCell(header("Team"));

        int row = 0;
        for (Customer p : players) {
            BaseColor bg = (row % 2 == 0)
                    ? BaseColor.WHITE
                    : new BaseColor(245, 245, 245);

            cell(p.getId().toString(), bg, table);
            cell(p.getName(), bg, table);
            cell(utility.capitalize(p.getGender()), bg, table);
            cell(utility.capitalize(utility.getConfig(p.getCategory()).getConfigValue()), bg, table);
            cell(String.valueOf(p.getWeight()), bg, table);
            cell(p.getTeam().getTeamName(), bg, table);

            row++;
        }
            doc.add(table);
        }else{
            doc.add(new Paragraph("No teams found.", TABLE_BODY_FONT));
        }
    }

    /* ===================== TABLE HELPERS ===================== */

    private PdfPCell header(String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_HEADER_FONT));
        cell.setBackgroundColor(new BaseColor(230, 230, 230));
        cell.setBorder(Rectangle.BOTTOM);
        cell.setPadding(6);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        return cell;
    }

    private void cell(String text, BaseColor bg, PdfPTable table) {
        PdfPCell cell = new PdfPCell(new Phrase(text, TABLE_BODY_FONT));
        cell.setBackgroundColor(bg);
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(6);
        table.addCell(cell);
    }

    @Override
    public void generateReport(List<Event> event, String title) {
        // Not implemented
    }
}
